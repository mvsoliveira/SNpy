package bitonic_sorter_pkg;

	const integer ASCENDING  = 1;
	const integer DESCENDING = 0;
	
	parameter int MUON_NUMBER = 352; // 16
  parameter int IDX_WIDTH   = $clog2(MUON_NUMBER);
	parameter int PT_WIDTH    = 4;
	

	typedef struct {
		logic [PT_WIDTH-1:0]  pt;
		logic [IDX_WIDTH-1:0] idx;
	} muon_t;
	
endpackage : bitonic_sorter_pkg