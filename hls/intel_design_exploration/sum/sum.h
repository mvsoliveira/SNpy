/*
 * sum.h
 *
 *  Created on: Jun 4, 2021
 *      Author: msilvaol
 */

#ifndef SUM_H_
#define SUM_H_

#ifdef __INTELFPGA_COMPILER__
#include "HLS/ac_int.h"
#else
#include "ref/ac_int.h"
#endif

using namespace std;

#define SUMI_WIDTH 28
#define SUMO_WIDTH 30


typedef ac_int<SUMI_WIDTH, false> sumi_t;
typedef ac_int<SUMO_WIDTH, false> sumo_t;


typedef struct {
    sumi_t a;
    sumi_t b;
    sumi_t c;
    sumi_t d;
} sumi_s_t;


typedef struct {
	sumi_s_t m[2];
} sumi_s_v_s_t;



#endif /* SUM_H_ */
