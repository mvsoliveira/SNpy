#include "comparator.h"

void compare_exchange(element_t data[N], const int a=0, const int b=1)
{
	element_t t;
	if (data[a].pt <= data[b].pt) {
		t = data[a];
		data[a] = data[b];
		data[b] = t;
	}
}

void compare_main(element_t data[N]) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS ARRAY_PARTITION variable=data complete dim=1
#pragma HLS INTERFACE ap_none port=data
	for (int i=0; i < 1; i++)
		{
#pragma HLS UNROLL
			compare_exchange(data,0,1);
		}

}
