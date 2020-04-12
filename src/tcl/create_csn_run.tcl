
proc create_run {I O D mux flat in_reg rebuilt} {

puts "Creating run with I = $I, O = $O, D = $D mux = $mux, flat= $flat, in_reg = $in_reg, rebuilt= $rebuilt"

set runname [format "I%03d_O%03d_D%03d_M%01d_F%01d_IR%01d_R%01d" $I $O $D $mux $flat $in_reg $rebuilt]

create_run Synth_$runname -flow {Vivado Synthesis 2018}
create_run Impl_$runname -parent_run Synth_$runname -flow {Vivado Implementation 2019}
current_run [get_runs Impl_$runname]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value "-generic I=$I -generic O=$O -generic delay=$D" -objects [get_runs Synth_$runname]
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs Synth_$runname]

}

proc range {from to {step 1}} {
    set res $from; while {$to>$from} {lappend res [incr from $step]}; return $res
}

set cfgs []
lappend cfgs [list 64 16 [range 1 9]]
lappend cfgs [list 88 16 [range 1 9]]
lappend cfgs [list 352 16 [range 5 10]]

foreach cfg $cfgs {
    foreach {I O Dr} $cfg {
        foreach {D} $Dr {
            create_run_I_O_D $I $O $D
        }
    }
}
