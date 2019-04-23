
proc create_run_I_O_D {I O D} {

puts "Creating run with I = $I, O = $O, D = $D"

set runname [format "I%03d_O%03d_D%03d_CSN_SEL_PIPE" $I $O $D]

create_run Synth_$runname -flow {Vivado Synthesis 2018}
create_run Impl_$runname -parent_run Synth_$runname -flow {Vivado Implementation 2018}
current_run [get_runs Impl_$runname]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value "-generic I=$I -generic O=$O -generic delay=$D" -objects [get_runs Synth_$runname]

}

proc range {from to {step 1}} {
    set res $from; while {$to>$from} {lappend res [incr from $step]}; return $res
}

set cfgs []
lappend cfgs [list 64 16 [range 1 9]]
lappend cfgs [list 88 16 [range 1 9]]
lappend cfgs [list 352 16 [range 5 14]]

foreach cfg $cfgs {
    foreach {I O Dr} $cfg {
        foreach {D} $Dr {
            create_run_I_O_D $I $O $D
        }
    }
}
