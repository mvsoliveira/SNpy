module reducer #(input_width_log4 = 5) 
(
	input clock,
	input [4**input_width_log4-1:0] input_vector,
	output output_bit
);

	logic [4**input_width_log4-1:0] delay_block [input_width_log4:0];
	logic [4**input_width_log4-1:0] last_block;
	logic [4**input_width_log4-1:0] prev_block;
	logic [4**input_width_log4-1:0] cur_block;
	
	integer i;
	integer j;
	
	// Load the the first block
	always_ff @ (posedge clock) begin
		delay_block[0] <= input_vector;
	end

	// loop to xor down logic to 1 set
	always_ff @ (posedge clock) begin
		for (i = 0; i < input_width_log4; i = i+1) begin
			prev_block = delay_block[i];
			for (j = 0; j < 4**(input_width_log4-1); j = j+1) begin
				cur_block[j] = ^ prev_block[j*4 +: 4];
			end
			delay_block[i+1] <= cur_block;
		end
	 end


	// Get the last data out
	assign last_block = delay_block[input_width_log4];
	assign output_bit = last_block[0];

endmodule
