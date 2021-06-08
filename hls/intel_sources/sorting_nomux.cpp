#include "sorting_nomux.h"

ioelement_s_t compare_exchange(ioelement_s_t i, const int a = 0, const int b = 1)
{
	//#pragma HLS INLINE
    oelement_t t;
    if (i.data[a].pt <= i.data[b].pt) {
        t = i.data[a];
        i.data[a] = i.data[b];
        i.data[b] = t;
    }
    return i;
}

hls_stall_free_return
//void compare_exchange();
component oelement_s_t compare_main(const ielement_s_t in)
{

	//#pragma HLS ARRAY_PARTITION variable = idata complete dim = 1
	//#pragma HLS ARRAY_PARTITION variable = odata complete dim = 1

    // input
	ioelement_s_t d;
	//#pragma HLS ARRAY_PARTITION variable = data complete dim = 1
	#pragma unroll
    for (int i = 0; i < I; i++) {
        d.data[i].pt = in.idata[i].pt;
        d.data[i].roi = in.idata[i].roi;
        d.data[i].flg = in.idata[i].flg;
        d.data[i].id = i;
    }

    // comparison exchanges
	#pragma unroll
    for (int i = 0; i < np; i++) {
        d = compare_exchange(d, pairs[i][0], pairs[i][1]);
    }

    // output
    oelement_s_t o;
	#pragma unroll
    for (int i = 0; i < O; i++) {
        o.data[i] = d.data[i];
    }
    return o;
}
