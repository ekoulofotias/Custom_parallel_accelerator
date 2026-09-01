`include "parameters.vh"

module vector_bitwise (
	output reg [`TOTAL_SIZE-1:0] RES,
	input wire [`TOTAL_SIZE-1:0] A, B,
	input wire [2:0] OP
);

	always @(*) begin
		case (OP)
			`BITWISE_AND: RES = A & B;
			`BITWISE_OR: RES = A | B;
			`BITWISE_XOR: RES = A ^ B;
			`BITWISE_NOT: RES = ~A;
			`BITWISE_NAND: RES = ~(A & B);
			`BITWISE_NOR: RES = ~(A | B);
			`BITWISE_XNOR: RES = ~(A ^ B);
			default: RES = {`TOTAL_SIZE{1'b0}};
		endcase
	end

endmodule

