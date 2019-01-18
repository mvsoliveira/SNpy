proc create_run_I_O {I O} {
	puts "Creating run with I = $I, O = $O"
	set run [format "I%03dO%02d" $I $O] 
	if {[string equal [get_runs -quiet $run] ""]} {
	    create_run -name $run -part xcvu9p-flgc2104-2-e -flow {Vivado Synthesis 2018} -strategy "Flow_RuntimeOptimized" -report_strategy {No Reports} -constrset constrs_1
	} else {
	  set_property strategy "Flow_RuntimeOptimized" [get_runs $run]
	  set_property flow "Vivado Synthesis 2018" [get_runs $run]	  
	}
	# Create '$run_synth_report_utilization_0' report (if not found)
	if { [ string equal [get_report_configs -of_objects [get_runs $run] I=${I}O=${O}_synth_report_utilization_0] "" ] } {
	  create_report_config -report_name I=${I}O=${O}_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs $run
	}
	set obj [get_report_configs -of_objects [get_runs $run] I=${I}O=${O}_synth_report_utilization_0]
	if { $obj != "" } {

	}
	set obj [get_runs $run]
	set_property -name "part" -value "xcvu9p-flgc2104-2-e" -objects $obj
	set_property -name "strategy" -value "Flow_RuntimeOptimized" -objects $obj
	set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value "-generic I=$I -generic O=$O -no_timing_driven -verbose" -objects $obj
	set_property report_strategy {Vivado Synthesis Utilization Reports} $obj
        set_property report_strategy {Utilization} $obj
}

set i 96
set step 8
set maxi 176
set maxo 16
while { $i <= $maxi } {
    if {$i < $maxo} {
	create_run_I_O $i $i
    } else {
	create_run_I_O $i $maxo
    }
	set i [expr $i + $step]
}



