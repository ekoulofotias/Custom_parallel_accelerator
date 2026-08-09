`include "parameters.vh"

module hadamard_n_bit(

	input wire [`BIT_SIZE-1:0] A, B,
	output wire [`BIT_SIZE-1:0] res
);

	assign res = (A * B);

endmodule

