library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;

package csn_pkg is

	constant MUON_NUMBER : integer := 352;
	constant IDX_WIDTH   : integer := integer(ceil(log(real(MUON_NUMBER), real(2))));
	constant PT_WIDTH    : integer := 4;
	constant ROI_WIDTH   : integer := 8;
	constant FLAGS_WIDTH : integer := 4;
	constant in_word_w   : integer := PT_WIDTH + ROI_WIDTH + FLAGS_WIDTH;
	constant out_word_w  : integer := PT_WIDTH + ROI_WIDTH + FLAGS_WIDTH + IDX_WIDTH;

	type muon_type is record
		idx   : std_logic_vector(IDX_WIDTH - 1 downto 0);
		pt    : std_logic_vector(PT_WIDTH - 1 downto 0);
		roi   : std_logic_vector(ROI_WIDTH - 1 downto 0);
		flags : std_logic_vector(FLAGS_WIDTH - 1 downto 0);
	end record;

	type muon_sort_type is record
		pt  : std_logic_vector(PT_WIDTH - 1 downto 0);
		idx : std_logic_vector(IDX_WIDTH - 1 downto 0);
	end record;

	type muon_a is array (natural range <>) of muon_type;
	type muon_sort_a is array (natural range <>) of muon_sort_type;

	type cmp_cfg is record
		a : natural;
		b : natural;
		p : boolean;
	end record;

	-- has to be array of array instead of (x,y) array because of issues with synplify
	type pair_cmp_cfg is array (natural range <>) of cmp_cfg;
	type cfg_net_t is array (natural range <>) of pair_cmp_cfg;
	type stages_a is array (natural range <>) of boolean;

	function to_array(data : std_logic_vector; N : integer) return muon_a;
	function to_stdv(muon : muon_a; N : integer) return std_logic_vector;

	--type cfg_net_t is array (natural range <>, natural range <>) of cmp_cfg;
	function get_cfg(I : integer) return cfg_net_t;
	function get_stg(I : integer; D : integer) return stages_a;

	constant empty_cfg : cfg_net_t := (
		((a => 0, b => 1, p => False), (a => 2, b => 3, p => False)),
		((a => 0, b => 2, p => False), (a => 1, b => 3, p => False)),
		((a => 1, b => 2, p => False), (a => 0, b => 3, p => True))
	);

end package csn_pkg;

package body csn_pkg is

	function get_cfg(I : integer) return cfg_net_t is
	begin
		case I is
			-- 
			when 22 => return (
					((a => 20, b => 21, p => False), (a => 18, b => 19, p => False), (a => 16, b => 17, p => False), (a => 14, b => 15, p => False), (a => 12, b => 13, p => False), (a => 10, b => 11, p => False), (a => 8, b => 9, p => False), (a => 6, b => 7, p => False), (a => 4, b => 5, p => False), (a => 2, b => 3, p => False), (a => 0, b => 1, p => False)),
					((a => 17, b => 19, p => False), (a => 13, b => 15, p => False), (a => 9, b => 11, p => False), (a => 5, b => 7, p => False), (a => 1, b => 3, p => False), (a => 18, b => 20, p => False), (a => 12, b => 14, p => False), (a => 8, b => 10, p => False), (a => 4, b => 6, p => False), (a => 0, b => 2, p => False), (a => 16, b => 21, p => False)),
					((a => 11, b => 15, p => False), (a => 3, b => 7, p => False), (a => 16, b => 18, p => False), (a => 19, b => 21, p => False), (a => 10, b => 14, p => False), (a => 2, b => 6, p => False), (a => 17, b => 20, p => False), (a => 9, b => 13, p => False), (a => 1, b => 5, p => False), (a => 8, b => 12, p => False), (a => 0, b => 4, p => False)),
					((a => 4, b => 12, p => False), (a => 17, b => 19, p => False), (a => 6, b => 14, p => False), (a => 2, b => 10, p => False), (a => 11, b => 21, p => False), (a => 5, b => 13, p => False), (a => 9, b => 18, p => False), (a => 0, b => 8, p => False), (a => 3, b => 20, p => False), (a => 1, b => 16, p => False), (a => 7, b => 15, p => False)),
					((a => 14, b => 21, p => False), (a => 1, b => 4, p => False), (a => 7, b => 8, p => False), (a => 6, b => 18, p => False), (a => 3, b => 12, p => False), (a => 13, b => 20, p => False), (a => 10, b => 19, p => False), (a => 2, b => 9, p => False), (a => 5, b => 17, p => False), (a => 11, b => 16, p => False), (a => 0, b => 15, p => True)),
					((a => 0, b => 1, p => False), (a => 15, b => 21, p => False), (a => 3, b => 9, p => False), (a => 13, b => 18, p => False), (a => 5, b => 7, p => False), (a => 8, b => 19, p => False), (a => 12, b => 16, p => False), (a => 6, b => 11, p => False), (a => 14, b => 17, p => False), (a => 4, b => 10, p => False), (a => 2, b => 20, p => True)),
					((a => 1, b => 5, p => False), (a => 7, b => 9, p => False), (a => 10, b => 11, p => False), (a => 12, b => 14, p => False), (a => 16, b => 17, p => False), (a => 18, b => 20, p => False), (a => 2, b => 3, p => False), (a => 4, b => 6, p => False), (a => 8, b => 13, p => False), (a => 15, b => 19, p => False), (a => 0, b => 21, p => True)),
					((a => 1, b => 2, p => False), (a => 4, b => 5, p => False), (a => 7, b => 10, p => False), (a => 13, b => 14, p => False), (a => 16, b => 18, p => False), (a => 19, b => 20, p => False), (a => 3, b => 6, p => False), (a => 8, b => 12, p => False), (a => 15, b => 17, p => False), (a => 9, b => 11, p => False), (a => 0, b => 21, p => True)),
					((a => 2, b => 3, p => False), (a => 5, b => 7, p => False), (a => 9, b => 10, p => False), (a => 12, b => 13, p => False), (a => 14, b => 15, p => False), (a => 18, b => 19, p => False), (a => 6, b => 8, p => False), (a => 11, b => 16, p => False), (a => 0, b => 21, p => True), (a => 1, b => 20, p => True), (a => 4, b => 17, p => True)),
					((a => 2, b => 4, p => False), (a => 6, b => 7, p => False), (a => 8, b => 9, p => False), (a => 10, b => 12, p => False), (a => 14, b => 16, p => False), (a => 3, b => 5, p => False), (a => 11, b => 13, p => False), (a => 15, b => 18, p => False), (a => 0, b => 21, p => True), (a => 1, b => 20, p => True), (a => 17, b => 19, p => True)),
					((a => 3, b => 4, p => False), (a => 5, b => 6, p => False), (a => 7, b => 8, p => False), (a => 9, b => 10, p => False), (a => 11, b => 12, p => False), (a => 13, b => 14, p => False), (a => 15, b => 16, p => False), (a => 0, b => 21, p => True), (a => 1, b => 20, p => True), (a => 2, b => 19, p => True), (a => 17, b => 18, p => True)),
					((a => 4, b => 5, p => False), (a => 6, b => 7, p => False), (a => 8, b => 9, p => False), (a => 10, b => 11, p => False), (a => 12, b => 13, p => False), (a => 14, b => 15, p => False), (a => 0, b => 21, p => True), (a => 1, b => 20, p => True), (a => 2, b => 19, p => True), (a => 3, b => 18, p => True), (a => 16, b => 17, p => True))
				);

			when 32 => return (
					((a => 0, b => 16, p => False), (a => 8, b => 24, p => False), (a => 4, b => 20, p => False), (a => 12, b => 28, p => False), (a => 2, b => 18, p => False), (a => 10, b => 26, p => False), (a => 6, b => 22, p => False), (a => 14, b => 30, p => False), (a => 1, b => 17, p => False), (a => 9, b => 25, p => False), (a => 5, b => 21, p => False), (a => 13, b => 29, p => False), (a => 3, b => 19, p => False), (a => 11, b => 27, p => False), (a => 7, b => 23, p => False), (a => 15, b => 31, p => False)),
					((a => 8, b => 16, p => False), (a => 12, b => 20, p => False), (a => 10, b => 18, p => False), (a => 14, b => 22, p => False), (a => 9, b => 17, p => False), (a => 13, b => 21, p => False), (a => 11, b => 19, p => False), (a => 15, b => 23, p => False), (a => 0, b => 31, p => True), (a => 1, b => 30, p => True), (a => 2, b => 29, p => True), (a => 3, b => 28, p => True), (a => 4, b => 27, p => True), (a => 5, b => 26, p => True), (a => 6, b => 25, p => True), (a => 7, b => 24, p => True)),
					((a => 4, b => 8, p => False), (a => 12, b => 16, p => False), (a => 6, b => 10, p => False), (a => 14, b => 18, p => False), (a => 5, b => 9, p => False), (a => 13, b => 17, p => False), (a => 7, b => 11, p => False), (a => 15, b => 19, p => False), (a => 0, b => 31, p => True), (a => 1, b => 30, p => True), (a => 2, b => 29, p => True), (a => 3, b => 28, p => True), (a => 20, b => 27, p => True), (a => 21, b => 26, p => True), (a => 22, b => 25, p => True), (a => 23, b => 24, p => True)),
					((a => 2, b => 4, p => False), (a => 6, b => 8, p => False), (a => 10, b => 12, p => False), (a => 14, b => 16, p => False), (a => 3, b => 5, p => False), (a => 7, b => 9, p => False), (a => 11, b => 13, p => False), (a => 15, b => 17, p => False), (a => 0, b => 31, p => True), (a => 1, b => 30, p => True), (a => 18, b => 29, p => True), (a => 19, b => 28, p => True), (a => 20, b => 27, p => True), (a => 21, b => 26, p => True), (a => 22, b => 25, p => True), (a => 23, b => 24, p => True)),
					((a => 1, b => 2, p => False), (a => 3, b => 4, p => False), (a => 5, b => 6, p => False), (a => 7, b => 8, p => False), (a => 9, b => 10, p => False), (a => 11, b => 12, p => False), (a => 13, b => 14, p => False), (a => 15, b => 16, p => False), (a => 0, b => 31, p => True), (a => 17, b => 30, p => True), (a => 18, b => 29, p => True), (a => 19, b => 28, p => True), (a => 20, b => 27, p => True), (a => 21, b => 26, p => True), (a => 22, b => 25, p => True), (a => 23, b => 24, p => True))
				);

			when others => return empty_cfg;

		end case;
	end function get_cfg;

	function get_stg(I : integer; D : integer) return stages_a is
	begin
		case I is

			when 352 =>
				case D is
					when 1 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, True);
					-- total number of registered stages: 1.
					when 2 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, True);
					-- total number of registered stages: 2.
					when 3 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, False, False, False, False, False, False, True, False, False, False, False, False, False, False, False, False, False, True, False, False, False, False, False, False, False, False, False, False, True);
					-- total number of registered stages: 3.
					when 4 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, False, False, False, False, True, False, False, False, False, False, False, False, True, False, False, False, False, False, False, False, True, False, False, False, False, False, False, False, True);
					-- total number of registered stages: 4.
					when 5 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, False, False, False, True, False, False, False, False, False, True, False, False, False, False, False, False, True, False, False, False, False, False, True, False, False, False, False, False, True);
					-- total number of registered stages: 5.
					when 6 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, False, False, True, False, False, False, False, True, False, False, False, False, False, True, False, False, False, False, True, False, False, False, False, True, False, False, False, False, True);
					-- total number of registered stages: 6.
					when 7 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, True, False, False, False, False, True, False, False, False, True, False, False, False, False, True, False, False, False, True, False, False, False, False, True, False, False, False, False, True);
					-- total number of registered stages: 7.
					when 8 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, True, False, False, False, True, False, False, False, True, False, False, False, True, False, False, False, True, False, False, False, True, False, False, False, True, False, False, False, True);
					-- total number of registered stages: 8.
					when 9 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, True, False, False, False, True, False, False, True, False, False, False, True, False, False, True, False, False, False, True, False, False, True, False, False, False, True, False, False, False, True);
					-- total number of registered stages: 9.
					when 10 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, False, True, False, False, True, False, False, True, False, False, True, False, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True);
					-- total number of registered stages: 10.
					when 11 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True, False, False, True);
					-- total number of registered stages: 11.
					when 12 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, False, False, True, False, False, True, False, True, False, False, True, False, False, True, False, True, False, False, True, False, False, True, False, True, False, False, True, False, False, True);
					-- total number of registered stages: 12.
					when 13 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, True, False, True, False, False, True, False, True, False, False, True, False, True, False, False, True, False, True, False, False, True, False, True, False, False, True, False, True, False, True);
					-- total number of registered stages: 13.
					when 14 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, True, False, True, False, True, False, False, True, False, True, False, True, False, False, True, False, True, False, True, False, True, False, False, True, False, True, False, True, False, True);
					-- total number of registered stages: 14.
					when 15 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True);
					-- total number of registered stages: 15.
					when 16 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True);
					-- total number of registered stages: 16.
					when 17 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True, False, True);
					-- total number of registered stages: 17.
					when 18 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (True, False, True, False, True, False, True, True, False, True, False, True, False, True, False, True, True, False, True, False, True, False, True, True, False, True, False, True, False, True, False, True);
					-- total number of registered stages: 18.
					when 19 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (True, False, True, False, True, True, False, True, False, True, True, False, True, False, True, True, False, True, False, True, True, False, True, False, True, True, False, True, False, True, False, True);
					-- total number of registered stages: 19.
					when 20 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (True, False, True, True, False, True, False, True, True, False, True, True, False, True, False, True, True, False, True, True, False, True, False, True, True, False, True, True, False, True, False, True);
					-- total number of registered stages: 20.
					when 21 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (True, False, True, True, False, True, True, False, True, True, False, True, True, False, True, True, False, True, True, False, True, True, False, True, True, False, True, True, False, True, False, True);
					-- total number of registered stages: 21.
					when 22 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, False, True, True, False, True, True, False, True, True, False, True, True, False, True, True, True, False, True, True, False, True, True, False, True, True, False, True, True, True);
					-- total number of registered stages: 22.
					when 23 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, False, True, True, True, False, True, True, False, True, True, True, False, True, True, False, True, True, True, False, True, True, False, True, True, True, False, True, True, True);
					-- total number of registered stages: 23.
					when 24 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, False, True, True, True, False, True, True, True, False, True, True, True, False, True, True, True, False, True, True, True, False, True, True, True, False, True, True, True, True);
					-- total number of registered stages: 24.
					when 25 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, True, False, True, True, True, True, False, True, True, True, False, True, True, True, True, False, True, True, True, False, True, True, True, True, False, True, True, True, True);
					-- total number of registered stages: 25.
					when 26 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, True, True, False, True, True, True, True, False, True, True, True, True, False, True, True, True, True, True, False, True, True, True, True, False, True, True, True, True, True);
					-- total number of registered stages: 26.
					when 27 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, True, True, True, False, True, True, True, True, True, False, True, True, True, True, True, True, False, True, True, True, True, True, False, True, True, True, True, True, True);
					-- total number of registered stages: 27.
					when 28 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, True, True, True, True, False, True, True, True, True, True, True, True, False, True, True, True, True, True, True, True, False, True, True, True, True, True, True, True, True);
					-- total number of registered stages: 28.
					when 29 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, True, True, True, True, True, True, True, False, True, True, True, True, True, True, True, True, True, True, False, True, True, True, True, True, True, True, True, True, True);
					-- total number of registered stages: 29.
					when 30 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, True, True, True, True, True, True, True, True, True, True, True, True, False, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True);
					-- total number of registered stages: 30.
					when 31 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (False, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True);
					-- total number of registered stages: 31.
					when 32 =>
						-- Registered stages configuration
						-- num -> |     0,     1,     2,     3,     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,    26,    27,    28,    29,    30,    31|;
						return (True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True);
					-- total number of registered stages: 32.

					when others =>
						null;
				end case;

			when others => return (False, False);

		end case;
	end function get_stg;

	function to_array(data : std_logic_vector; N : integer) return muon_a is
		variable muon  : muon_a(0 to N - 1);
		variable left  : integer;
		variable right : integer;
	begin
		for i in muon'range loop
			left          := (i + 1) * in_word_w - 1;
			right         := i * in_word_w;
			muon(i).pt    := data(left - FLAGS_WIDTH - ROI_WIDTH downto right);
			muon(i).roi   := data(left - FLAGS_WIDTH downto right + PT_WIDTH);
			muon(i).flags := data(left downto right + PT_WIDTH + ROI_WIDTH);
		end loop;
		return muon;
	end to_array;

	function to_stdv(muon : muon_a; N : integer) return std_logic_vector is
		variable data  : std_logic_vector(N * out_word_w - 1 downto 0);
		variable left  : integer;
		variable right : integer;
	begin
		for i in muon'range loop
			left                                                          := (i + 1) * out_word_w - 1;
			right                                                         := i * out_word_w;
			data(left - IDX_WIDTH - FLAGS_WIDTH - ROI_WIDTH downto right) := muon(i).pt;
			data(left - IDX_WIDTH - FLAGS_WIDTH downto right + PT_WIDTH)  := muon(i).roi;
			data(left - IDX_WIDTH downto right + PT_WIDTH + ROI_WIDTH)    := muon(i).flags;
			data(left downto right + PT_WIDTH + ROI_WIDTH + FLAGS_WIDTH)  := muon(i).idx;
		end loop;
		return data;
	end to_stdv;

end package body csn_pkg;
