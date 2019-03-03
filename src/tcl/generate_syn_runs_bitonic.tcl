proc create_run {I O D {run 1} opt} {
    puts "Creating run with I = $I, O = $O, D = $D"
    set prjpre [format "I%03d_O%03d_D%03d_BITONIC" $I $O $D]
    set prjname [format "%s-%s" $prjpre $opt]
    set basepath "D:/mygitlab/sorting"
    set prjpath [format "%s/syn/%s/wrapper_%s.prj" $basepath $prjname $prjname]
    set subprjpath [format "%s/syn/%s/muon_sorter_1/muon_sorter_%s.prj" $basepath $prjname $prjname]
    puts $prjpath
    puts $subprjpath
    project -new $prjpath
	add_file -verilog ${basepath}/src/rtl/bitonic_sorter_pkg.sv
	add_file -verilog ${basepath}/src/rtl/compare.sv
	add_file -verilog ${basepath}/src/rtl/bitonic_merge.sv
	add_file -verilog ${basepath}/src/rtl/bitonic_sort.sv
	add_file -verilog ${basepath}/src/rtl/retiming_bitonic.sv
    add_file -verilog ${basepath}/src/rtl/lfsr.sv    
    add_file -verilog ${basepath}/src/rtl/reducer.sv
	add_file -verilog ${basepath}/src/rtl/bitonic_sorter_16_top.sv
    set_option -disable_io_insertion 0
    set_option -part XCVU9P
    set_option -package FLGC2104
    set_option -vhdl2008 1
    set_option -retiming 0
	hdl_param -set delay $D
    switch $opt {
	freq160retfan10000 {
	    set_option -frequency 160
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq160retfan16 {
	    set_option -frequency 160
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq80retfan10000 {
	    set_option -frequency 80
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq80retfan16 {
	    set_option -frequency 80
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq100retfan10000 {
	    set_option -frequency 100
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq100retfan16 {
	    set_option -frequency 100
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}	
	freq320retfan10000 {
	    set_option -frequency 320
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq320retfan16 {
	    set_option -frequency 320
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq40retfan10000 {
	    set_option -frequency 40
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}
	freq40retfan16 {
	    set_option -frequency 40
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		add_file -constraint ${basepath}/src/xdc/wrapper.sdc
	}	
	default {
	    puts "Invalid opt option!"
	}
    }
    project -save $prjpath
    project -run compile
    cd ${basepath}/syn
    export_project -instance dut_inst -add_file {../src/rtl/bitonic_sorter_pkg.sv ../src/rtl/compare.sv ../src/rtl/bitonic_merge.sv ../src/rtl/bitonic_sort.sv ../src/rtl/retiming_bitonic.sv} -no_default_hdl -project $subprjpath

    project_data -active $subprjpath

    set_option -disable_io_insertion 1
    set_option -part XCVU9P
    set_option -package FLGC2104
    set_option -vhdl2008 1   
    hdl_param -set delay $D
    set_option -job pr_1 -add par
    set_option -job pr_1 -option enable_run 0
    switch $opt {
	freq160retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 160
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq160retfan16 {
	    set_option -retiming 1
	    set_option -frequency 160
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq80retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 80
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq80retfan16 {
	    set_option -retiming 1
	    set_option -frequency 80
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq100retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 100
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq100retfan16 {
	    set_option -retiming 1
	    set_option -frequency 100
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_100.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}	
	freq320retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq320retfan16 {
	    set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq40retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 40
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
	}
	freq40retfan16 {
	    set_option -retiming 1
	    set_option -frequency 40
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		add_file -constraint ${basepath}/src/xdc/muon_bitonic.sdc
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
set opts [list freq320retfan10000 freq160retfan10000 freq100retfan10000]

#lappend cfgs [list 16 16 [range 0 2]]
#lappend cfgs [list 16 2 [range 0 2]]
lappend cfgs [list 16 16 [range 0 4]]
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
