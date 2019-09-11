PYTHONPATH=/d/projects/cocotb/:/c/ProgramData/Anaconda3/python37.zip/:/c/ProgramData/Anaconda3/DLLs/:/c/ProgramData/Anaconda3/Library/bin/:/c/ProgramData/Anaconda3/lib/:/c/ProgramData/Anaconda3/:/c/ProgramData/Anaconda3/lib/site-packages/numpy/:/c/ProgramData/Anaconda3/lib/site-packages/:/c/ProgramData/Anaconda3/lib/site-packages/win32/:/c/ProgramData/Anaconda3/lib/site-packages/win32/lib/:/c/ProgramData/Anaconda3/lib/site-packages/Pythonwin/:/c/ProgramData/Anaconda3:/c/ProgramData/Anaconda3/Library/mingw-w64/bin:/c/ProgramData/Anaconda3/Library/usr/bin:/c/ProgramData/Anaconda3/Scripts
# always generate the same random sequence
export RANDOM_SEED=1377424946
# raise an error when trying to read
export COCOTB_RESOLVE_X=VALUE_ERROR
# top-level language
TOPLEVEL_LANG=vhdl
# Gui mode if desired
GUI=0
# force waveform to be generated, you can open the wlf file using vsim -view 
WAVES=0
# sets default simulator
SIM=modelsim
# enables Modelsim support to VHDL-2008 by default
VCOM_ARGS=-2008
# sets timescale to ps if desired, default ns
#VSIM_ARGS+	=-t 1ps
# set generics
export VSIM_ARGS+=-gI=352 -gO=16 -gdelay=5 -gDA=4 -gDB=2
# vhdl files
include ./RTLFiles.inc
# top-level entity name
#export TOPLEVEL=csn_sel_wrapper
export TOPLEVEL=csn_sort_88_64
# python test name
MODULE=test_muon_csn
# include to cocotb makefiles
include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
