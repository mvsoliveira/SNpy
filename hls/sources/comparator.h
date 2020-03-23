#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include <ap_int.h>
#include <cmath>
#include "pairs_5.h"

using namespace std;

#define PT_WIDTH 4
#define ID_WIDTH 1

typedef ap_uint<PT_WIDTH> mpt_t;
typedef ap_uint<ID_WIDTH> mid_t;

typedef struct {
	mid_t  id;
   mpt_t  pt;
   } element_t;


void compare_exchange(element_t data[N], const int a, const int b);
void compare_main(element_t data[N]);



#endif
