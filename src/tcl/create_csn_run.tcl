proc range {from to {step 1}} {
    set res $from; while {$to>$from} {lappend res [incr from $step]}; return $res
}

proc my_create_run {I O D mux flat in_reg rebuilt} {

puts "Creating run with I = $I, O = $O, D = $D mux = $mux, flat= $flat, in_reg = $in_reg, rebuilt= $rebuilt"

set runname [format "I%03d_O%03d_D%03d_M%01d_F%01d_IR%01d_R%01d" $I $O $D $mux $flat $in_reg $rebuilt]

create_run Synth_$runname -flow {Vivado Synthesis 2019}
create_run Impl_$runname -parent_run Synth_$runname -flow {Vivado Implementation 2019}
current_run [get_runs Impl_$runname]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value "-mode out_of_context -generic I=$I -generic O=$O -generic D=$D -generic mux=$mux -generic in_reg=$in_reg -generic flat=$flat" -objects [get_runs Synth_$runname]

if {$rebuilt == 1} {
	set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY rebuilt [get_runs Synth_$runname]
	} else	{
	set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs Synth_$runname]
	}
}


set Is [list 352]
set Os [list 16]
set Ds [range 1 2]
set muxs [list 0 1]
set flats [list 1]
set in_regs [list 0]
set rebuilts [list 0 1]


foreach I $Is {
	foreach O $Os {
		foreach D $Ds {
			foreach mux $muxs {
				foreach flat $flats {
					foreach in_reg $in_regs {
					    foreach rebuilt $rebuilts {
						#puts "Calling run with I = $I, O = $O, D = $D mux = $mux, flat= $flat, in_reg = $in_reg, rebuilt= $rebuilt"
							my_create_run $I $O $D $mux $flat $in_reg $rebuilt
						}
					}
				}
			}
		}
	}
}


