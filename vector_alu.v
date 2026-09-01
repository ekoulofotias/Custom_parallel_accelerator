`include "parameters.vh"

module vector_alu (
	// Main outputs
	output reg  [`TOTAL_SIZE-1:0] ALU_OUT,          // Vector output
	output wire [`BIT_SIZE*2-1:0] DOT_OUT,          // Dot Product output

	// CONTROL BUS
	input wire [3:0] OPCODE,                        // VOP_ADD, VOP_BITWISE, VOP_SHIFT, VOP_HADAMARD, VOP_DOT
	input wire [2:0] SUB_OP,                        // bitwise Sub-Op, shift direction
	input wire [2:0] SHIFT_POS,                     // Shift positions for shifting unit

	// DATA BUSSES
	input wire [`TOTAL_SIZE-1:0] VEC_A,
	input wire [`TOTAL_SIZE-1:0] VEC_B
);

	wire [`TOTAL_SIZE-1:0] res_add_sub;
	wire [`TOTAL_SIZE-1:0] res_bitwise;
	wire [`TOTAL_SIZE-1:0] res_shift;
	wire [(`BIT_SIZE*2 * `VEC_SIZE)-1:0] res_hadamard;

	// Add / Subtract Unit (Subtraction is done via Two's Complement)
	vector_add_sub ADD_SUB(.S(res_add_sub), .A(VEC_A), .B(VEC_B));

	// Bitwise Logic Unit
	vector_bitwise BITWISE(.RES(res_bitwise), .A(VEC_A), .B(VEC_B), .OP(SUB_OP));

	// Shift Unit
	shifting v_shift_inst (.RES(res_shift), .A(VEC_A), .POS(SHIFT_POS), .DIR(SUB_OP[0]));

	// Hadamard Product Unit
	vector_hadamard v_hadamard_inst ( .RES(res_hadamard), .A(VEC_A), .B(VEC_B));

	// Dot Product Unit
	dot_product v_dot_inst (.RES(DOT_OUT), .A(VEC_A), .B(VEC_B));

	always @(*) begin
		case (OPCODE)
			`VOP_ADD : ALU_OUT = res_add_sub;
			`VOP_BITWISE : ALU_OUT = res_bitwise;
			`VOP_SHIFT : ALU_OUT = res_shift;
			`VOP_HADAMARD : ALU_OUT = res_hadamard;
			`VOP_DOT : ALU_OUT = {`TOTAL_SIZE{1'b0}};
			default : ALU_OUT = {`TOTAL_SIZE{1'b0}};
		endcase
	end

endmodule

