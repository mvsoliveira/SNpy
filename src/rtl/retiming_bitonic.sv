module retiming_bitonic #(
	parameter W     = 16,
	parameter DIR   = 1,
	parameter delay = 0) (
	input clk,
	input  muon_t m [0:W-1],
	output muon_t q [0:W-1]);

import bitonic_sorter_pkg::*;

muon_t qcomb [0:W-1];
muon_t qdelay [0:delay][0:W-1];

assign qdelay[0] = qcomb;
assign q = qdelay[delay];

	// shift register
	always_ff @(posedge clk)
	begin
		integer i;
		for (i = 1; i <= delay; i += 1) begin
		qdelay[i]   <= qdelay[i-1];
		end
	end

	bitonic_sort #(
		.WIDTH(W),
		.DIR(1)
	) sorter_inst (
		.m(m),
		.q(qcomb)
	);



endmodule