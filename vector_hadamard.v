`include "parameters.vh"

module vector_hadamard (
	input wire [`TOTAL_SIZE-1:0] A, B,
	output wire [(`BIT_SIZE*2 * `VEC_SIZE)-1:0] RES
);

	genvar i;

	generate
		for (i = 0; i < `VEC_SIZE; i = i + 1) begin : vector_ops
			assign RES[(i+1)*(`BIT_SIZE*2)-1 : i*(`BIT_SIZE*2)] = $signed(A[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE]) * $signed(B[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE]);
		end
	endgenerate

endmodule