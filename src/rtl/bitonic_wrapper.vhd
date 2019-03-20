library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bitonic_sorter_vhd_pkg.all;

entity bitonic_wrapper is
	generic(
		I        : natural := 16;
		O        : natural := 16;
		fixed_id : natural := 0;
		delay    : natural := 3         -- delay in clock cycles for pipeline register
	);

	port(
		clk : in  std_logic;
		muon_cand   : in  muon_array(0 to I - 1);
		top_cand   : out muon_array(0 to O - 1)
	);
end entity bitonic_wrapper;

architecture RTL of bitonic_wrapper is


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


	bitonic_inst : retiming_bitonic
		generic map(
			W     => I,
			DIR   => 1,
			delay => delay)
		port map(
			clk => clk,
			m   => muon_cand,
			q   => top_cand);

end architecture RTL;
