#include "sum.h"

using namespace std;

void sum(const sumi_s_t i[SUMN], sumo_t &y)
{
    sumo_t s = 0;
    SUM_LOOP : for (unsigned int n=0; n<SUMN; n++) {
	s = s + i[n].a+i[n].b+i[n].c+i[n].d;
	}
	y=s;
}

