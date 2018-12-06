proc create_run_N {N} {
	puts "Creating run with N = $N"
	if {[string equal [get_runs -quiet N=$N] ""]} {
	    create_run -name N=$N -part xcvu9p-flgc2104-2-e -flow {Vivado Synthesis 2018} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
	} else {
	  set_property strategy "Vivado Synthesis Defaults" [get_runs N=$N]
	  set_property flow "Vivado Synthesis 2018" [get_runs N=$N]	  
	}
	# Create 'N=$N_synth_report_utilization_0' report (if not found)
	if { [ string equal [get_report_configs -of_objects [get_runs N=$N] N={$N}_synth_report_utilization_0] "" ] } {
	  create_report_config -report_name N=${N}_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs N=$N
	}
	set obj [get_report_configs -of_objects [get_runs N=$N] N=${N}_synth_report_utilization_0]
	if { $obj != "" } {

	}
	set obj [get_runs N=$N]
	set_property -name "part" -value "xcvu9p-flgc2104-2-e" -objects $obj
	set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj
	set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value "-generic N=$N" -objects $obj
	set_property report_strategy {Vivado Synthesis Utilization Reports} $obj
        set_property report_strategy {Utilization} $obj
}

set i 2
set step 500
set maxi 1510
while { $i < $maxi } {
	create_run_N $i
	set i [expr $i + $step]
}



