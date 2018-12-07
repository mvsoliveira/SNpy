proc create_run_N {N O} {
	puts "Creating run with N = $N, O = $O"
	if {[string equal [get_runs -quiet N${N}O${O}] ""]} {
	    create_run -name N${N}O${O} -part xcvu9p-flgc2104-2-e -flow {Vivado Synthesis 2018} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
	} else {
	  set_property strategy "Vivado Synthesis Defaults" [get_runs N${N}O${O}]
	  set_property flow "Vivado Synthesis 2018" [get_runs N${N}O${O}]	  
	}
	# Create 'N${N}O${O}_synth_report_utilization_0' report (if not found)
	if { [ string equal [get_report_configs -of_objects [get_runs N${N}O${O}] N={$N}_synth_report_utilization_0] "" ] } {
	  create_report_config -report_name N=${N}_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs N${N}O${O}
	}
	set obj [get_report_configs -of_objects [get_runs N${N}O${O}] N=${N}_synth_report_utilization_0]
	if { $obj != "" } {

	}
	set obj [get_runs N${N}O${O}]
	set_property -name "part" -value "xcvu9p-flgc2104-2-e" -objects $obj
	set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj
	set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value "-generic N=$N -generic O=$O" -objects $obj
	set_property report_strategy {Vivado Synthesis Utilization Reports} $obj
        set_property report_strategy {Utilization} $obj
}

set i 37
set step 1
set maxi 50
set maxo 16
while { $i <= $maxi } {
    if {$i < $maxo} {
	create_run_N $i $i
    } else {
	create_run_N $i $maxo
    }
	set i [expr $i + $step]
}



