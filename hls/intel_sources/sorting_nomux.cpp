#include "sorting_nomux.h"

void compare_exchange(oelement_t data[I], const int a = 0, const int b = 1)
{
	//#pragma HLS INLINE
    oelement_t t;
    if (data[a].pt <= data[b].pt) {
        t = data[a];
        data[a] = data[b];
        data[b] = t;
    }
}

hls_stall_free_return
//void compare_exchange();
component oelement_s_t compare_main(const ielement_s_t in)
{

	//#pragma HLS ARRAY_PARTITION variable = idata complete dim = 1
	//#pragma HLS ARRAY_PARTITION variable = odata complete dim = 1

    // input
    oelement_t data[I];
	//#pragma HLS ARRAY_PARTITION variable = data complete dim = 1
	#pragma unroll
    for (int i = 0; i < I; i++) {
        data[i].pt = in.idata[i].pt;
        data[i].roi = in.idata[i].roi;
        data[i].flg = in.idata[i].flg;
        data[i].id = i;
    }

    // comparison exchanges
	#pragma unroll
    for (int i = 0; i < np; i++) {
        compare_exchange(data, pairs[i][0], pairs[i][1]);
    }

    // output
    oelement_s_t o;
	#pragma unroll
    for (int i = 0; i < O; i++) {
        o.data[i] = data[i];
    }
    return o;
}
