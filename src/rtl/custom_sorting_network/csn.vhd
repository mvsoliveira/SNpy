library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.csn_pkg.all;

entity csn is
	generic(
		I     : natural := 16;
		O     : natural := 16;
		delay : natural := 3            -- delay in clock cycles for pipeline register
	);
	port(
		clk    : in std_logic;
		muon_i : in muon_a(0 to I - 1);
		muon_o : in muon_a(0 to O - 1)
	);
end entity csn;

architecture RTL of csn is

	constant cfg : cmp_cfg := (a => 0, b => 1, pass => False, asce => False);
	type cfg_1da is array (natural range <>) of cmp_cfg;

	type cfg_2da is array (natural range <>) of cfg_1da;
	
	constant cfg_1dav : cfg_1da := ((a => 0, b => 1, pass => False, asce => False), (a => 0, b => 1, pass => False, asce => False));
	constant cfg_2dav : cfg_2da := (((a => 0, b => 1, pass => False, asce => False), (a => 0, b => 1, pass => False, asce => False)),
		                            ((a => 0, b => 1, pass => False, asce => False), (a => 0, b => 1, pass => False, asce => False)));
									


begin

end architecture RTL;
