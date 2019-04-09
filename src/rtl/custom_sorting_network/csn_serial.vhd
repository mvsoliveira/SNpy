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

	constant pair_cmp_net : pair_cmp_cfg := get_pair_cfg(I);

	type net_array_t is array (natural range <>) of muon_a(0 to I - 1);
	--type net_array_t is array (0 to cfg_net'length) of muon_a(0 to I - 1);
	--type ret_array_t is array (0 to delay) of muon_a(0 to I - 1);
	signal net_array     : net_array_t(0 to pair_cmp_net'length);
	type ret_off_t is array (natural range <>) of natural;
	--constant ret_off : ret_off_t(0 to I - 1) := (0,0,1,2,3,3,4,5,5,4,3,3,2,1,0,0);
	--constant ret_off : ret_off_t(0 to I - 1) := (0,0,0,0,1,1,2,2,3,3,3,3,4,4,5,5);
	--constant ret_off : ret_off_t(0 to I - 1) := (0,0,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,0,0);
	constant ret_off     : ret_off_t(0 to I - 1) := (others => 0);
	constant max_ret_off : natural               := 0;
	signal ret_array     : net_array_t(0 to delay + max_ret_off);

begin

	net_array(0) <= muon_i;

	stage_g : for stage in 0 to pair_cmp_net'high generate

		csn_cmp_inst : entity work.csn_cmp
			generic map(
				ascending       => pair_cmp_net(stage).o,
				pass_through    => pair_cmp_net(stage).p,
				output_register => pair_cmp_net(stage).r
			)
			port map(
				clk => clk,
				a_i => net_array(stage)(pair_cmp_net(stage).a),
				b_i => net_array(stage)(pair_cmp_net(stage).b),
				a_o => net_array(stage + 1)(pair_cmp_net(stage).a),
				b_o => net_array(stage + 1)(pair_cmp_net(stage).b)
			);

		input_g : for i in 0 to I - 1 generate

			in_g : if not ((i = pair_cmp_net(stage).a) or (i = pair_cmp_net(stage).b)) generate
				net_array(stage + 1)(i) <= net_array(stage)(i);
			end generate in_g;

		end generate input_g;
	end generate stage_g;

	ret_array(0) <= net_array(pair_cmp_net'length);

	retiming_p : process(all) is
	begin
		if rising_edge(clk) then
			for i in 1 to delay + max_ret_off loop
				ret_array(i) <= ret_array(i - 1);
			end loop;
		end if;
		for i in muon_o'range loop
			muon_o(i) <= ret_array(delay + ret_off(i))(i);
		end loop;
	end process retiming_p;

end architecture RTL;
