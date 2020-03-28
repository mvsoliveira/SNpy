#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include <ap_int.h>
#include "pairs_22_16_hier.h"
#include "pairs_32_16_hier.h"

using namespace std;

#define I 352
#define O 16

#define PT_WIDTH 4
#define ID_WIDTH 9
#define ROI_WIDTH 8
#define FLG_WIDTH 4

typedef ap_uint<PT_WIDTH> mpt_t;
typedef ap_uint<ID_WIDTH> mid_t;
typedef ap_uint<ROI_WIDTH> mroi_t;
typedef ap_uint<FLG_WIDTH> mflg_t;

typedef struct {
    mid_t id;
    mpt_t pt;
} element_t;

typedef struct {
    mid_t id;
    mpt_t pt;
//    mroi_t roi;
//    mflg_t flg;
} oelement_t;

typedef struct {
    mpt_t pt;
//    mroi_t roi;
//    mflg_t flg;
} ielement_t;

void compare_exchange(element_t data[I], const int a, const int b);
void compare_main(ielement_t idata[I], oelement_t odata[O]);

#endif
