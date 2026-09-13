`include "parameters.vh"

module accelerator_connector (

	// Top driver inputs
	input wire [127:0] mat_a_in,
	input wire [127:0] mat_b_in,
	input wire [255:0] mat_c_in,
	input wire [`TOTAL_SIZE-1:0] vec_1_in,
	input wire [`TOTAL_SIZE-1:0] vec_2_in,

	// Accelerator pins
	output wire [`TOTAL_SIZE-1:0] vec_a_out,
	output wire [`TOTAL_SIZE-1:0] vec_b_out,

	// Tensor A pins (8-bit)
	output wire [`BIT_SIZE-1:0] T_A00_00, T_A00_01, T_A00_10, T_A00_11,
	output wire [`BIT_SIZE-1:0] T_A01_00, T_A01_01, T_A01_10, T_A01_11,
	output wire [`BIT_SIZE-1:0] T_A10_00, T_A10_01, T_A10_10, T_A10_11,
	output wire [`BIT_SIZE-1:0] T_A11_00, T_A11_01, T_A11_10, T_A11_11,

	// Tensor B pins (8-bit)
	output wire [`BIT_SIZE-1:0] T_B00_00, T_B00_01, T_B00_10, T_B00_11,
	output wire [`BIT_SIZE-1:0] T_B01_00, T_B01_01, T_B01_10, T_B01_11,
	output wire [`BIT_SIZE-1:0] T_B10_00, T_B10_01, T_B10_10, T_B10_11,
	output wire [`BIT_SIZE-1:0] T_B11_00, T_B11_01, T_B11_10, T_B11_11,

	// Tensor C pins (16-bit)
	output wire [`BIT_SIZE*2-1:0] T_C00_00, T_C00_01, T_C00_10, T_C00_11,
	output wire [`BIT_SIZE*2-1:0] T_C01_00, T_C01_01, T_C01_10, T_C01_11,
	output wire [`BIT_SIZE*2-1:0] T_C10_00, T_C10_01, T_C10_10, T_C10_11,
	output wire [`BIT_SIZE*2-1:0] T_C11_00, T_C11_01, T_C11_10, T_C11_11
);

	// Vector Routing
	assign vec_a_out = vec_1_in;
	assign vec_b_out = vec_2_in;

	// Matrix A Slicing
	assign T_A00_00 = mat_a_in[7:0]; assign T_A00_01 = mat_a_in[15:8];
	assign T_A00_10 = mat_a_in[23:16]; assign T_A00_11 = mat_a_in[31:24];
	assign T_A01_00 = mat_a_in[39:32]; assign T_A01_01 = mat_a_in[47:40];
	assign T_A01_10 = mat_a_in[55:48]; assign T_A01_11 = mat_a_in[63:56];
	assign T_A10_00 = mat_a_in[71:64]; assign T_A10_01 = mat_a_in[79:72];
	assign T_A10_10 = mat_a_in[87:80]; assign T_A10_11 = mat_a_in[95:88];
	assign T_A11_00 = mat_a_in[103:96]; assign T_A11_01 = mat_a_in[111:104];
	assign T_A11_10 = mat_a_in[119:112]; assign T_A11_11 = mat_a_in[127:120];

	// Matrix B Slicing
	assign T_B00_00 = mat_b_in[7:0]; assign T_B00_01 = mat_b_in[15:8];
	assign T_B00_10 = mat_b_in[23:16]; assign T_B00_11 = mat_b_in[31:24];
	assign T_B01_00 = mat_b_in[39:32]; assign T_B01_01 = mat_b_in[47:40];
	assign T_B01_10 = mat_b_in[55:48]; assign T_B01_11 = mat_b_in[63:56];
	assign T_B10_00 = mat_b_in[71:64]; assign T_B10_01 = mat_b_in[79:72];
	assign T_B10_10 = mat_b_in[87:80]; assign T_B10_11 = mat_b_in[95:88];
	assign T_B11_00 = mat_b_in[103:96]; assign T_B11_01 = mat_b_in[111:104];
	assign T_B11_10 = mat_b_in[119:112]; assign T_B11_11 = mat_b_in[127:120];

	// Matrix C Slicing (16-bit elements)
	assign T_C00_00 = mat_c_in[15:0];assign T_C00_01 = mat_c_in[31:16];
	assign T_C00_10 = mat_c_in[47:32]; assign T_C00_11 = mat_c_in[63:48];
	assign T_C01_00 = mat_c_in[79:64]; assign T_C01_01 = mat_c_in[95:80];
	assign T_C01_10 = mat_c_in[111:96]; assign T_C01_11 = mat_c_in[127:112];
	assign T_C10_00 = mat_c_in[143:128]; assign T_C10_01 = mat_c_in[159:144];
	assign T_C10_10 = mat_c_in[175:160]; assign T_C10_11 = mat_c_in[191:176];
	assign T_C11_00 = mat_c_in[207:192]; assign T_C11_01 = mat_c_in[223:208];
	assign T_C11_10 = mat_c_in[239:224]; assign T_C11_11 = mat_c_in[255:240];

endmodule