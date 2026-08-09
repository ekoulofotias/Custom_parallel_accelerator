`include "parameters.vh"

module shifting (
	output wire [`TOTAL_SIZE-1:0] RES,
	input wire [`TOTAL_SIZE-1:0] A,
	input wire [2:0] POS,
	input wire DIR
);

	genvar i;

	generate
		for (i = 0; i < `VEC_SIZE; i = i + 1) begin : vector_shift

			wire [`BIT_SIZE-1:0] A_BUS, RES_BUS;

			assign A_BUS = A[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE];
			assign RES_BUS = (DIR == 1'b0) ? (A_BUS << POS) : (A_BUS >> POS);
			assign RES[(i+1)*`BIT_SIZE-1 : i*`BIT_SIZE] = RES_BUS;

		end
	endgenerate

endmodule

