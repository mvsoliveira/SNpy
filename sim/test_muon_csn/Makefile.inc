# setting python bin
export PYTHON_BIN=python3
# always generate the same random sequence
export RANDOM_SEED=1377424946
# raise an error when trying to read
export COCOTB_RESOLVE_X=VALUE_ERROR
export SORTING_PATH=/home/msilvaol/sorting
export PYTHONPATH=/home/msilvaol/sorting/sim/test_muon_csn:/home/msilvaol/sorting/src/py
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
#generic is taken from Makefile from one of the nested folders
# vhdl files
VHDL_SOURCES += $(PWD)/../../src/rtl/custom_sorting_network/csn_pkg.vhd
VHDL_SOURCES += $(PWD)/../../src/rtl/custom_sorting_network/csn_cmp.vhd
VHDL_SOURCES += $(PWD)/../../src/rtl/custom_sorting_network/csn.vhd
VHDL_SOURCES += $(PWD)/../../src/rtl/custom_sorting_network/csn_net.vhd
VHDL_SOURCES += $(PWD)/../../src/rtl/custom_sorting_network/csn_sort_v2.vhd
# top-level entity name
export TOPLEVEL=csn_sort_v2
# python test name
MODULE="test_muon_csn"
# include to cocotb makefiles
include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
