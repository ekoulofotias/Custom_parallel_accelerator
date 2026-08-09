`include "parameters.vh"

module top_accelerator (
	input wire clk,
	input wire rst,
	input wire [63:0] instruction_in, // Full instruction

	// Vector Data Buses
	input wire [`TOTAL_SIZE-1:0] vec_a_in,
	input wire [`TOTAL_SIZE-1:0] vec_b_in,
	output wire [`TOTAL_SIZE-1:0] vec_alu_out,
	output wire [`BIT_SIZE*2-1:0] dot_out,
	output wire [`VEC_SIZE-1:0] carry_out,
	output wire [`VEC_SIZE-1:0] overflow_out,

	// Tensor Grid Inputs / Outputs
	input wire [`BIT_SIZE-1:0] T_A00_00, T_A00_01, T_A00_10, T_A00_11,
	input wire [`BIT_SIZE-1:0] T_A01_00, T_A01_01, T_A01_10, T_A01_11,
	input wire [`BIT_SIZE-1:0] T_A10_00, T_A10_01, T_A10_10, T_A10_11,
	input wire [`BIT_SIZE-1:0] T_A11_00, T_A11_01, T_A11_10, T_A11_11,

	input wire [`BIT_SIZE-1:0] T_B00_00, T_B00_01, T_B00_10, T_B00_11,
	input wire [`BIT_SIZE-1:0] T_B01_00, T_B01_01, T_B01_10, T_B01_11,
	input wire [`BIT_SIZE-1:0] T_B10_00, T_B10_01, T_B10_10, T_B10_11,
	input wire [`BIT_SIZE-1:0] T_B11_00, T_B11_01, T_B11_10, T_B11_11,

	output wire [`BIT_SIZE*2-1:0] T_D00_00, T_D00_01, T_D00_10, T_D00_11,
	output wire [`BIT_SIZE*2-1:0] T_D01_00, T_D01_01, T_D01_10, T_D01_11,
	output wire [`BIT_SIZE*2-1:0] T_D10_00, T_D10_01, T_D10_10, T_D10_11,
	output wire [`BIT_SIZE*2-1:0] T_D11_00, T_D11_01, T_D11_10, T_D11_11
);

	// Instruction decoding
	wire [2:0] dec_exec_unit = instruction_in[63:61];
	wire [3:0] dec_alu_opcode = instruction_in[60:57];
	wire [2:0] dec_alu_sub_op = instruction_in[56:54];
	wire [2:0] dec_shift_pos = instruction_in[53:51];
	wire dec_zero_block = instruction_in[50];

	vector_alu u_vector_alu (
		.ALU_OUT(vec_alu_out),
		.DOT_OUT(dot_out),
		.CARRY_OUT(carry_out),
		.OVERFLOW_OUT(overflow_out),
		.OPCODE(dec_alu_opcode),
		.SUB_OP(dec_alu_sub_op),
		.SHIFT_POS(dec_shift_pos),
		.VEC_A(vec_a_in),
		.VEC_B(vec_b_in)
	);

	tensor_grid_4x4 u_tensor_grid (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(dec_zero_block),
		
		.A00_00(T_A00_00), .A00_01(T_A00_01), .A00_10(T_A00_10), .A00_11(T_A00_11),
		.A01_00(T_A01_00), .A01_01(T_A01_01), .A01_10(T_A01_10), .A01_11(T_A01_11),
		.A10_00(T_A10_00), .A10_01(T_A10_01), .A10_10(T_A10_10), .A10_11(T_A10_11),
		.A11_00(T_A11_00), .A11_01(T_A11_01), .A11_10(T_A11_10), .A11_11(T_A11_11),

		.B00_00(T_B00_00), .B00_01(T_B00_01), .B00_10(T_B00_10), .B00_11(T_B00_11),
		.B01_00(T_B01_00), .B01_01(T_B01_01), .B01_10(T_B01_10), .B01_11(T_B01_11),
		.B10_00(T_B10_00), .B10_01(T_B10_01), .B10_10(T_B10_10), .B10_11(T_B10_11),
		.B11_00(T_B11_00), .B11_01(T_B11_01), .B11_10(T_B11_10), .B11_11(T_B11_11),

		.D00_00(T_D00_00), .D00_01(T_D00_01), .D00_10(T_D00_10), .D00_11(T_D00_11),
		.D01_00(T_D01_00), .D01_01(T_D01_01), .D01_10(T_D01_10), .D01_11(T_D01_11),
		.D10_00(T_D10_00), .D10_01(T_D10_01), .D10_10(T_D10_10), .D10_11(T_D10_11),
		.D11_00(T_D11_00), .D11_01(T_D11_01), .D11_10(T_D11_10), .D11_11(T_D11_11)
	);

endmodule