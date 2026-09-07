`include "parameters.vh"

module tb_tensor_bench;

	reg clk;
	reg rst;
	reg [15:0] instruction_in;

	// Vector Data Buses (Unused in Tensor Benchmarks)
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
		$dumpfile("tb_tensor.vcd");
		$dumpvars(0, tb_tensor_bench);
		
		clk = 0;
		rst = 1;
		instruction_in = 16'b0;
		vec_a_in = 0;
		vec_b_in = 0;

		#20 rst = 0;

		// TEST 1: TENSOR MAC WITH SIGNED MATRICES & NEGATIVE BIAS (ZB OFF)
		@(negedge clk);

		#5;
		$print_activity;

		instruction_in = 16'h0000;

		// Matrix A
		T_A00_00 = 8'h02; T_A00_01 = 8'hFF; T_A00_10 = 8'hFE; T_A00_11 = 8'h03;
		T_A01_00 = 8'h01; T_A01_01 = 8'h00; T_A01_10 = 8'h02; T_A01_11 = 8'hFB;
		T_A10_00 = 8'hFC; T_A10_01 = 8'h01; T_A10_10 = 8'h00; T_A10_11 = 8'h02;
		T_A11_00 = 8'h01; T_A11_01 = 8'h01; T_A11_10 = 8'hFF; T_A11_11 = 8'h02;

		// Matrix B
		T_B00_00 = 8'h01; T_B00_01 = 8'h02; T_B00_10 = 8'h03; T_B00_11 = 8'hFF;
		T_B01_00 = 8'hFE; T_B01_01 = 8'h01; T_B01_10 = 8'h00; T_B01_11 = 8'h02;
		T_B10_00 = 8'h02; T_B10_01 = 8'h00; T_B10_10 = 8'h01; T_B10_11 = 8'hFC;
		T_B11_00 = 8'h01; T_B11_01 = 8'h02; T_B11_10 = 8'h03; T_B11_11 = 8'h01;

		// Matrix C
		T_C00_00 = 16'hFFF6; T_C00_01 = 16'h000A; T_C00_10 = 16'h0005; T_C00_11 = 16'hFFFE; 
		T_C01_00 = 16'h0000; T_C01_01 = 16'h0003; T_C01_10 = 16'h0004; T_C01_11 = 16'h0001;
		T_C10_00 = 16'hFFF0; T_C10_01 = 16'h0002; T_C10_10 = 16'h0001; T_C10_11 = 16'h0005;
		T_C11_00 = 16'h0002; T_C11_01 = 16'hFFFA; T_C11_10 = 16'h0003; T_C11_11 = 16'h0000;

		@(negedge clk);
		instruction_in = 16'h4000; // UNIT_TENSOR_CORE + MATMUL (ZB OFF)

		@(posedge clk);
		@(posedge clk);
		#5;

		$display("TEST 1: Signed Tensor MAC Result (A x B + C = D)");
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

		#5;
		$print_activity;

		// TEST 2: TENSOR MAC (Zero Blocking ON) - Matrix A with 1 Tile of Zeros (A00)
		@(negedge clk);
		instruction_in = 16'h0000;

		// Matrix A (Tile A00 = ALL ZEROS)
		T_A00_00 = 8'h00; T_A00_01 = 8'h00; T_A00_10 = 8'h00; T_A00_11 = 8'h00;
		T_A01_00 = 8'h02; T_A01_01 = 8'h01; T_A01_10 = 8'h03; T_A01_11 = 8'hFE;
		T_A10_00 = 8'h01; T_A10_01 = 8'h04; T_A10_10 = 8'h02; T_A10_11 = 8'h01;
		T_A11_00 = 8'hFD; T_A11_01 = 8'h02; T_A11_10 = 8'h01; T_A11_11 = 8'h03;

		// Matrix B
		T_B00_00 = 8'h02; T_B00_01 = 8'h01; T_B00_10 = 8'hFE; T_B00_11 = 8'h03;
		T_B01_00 = 8'h01; T_B01_01 = 8'h02; T_B01_10 = 8'h00; T_B01_11 = 8'h01;
		T_B10_00 = 8'h03; T_B10_01 = 8'hFD; T_B10_10 = 8'h01; T_B10_11 = 8'h02;
		T_B11_00 = 8'h01; T_B11_01 = 8'h00; T_B11_10 = 8'hFE; T_B11_11 = 8'h01;

		// Matrix C (Zero Bias)
		T_C00_00 = 16'h0000; T_C00_01 = 16'h0000; T_C00_10 = 16'h0000; T_C00_11 = 16'h0000;
		T_C01_00 = 16'h0000; T_C01_01 = 16'h0000; T_C01_10 = 16'h0000; T_C01_11 = 16'h0000;
		T_C10_00 = 16'h0000; T_C10_01 = 16'h0000; T_C10_10 = 16'h0000; T_C10_11 = 16'h0000;
		T_C11_00 = 16'h0000; T_C11_01 = 16'h0000; T_C11_10 = 16'h0000; T_C11_11 = 16'h0000;

		@(negedge clk);
		instruction_in = 16'h4004; // UNIT_TENSOR_CORE + MATMUL + TENSOR_ZB_ON

		@(posedge clk);
		@(posedge clk);
		#5;

		$display("TEST 2: Zero Blocking ON - Matrix A with 1 Zero-Tile (A00)");
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

		#5;
		$print_activity;

		// TEST 3: TENSOR MAC (Zero Blocking ON) - Matrix A with 2 Tiles of Zeros (A00, A01)
		@(negedge clk);
		instruction_in = 16'h0000;

		// Matrix A (Tiles A00 & A01 = ALL ZEROS)
		T_A00_00 = 8'h00; T_A00_01 = 8'h00; T_A00_10 = 8'h00; T_A00_11 = 8'h00;
		T_A01_00 = 8'h00; T_A01_01 = 8'h00; T_A01_10 = 8'h00; T_A01_11 = 8'h00;
		T_A10_00 = 8'h02; T_A10_01 = 8'h01; T_A10_10 = 8'hFE; T_A10_11 = 8'h03;
		T_A11_00 = 8'h01; T_A11_01 = 8'h02; T_A11_10 = 8'h04; T_A11_11 = 8'hFD;

		@(negedge clk);
		instruction_in = 16'h4004;

		@(posedge clk);
		@(posedge clk);
		#5;

		$display("TEST 3: Zero Blocking ON - Matrix A with 2 Zero-Tiles (A00, A01)");
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

		#5;
		$print_activity;

		// TEST 4: TENSOR MAC (Zero Blocking ON) - Matrix A with 3 Tiles of Zeros (A00, A01, A10)
		@(negedge clk);
		instruction_in = 16'h0000;

		// Matrix A (Tiles A00, A01 & A10 = ALL ZEROS)
		T_A00_00 = 8'h00; T_A00_01 = 8'h00; T_A00_10 = 8'h00; T_A00_11 = 8'h00;
		T_A01_00 = 8'h00; T_A01_01 = 8'h00; T_A01_10 = 8'h00; T_A01_11 = 8'h00;
		T_A10_00 = 8'h00; T_A10_01 = 8'h00; T_A10_10 = 8'h00; T_A10_11 = 8'h00;
		T_A11_00 = 8'h03; T_A11_01 = 8'h02; T_A11_10 = 8'hFE; T_A11_11 = 8'h01;

		@(negedge clk);
		instruction_in = 16'h4004;

		@(posedge clk);
		@(posedge clk);
		#5;

		$display("TEST 4: Zero Blocking ON - Matrix A with 3 Zero-Tiles (A00, A01, A10)");
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

		#5;
		$print_activity;

		#20;
		$finish;
	end

endmodule