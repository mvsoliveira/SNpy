
set TopModule "compare_main"
set ClockPeriod 6.25
set ClockList ap_clk
set HasVivadoClockPeriod 0
set CombLogicFlag 0
set PipelineFlag 1
set DataflowTaskPipelineFlag 1
set TrivialPipelineFlag 0
set noPortSwitchingFlag 0
set FloatingPointFlag 0
set FftOrFirFlag 0
set NbRWValue 0
set intNbAccess 0
set NewDSPMapping 1
set HasDSPModule 0
set ResetLevelFlag 1
set ResetStyle control
set ResetSyncFlag 1
set ResetRegisterFlag 0
set ResetVariableFlag 0
set FsmEncStyle onehot
set MaxFanout 0
set RtlPrefix {}
set ExtraCCFlags {}
set ExtraCLdFlags {}
set SynCheckOptions {}
set PresynOptions {}
set PreprocOptions {}
set SchedOptions {}
set BindOptions {}
set RtlGenOptions {}
set RtlWriterOptions {}
set CbcGenFlag {}
set CasGenFlag {}
set CasMonitorFlag {}
set AutoSimOptions {}
set ExportMCPathFlag 0
set SCTraceFileName mytrace
set SCTraceFileFormat vcd
set SCTraceOption all
set TargetInfo xcvu9p:-flgc2104:-1-e
set SourceFiles {sc {} c {../../../../sources/pairs_352_16.h ../../../../sources/sorting_nomux.h ../../../../sources/sorting_nomux.cpp}}
set SourceFlags {sc {} c {{ } {} { } {} { } {}}}
set DirectiveFile /vol1/msilva_selsrv1/sorting/hls/design_exploration2/nomux_rebuit1/sorting_nomux/I352_O016_D008_II1_M0_F1_IR0_R1/I352_O016_D008_II1_M0_F1_IR0_R1.directive
set TBFiles {verilog {../../../../sources/comparator_test_nomux.cpp ../../../../sources/test.dat ../../../../dat/test_22_16.dat ../../../../dat/test_352_16.dat} bc {../../../../sources/comparator_test_nomux.cpp ../../../../sources/test.dat ../../../../dat/test_22_16.dat ../../../../dat/test_352_16.dat} sc {../../../../sources/comparator_test_nomux.cpp ../../../../sources/test.dat ../../../../dat/test_22_16.dat ../../../../dat/test_352_16.dat} vhdl {../../../../sources/comparator_test_nomux.cpp ../../../../sources/test.dat ../../../../dat/test_22_16.dat ../../../../dat/test_352_16.dat} c {} cas {../../../../sources/comparator_test_nomux.cpp ../../../../sources/test.dat ../../../../dat/test_22_16.dat ../../../../dat/test_352_16.dat}}
set SpecLanguage C
set TVInFiles {bc {} c {} sc {} cas {} vhdl {} verilog {}}
set TVOutFiles {bc {} c {} sc {} cas {} vhdl {} verilog {}}
set TBTops {verilog {} bc {} sc {} vhdl {} c {} cas {}}
set TBInstNames {verilog {} bc {} sc {} vhdl {} c {} cas {}}
set XDCFiles {}
set ExtraGlobalOptions {"area_timing" 1 "clock_gate" 1 "impl_flow" map "power_gate" 0}
set TBTVFileNotFound {}
set AppFile ../vivado_hls.app
set ApsFile I352_O016_D008_II1_M0_F1_IR0_R1.aps
set AvePath ../..
set DefaultPlatform DefaultPlatform
set multiClockList {}
set SCPortClockMap {}
set intNbAccess 0
set PlatformFiles {{DefaultPlatform {xilinx/virtexuplus/virtexuplus xilinx/virtexuplus/virtexuplus_fpv7}}}
set HPFPO 0
