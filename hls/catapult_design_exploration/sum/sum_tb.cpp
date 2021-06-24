#include<iostream>
#include<fstream>
#include "sum.h"

#include <mc_scverify.h>

using namespace std;

CCS_MAIN(int argc, char *argv[])
{
	sumi_s_t x[SUMN];
	sumo_t y;
	x[0].a = 5; x[0].b = 6; x[0].c = 7; x[0].d = 8;
	x[1].a = 7; x[1].b = 6; x[1].c = 5; x[1].d = 4;
	CCS_DESIGN(sum) (x,y);
	x[0].a = 5; x[0].b = 6; x[0].c = 7; x[0].d = 9;
	x[1].a = 9; x[1].b = 1; x[1].c = 2; x[1].d = 3;
	CCS_DESIGN(sum) (x,y);
	
	x[0].a = 9; x[0].b = 1; x[0].c = 2; x[0].d = 3;
	x[1].a = 5; x[1].b = 6; x[1].c = 7; x[1].d = 9;
	CCS_DESIGN(sum) (x,y);
	x[0].a = 7; x[0].b = 6; x[0].c = 5; x[0].d = 4;
	x[1].a = 5; x[1].b = 6; x[1].c = 7; x[1].d = 8;
	CCS_DESIGN(sum) (x,y);
	cout << "The sum is : " <<  y.to_int() << ".\n" << endl;
	CCS_RETURN(0);
//	if (y.to_int() == 48) {
//		return 0;
//	} else {
//		return -1;
//	}

}
