import bitonic_sorter_pkg::*;

module bitonic_merge #(
	parameter WIDTH = 4,
	parameter DIR   = 1
) (
	input  muon_t m [0:WIDTH-1],
	output muon_t q [0:WIDTH-1]
);

	localparam k = WIDTH/2;
	muon_t cmp[0:WIDTH-1];
	
	genvar i;
	generate
		
		if (WIDTH == 1) 
			assign q = m;
		else begin
			// Instaniate compare and exchange modules
			for (i = 0; i < k; i += 1) begin : cmp_g
				compare	#(DIR)
				compare_i (
					.a(m[i]),
					.b(m[i+k]),
					.s0(cmp[i]),
					.s1(cmp[i+k])
				);										
			end
			// Instaniate low merger
			bitonic_merge #(
				.WIDTH(WIDTH/2),
				.DIR(DIR)
			) bitonic_merge_low (
				.m(cmp[0:k-1]),
				.q(q[0:k-1])
			);
			// Instaniate high merger
			bitonic_merge #(
				.WIDTH(WIDTH/2),
				.DIR(DIR)
			) bitonic_merge_high (
				.m(cmp[k:WIDTH-1]),
				.q(q[k:WIDTH-1])
			);
		end
	endgenerate
	
	
endmodule
