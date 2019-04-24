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
    constant stages  : stages_a  := get_stg(I, delay);
    -- total number of registered stages: 11.

	type net_array_t is array (natural range <>) of muon_a(0 to I - 1);

	signal net_array : net_array_t(0 to cfg_net'length);
	type ret_off_t is array (natural range <>) of natural;

	constant ret_off : ret_off_t(0 to I - 1) := (others => 0); 
	constant max_ret_off : natural := 0;
	
	signal ret_array : net_array_t(0 to delay + max_ret_off);
	
	-- for xilinx synthesis
	attribute shreg_extract : string;
    attribute shreg_extract of ret_array : signal is "no";
    
    attribute syn_srlstyle: string;  
    attribute syn_srlstyle of ret_array : signal is "registers";
    

begin

	net_array(0) <= muon_i;

	stage_g : for stage in 0 to cfg_net'high generate
		pair_g : for pair in 0 to I / 2 - 1 generate

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

		end generate pair_g;
	end generate stage_g;

	--ret_array(0) <= net_array(cfg_net'length);
	muon_o <= net_array(cfg_net'length)(muon_o'range);

	--retiming_p : process(all) is
	--begin
	--	if rising_edge(clk) then
	--		for i in 1 to delay + max_ret_off loop
	--			ret_array(i) <= ret_array(i - 1);
	--		end loop;
	--	end if;
	--	for i in muon_o'range loop
	--		muon_o(i) <= ret_array(delay+ret_off(i))(i);
	--	end loop;
	--end process retiming_p;



end architecture RTL;
