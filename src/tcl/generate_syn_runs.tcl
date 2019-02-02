project -new D:/mygitlab/sorting/syn/prjI016O16D00/wrapperI016O16D00.prj
add_file -vhdl D:/mygitlab/sorting/src/rtl/MuctpiDataTypes.vhd
add_file -vhdl D:/mygitlab/sorting/src/rtl/MuctpiFunctions.vhd
add_file -verilog D:/mygitlab/sorting/src/rtl/lfsr.sv
add_file -vhdl D:/mygitlab/sorting/src/rtl/muon_sorter.vhd
add_file -verilog D:/mygitlab/sorting/src/rtl/reducer.sv
add_file -vhdl D:/mygitlab/sorting/src/rtl/shift_reg_tap.vhd
add_file -vhdl D:/mygitlab/sorting/src/rtl/wrapper.vhd
add_file -constraint ../../src/xdc/wrapper.sdc
set_option -disable_io_insertion 0
set_option -part XCVU9P
set_option -package FLGC2104
set_option -vhdl2008 1
set_option -retiming 0
hdl_param -set I 16
hdl_param -set O 16
hdl_param -set delay 0
project -save D:/mygitlab/sorting/syn/prjI016O16D00/wrapperI016O16D00.prj 
project -run compile 
export_project -instance muon_sorter_1 -add_file {../src/rtl/MuctpiDataTypes.vhd ../src/rtl/MuctpiFunctions.vhd ../src/rtl/muon_sorter.vhd} -no_default_hdl -project D:/mygitlab/sorting/syn/prjI016O16D00/muon_sorter_1/muon_sorter_1.prj

project_data -active D:/mygitlab/sorting/syn/prjI016O16D00/muon_sorter_1/muon_sorter_1.prj

set_option -disable_io_insertion 1
set_option -part XCVU9P
set_option -package FLGC2104
set_option -vhdl2008 1
set_option -retiming 1
hdl_param -set num_in 16
hdl_param -set num_out 16
hdl_param -set delay 0
set_option -job pr_1 -add par
set_option -job pr_1 -option enable_run 0

add_file -constraint ../../../src/xdc/muon_sorter.sdc
project -save D:/mygitlab/sorting/syn/prjI016O16D00/muon_sorter_1/muon_sorter_1.prj


project_data -active D:/mygitlab/sorting/syn/prjI016O16D00/wrapperI016O16D00.prj
set_option -job par_1 -option enable_run 1
#impl -active rev_1
project -run



#run_tcl -fg D:/mygitlab/sorting/src/tcl/generate_syn_runs.tcl

# project_data -active D:/mygitlab/sorting/syn/muon_sorter_muon_sorter_1/muon_sorter_muon_sorter_1.prj
# set_option -disable_io_insertion 1
# set_option -part XCVU9P
# set_option -package FLGC2104
# set_option -vhdl2008 1
# set_option -retiming 1
# hdl_param -set num_in 16
# hdl_param -set num_out 16
# hdl_param -set delay 0
# set_option -job pr_1 -add par
# set_option -job pr_1 -option enable_run 0
# set_option -constraint  D:/mygitlab/sorting/src/xdc/muon_sorter.sdc
# project -save D:/mygitlab/sorting/syn/muon_sorter_muon_sorter_1/muon_sorter_muon_sorter_1.prj
#impl -active muon_impl
# project -run  
# project_data -active D:/mygitlab/sorting/syn/prjI016O16D00/wrapperI016O16D00.prj
#impl -active wrapper_impl
# project -run