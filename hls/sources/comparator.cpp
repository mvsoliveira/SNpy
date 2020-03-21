#include "comparator.h"


void compare_exchange(element_t data[N], element_t temp[N], const int a=0, const int b=1)
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

void compare_main(element_t data[N]) {
#pragma HLS INTERFACE ap_vld port=data
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS ARRAY_PARTITION variable=data complete dim=1

element_t temp[N];
#pragma HLS ARRAY_PARTITION variable=temp complete dim=1
	for (int i=0; i < np; i++)
		{
#pragma HLS UNROLL
			compare_exchange(data, temp, pairs[i][0],pairs[i][1]);
		}

}
