#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include <ap_int.h>
#include <cmath>

using namespace std;

#define N 4

const int np = 5;
const int pairs[np][2] =
{
		{0,1},
		{2,3},
		{0,2},
		{1,3},
		{1,2}
};


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
