#set_property PACKAGE_PIN AU33 [get_ports clk_wrapper]
#set_property PACKAGE_PIN AV33 [get_ports clk_user]
#set_property PACKAGE_PIN AN32 [get_ports input]
#set_property PACKAGE_PIN AU31 [get_ports output]

#set_property IOSTANDARD LVCMOS18 [get_ports clk_wrapper]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_user]
#set_property IOSTANDARD LVCMOS18 [get_ports input]
#set_property IOSTANDARD LVCMOS18 [get_ports output]

define_attribute {v:dut_inst*} syn_hier {hard}

create_clock -period 1000.000 -name clk_wrapper -waveform {0.000 500.000} [get_ports clk_wrapper]

set_clock_groups -asynchronous -group [get_clocks clk_wrapper] -group [get_clocks clk]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks clk_wrapper]
set_false_path -from [get_clocks clk_wrapper] -to [get_clocks clk_wrapper]
