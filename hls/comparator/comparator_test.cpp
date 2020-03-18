#include <iostream>
#include <iomanip>
#include <fstream>
#include <ap_int.h>
#include <stdint.h>
#include "comparator.h"
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

bool read_element(element_t element[N], ifstream& sti)
{
	int32_t id, pt;
	for (int i=0; i < N; i++)
	{
		if (sti >> id >> pt) {
			element[i].id = id;
			element[i].pt = pt;
			cout << "    Element id : " << element[i].id << " Element pt : " << element[i].pt << endl;
		} else {
			element[i].id = 0;
			element[i].pt = 0;
			return false;
		}
	}
	return true;
}



int main ()
{
  cout << "I am starting..." << endl;
  const char *stimulus_source = "comparator.dat";
  ifstream sti (stimulus_source);

  bool reading = true;
  bool test_error=false;
  bool error=false;
  int i = 0;
  element_t testdata[N];
  element_t expected[N];

  if (!sti.is_open())
  {
	cout << "The file is unable to open!" << '\n';
	return 1;
  }
  else
  {
	while (reading)
	{
		cout << "Iteration " << i << ": Reading test data." << endl;
		reading = read_element(testdata,sti);
		cout << "Iteration " << i << ": Reading expected data." << endl;
		reading = read_element(expected,sti);
		if (reading) {
			compare_main(testdata);
			error = compare_arrays(expected,testdata);
			if (error) {
				cout << "Iteration error" << endl;
				test_error = true;
				// giving up of reading anymore inputs
				return(1);
			}
			i++;
		}

	}
  }

  sti.close();


   if (!test_error) {
	  cout << "Test Passed" << endl;
	  return(0);
   }


}
