#include "comparator.h"

void compare_exchange(element_t data[N], id_t a, id_t b)
{
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=b
#pragma HLS INTERFACE ap_none port=a
#pragma HLS ARRAY_PARTITION variable=data complete dim=1
#pragma HLS INTERFACE ap_none port=data
	element_t t;
	if (data[a].pt <= data[b].pt) {
		t = data[a];
		data[a] = data[b];
		data[b] = t;
	}
}
