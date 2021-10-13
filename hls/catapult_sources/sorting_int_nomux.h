#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include <ac_int.h>
#include "pairs_352_16.h"

using namespace std;

#define PT_WIDTH 4


typedef ac_int<PT_WIDTH, false> ielement_t;
typedef ac_int<PT_WIDTH, false> oelement_t;

void compare_exchange(oelement_t data[I], const int a, const int b);
void compare_exchange_noif(oelement_t data[I], const int a, const int b);
void compare_main(const ielement_t idata[I], oelement_t odata[O]);

#endif

