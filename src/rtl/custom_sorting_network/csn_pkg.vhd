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
		a    : natural;
		b    : natural;
		pass : boolean;
		asce : boolean;
	end record;
	
	constant cfg : cmp_cfg := (a => 0, b => 1, pass => False, asce => False);
	

end package csn_pkg;

package body csn_pkg is

end package body csn_pkg;
