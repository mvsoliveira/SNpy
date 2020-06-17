#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/softs/xilinx/vivado/2019.2_lin64/ids_lite/ISE/bin/lin64:/softs/xilinx/vivado/2019.2_lin64/bin
else
  PATH=/softs/xilinx/vivado/2019.2_lin64/ids_lite/ISE/bin/lin64:/softs/xilinx/vivado/2019.2_lin64/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/vol1/msilva_selsrv1/sorting/hls/design_exploration2/nomux_rebuit1/sorting_nomux/I352_O016_D004_II4_M0_F1_IR1_R1/impl/verilog/project.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log compare_main.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source compare_main.tcl
