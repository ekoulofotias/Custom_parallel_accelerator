`include "parameters.vh"

module dot_product(
	output reg [`BIT_SIZE*2-1:0] RES,
	input wire [`TOTAL_SIZE-1:0] A,
	input wire [`TOTAL_SIZE-1:0] B
);

	wire [(`BIT_SIZE*2 * `VEC_SIZE)-1:0] had_res;
	wire [`BIT_SIZE*2-1:0] SCAL [0:`VEC_SIZE-1];

	vector_hadamard v_had (.RES(had_res), .A(A), .B(B));

	genvar i;
	generate
		for (i = 0; i < `VEC_SIZE; i = i + 1) begin : CUT
			assign SCAL[i] = had_res[(i+1)*(`BIT_SIZE*2)-1 : i*(`BIT_SIZE*2)];
		end
	endgenerate

	integer j;
	always @(*) begin
		RES = {`BIT_SIZE*2{1'b0}};
		for (j = 0; j < `VEC_SIZE; j = j + 1) begin
			RES = $signed(RES) + $signed(SCAL[j]);
		end
	end

endmodule