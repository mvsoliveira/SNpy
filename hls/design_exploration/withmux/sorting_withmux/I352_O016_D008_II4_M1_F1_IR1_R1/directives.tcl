############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
set_directive_pipeline -II 4 "compare_main"
set_directive_interface -mode ap_none -register "compare_main" idata
set_directive_latency -max 9 "compare_main"
set_directive_latency -min 9 "compare_main"
set_directive_interface -mode ap_none -register "compare_main" odata
set_directive_interface -mode ap_ctrl_hs "compare_main"