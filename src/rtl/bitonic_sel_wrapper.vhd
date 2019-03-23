library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bitonic_sorter_vhd_pkg.all;

entity bitonic_sel_wrapper is
	generic(
		I     : natural := 16;
		O     : natural := 16;
		delay : natural := 3            -- delay in clock cycles for pipeline register
	);

	port(
		clk : in  std_logic;
		m   : in  muon_sel_array(0 to I - 1);
		q   : out muon_array(0 to O - 1)
	);
end entity bitonic_sel_wrapper;

architecture RTL of bitonic_sel_wrapper is

	signal muon_cand : muon_array(0 to I - 1);

	component retiming_bitonic
		generic(
			W     : integer;
			DIR   : integer;
			delay : integer
		);
		port(
			clk : in  std_logic;
			m   : in  muon_array(0 to I - 1);
			q   : out muon_array(0 to O - 1)
		);
	end component retiming_bitonic;

begin

	id_g : for id in 0 to I - 1 generate

		muon_cand(id).idx <= std_logic_vector(to_unsigned(id, IDX_WIDTH));
		muon_cand(id).pt  <= m(id).pt;

	end generate id_g;

	bitonic_inst : retiming_bitonic
		generic map(
			W     => I,
			DIR   => 1,
			delay => delay)
		port map(
			clk => clk,
			m   => muon_cand,
			q   => q);

end architecture RTL;