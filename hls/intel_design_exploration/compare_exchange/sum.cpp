#include "HLS/hls.h"
#include<iostream>

using namespace std;

hls_stall_free_return
//hls_always_run_component
component int sum(int a, int b)
{
	// hls_fpga_reg ensures a output register is implemented
    return hls_fpga_reg(a+b);
    //return a+b;
}

int main()
{
	int x,y,s;
	x = 5;
	y = 3;
	s=sum(x,y);
	cout<<"The sum is : "<<s << " \n";
	return (s=8);
}
