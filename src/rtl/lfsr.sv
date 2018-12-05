module lfsr #(WIDTH = 32) (
  input                    clock, 
  input                    input_bit,
  output logic [WIDTH-1:0] output_vector);

  logic [WIDTH-1:0] shiftreg_vector;

  always_ff @ (posedge clock)
	shiftreg_vector <= {shiftreg_vector[WIDTH-2:0], input_bit ^ shiftreg_vector[WIDTH-1]};

  // register the output
  always_ff @ (posedge clock)
	output_vector <= shiftreg_vector;

endmodule
