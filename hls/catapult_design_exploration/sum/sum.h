/*
 * sum.h
 *
 *  Created on: Jun 4, 2021
 *      Author: msilvaol
 */

#ifndef SUM_H_
#define SUM_H_

#include <ac_int.h>

using namespace std;

const unsigned SUMI_WIDTH = 28;
const unsigned SUMO_WIDTH = 30;
const unsigned SUMN = 2;


typedef ac_int<SUMI_WIDTH, false> sumi_t;
typedef ac_int<SUMO_WIDTH, false> sumo_t;


typedef struct {
    sumi_t a;
    sumi_t b;
    sumi_t c;
    sumi_t d;
} sumi_s_t;


void sum(const sumi_s_t i[SUMN], sumo_t &);



#endif /* SUM_H_ */
