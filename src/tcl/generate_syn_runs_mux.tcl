proc create_run {AW DW D {run 1} myopt} {
    puts "Creating run with AW = $AW, DW = $DW, D = $D"
    set prjpre [format "mux_AW%03d_DW%03d_D%03d" $AW $DW $D]
    set prjname [format "%s-%s" $prjpre $myopt]
    set basepath "D:/mygitlab/sorting"
    set prjpath [format "%s/syn/%s/wrapper_mux_%s.prj" $basepath $prjname $prjname]
    set subprjpath [format "%s/syn/%s/mux_1/mux_%s.prj" $basepath $prjname $prjname]
    puts $prjpath
    puts $subprjpath
    project -new $prjpath
	add_file -vhdl ${basepath}/src/rtl/mux/mux_pkg.vhd
    add_file -vhdl ${basepath}/src/rtl/mux/mux.vhd
    add_file -verilog ${basepath}/src/rtl/lfsr.sv    
    add_file -verilog ${basepath}/src/rtl/reducer.sv
    add_file -vhdl ${basepath}/src/rtl/shift_reg_tap.vhd    
	add_file -vhdl ${basepath}/src/rtl/mux/wrapper_mux.vhd  
    set_option -disable_io_insertion 0
    set_option -part XCVU9P
    set_option -package FLGC2104
    set_option -vhdl2008 1
    set_option -retiming 0
    switch $myopt {
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
	    puts "Invalid myopt option!"
	}
    }
    hdl_param -set AW $AW
    hdl_param -set DW $DW
    hdl_param -set delay $D
    project -save $prjpath
    project -run compile
    cd ${basepath}/syn
    export_project -instance mux_1 -add_file {../src/rtl/mux/mux_pkg.vhd ../src/rtl/mux/mux.vhd} -no_default_hdl -project $subprjpath

    project_data -active $subprjpath

    set_option -disable_io_insertion 1
    set_option -part XCVU9P
    set_option -package FLGC2104
    set_option -vhdl2008 1   
    hdl_param -set AW $AW
    hdl_param -set DW $DW
    hdl_param -set delay $D
    set_option -job pr_1 -add par
    set_option -job pr_1 -option enable_run 0
    switch $myopt {
	freq160retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 160
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
	}
	freq160retfan16 {
	    set_option -retiming 1
	    set_option -frequency 160
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_160.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
	}
	freq80retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 80
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
	}
	freq80retfan16 {
	    set_option -retiming 1
	    set_option -frequency 80
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_80.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
	}	
	freq320retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
	}
	freq320retfan16 {
	    set_option -retiming 1
	    set_option -frequency 320
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_320.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
	}
	freq40retfan10000 {
	    set_option -retiming 1
	    set_option -frequency 40
	    set_option -fanout_limit 10000
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
	}
	freq40retfan16 {
	    set_option -retiming 1
	    set_option -frequency 40
	    set_option -fanout_limit 16
		add_file -constraint ${basepath}/src/xdc/clock_40.sdc
		add_file -constraint ${basepath}/src/xdc/mux.sdc
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
#set opts [list freq320retfan10000 freq320retfan16 freq160retfan10000 freq160retfan16 freq80retfan10000 freq80retfan16 freq40retfan10000 freq40retfan16]
set opts [list freq160retfan10000]
lappend cfgs [list 12 32 [range 0 3]]

foreach cfg $cfgs {
    foreach {AW DW Dr} $cfg {
		foreach {D} $Dr {
			foreach myopt $opts {
				puts "$AW $DW $D"
				create_run $AW $DW $D 1 $myopt
			}
		}
    }
}