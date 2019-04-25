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
		clk          : in  std_logic;
		sink_valid   : in  std_logic;
		source_valid : out std_logic;
		muon_i       : in  muon_a(0 to I - 1);
		muon_o       : out muon_a(0 to O - 1)
	);
end entity csn;

architecture RTL of csn is

	constant cfg_net : cfg_net_t := get_cfg(I);
	constant stages  : stages_a  := get_stg(I, delay);

	type net_array_t is array (natural range <>) of muon_a(0 to I - 1);

	signal net_array   : net_array_t(0 to cfg_net'length);
	signal valid_array : std_logic_vector(0 to cfg_net'length);

begin

	net_array(0) <= muon_i;
	valid_array(0) <= sink_valid;

	stage_g : for stage in 0 to cfg_net'high generate
		pair_g : for pair in 0 to I / 2 - 1 generate
			-- sorting network stage
			csn_cmp_inst : entity work.csn_cmp
				generic map(
					ascending       => False,
					pass_through    => cfg_net(stage)(pair).p,
					output_register => stages(stage)
				)
				port map(
					clk => clk,
					a_i => net_array(stage)(cfg_net(stage)(pair).a),
					b_i => net_array(stage)(cfg_net(stage)(pair).b),
					a_o => net_array(stage + 1)(cfg_net(stage)(pair).a),
					b_o => net_array(stage + 1)(cfg_net(stage)(pair).b)
				);
				
			-- valid flags			
			valid_g : if stages(stage) generate
				process(clk)
				begin
					if rising_edge(clk) then
						valid_array(stage + 1) <= valid_array(stage);
					end if;
				end process;
			else generate
				valid_array(stage + 1) <= valid_array(stage);
			end generate valid_g;

		end generate pair_g;
	end generate stage_g;

	muon_o <= net_array(cfg_net'length)(muon_o'range);
	source_valid <= valid_array(cfg_net'length);

end architecture RTL;
