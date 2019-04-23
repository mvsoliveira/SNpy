library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.csn_pkg.all;

entity csn_sort_88_64 is
	generic(
		I  : natural := 352;
		O  : natural := 16;
		DA : natural := 3;              -- delay in clock cycles for pipeline register
		DB : natural := 3               -- delay in clock cycles for pipeline register
	);

	port(
		clk        : in  std_logic;
		muon_sel_i : in  muon_sel_a(0 to I - 1);
		muon_o     : out muon_a(0 to O - 1)
	);
end entity csn_sort_88_64;

architecture RTL of csn_sort_88_64 is

	constant IA : natural := 88;
	constant IB : natural := 64;
	

	signal muon_cand    : muon_a(0 to I - 1);
	signal muon_stage_a : muon_a(0 to (I / IA) * O - 1);

begin

	id_g : for id in 0 to I - 1 generate

		muon_cand(id).idx <= std_logic_vector(to_unsigned(id, IDX_WIDTH));
		muon_cand(id).pt  <= muon_sel_i(id).pt;

	end generate id_g;

	stage_a_g : for id in 0 to I / IA - 1 generate

		csn_inst : entity work.csn
			generic map(
				I     => IA,
				O     => O,
				delay => DA
			)
			port map(
				clk    => clk,
				muon_i => muon_cand(id * IA to (id + 1) * IA - 1),
				muon_o => muon_stage_a(id * O to (id + 1) * O - 1)
			);

	end generate stage_a_g;

	stage_b_csn_inst : entity work.csn
		generic map(
			I     => IB,
			O     => O,
			delay => DB
		)
		port map(
			clk    => clk,
			muon_i => muon_stage_a,
			muon_o => muon_o
		);

end architecture RTL;
