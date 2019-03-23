proc create_run {I O D {run 1} opt} {
    puts "Creating run with I = $I, O = $O, D = $D"
    set prjpre [format "I%03d_O%03d_D%03d_BITONIC_SEL_TOPVHDL_PT4BIT" $I $O $D]
    set prjname [format "%s-%s" $prjpre $opt]
    set basepath "D:/mygitlab/sorting"
    set prjpath [format "%s/syn/%s/wrapper_%s.prj" $basepath $prjname $prjname]
    set subprjpath [format "%s/syn/%s/muon_sorter_1/muon_sorter_%s.prj" $basepath $prjname $prjname]
    puts $prjpath
    puts $subprjpath
    project -new $prjpath
	add_file -verilog ${basepath}/src/rtl/bitonic_sorter_pkg.sv
	add_file -vhdl    ${basepath}/src/rtl/bitonic_sorter_vhd_pkg.vhd
	add_file -verilog ${basepath}/src/rtl/compare.sv
	add_file -verilog ${basepath}/src/rtl/bitonic_merge.sv
	add_file -verilog ${basepath}/src/rtl/bitonic_sort.sv
	add_file -verilog ${basepath}/src/rtl/retiming_bitonic.sv
    add_file -verilog ${basepath}/src/rtl/lfsr.sv    
    add_file -verilog ${basepath}/src/rtl/reducer.sv
	add_file -vhdl    ${basepath}/src/rtl/shift_reg_tap.vhd
	add_file -vhdl    ${basepath}/src/rtl/bitonic_sel_wrapper.vhd
	add_file -vhdl    ${basepath}/src/rtl/wrapper_bitonic_selection.vhd
    set_option -disable_io_insertion 0
    set_option -part XCVU9P
    set_option -package FLGC2104
    set_option -vhdl2008 1
    set_option -retiming 0
	hdl_param -set I $I
    hdl_param -set O $O
	hdl_param -set delay $D
	set_option -top_module wrapper
    add_file -constraint ${basepath}/src/xdc/wrapper.sdc
    switch $opt {
	freq160retfan10000 {
	    set_option -frequency 160
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		
	}
	freq160retfan16 {
	    set_option -frequency 160
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		
	}
	freq80retfan10000 {
	    set_option -frequency 80
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		
	}
	freq80retfan16 {
	    set_option -frequency 80
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		
	}
	freq100retfan10000 {
	    set_option -frequency 100
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		
	}
	freq100retfan16 {
	    set_option -frequency 100
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		
	}	
	freq320retfan10000 {
	    set_option -frequency 320
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		
	}
	freq320retfan16 {
	    set_option -frequency 320
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		
	}
	freq40retfan10000 {
	    set_option -frequency 40
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		
	}
	freq40retfan16 {
	    set_option -frequency 40
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		
	}
	freq280x320retfan10000 {
	    set_option -frequency 280
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_280.sdc
		
	}
	freq280x400retfan10000 {
	    set_option -frequency 280
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_280.sdc
		
	}
	freq280retfan10000 {
	    set_option -frequency 280
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_280.sdc
		
	}
	freq160x320retfan10000 {
	    set_option -frequency 160
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		
	}	
	default {
	    puts "Invalid opt option!"
	}
    }
    project -save $prjpath
    project -run compile
    cd ${basepath}/syn
    export_project -instance dut_inst -add_file {../src/rtl/bitonic_sorter_vhd_pkg.vhd ../src/rtl/bitonic_sorter_pkg.sv ../src/rtl/compare.sv ../src/rtl/bitonic_merge.sv ../src/rtl/bitonic_sort.sv ../src/rtl/retiming_bitonic.sv ../src/rtl/bitonic_sel_wrapper.vhd} -no_default_hdl -project $subprjpath

    project_data -active $subprjpath

    set_option -disable_io_insertion 1
    set_option -part XCVU9P
    set_option -package FLGC2104
    set_option -vhdl2008 1   
    hdl_param -set I $I
    hdl_param -set O $O
	hdl_param -set delay $D
    set_option -job pr_1 -add par
    set_option -job pr_1 -option enable_run 0
	add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
    switch $opt {
	freq160retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 160
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		 
	}
	freq160retfan16 {
	    set_option -retiming 1
	    set_option -frequency 160
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		 
	}
	freq80retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 80
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		 
	}
	freq80retfan16 {
	    set_option -retiming 1
	    set_option -frequency 80
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		 
	}
	freq100retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 100
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		 
	}
	freq100retfan16 {
	    set_option -retiming 1
	    set_option -frequency 100
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		 
	}	
	freq320retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		 
	}
	freq320retfan16 {
	    set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		 
	}
	freq40retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 40
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		 
	}
	freq40retfan16 {
	    set_option -retiming 1
	    set_option -frequency 40
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		 
	}
	freq280x320retfan10000 {
		set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		 
	}
	freq280x400retfan10000 {
		set_option -retiming 1
	    set_option -frequency 400
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_400.sdc
		 
	}
	freq280retfan10000 {
		set_option -retiming 1
	    set_option -frequency 280
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_280.sdc
		 
	}
	freq160x320retfan10000 {
		set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		 
	}	
	default {
	    puts "Invalid opt option!"
	}
    }

    
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
#set opts [list freq320retfan10000 freq160retfan10000 freq100retfan10000]
set opts [list freq280x400retfan10000]

#lappend cfgs [list 16 16 [range 0 2]]
#lappend cfgs [list 16 2 [range 0 2]]
lappend cfgs [list 16 16 [range 0 0]]
lappend cfgs [list 32 32 [range 0 0]]
lappend cfgs [list 64 64 [range 0 0]]
lappend cfgs [list 128 128 [range 0 0]]
lappend cfgs [list 256 256 [range 0 0]]
lappend cfgs [list 512 512 [range 0 0]]
#lappend cfgs [list 32 16 [range 0 5]]
#lappend cfgs [list 32 4 [range 0 5]]
#lappend cfgs [list 48 16 [range 0 8]]
#lappend cfgs [list 64 16 [range 0 10]]

foreach cfg $cfgs {
    foreach {I O Dr} $cfg {
		foreach {D} $Dr {
			foreach opt $opts {
				puts "$I $O $D"
				create_run $I $O $D 1 $opt
			}
		}
    }
}
