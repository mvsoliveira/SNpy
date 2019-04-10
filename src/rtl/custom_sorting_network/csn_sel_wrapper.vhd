library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.csn_pkg.all;

entity csn_sel_wrapper is
	generic(
		I     : natural := 16;
		O     : natural := 16;
		delay : natural := 3            -- delay in clock cycles for pipeline register
	);
	
	port(
		clk    : in  std_logic;
		muon_sel_i : in  muon_sel_a(0 to I - 1);
		muon_o : out muon_a(0 to O - 1)
	);
end entity csn_sel_wrapper;

architecture RTL of csn_sel_wrapper is

	signal muon_cand : muon_a(0 to I - 1);	

begin

	id_g : for id in 0 to I - 1 generate

		muon_cand(id).idx <= std_logic_vector(to_unsigned(id, IDX_WIDTH));
		muon_cand(id).pt  <= muon_sel_i(id).pt;

	end generate id_g;

	dut_inst : entity work.csn
		generic map(
			I     => I,
			O     => O,
			delay => delay
		)
		port map(
			clk    => clk,
			muon_i => muon_cand,
			muon_o => muon_o
		);

end architecture RTL;