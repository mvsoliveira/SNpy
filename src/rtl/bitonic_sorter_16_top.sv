module bitonic_sorter_16_top (
	input clk_int, // logic clock
	input clk_io, // I/O clock
	input din, // serial data input
	output logic dout // serial data output
);

	import bitonic_sorter_pkg::*;

	localparam CAND_NUM     = 16;
//	localparam IDX_WIDTH    = $clog2(CAND_NUM);
//	localparam PT_WIDTH     = 4;
	localparam MUON_WIDTH   = PT_WIDTH + IDX_WIDTH;
	localparam IN_WIDTH     = CAND_NUM * MUON_WIDTH;
	localparam REDUCER_LOG4 = 4;
	
	logic [IN_WIDTH-1:0]  lfsr_out;
	muon_t unsorted_muons [0:CAND_NUM-1];
	muon_t sorted_muons [0:CAND_NUM-1];
	muon_t sorter_out [0:CAND_NUM-1];
	logic [4**REDUCER_LOG4-1:0] reducer_in;
	logic lfsr_din, reducer_dout;

    // Register the off-chip I/O
	always_ff @(posedge clk_io)
	begin
		lfsr_din <= din;
		dout     <= reducer_dout;
	end

    // LFSR to generate the sorter inputs
	lfsr #(IN_WIDTH) input_lfsr (
		.clock(clk_io),
		.input_bit(lfsr_din),
		.output_vector(lfsr_out));

	// Register sorter input and output
	always_ff @(posedge clk_int)
	begin
		integer i;
		for (i = 0; i < CAND_NUM; i += 1) begin
			unsorted_muons[i].pt  <= lfsr_out[i*MUON_WIDTH +: PT_WIDTH];
			unsorted_muons[i].idx <= lfsr_out[i*MUON_WIDTH+PT_WIDTH +: IDX_WIDTH];
		end
		sorted_muons <= sorter_out;
	end

	bitonic_sort #(
		.WIDTH(CAND_NUM),
		.DIR(1)
	) sorter_inst (
//		.clk(clk_int),
		.m(unsorted_muons),
		.q(sorter_out)
	);

	genvar i;
	generate
		for (i = 0; i < CAND_NUM; i += 1) begin : MAP
			assign reducer_in[i*MUON_WIDTH +: PT_WIDTH] = sorted_muons[i].pt;
			assign reducer_in[i*MUON_WIDTH+PT_WIDTH +: IDX_WIDTH] = sorted_muons[i].idx;
		end
	endgenerate

	//assign reducer_in = {'d0, cand_idx_vec};

	reducer #(REDUCER_LOG4) output_reducer (
	.clock(clk_io),
	.input_vector(reducer_in),
	.output_bit(reducer_dout));

endmodule
