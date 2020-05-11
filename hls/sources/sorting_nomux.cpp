#include "sorting_nomux.h"

void compare_exchange(oelement_t data[I], const int a = 0, const int b = 1)
{
	#pragma HLS INLINE
    oelement_t t;
    if (data[a].pt <= data[b].pt) {
        t = data[a];
        data[a] = data[b];
        data[b] = t;
    }
}

void compare_main(const ielement_t idata[I], oelement_t odata[O])
{

	#pragma HLS ARRAY_PARTITION variable = idata complete dim = 1
	#pragma HLS ARRAY_PARTITION variable = odata complete dim = 1

    // input
    oelement_t data[I];
	#pragma HLS ARRAY_PARTITION variable = data complete dim = 1
    for (int i = 0; i < I; i++) {
		#pragma HLS UNROLL
        data[i].pt = idata[i].pt;
        data[i].roi = idata[i].roi;
        data[i].flg = idata[i].flg;
        data[i].id = i;
    }

    // comparison exchanges
    for (int i = 0; i < np; i++) {
		#pragma HLS UNROLL
        compare_exchange(data, pairs[i][0], pairs[i][1]);
    }

    // output
    int id_temp;
    for (int i = 0; i < O; i++) {
		#pragma HLS UNROLL
        odata[i] = data[i];
    }
}
