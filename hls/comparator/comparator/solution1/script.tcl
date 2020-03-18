############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project comparator
set_top compare_main
add_files comparator.cpp
add_files -tb comparator.dat
add_files -tb comparator_test.cpp -cflags "-Wno-unknown-pragmas"
open_solution "solution1"
set_part {xcvu9p-flgc2104-1-e}
create_clock -period 6.25 -name default
config_export -format syn_dcp -rtl verilog -vivado_optimization_level 2 -vivado_phys_opt place -vivado_report_level 0
config_rtl -encoding onehot -kernel_profile=0 -module_auto_prefix=0 -mult_keep_attribute=0 -reset none -reset_async=0 -reset_level high -verbose=0
config_sdx -optimization_level none -target none
set_clock_uncertainty 12.5%
#source "./comparator/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -flow syn -rtl verilog -format syn_dcp
