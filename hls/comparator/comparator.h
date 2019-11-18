#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include <ap_int.h>
#include <cmath>

using namespace std;

#define N 2
#define PT_WIDTH 4
#define ID_WIDTH 1

typedef ap_uint<PT_WIDTH> pt_t;
typedef ap_uint<ID_WIDTH> id_t;

typedef struct {
	id_t  id;
   pt_t  pt;   
   } element_t;


void compare_exchange(element_t data[N], const int a, const int b);
void compare_main(element_t data[N]);
#endif
