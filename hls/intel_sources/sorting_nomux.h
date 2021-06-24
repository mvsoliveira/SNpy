#ifndef __COMPARATOR_H__
#define __COMPARATOR_H__

#include "HLS/hls.h"

#ifdef __INTELFPGA_COMPILER__
#include "HLS/ac_int.h"
#else
#include "ref/ac_int.h"
#endif
#include "pairs_22_16.h"

using namespace std;

#define PT_WIDTH 4
#define ID_WIDTH 9
#define ROI_WIDTH 8
#define FLG_WIDTH 4

typedef ac_int<PT_WIDTH, false> mpt_t;
typedef ac_int<ID_WIDTH, false> mid_t;
typedef ac_int<ROI_WIDTH, false> mroi_t;
typedef ac_int<FLG_WIDTH, false> mflg_t;

typedef struct __attribute__((packed)) {
	mid_t id;
	mpt_t pt;
	mroi_t roi;
	mflg_t flg;
} oelement_t;

typedef struct __attribute__((packed)) {
	mpt_t pt;
	mroi_t roi;
	mflg_t flg;
} ielement_t;

struct oelement_s_t {
	hls_register oelement_t data[O];
	//copy assignment operator
	oelement_s_t operator=(const oelement_s_t &org) {
#pragma unroll
		for (int i = 0; i < O; i++) {
			data[i] = org.data[i];
		}
		return *this;
	}
	//copy constructor
	oelement_s_t(const oelement_s_t &org) {
#pragma unroll
		for (int i = 0; i < O; i++) {
			data[i] = org.data[i];
		}
	}
	//default construct & destructor
	oelement_s_t() {
	}
	;
	~oelement_s_t() {
	}
	;
};

struct ielement_s_t {
	hls_register ielement_t idata[I];
	//copy assignment operator
	ielement_s_t operator=(const ielement_s_t &org) {
#pragma unroll
		for (int i = 0; i < I; i++) {
			idata[i] = org.idata[i];
		}
		return *this;
	}
	//copy constructor
	ielement_s_t(const ielement_s_t &org) {
#pragma unroll
		for (int i = 0; i < I; i++) {
			idata[i] = org.idata[i];
		}
	}
	//default construct & destructor
	ielement_s_t() {
	}
	;
	~ielement_s_t() {
	}
	;
};

struct ioelement_s_t {
	hls_register oelement_t data[I];
	//copy assignment operator
	ioelement_s_t operator=(const ioelement_s_t &org) {
#pragma unroll
		for (int i = 0; i < I; i++) {
			data[i] = org.data[i];
		}
		return *this;
	}
	//copy constructor
	ioelement_s_t(const ioelement_s_t &org) {
#pragma unroll
		for (int i = 0; i < I; i++) {
			data[i] = org.data[i];
		}
	}
	//default construct & destructor
	ioelement_s_t() {
	}
	;
	~ioelement_s_t() {
	}
	;
};

typedef oelement_s_t oelement_s_t;
typedef ioelement_s_t ioelement_s_t;
typedef ielement_s_t ielement_s_t;

ioelement_s_t compare_exchange(ioelement_s_t i, const int a, const int b);
oelement_s_t compare_main(const ielement_s_t in);

#endif

