#include "hierarchical.h"

void compare_exchange(element_t data[I], const int a = 0, const int b = 1)
{
	#pragma HLS INLINE
    element_t t;
    if (data[a].pt <= data[b].pt) {
        t = data[a];
        data[a] = data[b];
        data[b] = t;
    }
}

void sort(element_t data[I], int off) {
	for (int i = 0; i < npS; i++) {
		#pragma HLS UNROLL
		compare_exchange(data, pairsS[i][0]+off, pairsS[i][1]+off);
	}	
}


void merge(element_t data[I], int lut[IM]) {
	for (int i = 0; i < npM; i++) {
		#pragma HLS UNROLL
		compare_exchange(data, lut[pairsM[i][0]], lut[pairsM[i][1]]);
	}
}


void compare_main(ielement_t idata[I], oelement_t odata[O])
{

	#pragma HLS ARRAY_PARTITION variable = idata complete dim = 1
	#pragma HLS ARRAY_PARTITION variable = odata complete dim = 1

    // input
    element_t data[I];
	#pragma HLS ARRAY_PARTITION variable = data complete dim = 1
    for (int i = 0; i < I; i++) {
		#pragma HLS UNROLL
        data[i].pt = idata[i].pt;
        data[i].id = i;
    }

    const int R = 16;
    // sorting comparison exchanges
    for (int h = 0; h < R; h++) {
		#pragma HLS UNROLL
    	sort(data, h*IS);
    }

    int lut[32];
    // merging comparison exchanges
    for (int L = 0; L < 4; L++) {
		#pragma HLS UNROLL
    	for (int r = 0; r < R >> L; r+=2) {
			#pragma HLS UNROLL
    		for (int n = 0; n < 16; n++) {
				#pragma HLS UNROLL
    			lut[n] = r*(IS << L)+n;
    			lut[n+16] = (r+1)*(IS << L)+n;
    		}
    		merge(data,lut);
    	}

    }
    

    // output
    //int id_temp;
    for (int i = 0; i < O; i++) {
		#pragma HLS UNROLL
    	//id_temp = data[i].id;
        odata[i].id = data[i].id;
        odata[i].pt = data[i].pt;
        //odata[i].roi = idata[id_temp].roi;
        //odata[i].flg = idata[id_temp].flg;
    }
}
