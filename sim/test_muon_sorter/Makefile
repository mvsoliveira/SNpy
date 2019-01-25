# top-level language
TOPLEVEL_LANG=vhdl
# Gui mode if desired
GUI=1
# force waveform to be generated, you can open the wlf file using vsim -view 
WAVES=1
# sets default simulator
SIM=modelsim
# enables Modelsim support to VHDL-2008 by default
VCOM_ARGS=-2008
# sets timescale to ps if desired, default ns
#VSIM_ARGS+	=-t 1ps
# set generics
VSIM_ARGS+=-gnum_in=12 -gnum_out=2
# vhdl files
include ../RTLFiles.inc
# top-level entity name
TOPLEVEL=muon_sorter
# python test name
MODULE=test_muon_sorter
# include to cocotb makefiles
include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim
