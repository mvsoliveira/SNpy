create_clock -period 1000.000 -name clk_wrapper -waveform {0.000 500.000} [get_ports clk_wrapper]
create_clock -period 6.250 -name clk_user -waveform {0.000 3.125} [get_ports clk_user]

set_clock_groups -asynchronous -group [get_clocks clk_wrapper] -group [get_clocks clk_user]
set_clock_groups -asynchronous -group [get_clocks clk_user] -group [get_clocks clk_wrapper]
set_false_path -from [get_clocks clk_wrapper] -to [get_clocks clk_wrapper]
# not investigating timing yet
#set_false_path -from [get_clocks clk_user] -to [get_clocks clk_user]

