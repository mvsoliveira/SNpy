#include "comparator.h"
#include <iostream>
using namespace std;

// st_name is the name of the struct
/*void myprint(element_t st, const char *st_name)
{
    printf("Contents of structure %s are %ld, %d\n", st_name, st->id, st->pt);
}*/

bool compare_arrays(element_t expected[N], element_t testdata[N])
{
	for (int i=0; i < N; i++)
	{
		if (expected[i].pt != testdata[i].pt) {
			cout << "pt mismatch at index " << i << endl;
			return true;
		}
		if (expected[i].id != testdata[i].id) {
			cout << "id mismatch at index" << i << endl;
			return true;
		}
	}
	return false;
}

int main(void)
{
	int err;
	element_t testdata[N] = {
			{0,2},
			{1,8}
	};
	element_t expected[N] = {
			{1,8},
			{0,2}
	};
	compare_exchange(testdata,0,1);
	err = compare_arrays(expected,testdata);
	   if (err) {
		  cout << "!!! TEST FAILED - " << err << endl;;
	   } else
		  cout << "Test Passed" << endl;

	   // Only return 0 on success
	   return err;

}
