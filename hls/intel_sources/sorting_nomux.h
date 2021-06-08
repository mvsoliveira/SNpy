#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include "HLS/hls.h"

#ifdef __INTELFPGA_COMPILER__
#include "HLS/ac_int.h"
#else
#include "ref/ac_int.h"
#endif
#include "pairs_4_4.h"

using namespace std;

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

typedef struct {
	oelement_t data[O];
} oelement_s_t;

typedef struct {
	ielement_t idata[I];
} ielement_s_t;

void compare_exchange(oelement_t data[I], const int a, const int b);
oelement_s_t compare_main(const ielement_s_t in);

#endif

