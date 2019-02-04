proc create_run {I O D {run 0}} {
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
	cd ${basepath}/syn
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
	if {$run == 1} {project -run}  
	project -save $prjpath
}


proc range {from to {step 1}} {
	set res $from; while {$to>$from} {lappend res [incr from $step]}; return $res
}

set cfgs [] 
#lappend cfgs [list 16 16 [range 0 5]]
#lappend cfgs [list 32 16 [range 0 7]]
lappend cfgs [list 48 16 [range 0 8]]
#lappend cfgs [list 64 16 [range 0 10]]

foreach cfg $cfgs {
	foreach {I O Dr} $cfg {
		foreach {D} $Dr {
			puts "$I $O $D"
			create_run $I $O $D 1
			
		}
	}
}



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