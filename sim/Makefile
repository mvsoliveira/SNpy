# top-level language
TOPLEVEL_LANG=vhdl
# Gui mode if desired
GUI=0
# force waveform to be generated, you can open the wlf file using vsim -view 
WAVES=1
# sets default simulator
SIM=modelsim	
# enables support to VHDL-2008 by default
VCOM_ARGS=-2008
# sets timescale to ps if desired, default ns
#VSIM_ARGS+	=-t 1ps
# set generics
VSIM_ARGS+=-gdw=16 -gtw=5
# vhdl files
VHDL_SOURCES = $(PWD)/../src/rtl/shift_reg_tap.vhd
# top-level entity name
TOPLEVEL=shift_reg_tap
# python test name
MODULE=test_shift_reg_tap
# include to cocotb makefiles
include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim
