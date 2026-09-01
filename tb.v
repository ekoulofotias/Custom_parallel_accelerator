`include "parameters.vh"

module tb_accelerator;

	reg clk;
	reg rst;
	reg [15:0] instruction_in;

	// Vector Data Buses
	reg [`TOTAL_SIZE-1:0] vec_a_in;
	reg [`TOTAL_SIZE-1:0] vec_b_in;
	wire [`TOTAL_SIZE-1:0] vec_alu_out;
	wire [`BIT_SIZE*2-1:0] dot_out;

	// Tensor Grid Inputs (Matrix A - 8-bit)
	reg [`BIT_SIZE-1:0] T_A00_00, T_A00_01, T_A00_10, T_A00_11;
	reg [`BIT_SIZE-1:0] T_A01_00, T_A01_01, T_A01_10, T_A01_11;
	reg [`BIT_SIZE-1:0] T_A10_00, T_A10_01, T_A10_10, T_A10_11;
	reg [`BIT_SIZE-1:0] T_A11_00, T_A11_01, T_A11_10, T_A11_11;

	// Tensor Grid Inputs (Matrix B - 8-bit)
	reg [`BIT_SIZE-1:0] T_B00_00, T_B00_01, T_B00_10, T_B00_11;
	reg [`BIT_SIZE-1:0] T_B01_00, T_B01_01, T_B01_10, T_B01_11;
	reg [`BIT_SIZE-1:0] T_B10_00, T_B10_01, T_B10_10, T_B10_11;
	reg [`BIT_SIZE-1:0] T_B11_00, T_B11_01, T_B11_10, T_B11_11;

	// Tensor Grid Inputs (Matrix C / Bias - 16-bit)
	reg [`BIT_SIZE*2-1:0] T_C00_00, T_C00_01, T_C00_10, T_C00_11;
	reg [`BIT_SIZE*2-1:0] T_C01_00, T_C01_01, T_C01_10, T_C01_11;
	reg [`BIT_SIZE*2-1:0] T_C10_00, T_C10_01, T_C10_10, T_C10_11;
	reg [`BIT_SIZE*2-1:0] T_C11_00, T_C11_01, T_C11_10, T_C11_11;

	// Tensor Grid Outputs (Matrix D - 16-bit)
	wire [`BIT_SIZE*2-1:0] T_D00_00, T_D00_01, T_D00_10, T_D00_11;
	wire [`BIT_SIZE*2-1:0] T_D01_00, T_D01_01, T_D01_10, T_D01_11;
	wire [`BIT_SIZE*2-1:0] T_D10_00, T_D10_01, T_D10_10, T_D10_11;
	wire [`BIT_SIZE*2-1:0] T_D11_00, T_D11_01, T_D11_10, T_D11_11;

	top_accelerator dut (
		.clk(clk),
		.rst(rst),
		.instruction_in(instruction_in),
		.vec_a_in(vec_a_in),
		.vec_b_in(vec_b_in),
		.vec_alu_out(vec_alu_out),
		.dot_out(dot_out),
		.T_A00_00(T_A00_00), .T_A00_01(T_A00_01), .T_A00_10(T_A00_10), .T_A00_11(T_A00_11),
		.T_A01_00(T_A01_00), .T_A01_01(T_A01_01), .T_A01_10(T_A01_10), .T_A01_11(T_A01_11),
		.T_A10_00(T_A10_00), .T_A10_01(T_A10_01), .T_A10_10(T_A10_10), .T_A10_11(T_A10_11),
		.T_A11_00(T_A11_00), .T_A11_01(T_A11_01), .T_A11_10(T_A11_10), .T_A11_11(T_A11_11),
		.T_B00_00(T_B00_00), .T_B00_01(T_B00_01), .T_B00_10(T_B00_10), .T_B00_11(T_B00_11),
		.T_B01_00(T_B01_00), .T_B01_01(T_B01_01), .T_B01_10(T_B01_10), .T_B01_11(T_B01_11),
		.T_B10_00(T_B10_00), .T_B10_01(T_B10_01), .T_B10_10(T_B10_10), .T_B10_11(T_B10_11),
		.T_B11_00(T_B11_00), .T_B11_01(T_B11_01), .T_B11_10(T_B11_10), .T_B11_11(T_B11_11),
		.T_C00_00(T_C00_00), .T_C00_01(T_C00_01), .T_C00_10(T_C00_10), .T_C00_11(T_C00_11),
		.T_C01_00(T_C01_00), .T_C01_01(T_C01_01), .T_C01_10(T_C01_10), .T_C01_11(T_C01_11),
		.T_C10_00(T_C10_00), .T_C10_01(T_C10_01), .T_C10_10(T_C10_10), .T_C10_11(T_C10_11),
		.T_C11_00(T_C11_00), .T_C11_01(T_C11_01), .T_C11_10(T_C11_10), .T_C11_11(T_C11_11),
		.T_D00_00(T_D00_00), .T_D00_01(T_D00_01), .T_D00_10(T_D00_10), .T_D00_11(T_D00_11),
		.T_D01_00(T_D01_00), .T_D01_01(T_D01_01), .T_D01_10(T_D01_10), .T_D01_11(T_D01_11),
		.T_D10_00(T_D10_00), .T_D10_01(T_D10_01), .T_D10_10(T_D10_10), .T_D10_11(T_D10_11),
		.T_D11_00(T_D11_00), .T_D11_01(T_D11_01), .T_D11_10(T_D11_10), .T_D11_11(T_D11_11)
	);

	always #5 clk = ~clk;

	initial begin
		$dumpfile("tb.vcd");
		$dumpvars(0, tb_accelerator);
		
		clk = 0;
		rst = 1;
		instruction_in = 16'b0;

		// ==============================
		// TEST 1: SIGNED VECTOR ADDITION
		// ==============================
		vec_a_in = {8'd10, 8'hFB, 8'd15, 8'hF6, 8'd3, 8'd8, 8'h80, 8'd1};
		vec_b_in = {8'd5, 8'd5, 8'hFB, 8'd10, 8'd2, 8'hFE, 8'd1, 8'd2};

		T_A00_00 = 0; T_A00_01 = 0; T_A00_10 = 0; T_A00_11 = 0;
		T_B00_00 = 0; T_B00_01 = 0; T_B00_10 = 0; T_B00_11 = 0;
		T_C00_00 = 0; T_C00_01 = 0; T_C00_10 = 0; T_C00_11 = 0;

		#20 rst = 0;

		#10;
		instruction_in = 16'h2200; // UNIT_VECTOR_ALU + VOP_ADD
		#10;

		$display("========================================");
		$display("TEST 1: Signed Vector Addition (A + B)");
		$display("----------------------------------------");
		$display("A[7..0] = (%0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d)",
			$signed(vec_a_in[7*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_a_in[6*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_a_in[5*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_a_in[4*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_a_in[3*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_a_in[2*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_a_in[1*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_a_in[0*`BIT_SIZE +: `BIT_SIZE])
		);
		$display("B[7..0] = (%0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d)",
			$signed(vec_b_in[7*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_b_in[6*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_b_in[5*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_b_in[4*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_b_in[3*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_b_in[2*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_b_in[1*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_b_in[0*`BIT_SIZE +: `BIT_SIZE])
		);
		$display("OUT     = (%0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d)",
			$signed(vec_alu_out[7*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[6*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_alu_out[5*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[4*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_alu_out[3*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[2*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_alu_out[1*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[0*`BIT_SIZE +: `BIT_SIZE])
		);
		$display("----------------------------------------");

		// ==========================================
		// TEST 2: SIGNED DOT PRODUCT
		// ==========================================
		#10;
		instruction_in = 16'h2A00; // UNIT_VECTOR_ALU + VOP_DOT
		#10;

		$display("TEST 2: Signed Dot Product (A . B)");
		$display("----------------------------------------");
		$display("A . B = %0d", $signed(dot_out));
		$display("----------------------------------------");

		// ==========================================
		// TEST 3: BITWISE & SHIFT CHECKS
		// ==========================================
		#10;
		instruction_in = 16'h2610; // Shift Left by 2
		#10;
		$display("TEST 3: Vector Shift Left by 2");
		$display("----------------------------------------");
		$display("Shifted OUT[5] = %0d", $signed(vec_alu_out[5*`BIT_SIZE +: `BIT_SIZE]));
		$display("----------------------------------------");

		// ==========================================
		// TEST 4: TENSOR MAC WITH SIGNED MATRICES & NEGATIVE BIAS
		// ==========================================
		@(posedge clk);
	
		// Matrix A
		T_A00_00 = 8'd2;
		T_A00_01 = 8'hFF;
		T_A00_10 = 8'hFE;
		T_A00_11 = 8'd3;
		T_A01_00 = 8'd1;
		T_A01_01 = 8'd0;
		T_A01_10 = 8'd2;
		T_A01_11 = 8'hFB;
		T_A10_00 = 8'hFC;
		T_A10_01 = 8'd1;
		T_A10_10 = 8'd0;
		T_A10_11 = 8'd2;
		T_A11_00 = 8'd1;
		T_A11_01 = 8'd1;
		T_A11_10 = 8'hFF;
		T_A11_11 = 8'd2;

		// Matrix B
		T_B00_00 = 8'd1;
		T_B00_01 = 8'd2;
		T_B00_10 = 8'd3;
		T_B00_11 = 8'hFF;
		T_B01_00 = 8'hFE;
		T_B01_01 = 8'd1;
		T_B01_10 = 8'd0;
		T_B01_11 = 8'd2;
		T_B10_00 = 8'd2;
		T_B10_01 = 8'd0;
		T_B10_10 = 8'd1;
		T_B10_11 = 8'hFC;
		T_B11_00 = 8'd1;
		T_B11_01 = 8'd2;
		T_B11_10 = 8'd3;
		T_B11_11 = 8'd1;

		// Matrix C
		T_C00_00 = 16'hFFF6;
		T_C00_01 = 16'd10;
		T_C00_10 = 16'd5;
		T_C00_11 = 16'hFFFE; 
		T_C01_00 = 16'd0;
		T_C01_01 = 16'd3;
		T_C01_10 = 16'd4;
		T_C01_11 = 16'd1;
		T_C10_00 = 16'hFFF0;
		T_C10_01 = 16'd2;
		T_C10_10 = 16'd1;
		T_C10_11 = 16'd5;
		T_C11_00 = 16'd2;
		T_C11_01 = 16'hFFFA;
		T_C11_10 = 16'd3;
		T_C11_11 = 16'd0;

		instruction_in = 16'h4000; // UNIT_TENSOR_CORE + MATMUL

		@(posedge clk);
		@(posedge clk);
		#10;

		$display("TEST 4: Signed Tensor MAC Result (A x B + C = D)");
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(T_A00_00), $signed(T_A00_01), $signed(T_A01_00), $signed(T_A01_01));
		$display("  A =|%4d %4d %4d %4d|", $signed(T_A00_10), $signed(T_A00_11), $signed(T_A01_10), $signed(T_A01_11));
		$display("     |%4d %4d %4d %4d|", $signed(T_A10_00), $signed(T_A10_01), $signed(T_A11_00), $signed(T_A11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(T_A10_10), $signed(T_A10_11), $signed(T_A11_10), $signed(T_A11_11));
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(T_B00_00), $signed(T_B00_01), $signed(T_B01_00), $signed(T_B01_01));
		$display("  B =|%4d %4d %4d %4d|", $signed(T_B00_10), $signed(T_B00_11), $signed(T_B01_10), $signed(T_B01_11));
		$display("     |%4d %4d %4d %4d|", $signed(T_B10_00), $signed(T_B10_01), $signed(T_B11_00), $signed(T_B11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(T_B10_10), $signed(T_B10_11), $signed(T_B11_10), $signed(T_B11_11));
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(T_C00_00), $signed(T_C00_01), $signed(T_C01_00), $signed(T_C01_01));
		$display("  C =|%4d %4d %4d %4d|", $signed(T_C00_10), $signed(T_C00_11), $signed(T_C01_10), $signed(T_C01_11));
		$display("     |%4d %4d %4d %4d|", $signed(T_C10_00), $signed(T_C10_01), $signed(T_C11_00), $signed(T_C11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(T_C10_10), $signed(T_C10_11), $signed(T_C11_10), $signed(T_C11_11));
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(T_D00_00), $signed(T_D00_01), $signed(T_D01_00), $signed(T_D01_01));
		$display("  D =|%4d %4d %4d %4d|", $signed(T_D00_10), $signed(T_D00_11), $signed(T_D01_10), $signed(T_D01_11));
		$display("     |%4d %4d %4d %4d|", $signed(T_D10_00), $signed(T_D10_01), $signed(T_D11_00), $signed(T_D11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(T_D10_10), $signed(T_D10_11), $signed(T_D11_10), $signed(T_D11_11));
		$display("----------------------------------------");

		#20 $finish;
	end

endmodule

