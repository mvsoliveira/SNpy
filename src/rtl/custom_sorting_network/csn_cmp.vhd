library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.csn_pkg.all;

entity csn_cmp is
	generic(ascending       : boolean := False;
	        pass_through    : boolean := False;
	        output_register : boolean := False
	       );
	port(
		clk : in  std_logic;
		a_i : in  muon_type;
		b_i : in  muon_type;
		a_o : out muon_type;
		b_o : out muon_type
	);
end entity csn_cmp;

architecture RTL of csn_cmp is

	signal a_o_comb : muon_type;
	signal b_o_comb : muon_type;

begin

	process(all)
	begin
		if pass_through then
			a_o_comb <= a_i;
			b_o_comb <= b_i;
		else
			if (a_i.pt > b_i.pt) = ascending then
				b_o_comb <= a_i;
				a_o_comb <= b_i;
			else
				a_o_comb <= a_i;
				b_o_comb <= b_i;
			end if;
		end if;
	end process;

	out_g : if output_register generate
		process(clk)
		begin
			if rising_edge(clk) then
				a_o <= a_o_comb;
				b_o <= b_o_comb;
			end if;
		end process;
	else generate
		a_o <= a_o_comb;
		b_o <= b_o_comb;
	end generate out_g;

end architecture RTL;
