//  Catapult Ultra Synthesis 10.5c/896140 (Production Release) Sun Sep  6 22:45:38 PDT 2020
//  
//  Copyright (c) Mentor Graphics Corporation, 1996-2020, All Rights Reserved.
//                        UNPUBLISHED, LICENSED SOFTWARE.
//             CONFIDENTIAL AND PROPRIETARY INFORMATION WHICH IS THE
//                 PROPERTY OF MENTOR GRAPHICS OR ITS LICENSORS
//  
//  Running on Linux msilvaol@mes 3.10.0-1160.25.1.el7.x86_64 x86_64 aol
//  
//  Package information: SIFLIBS v23.5_3.0, HLS_PKGS v23.5_3.0, 
//                       SIF_TOOLKITS v23.5_3.0, SIF_XILINX v23.5_3.0, 
//                       SIF_ALTERA v23.5_3.0, CCS_LIBS v23.5_3.0, 
//                       CDS_PPRO v10.3c_2, CDS_DesigChecker v10.5c, 
//                       CDS_OASYS v19.1_3.7, CDS_PSR v20.1_0.0, 
//                       DesignPad v2.78_1.0
//  
solution new -state initial
solution options defaults
options set Architectural/DefaultMemMapThreshold 512
options set Architectural/DefaultRegisterThreshold 1024
solution options set /Output/GenerateCycleNetlist false
#
#
solution file add ../src/sorting_tb.cpp -exclude true
solution file add ../src/sorting_nomux.cpp
#
#
solution design set compare_exchange -block
solution design set compare_main -top
go analyze
#
#
solution library add mgc_Xilinx-VIRTEX-uplus-1_beh -- -rtlsyntool Vivado -manufacturer Xilinx -family VIRTEX-uplus -speed -1 -part xcvu9p-flgc2104-1-e
go libraries
#
#
directive set /compare_main/compare_exchange -MAP_TO_MODULE {[CCORE]}
directive set /compare_main/compare_exchange -CCORE_TYPE combinational
directive set -CLOCKS {clk {-CLOCK_PERIOD 6.25 -CLOCK_EDGE rising -CLOCK_UNCERTAINTY 0.0 -CLOCK_HIGH_TIME 3.125 -RESET_SYNC_NAME rst -RESET_ASYNC_NAME arst_n -RESET_KIND sync -RESET_SYNC_ACTIVE high -RESET_ASYNC_ACTIVE low -ENABLE_ACTIVE high}}
go assembly
#
# Uncomment this for 5 cycles latency
#directive set /compare_main/core -CLOCK_OVERHEAD 8.000000
#
directive set /compare_main/core/main -PIPELINE_INIT_INTERVAL 1
directive set /compare_main/core/INPUT_LOOP -UNROLL yes
directive set /compare_main/core/OUTPUT_LOOP -UNROLL yes
directive set /compare_main/core/PROCESSING_LOOP -UNROLL yes
directive set /compare_main/compare_exchange -INPUT_DELAY 5.500000
go allocate
go extract

