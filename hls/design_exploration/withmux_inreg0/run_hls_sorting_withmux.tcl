proc range {from to {step 1}} {
    set res $from; while {$to>$from} {lappend res [incr from $step]}; return $res
}


open_project sorting_withmux
set_top compare_main
add_files ../../sources/sorting_withmux.cpp
add_files ../../sources/sorting_withmux.h
add_files ../../sources/pairs_352_16.h
add_files -tb ../../dat/test_352_16.dat -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb ../../dat/test_22_16.dat -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb ../../sources/test.dat -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb ../../sources/comparator_test_withmux.cpp -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"




## solution-specific settings

set Is [list 352]
set Os [list 16]
set Ds [list 8 7]
set IIs [list 1 4]
set muxs [list 1]
set flats [list 1]
set in_regs [list 0]
set rebuilts [list 0 1]


foreach I $Is {
	foreach O $Os {
		foreach D $Ds {
			foreach II $IIs {
				foreach mux $muxs {
					foreach flat $flats {
						foreach in_reg $in_regs {
						    foreach rebuilt $rebuilts {
							puts "Creating solution with I = $I, O = $O, D = $D, II = $II, mux = $mux, flat = $flat, in_reg = $in_reg, rebuilt= $rebuilt"
							set runname [format "I%03d_O%03d_D%03d_II%01d_M%01d_F%01d_IR%01d_R%01d" $I $O $D $II $mux $flat $in_reg $rebuilt]
							open_solution -reset $runname
							set_part {xcvu9p-flgc2104-1-e}
							create_clock -period 6.25 -name default
							config_export -format syn_dcp -rtl verilog
							set_clock_uncertainty 0.8

							set_directive_pipeline -II $II "compare_main"
							if {$in_reg == 1} {
								set_directive_interface -mode ap_none -register "compare_main" idata
								set_directive_latency -min [expr $D + 1] -max [expr $D + 1] "compare_main"
							} else	{
							        set_directive_interface -mode ap_none "compare_main" idata
								set_directive_latency -min $D -max $D "compare_main"
							}
														
							set_directive_interface -mode ap_none -register "compare_main" odata
							set_directive_interface -mode ap_ctrl_hs "compare_main"

							if {$rebuilt == 1} {
							        config_export -vivado_synth_design_args "-directive sdx_optimization_effort_high -flatten_hierarchy rebuilt"
							} else	{
								config_export -vivado_synth_design_args "-directive sdx_optimization_effort_high -flatten_hierarchy none"
							}							
							
							csim_design
							csynth_design
							#cosim_design -trace_level port -rtl vhdl
							export_design -flow impl -rtl verilog -format syn_dcp

							}
						}
					}
				}
			}
		}
	}
}
exit
