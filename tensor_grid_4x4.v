`include "parameters.vh"

module tensor_grid_4x4 (
	input wire clk,
	input wire rst,
	input wire engage_zero_blocking, // Zero blocking switch

	// 4x4 Output Matrix D (split into 4 tiles of 2x2, 16-bit elements)
	output wire [`BIT_SIZE*2-1:0] D00_00, D00_01, D00_10, D00_11, // Tile D00
	output wire [`BIT_SIZE*2-1:0] D01_00, D01_01, D01_10, D01_11, // Tile D01
	output wire [`BIT_SIZE*2-1:0] D10_00, D10_01, D10_10, D10_11, // Tile D10
	output wire [`BIT_SIZE*2-1:0] D11_00, D11_01, D11_10, D11_11, // Tile D11

	// Tiles of matrix A (2x2, 8-bit elements)
	input wire [`BIT_SIZE-1:0] A00_00, A00_01, A00_10, A00_11,
	input wire [`BIT_SIZE-1:0] A01_00, A01_01, A01_10, A01_11,
	input wire [`BIT_SIZE-1:0] A10_00, A10_01, A10_10, A10_11,
	input wire [`BIT_SIZE-1:0] A11_00, A11_01, A11_10, A11_11,

	// Tiles of matrix B (2x2, 8-bit elements)
	input wire [`BIT_SIZE-1:0] B00_00, B00_01, B00_10, B00_11,
	input wire [`BIT_SIZE-1:0] B01_00, B01_01, B01_10, B01_11,
	input wire [`BIT_SIZE-1:0] B10_00, B10_01, B10_10, B10_11,
	input wire [`BIT_SIZE-1:0] B11_00, B11_01, B11_10, B11_11
);

	// Intermediate wires for tensor cores
	wire [`BIT_SIZE*2-1:0] P00_B_00, P00_B_01, P00_B_10, P00_B_11;
	wire [`BIT_SIZE*2-1:0] P01_B_00, P01_B_01, P01_B_10, P01_B_11;
	wire [`BIT_SIZE*2-1:0] P10_B_00, P10_B_01, P10_B_10, P10_B_11;
	wire [`BIT_SIZE*2-1:0] P11_B_00, P11_B_01, P11_B_10, P11_B_11;

	// TC00_B calculates A01 * B10
	tensor_core_2x2 TC00_B (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P00_B_00), .D01(P00_B_01), .D10(P00_B_10), .D11(P00_B_11),
		.A00(A01_00), .A01(A01_01), .A10(A01_10), .A11(A01_11),
		.B00(B10_00), .B01(B10_01), .B10(B10_10), .B11(B10_11)
	);

	// TC01_B calculates A01 * B11
	tensor_core_2x2 TC01_B (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P01_B_00), .D01(P01_B_01), .D10(P01_B_10), .D11(P01_B_11),
		.A00(A01_00), .A01(A01_01), .A10(A01_10), .A11(A01_11),
		.B00(B11_00), .B01(B11_01), .B10(B11_10), .B11(B11_11)
	);

	// TC10_B calculates A11 * B10
	tensor_core_2x2 TC10_B (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P10_B_00), .D01(P10_B_01), .D10(P10_B_10), .D11(P10_B_11),
		.A00(A11_00), .A01(A11_01), .A10(A11_10), .A11(A11_11),
		.B00(B10_00), .B01(B10_01), .B10(B10_10), .B11(B10_11)
	);

	// TC11_B calculates A11 * B11
	tensor_core_2x2 TC11_B (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P11_B_00), .D01(P11_B_01), .D10(P11_B_10), .D11(P11_B_11),
		.A00(A11_00), .A01(A11_01), .A10(A11_10), .A11(A11_11),
		.B00(B11_00), .B01(B11_01), .B10(B11_10), .B11(B11_11)
	);

	wire [`BIT_SIZE*2-1:0] P00_A_00, P00_A_01, P00_A_10, P00_A_11;
	wire [`BIT_SIZE*2-1:0] P01_A_00, P01_A_01, P01_A_10, P01_A_11;
	wire [`BIT_SIZE*2-1:0] P10_A_00, P10_A_01, P10_A_10, P10_A_11;
	wire [`BIT_SIZE*2-1:0] P11_A_00, P11_A_01, P11_A_10, P11_A_11;

	tensor_core_2x2 TC00_A (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P00_A_00), .D01(P00_A_01), .D10(P00_A_10), .D11(P00_A_11),
		.A00(A00_00), .A01(A00_01), .A10(A00_10), .A11(A00_11),
		.B00(B00_00), .B01(B00_01), .B10(B00_10), .B11(B00_11)
	);

	tensor_core_2x2 TC01_A (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P01_A_00), .D01(P01_A_01), .D10(P01_A_10), .D11(P01_A_11),
		.A00(A00_00), .A01(A00_01), .A10(A00_10), .A11(A00_11),
		.B00(B01_00), .B01(B01_01), .B10(B01_10), .B11(B01_11)
	);

	tensor_core_2x2 TC10_A (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P10_A_00), .D01(P10_A_01), .D10(P10_A_10), .D11(P10_A_11),
		.A00(A10_00), .A01(A10_01), .A10(A10_10), .A11(A10_11),
		.B00(B00_00), .B01(B00_01), .B10(B00_10), .B11(B00_11)
	);

	tensor_core_2x2 TC11_A (
		.clk(clk),
		.rst(rst),
		.engage_zero_blocking(engage_zero_blocking),
		.D00(P11_A_00), .D01(P11_A_01), .D10(P11_A_10), .D11(P11_A_11),
		.A00(A10_00), .A01(A10_01), .A10(A10_10), .A11(A10_11),
		.B00(B01_00), .B01(B01_01), .B10(B01_10), .B11(B01_11)
	);

	// Combined tile additions
	assign D00_00 = P00_A_00 + P00_B_00;
	assign D00_01 = P00_A_01 + P00_B_01;
	assign D00_10 = P00_A_10 + P00_B_10;
	assign D00_11 = P00_A_11 + P00_B_11;

	assign D01_00 = P01_A_00 + P01_B_00;
	assign D01_01 = P01_A_01 + P01_B_01;
	assign D01_10 = P01_A_10 + P01_B_10;
	assign D01_11 = P01_A_11 + P01_B_11;

	assign D10_00 = P10_A_00 + P10_B_00;
	assign D10_01 = P10_A_01 + P10_B_01;
	assign D10_10 = P10_A_10 + P10_B_10;
	assign D10_11 = P10_A_11 + P10_B_11;

	assign D11_00 = P11_A_00 + P11_B_00;
	assign D11_01 = P11_A_01 + P11_B_01;
	assign D11_10 = P11_A_10 + P11_B_10;
	assign D11_11 = P11_A_11 + P11_B_11;

endmodule

