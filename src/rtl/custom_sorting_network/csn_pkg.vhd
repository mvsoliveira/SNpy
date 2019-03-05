library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;

package csn_pkg is

	constant MUON_NUMBER : integer := 352;
	constant IDX_WIDTH   : integer := integer(ceil(log(real(MUON_NUMBER), real(2))));
	constant PT_WIDTH    : integer := 4;
	constant word_w      : integer := PT_WIDTH + IDX_WIDTH;

	type muon_type is record
		idx : std_logic_vector(IDX_WIDTH - 1 downto 0);
		pt  : std_logic_vector(PT_WIDTH - 1 downto 0);
	end record;

	type muon_a is array (natural range <>) of muon_type;

	type cmp_cfg is record
		a : natural;
		b : natural;
		p : boolean;
		o : boolean;
		r : boolean;
	end record;
	
	-- has to be array of array instead of (x,y) array because of issues with synplify
	type pair_cmp_cfg is array (natural range <>) of cmp_cfg;
	type cfg_net_t is array (natural range <>) of pair_cmp_cfg;

	--type cfg_net_t is array (natural range <>, natural range <>) of cmp_cfg;
	function get_cfg(I : integer) return cfg_net_t;
		
	constant empty_cfg : cfg_net_t := (
					((a => 0, b => 1, p => False, o => False, r => False), (a => 2, b => 3, p => False, o => False, r => False)),
					((a => 0, b => 2, p => False, o => False, r => False), (a => 1, b => 3, p => False, o => False, r => False)),
					((a => 1, b => 2, p => False, o => False, r => False), (a => 0, b => 3, p => True, o => False, r => False))
				);


end package csn_pkg;

package body csn_pkg is

	function get_cfg(I : integer) return cfg_net_t is
	begin
		case I is
			-- I=4 batcher odd-even mergesort 
			when 4      => return (
					((a => 0, b => 1, p => False, o => False, r => False), (a => 2, b => 3, p => False, o => False, r => False)),
					((a => 0, b => 2, p => False, o => False, r => False), (a => 1, b => 3, p => False, o => False, r => False)),
					((a => 1, b => 2, p => False, o => False, r => False), (a => 0, b => 3, p => True, o => False, r => False))
				);
			-- I=8 batcher odd-even mergesort
			when 8      => return (
					((a => 0, b => 1, p => False, o => False, r => False), (a => 2, b => 3, p => False, o => False, r => False), (a => 4, b => 5, p => False, o => False, r => False), (a => 6, b => 7, p => False, o => False, r => False)),
					((a => 0, b => 2, p => False, o => False, r => False), (a => 1, b => 3, p => False, o => False, r => False), (a => 4, b => 6, p => False, o => False, r => False), (a => 5, b => 7, p => False, o => False, r => False)),
					((a => 1, b => 2, p => False, o => False, r => False), (a => 5, b => 6, p => False, o => False, r => False), (a => 0, b => 7, p => True, o => False, r => False), (a => 3, b => 4, p => True, o => False, r => False)),
					((a => 0, b => 4, p => False, o => False, r => False), (a => 1, b => 5, p => False, o => False, r => False), (a => 2, b => 6, p => False, o => False, r => False), (a => 3, b => 7, p => False, o => False, r => False)),
					((a => 2, b => 4, p => False, o => False, r => False), (a => 3, b => 5, p => False, o => False, r => False), (a => 0, b => 7, p => True, o => False, r => False), (a => 1, b => 6, p => True, o => False, r => False)),
					((a => 1, b => 2, p => False, o => False, r => False), (a => 3, b => 4, p => False, o => False, r => False), (a => 5, b => 6, p => False, o => False, r => False), (a => 1, b => 7, p => True, o => False, r => False))
				);
			when others => return empty_cfg;

		end case;
	end function get_cfg;  

	function to_array(data : std_logic_vector; N : integer) return muon_a is
		variable muon : muon_a(0 to N - 1);
	begin
		for i in muon'range loop
			muon(i).pt  := data((i + 1) * word_w - 1 - IDX_WIDTH downto i * word_w);
			muon(i).idx := data((i + 1) * word_w - 1 downto i * word_w + PT_WIDTH);
		end loop;
		return muon;
	end to_array;

	function to_stdv(muon : muon_a; N : integer) return std_logic_vector is
		variable vector : std_logic_vector(N * word_w - 1 downto 0);
	begin
		for i in muon'range loop
			vector((i + 1) * word_w - 1 - IDX_WIDTH downto i * word_w) := muon(i).pt;
			vector((i + 1) * word_w - 1 downto i * word_w + PT_WIDTH)  := muon(i).idx;
		end loop;
		return vector;
	end to_stdv;

end package body csn_pkg;