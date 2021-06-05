#include "HLS/hls.h"
#include "sum.h"
#include<iostream>

using namespace std;

hls_stall_free_return
//hls_always_run_component
component sumo_t sum(sumi_s_t i)
{
	// hls_fpga_reg ensures a output register is implemented
	sumo_t y = i.a+i.b+i.c+i.d;
    //return hls_fpga_reg(y);
    return y;
}

int main()
{
	sumi_s_t x;
	sumo_t y;
	x.a = 5; x.b = 6; x.c = 7; x.d = 8;
	y=sum(x);
	x.a = 5; x.b = 6; x.c = 7; x.d = 9;
	y=sum(x);
	ihc_hls_enqueue(&y,&sum,x);
	x.a = 9; x.b = 1; x.c = 2; x.d = 3;
	ihc_hls_enqueue(&y,&sum,x);
	x.a = 7; x.b = 6; x.c = 5; x.d = 4;
	ihc_hls_enqueue(&y,&sum,x);
	ihc_hls_component_run_all(&sum);
//cout<<"The sum is : "<< y << " \n";
	printf("The sum is : %d\n", y.to_int());
	return (y.to_int()==22);
}
