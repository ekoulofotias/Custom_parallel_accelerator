`include "parameters.vh"

module top_driver (
	input clk,
	input rst,
	input enable,
	input ready_in,
	input [2:0] target_sel, // Selects which driver communicates with the bus
	input wire [31:0] bus,
	
	// Outputs to connector
	output wire [127:0] matrix_a_out,
	output wire [127:0] matrix_b_out,
	output wire [255:0] matrix_c_out, // 256-bit total for C (16-bit entries)
	output wire [`TOTAL_SIZE-1:0] vector_1_out,
	output wire [`TOTAL_SIZE-1:0] vector_2_out
);

	// Target selection logic
	wire en_mat_a  = enable && (target_sel == 3'b000);
	wire en_mat_b  = enable && (target_sel == 3'b001);
	wire en_mat_c1 = enable && (target_sel == 3'b010);
	wire en_mat_c2 = enable && (target_sel == 3'b011); 
	wire en_vec_1  = enable && (target_sel == 3'b100);
	wire en_vec_2  = enable && (target_sel == 3'b101);

	// 1. Matrix A Driver (128-bit)
	matrix_driver drv_mat_a (
		.clk(clk), .rst(rst), .enable(en_mat_a),
		.bus(bus), .ready_in(ready_in), .matrix_out(matrix_a_out)
	);

	// 2. Matrix B Driver (128-bit)
	matrix_driver drv_mat_b (
		.clk(clk), .rst(rst), .enable(en_mat_b),
		.bus(bus), .ready_in(ready_in), .matrix_out(matrix_b_out)
	);

	// 3. Matrix C Driver (256-bit implemented with two 128-bit drivers)
	wire [127:0] mat_c_low, mat_c_high;
	matrix_driver drv_mat_c_low (
		.clk(clk), .rst(rst), .enable(en_mat_c1),
		.bus(bus), .ready_in(ready_in), .matrix_out(mat_c_low)
	);
	matrix_driver drv_mat_c_high (
		.clk(clk), .rst(rst), .enable(en_mat_c2),
		.bus(bus), .ready_in(ready_in), .matrix_out(mat_c_high)
	);
	assign matrix_c_out = {mat_c_high, mat_c_low};

	// 4. Vector 1 Driver (64-bit)
	vector_driver drv_vec_1 (
		.clk(clk), .rst(rst), .enable(en_vec_1),
		.bus(bus), .ready_in(ready_in), .vector_out(vector_1_out)
	);

	// 5. Vector 2 Driver (64-bit)
	vector_driver drv_vec_2 (
		.clk(clk), .rst(rst), .enable(en_vec_2),
		.bus(bus), .ready_in(ready_in), .vector_out(vector_2_out)
	);

endmodule