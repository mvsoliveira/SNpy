import bitonic_sorter_pkg::*;

module bitonic_sort #(
	parameter WIDTH = 4,
	parameter DIR   = 1
) (
	input  muon_t m [0:WIDTH-1],
	output muon_t q [0:WIDTH-1]
);

	localparam k = WIDTH/2;
	muon_t sort[0:WIDTH-1];
	
	genvar i;
	generate
		
		if (WIDTH == 1) 
			assign q = m;
		else begin
			// Instaniate low sorter
			bitonic_sort #(
				.WIDTH(WIDTH/2),
				.DIR(1)
			) bitonic_sort_low (
				.m(m[0:k-1]),
				.q(sort[0:k-1])
			);
			// Instaniate high sorter
			bitonic_sort #(
				.WIDTH(WIDTH/2),
				.DIR(0)
			) bitonic_sort_high (
				.m(m[k:WIDTH-1]),
				.q(sort[k:WIDTH-1])
			);
			// Instaniate merger
			bitonic_merge #(
				.WIDTH(WIDTH),
				.DIR(DIR)
			) bitonic_merge_i (
				.m(sort),
				.q(q)
			);
		end
	endgenerate
	
	
endmodule
