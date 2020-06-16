############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project sorting_withmux
set_top compare_main
add_files ../../sources/pairs_352_16.h
add_files ../../sources/sorting_withmux.h
add_files ../../sources/sorting_withmux.cpp
add_files -tb ../../sources/comparator_test_withmux.cpp -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb ../../sources/test.dat -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb ../../dat/test_22_16.dat -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb ../../dat/test_352_16.dat -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
open_solution "I352_O016_D006_II4_M1_F1_IR0_R0"
set_part {xcvu9p-flgc2104-1-e}
create_clock -period 6.25 -name default
config_export -format syn_dcp -rtl verilog -vivado_synth_design_args {-directive sdx_optimization_effort_high -flatten_hierarchy none}
set_clock_uncertainty 0.8
source "./sorting_withmux/I352_O016_D006_II4_M1_F1_IR0_R0/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -format syn_dcp
