create_clock -period 6.250 -name clk -waveform {0.000 3.125} [get_ports clk]
set_input_delay 0 -clock clk muon_cand*
set_input_delay 0 -clock clk sink_valid
set_output_delay 0 -clock clk top_cand*	
set_output_delay 0 -clock clk source_valid