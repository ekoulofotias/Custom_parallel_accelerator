`include "parameters.vh"

module vector_add_sub (
	input wire [`TOTAL_SIZE-1:0] A, B,
	input wire OP,
	output wire [`TOTAL_SIZE-1:0] S,
	output wire [`VEC_SIZE-1:0] C,
	output wire [`VEC_SIZE-1:0] OV
);

	genvar i;

	generate
		for (i = 0; i < `VEC_SIZE; i = i + 1) begin : vector_ops

			wire [`BIT_SIZE-1:0] A_BUS, B_BUS, S_BUS;

			assign A_BUS = A[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE];
			assign B_BUS = B[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE];

			add_sub_n_bit ADD_SUB_V(.S(S_BUS), .C(C[i]), .OV(OV[i]), .A(A_BUS), .B(B_BUS), .OP(OP));
			assign S[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE] = S_BUS;

		end
	endgenerate

endmodule

