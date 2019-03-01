import bitonic_sorter_pkg::*;

module compare #(parameter dir = 1) 
(
	input  muon_t a, b,
	output muon_t s0, s1
);
		
	always_comb begin
		if ((a.pt > b.pt) == dir) begin
			s0 = a;
			s1 = b;
		end
		else begin
			s0 = b;
			s1 = a;
		end
	end
	
endmodule
