#include "sorting_nomux.h"

//void compare_exchange(oelement_t data[I], const int a = 0, const int b = 1)
#pragma hls_design ccore
#pragma hls_ccore_type combinational
void compare_exchange(	oelement_t dataIn1, oelement_t dataIn2, 
			oelement_t &dataOut1,  oelement_t &dataOut2 )
{
//    oelement_t t;
/*    if (data[a].pt <= data[b].pt) {
        t = data[a];
        data[a] = data[b];
        data[b] = t;
    } */
    if (dataIn1.pt <= dataIn2.pt) {
        dataOut1 = dataIn2;
        dataOut2 = dataIn1;
    }
    else {
        dataOut1 = dataIn1;
        dataOut2 = dataIn2;
    }    
}

void compare_exchange_noif(oelement_t data[I], const int a = 0, const int b = 1)
{
    bool cond = data[a].pt <= data[b].pt;
    oelement_t t;
    t = data[a];    
    data[a] = (cond) ? data[b] : data[a];
    data[b] = (cond) ? t : data[b];
}

void compare_main(const ielement_t idata[I], oelement_t odata[O])
{

    // input
    oelement_t data[I];
    INPUT_LOOP : for (int i = 0; i < I; i++) {
        data[i].pt = idata[i].pt;
        data[i].roi = idata[i].roi;
        data[i].flg = idata[i].flg;
        data[i].id = i;
    }

    // comparison exchanges
    PROCESSING_LOOP : for (int i = 0; i < np; i++) {
//        compare_exchange(data, pairs[i][0], pairs[i][1]);
        compare_exchange(data[pairs[i][0]], data[pairs[i][1]], data[pairs[i][0]], data[pairs[i][1]]);
    }

    // output
    OUTPUT_LOOP : for (int i = 0; i < O; i++) {
        odata[i] = data[i];
    }
}
