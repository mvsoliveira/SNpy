# ==============================================================
# Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.2.1 (64-bit)
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# ==============================================================
source ./settings.tcl
source -notrace ./extraction.tcl

set targetPart ${device}${package}${speed}
set vivadoProjectName project
set vivadoProjectDir .
set hlsProjectName sorting_nomux
set hlsSolutionName I352_O016_D008_II1_M0_F1_IR0_R0
set outputDir ./report 
set top_inst_name $top_module
set error_if_impl_timing_fails false
set target_clk_period_ns "6.250"
file mkdir $outputDir

create_project $vivadoProjectName $vivadoProjectDir -part $targetPart -force
set_property target_language $language [current_project]


# setup design sources and constraints
set hdlfs [glob -nocomplain ./*.vhd ./*.v]
if {$hdlfs != "" } {
    add_files -norecurse $hdlfs
}
set xdcfs [glob -nocomplain ./*.xdc]
if {$xdcfs != "" } {
    add_files -fileset constrs_1 -norecurse $xdcfs
}

# vivado scripts to generate IP
set tclfiles [glob -nocomplain *_ip.tcl]
if { $tclfiles != ""} {
    foreach file $tclfiles {
         source $file
    }
}

update_compile_order -fileset sources_1
set_property XPM_LIBRARIES {XPM_MEMORY} [current_project]

# synth properties setting
set synth_run [get_runs -filter {IS_SYNTHESIS == 1} synth_1]

set synth_args [list -directive sdx_optimization_effort_high -flatten_hierarchy none -mode out_of_context]
if { [llength $synth_args] } {
    set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value $synth_args -objects $synth_run
}

# launch run synth
launch_runs synth_1
wait_on_run synth_1
open_run synth_1
# write a few files and reports after synthesis
run_report report_utilization -file $outputDir/${top_module}_utilization_synth.rpt
run_report report_timing_summary -file $outputDir/${top_module}_timing_synth.rpt
write_checkpoint -force $outputDir/${top_module}.dcp

if { [catch { compile_reports_vivado false $target_clk_period_ns $outputDir $top_module ../report/$language $targetPart $hlsProjectName $hlsSolutionName $clock } err] } {
    puts "ERROR \[IMPL-251\] Errors occured while compiling post-synthesis report: $err"
    exit 1
}
# launch run impl
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
launch_runs impl_1
wait_on_run impl_1
open_run impl_1
# write a few files and reports after route
run_report report_route_status -file $outputDir/${top_module}_status_routed.rpt
run_report report_timing -max_paths 10 -file $outputDir/${top_module}_timing_paths_routed.rpt
run_report report_utilization -file $outputDir/${top_module}_utilization_routed.rpt
run_report report_timing_summary -file $outputDir/${top_module}_timing_routed.rpt
check_impl_run impl_1 $error_if_impl_timing_fails
if { [catch { compile_reports_vivado 1 $target_clk_period_ns $outputDir $top_module ../report/$language $targetPart $hlsProjectName $hlsSolutionName $clock } err] } {
    puts "ERROR \[IMPL-251\] Errors occured while compiling report: $err"
    exit 1
}
