`include "parameters.vh"

module vector_hadamard (
	input wire [`TOTAL_SIZE-1:0] A, B,
	output wire [`TOTAL_SIZE-1:0] RES
);

	genvar i;

	generate
		for (i = 0; i < `VEC_SIZE; i = i + 1) begin : vector_ops

			wire [`BIT_SIZE-1:0] A_BUS, B_BUS, RES_BUS;

			assign A_BUS = A[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE];
			assign B_BUS = B[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE];

			hadamard_n_bit HADAMARD_INST (.res(RES_BUS), .A(A_BUS), .B(B_BUS));
			assign RES[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE] = RES_BUS;

		end
	endgenerate

endmodule

