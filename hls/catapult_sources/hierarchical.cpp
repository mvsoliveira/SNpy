#include "hierarchical.h"

void compare_exchange(oelement_t data[I], const int a = 0, const int b = 1)
{
    oelement_t t;
    if (data[a].pt <= data[b].pt) {
        t = data[a];
        data[a] = data[b];
        data[b] = t;
    }
}

void sort(const oelement_t idata[I], oelement_t odata[I], int off) {
    oelement_t data[I];
    INPUT_LOOP : for (int i = 0; i < I; i++) {
        data[i] = idata[i];
    }
	PROCESSING_LOOP : for (int i = 0; i < npS; i++) {
		compare_exchange(data, pairsS[i][0]+off, pairsS[i][1]+off);
	}
	OUTPUT_LOOP : for (int i = 0; i < I; i++) {
        odata[i] = data[i];
    }
}


//void merge(element_t data[I], int lut[IM]) {
//	for (int i = 0; i < npM; i++) {
//		#pragma HLS UNROLL
//		compare_exchange(data, lut[pairsM[i][0]], lut[pairsM[i][1]]);
//	}
//}


void compare_main(ielement_t idata[I], oelement_t odata[O])
{

    // input
    oelement_t data[I];
    for (int i = 0; i < I; i++) {
        data[i].pt = idata[i].pt;
        data[i].id = i;
    }

    const int R = 16;
    // sorting comparison exchanges
    for (int h = 0; h < R; h++) {
    	//sort(data, h*IS);
    	for (int i = 0; i < npS; i++) {
    		compare_exchange(data, pairsS[i][0]+h*IS, pairsS[i][1]+h*IS);
    	}
    }

    int lut[32];
    // merging comparison exchanges
    for (int L = 0; L < 4; L++) {
    	for (int r = 0; r < R >> L; r+=2) {
    		for (int n = 0; n < 16; n++) {
    			lut[n] = r*(IS << L)+n;
    			lut[n+16] = (r+1)*(IS << L)+n;
    		}
    		//merge(data,lut);
    		for (int i = 0; i < npM; i++) {
    			compare_exchange(data, lut[pairsM[i][0]], lut[pairsM[i][1]]);
    		}
    	}

    }
    

    // output
    int id_temp;
    for (int i = 0; i < O; i++) {
		#pragma HLS UNROLL
    	id_temp = data[i].id;
        odata[i].id = data[i].id;
        odata[i].pt = data[i].pt;
        odata[i].roi = idata[id_temp].roi;
        odata[i].flg = idata[id_temp].flg;
    }
}
