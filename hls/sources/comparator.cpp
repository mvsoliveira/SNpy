#include "comparator.h"

void compare_exchange(element_t data[I], element_t temp[I], const int a = 0, const int b = 1)
{
	#pragma HLS INLINE
    element_t t;
    temp[a] = data[a];
    temp[b] = data[b];
    if (temp[a].pt <= temp[b].pt) {
        t = temp[a];
        temp[a] = temp[b];
        temp[b] = t;
    }
    data[a] = temp[a];
    data[b] = temp[b];
}

void compare_main(const ielement_t idata[I], element_t odata[O])
{

	#pragma HLS ARRAY_PARTITION variable = idata complete dim = 1
	#pragma HLS ARRAY_PARTITION variable = odata complete dim = 1

    // input
    element_t data[I];
	#pragma HLS ARRAY_PARTITION variable = data complete dim = 1
    for (int i = 0; i < I; i++) {
		#pragma HLS UNROLL
        data[i].pt = idata[i].pt;
        data[i].roi = idata[i].roi;
        data[i].flg = idata[i].flg;
        data[i].id = i;
    }

    element_t temp[I];
	#pragma HLS ARRAY_PARTITION variable = temp complete dim = 1
    for (int i = 0; i < np; i++) {
		#pragma HLS UNROLL
        compare_exchange(data, temp, pairs[i][0], pairs[i][1]);
    }

    // output
    for (int i = 0; i < O; i++) {
		#pragma HLS UNROLL
        odata[i] = data[i];
    }
}
