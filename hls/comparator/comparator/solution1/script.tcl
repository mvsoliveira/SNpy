############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project comparator
set_top compare_exchange
add_files comparator.cpp
add_files -tb comparator_test.cpp
open_solution "solution1"
set_part {xcvu9p-flgc2104-1-e}
create_clock -period 10 -name default
config_export -format syn_dcp -rtl verilog -vivado_optimization_level 2 -vivado_phys_opt place -vivado_report_level 0
config_rtl -encoding onehot -kernel_profile=0 -module_auto_prefix=0 -mult_keep_attribute=0 -reset none -reset_async=0 -reset_level high -verbose=0
#source "./comparator/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -flow syn -rtl verilog -format syn_dcp
