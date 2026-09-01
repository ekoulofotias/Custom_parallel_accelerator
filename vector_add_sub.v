`include "parameters.vh"

	module vector_add_sub (
		output wire [`TOTAL_SIZE-1:0] S,
		input wire [`TOTAL_SIZE-1:0] A, B
	);

	genvar i;

	generate
		for (i = 0; i < `VEC_SIZE; i = i + 1) begin : vector_add_loop
			assign S[i*`BIT_SIZE +: `BIT_SIZE] = $signed(A[i*`BIT_SIZE +: `BIT_SIZE]) + $signed(B[i*`BIT_SIZE +: `BIT_SIZE]);
		end
	endgenerate

endmodule

