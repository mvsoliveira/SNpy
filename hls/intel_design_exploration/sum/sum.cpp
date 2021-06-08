#include "HLS/hls.h"
#include "sum.h"
#include<iostream>

using namespace std;

hls_stall_free_return
//hls_always_run_component
component sumo_t sum(sumi_s_v_s_t i)
{
	// hls_fpga_reg ensures a output register is implemented
	sumo_t y = i.m[0].a+i.m[0].b+i.m[0].c+i.m[0].d+i.m[1].a+i.m[1].b+i.m[1].c+i.m[1].d;
    //return hls_fpga_reg(y);
    return y;
}

int main()
{
	sumi_s_v_s_t x;
	sumo_t y;
	x.m[0].a = 5; x.m[0].b = 6; x.m[0].c = 7; x.m[0].d = 8;
	x.m[1].a = 7; x.m[1].b = 6; x.m[1].c = 5; x.m[1].d = 4;
	y=sum(x);
	x.m[0].a = 5; x.m[0].b = 6; x.m[0].c = 7; x.m[0].d = 9;
	x.m[1].a = 9; x.m[1].b = 1; x.m[1].c = 2; x.m[1].d = 3;
	y=sum(x);
	ihc_hls_enqueue(&y,&sum,x);
	x.m[0].a = 9; x.m[0].b = 1; x.m[0].c = 2; x.m[0].d = 3;
	x.m[1].a = 5; x.m[1].b = 6; x.m[1].c = 7; x.m[1].d = 9;
	ihc_hls_enqueue(&y,&sum,x);
	x.m[0].a = 7; x.m[0].b = 6; x.m[0].c = 5; x.m[0].d = 4;
	x.m[1].a = 5; x.m[1].b = 6; x.m[1].c = 7; x.m[1].d = 8;
	ihc_hls_enqueue(&y,&sum,x);
	ihc_hls_component_run_all(&sum);
//cout<<"The sum is : "<< y << " \n";
	printf("The sum is : %d\n", y.to_int());
	return (y.to_int()==48);
}
