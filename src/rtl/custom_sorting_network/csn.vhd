library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.csn_pkg.all;

entity csn is
	generic(
		I     : natural := 16;
		O     : natural := 16;
		delay : natural := 3
	);
	port(
		clk    : in  std_logic;
		muon_i : in  muon_a(0 to I - 1);
		muon_o : out muon_a(0 to O - 1)
	);
end entity csn;

architecture RTL of csn is
	
  
	constant cfg_net : cfg_net_t := get_cfg(I);

	type net_array_t is array (0 to cfg_net'length) of muon_a(0 to I - 1);
	type ret_array_t is array (0 to delay) of muon_a(0 to I - 1);
	signal net_array : net_array_t;
	signal ret_array : ret_array_t;

begin

	net_array(0) <= muon_i;

	stage_g : for stage in 0 to cfg_net'high generate
		pair_g : for pair in 0 to I / 2 - 1 generate

			csn_cmp_inst : entity work.csn_cmp
				generic map(
					ascending       => cfg_net(stage)(pair).o,
					pass_through    => cfg_net(stage)(pair).p,
					output_register => cfg_net(stage)(pair).r
				)
				port map(
					clk => clk,
					a_i => net_array(stage)(cfg_net(stage)(pair).a),
					b_i => net_array(stage)(cfg_net(stage)(pair).b),
					a_o => net_array(stage + 1)(cfg_net(stage)(pair).a),
					b_o => net_array(stage + 1)(cfg_net(stage)(pair).b)
				);

		end generate pair_g;
	end generate stage_g;

	ret_array(0) <= net_array(cfg_net'length);

	retiming_p : process(all) is
	begin
		if rising_edge(clk) then
			for i in 1 to delay loop
				ret_array(i) <= ret_array(i - 1);
			end loop;
		end if;
	end process retiming_p;

	muon_o <= ret_array(delay);

end architecture RTL;