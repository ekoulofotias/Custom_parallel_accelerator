`include "parameters.vh"

module zero_block_detector (
	input wire engage,
	input wire [(4*`BIT_SIZE)-1:0] A,
	input wire [(4*`BIT_SIZE)-1:0] B,
	output wire skip
);
	wire zero_A, zero_B;

	assign zero_A = ~|A;
	assign zero_B = ~|B;

	assign skip = engage & (zero_A | zero_B);

endmodule

