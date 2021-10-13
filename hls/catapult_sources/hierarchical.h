#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include <ac_int.h>
#include "pairs_22_16_hier.h"
#include "pairs_32_16_hier.h"

using namespace std;

#define I 352
#define O 16

#define PT_WIDTH 4
#define ID_WIDTH 9
#define ROI_WIDTH 8
#define FLG_WIDTH 4

typedef ac_int<PT_WIDTH, false> mpt_t;
typedef ac_int<ID_WIDTH, false> mid_t;
typedef ac_int<ROI_WIDTH, false> mroi_t;
typedef ac_int<FLG_WIDTH, false> mflg_t;

typedef struct {
    mid_t id;
    mpt_t pt;
    mroi_t roi;
    mflg_t flg;
} oelement_t;

typedef struct {
    mpt_t pt;
    mroi_t roi;
    mflg_t flg;
} ielement_t;

void compare_exchange(oelement_t data[I], const int a, const int b);
void compare_main(const ielement_t idata[I], oelement_t odata[O]);

#endif
