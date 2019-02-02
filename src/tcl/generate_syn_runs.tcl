proc create_run {I O D} {
	puts "Creating run with I = $I, O = $O, D = $D"
	set prjname [format "prj_I%03d_O%03d_D%03d" $I $O $D]
	set basepath "D:/mygitlab/sorting"
	set prjpath [format "%s/syn/%s/wrapper_%s.prj" $basepath $prjname $prjname]
	set subprjpath [format "%s/syn/%s/muon_sorter_1/muon_sorter_%s.prj" $basepath $prjname $prjname]
	puts $prjpath
	puts $subprjpath
	project -new $prjpath
	add_file -vhdl ${basepath}/src/rtl/MuctpiDataTypes.vhd
	add_file -vhdl ${basepath}/src/rtl/MuctpiFunctions.vhd
	add_file -verilog ${basepath}/src/rtl/lfsr.sv
	add_file -vhdl ${basepath}/src/rtl/muon_sorter.vhd
	add_file -verilog ${basepath}/src/rtl/reducer.sv
	add_file -vhdl ${basepath}/src/rtl/shift_reg_tap.vhd
	add_file -vhdl ${basepath}/src/rtl/wrapper.vhd
	add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	set_option -disable_io_insertion 0
	set_option -part XCVU9P
	set_option -package FLGC2104
	set_option -vhdl2008 1
	set_option -retiming 0
	hdl_param -set I $I
	hdl_param -set O $O
	hdl_param -set delay $D
	project -save $prjpath
	project -run compile 
	export_project -instance muon_sorter_1 -add_file {../src/rtl/MuctpiDataTypes.vhd ../src/rtl/MuctpiFunctions.vhd ../src/rtl/muon_sorter.vhd} -no_default_hdl -project $subprjpath

	project_data -active $subprjpath

	set_option -disable_io_insertion 1
	set_option -part XCVU9P
	set_option -package FLGC2104
	set_option -vhdl2008 1
	set_option -retiming 1
	hdl_param -set num_in $I
	hdl_param -set num_out $O
	hdl_param -set delay $D
	set_option -job pr_1 -add par
	set_option -job pr_1 -option enable_run 0

	add_file -constraint ${basepath}/src/xdc/muon_sorter.sdc
	project -save $subprjpath


	project_data -active $prjpath
	set_option -job par_1 -option enable_run 1
	#impl -active rev_1
	project -run
}



create_run 16 16 0
create_run 16 16 1
create_run 16 16 2
create_run 16 16 3

#run_tcl D:/mygitlab/sorting/src/tcl/generate_syn_runs.tcl

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