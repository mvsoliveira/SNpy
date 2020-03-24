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

bool compare_arrays(element_t expected[O], element_t computed[O])
{
	for (int i=0; i < O; i++)
	{
		if (expected[i].pt != computed[i].pt) {
			cout << "pt mismatch at index " << i << endl;
			return true;
		}
		if (expected[i].id != computed[i].id) {
			cout << "id mismatch at index" << i << endl;
			return true;
		}
		if (expected[i].roi != computed[i].roi) {
			cout << "roi mismatch at index " << i << endl;
			return true;
		}
		if (expected[i].flg != computed[i].flg) {
			cout << "flags mismatch at index" << i << endl;
			return true;
		}
	}
	return false;
}

bool read_ielements(ielement_t element[I], ifstream& sti)
{
	int32_t pt, roi, flg;
	for (int i=0; i < I; i++)
	{
		if (sti >> pt >> roi >> flg) {
			element[i].pt = pt;
			element[i].roi = roi;
			element[i].flg = flg;
			cout << "Reading stimulus data for iteration " << i << endl;
			cout << "    Element pt : " << element[i].pt << endl;
			cout << "    Element roi : " << element[i].roi << endl;
			cout << "    Element flg : " << element[i].flg << endl;
		} else return false;

	}
	return true;
}

bool read_oelements(element_t element[O], ifstream& sti)
{
	int32_t id, pt, roi, flg;
	for (int i=0; i < O; i++)
	{
		if (sti >> id >> pt >> roi >> flg) {
			element[i].pt = pt;
			element[i].id = id;
			element[i].roi = roi;
			element[i].flg = flg;
			cout << "Reading expected data for iteration " << i << endl;
			cout << "    Element id : " << element[i].id << endl;
			cout << "    Element pt : " << element[i].pt << endl;
			cout << "    Element roi : " << element[i].roi << endl;
			cout << "    Element flg : " << element[i].flg << endl;
		} else return false;

	}
	return true;
}



int main ()
{
  cout << "I am starting..." << endl;
  const char *stimulus_source = "test_352_16.dat";
  ifstream sti (stimulus_source);

  bool reading = true;
  bool test_error=false;
  bool error=false;
  int i = 0;
  ielement_t testdata[I];
  element_t computed[O];
  element_t expected[O];

  if (!sti.is_open())
  {
	cout << "The file is unable to open!" << '\n';
	return 1;
  }
  else
  {
	while (reading)
	{

		reading = read_ielements(testdata,sti);
		reading = read_oelements(expected,sti);
		if (reading) {
			const ielement_t* const_destdata = const_cast<const ielement_t*>(testdata);
			cout << "Sorting stimulus for iteration " << i << endl;
			compare_main(const_destdata,computed);
			cout << "Checking result for iteration " << i << endl;
			error = compare_arrays(expected,computed);
			if (error) {
				cout << "Iteration error for iteration " << i << endl;
				test_error = true;
				// giving up of reading anymore inputs
				return(1);
			}
			cout << "Check successful for iteration " << i << endl;
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
