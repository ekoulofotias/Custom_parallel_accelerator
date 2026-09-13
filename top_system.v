`include "parameters.vh"

module top_system (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire ready_in,
    input wire [2:0] target_sel,
    input wire [31:0] bus,
    input wire [15:0] instruction_in,

    output wire [`TOTAL_SIZE-1:0] vec_alu_out,
    output wire [`BIT_SIZE*2-1:0] dot_out,
    output wire [`BIT_SIZE*2-1:0] T_D00_00, T_D00_01, T_D00_10, T_D00_11,
    output wire [`BIT_SIZE*2-1:0] T_D01_00, T_D01_01, T_D01_10, T_D01_11,
    output wire [`BIT_SIZE*2-1:0] T_D10_00, T_D10_01, T_D10_10, T_D10_11,
    output wire [`BIT_SIZE*2-1:0] T_D11_00, T_D11_01, T_D11_10, T_D11_11
);

    wire [127:0] mat_a_sig, mat_b_sig;
    wire [255:0] mat_c_sig;
    wire [`TOTAL_SIZE-1:0] vec_1_sig, vec_2_sig;

    wire [`TOTAL_SIZE-1:0] conn_vec_a, conn_vec_b;
    wire [`BIT_SIZE-1:0]   t_a00_00, t_a00_01, t_a00_10, t_a00_11;
    wire [`BIT_SIZE-1:0]   t_a01_00, t_a01_01, t_a01_10, t_a01_11;
    wire [`BIT_SIZE-1:0]   t_a10_00, t_a10_01, t_a10_10, t_a10_11;
    wire [`BIT_SIZE-1:0]   t_a11_00, t_a11_01, t_a11_10, t_a11_11;

    wire [`BIT_SIZE-1:0]   t_b00_00, t_b00_01, t_b00_10, t_b00_11;
    wire [`BIT_SIZE-1:0]   t_b01_00, t_b01_01, t_b01_10, t_b01_11;
    wire [`BIT_SIZE-1:0]   t_b10_00, t_b10_01, t_b10_10, t_b10_11;
    wire [`BIT_SIZE-1:0]   t_b11_00, t_b11_01, t_b11_10, t_b11_11;

    wire [`BIT_SIZE*2-1:0] t_c00_00, t_c00_01, t_c00_10, t_c00_11;
    wire [`BIT_SIZE*2-1:0] t_c01_00, t_c01_01, t_c01_10, t_c01_11;
    wire [`BIT_SIZE*2-1:0] t_c10_00, t_c10_01, t_c10_10, t_c10_11;
    wire [`BIT_SIZE*2-1:0] t_c11_00, t_c11_01, t_c11_10, t_c11_11;

    top_driver U_TOP_DRIVER (
        .clk(clk), .rst(rst), .enable(enable), .ready_in(ready_in),
        .target_sel(target_sel), .bus(bus),
        .matrix_a_out(mat_a_sig), .matrix_b_out(mat_b_sig),
        .matrix_c_out(mat_c_sig), .vector_1_out(vec_1_sig),
        .vector_2_out(vec_2_sig)
    );

    accelerator_connector U_CONNECTOR (
        .mat_a_in(mat_a_sig), .mat_b_in(mat_b_sig), .mat_c_in(mat_c_sig),
        .vec_1_in(vec_1_sig), .vec_2_in(vec_2_sig),
        .vec_a_out(conn_vec_a), .vec_b_out(conn_vec_b),
        .T_A00_00(t_a00_00), .T_A00_01(t_a00_01), .T_A00_10(t_a00_10), .T_A00_11(t_a00_11),
        .T_A01_00(t_a01_00), .T_A01_01(t_a01_01), .T_A01_10(t_a01_10), .T_A01_11(t_a01_11),
        .T_A10_00(t_a10_00), .T_A10_01(t_a10_01), .T_A10_10(t_a10_10), .T_A10_11(t_a10_11),
        .T_A11_00(t_a11_00), .T_A11_01(t_a11_01), .T_A11_10(t_a11_10), .T_A11_11(t_a11_11),
        .T_B00_00(t_b00_00), .T_B00_01(t_b00_01), .T_B00_10(t_b00_10), .T_B00_11(t_b00_11),
        .T_B01_00(t_b01_00), .T_B01_01(t_b01_01), .T_B01_10(t_b01_10), .T_B01_11(t_b01_11),
        .T_B10_00(t_b10_00), .T_B10_01(t_b10_01), .T_B10_10(t_b10_10), .T_B10_11(t_b10_11),
        .T_B11_00(t_b11_00), .T_B11_01(t_b11_01), .T_B11_10(t_b11_10), .T_B11_11(t_b11_11),
        .T_C00_00(t_c00_00), .T_C00_01(t_c00_01), .T_C00_10(t_c00_10), .T_C00_11(t_c00_11),
        .T_C01_00(t_c01_00), .T_C01_01(t_c01_01), .T_C01_10(t_c01_10), .T_C01_11(t_c01_11),
        .T_C10_00(t_c10_00), .T_C10_01(t_c10_01), .T_C10_10(t_c10_10), .T_C10_11(t_c10_11),
        .T_C11_00(t_c11_00), .T_C11_01(t_c11_01), .T_C11_10(t_c11_10), .T_C11_11(t_c11_11)
    );

    top_accelerator U_ACCEL (
        .clk(clk), .rst(rst), .instruction_in(instruction_in),
        .vec_a_in(conn_vec_a), .vec_b_in(conn_vec_b),
        .vec_alu_out(vec_alu_out), .dot_out(dot_out),
        .T_A00_00(t_a00_00), .T_A00_01(t_a00_01), .T_A00_10(t_a00_10), .T_A00_11(t_a00_11),
        .T_A01_00(t_a01_00), .T_A01_01(t_a01_01), .T_A01_10(t_a01_10), .T_A01_11(t_a01_11),
        .T_A10_00(t_a10_00), .T_A10_01(t_a10_01), .T_A10_10(t_a10_10), .T_A10_11(t_a10_11),
        .T_A11_00(t_a11_00), .T_A11_01(t_a11_01), .T_A11_10(t_a11_10), .T_A11_11(t_a11_11),
        .T_B00_00(t_b00_00), .T_B00_01(t_b00_01), .T_B00_10(t_b00_10), .T_B00_11(t_b00_11),
        .T_B01_00(t_b01_00), .T_B01_01(t_b01_01), .T_B01_10(t_b01_10), .T_B01_11(t_b01_11),
        .T_B10_00(t_b10_00), .T_B10_01(t_b10_01), .T_B10_10(t_b10_10), .T_B10_11(t_b10_11),
        .T_B11_00(t_b11_00), .T_B11_01(t_b11_01), .T_B11_10(t_b11_10), .T_B11_11(t_b11_11),
        .T_C00_00(t_c00_00), .T_C00_01(t_c00_01), .T_C00_10(t_c00_10), .T_C00_11(t_c00_11),
        .T_C01_00(t_c01_00), .T_C01_01(t_c01_01), .T_C01_10(t_c01_10), .T_C01_11(t_c01_11),
        .T_C10_00(t_c10_00), .T_C10_01(t_c10_01), .T_C10_10(t_c10_10), .T_C10_11(t_c10_11),
        .T_C11_00(t_c11_00), .T_C11_01(t_c11_01), .T_C11_10(t_c11_10), .T_C11_11(t_c11_11),
        .T_D00_00(T_D00_00), .T_D00_01(T_D00_01), .T_D00_10(T_D00_10), .T_D00_11(T_D00_11),
        .T_D01_00(T_D01_00), .T_D01_01(T_D01_01), .T_D01_10(T_D01_10), .T_D01_11(T_D01_11),
        .T_D10_00(T_D10_00), .T_D10_01(T_D10_01), .T_D10_10(T_D10_10), .T_D10_11(T_D10_11),
        .T_D11_00(T_D11_00), .T_D11_01(T_D11_01), .T_D11_10(T_D11_10), .T_D11_11(T_D11_11)
    );

endmodule