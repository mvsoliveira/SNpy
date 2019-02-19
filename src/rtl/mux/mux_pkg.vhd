library ieee;
use ieee.std_logic_1164.all;

package mux_pkg is
	type array2d is array (natural range <>) of std_logic_vector;
	function to_array(data : std_logic_vector; AW : integer; DW : integer) return array2d;

end package mux_pkg;

package body mux_pkg is

	function to_array(data : std_logic_vector; AW : integer; DW : integer) return array2d is
		variable mux_a : array2d(0 to 2**AW - 1)(DW - 1 downto 0);
	begin
		for i in mux_a'range  loop
			mux_a(i) := data((i+1)*DW-1 downto i*DW);
		end loop;
		return mux_a;
	end to_array;

end package body mux_pkg;
