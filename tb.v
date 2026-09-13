`include "parameters.vh"

module tb_system;

	reg clk;
	reg rst;
	reg enable;
	reg ready_in;
	reg [2:0] target_sel;
	reg [31:0] bus;
	reg [15:0] instruction_in;

	wire [`TOTAL_SIZE-1:0] vec_alu_out;
	wire [`BIT_SIZE*2-1:0] dot_out;
	wire [`BIT_SIZE*2-1:0] T_D00_00, T_D00_01, T_D00_10, T_D00_11;
	wire [`BIT_SIZE*2-1:0] T_D01_00, T_D01_01, T_D01_10, T_D01_11;
	wire [`BIT_SIZE*2-1:0] T_D10_00, T_D10_01, T_D10_10, T_D10_11;
	wire [`BIT_SIZE*2-1:0] T_D11_00, T_D11_01, T_D11_10, T_D11_11;

	reg [7:0] t_a00_00, t_a00_01, t_a00_10, t_a00_11;
	reg [7:0] t_a01_00, t_a01_01, t_a01_10, t_a01_11;
	reg [7:0] t_a10_00, t_a10_01, t_a10_10, t_a10_11;
	reg [7:0] t_a11_00, t_a11_01, t_a11_10, t_a11_11;

	reg [7:0] t_b00_00, t_b00_01, t_b00_10, t_b00_11;
	reg [7:0] t_b01_00, t_b01_01, t_b01_10, t_b01_11;
	reg [7:0] t_b10_00, t_b10_01, t_b10_10, t_b10_11;
	reg [7:0] t_b11_00, t_b11_01, t_b11_10, t_b11_11;

	reg [15:0] t_c00_00, t_c00_01, t_c00_10, t_c00_11;
	reg [15:0] t_c01_00, t_c01_01, t_c01_10, t_c01_11;
	reg [15:0] t_c10_00, t_c10_01, t_c10_10, t_c10_11;
	reg [15:0] t_c11_00, t_c11_01, t_c11_10, t_c11_11;

	top_system dut (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.ready_in(ready_in),
		.target_sel(target_sel),
		.bus(bus),
		.instruction_in(instruction_in),
		.vec_alu_out(vec_alu_out),
		.dot_out(dot_out),
		.T_D00_00(T_D00_00), .T_D00_01(T_D00_01), .T_D00_10(T_D00_10), .T_D00_11(T_D00_11),
		.T_D01_00(T_D01_00), .T_D01_01(T_D01_01), .T_D01_10(T_D01_10), .T_D01_11(T_D01_11),
		.T_D10_00(T_D10_00), .T_D10_01(T_D10_01), .T_D10_10(T_D10_10), .T_D10_11(T_D10_11),
		.T_D11_00(T_D11_00), .T_D11_01(T_D11_01), .T_D11_10(T_D11_10), .T_D11_11(T_D11_11)
	);

	always #5 clk = ~clk;

	initial begin
		$dumpfile("tb_system.vcd");
		$dumpvars(0, tb_system);
		
		clk = 0;
		rst = 1;
		enable = 0;
		ready_in = 0;
		target_sel = 3'b000;
		bus = 32'b0;
		instruction_in = 16'b0;

		#20 rst = 0;
		#10;

		// TEST 1: SIGNED VECTOR ADDITION (A + B)

		@(posedge clk);
		target_sel = 3'b100;
		enable = 1;
		ready_in = 1;
		bus = {8'h03, 8'h08, 8'h80, 8'h01};
		
		@(posedge clk);
		bus = {8'h0A, 8'hFB, 8'h0F, 8'hF6};

		@(posedge clk);
		target_sel = 3'b101;
		bus = {8'h02, 8'hFE, 8'h01, 8'h02};
		
		@(posedge clk);
		bus = {8'h05, 8'h05, 8'hFB, 8'h0A};

		@(posedge clk);
		enable = 0;
		ready_in = 0;

		#10;
		instruction_in = 16'h2200; // UNIT_VECTOR_ALU + VOP_ADD
		#10;

		$display("========================================");
		$display("TEST 1: Signed Vector Addition (A + B)");
		$display("----------------------------------------");
		$display("OUT     = (%0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d)",
			$signed(vec_alu_out[7*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[6*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_alu_out[5*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[4*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_alu_out[3*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[2*`BIT_SIZE +: `BIT_SIZE]),
			$signed(vec_alu_out[1*`BIT_SIZE +: `BIT_SIZE]), $signed(vec_alu_out[0*`BIT_SIZE +: `BIT_SIZE])
		);
		$display("----------------------------------------");

		// TEST 2: SIGNED DOT PRODUCT

		#10;
		instruction_in = 16'h2A00; // UNIT_VECTOR_ALU + VOP_DOT
		#10;

		$display("TEST 2: Signed Dot Product (A . B)");
		$display("----------------------------------------");
		$display("A . B = %0d", $signed(dot_out));
		$display("----------------------------------------");

		// TEST 3: BITWISE & SHIFT CHECKS

		#10;
		instruction_in = 16'h2610; // Shift Left by 2
		#10;
		$display("TEST 3: Vector Shift Left by 2");
		$display("----------------------------------------");
		$display("Shifted OUT[5] = %0d", $signed(vec_alu_out[5*`BIT_SIZE +: `BIT_SIZE]));
		$display("----------------------------------------");

		// TEST 4: TENSOR MAC (A x B + C = D)

		// Loading matrix A (target_sel = 3'b000) - 4 cycles
		@(posedge clk);
		target_sel = 3'b000;
		enable = 1;
		ready_in = 1;
		bus = {8'h03, 8'hFE, 8'hFF, 8'h02}; 
		@(posedge clk);
		bus = {8'hFB, 8'h02, 8'h00, 8'h01}; 
		@(posedge clk);
		bus = {8'h02, 8'h00, 8'h01, 8'hFC}; 
		@(posedge clk);
		bus = {8'h02, 8'hFF, 8'h01, 8'h01}; 

		// Loading matrix B (target_sel = 3'b001) - 4 cycles
		@(posedge clk);
		target_sel = 3'b001;
		bus = {8'hFF, 8'h03, 8'h02, 8'h01}; 
		@(posedge clk);
		bus = {8'h02, 8'h00, 8'h01, 8'hFE}; 
		@(posedge clk);
		bus = {8'hFC, 8'h01, 8'h00, 8'h02}; 
		@(posedge clk);
		bus = {8'h01, 8'h03, 8'h02, 8'h01}; 

		// Loading matrix C 256-bit (8 cycles)
		@(posedge clk);
		target_sel = 3'b010;
		bus = {16'h0000, 16'h0003}; 
		@(posedge clk);
		bus = {16'hFFFE, 16'h0005};
		@(posedge clk);
		bus = {16'h0001, 16'h0004};
		@(posedge clk);
		bus = {16'hFFFA, 16'h0002};

		@(posedge clk);
		target_sel = 3'b011;
		bus = {16'h0005, 16'h0001};
		@(posedge clk);
		bus = {16'h0002, 16'hFFF0};
		@(posedge clk);
		bus = {16'h0003, 16'h0000};
		@(posedge clk);
		bus = {16'hFFFE, 16'h0000}; 

		@(posedge clk);
		enable = 0;
		ready_in = 0;

		t_a00_00 = 8'h02; t_a00_01 = 8'hFF; t_a00_10 = 8'hFE; t_a00_11 = 8'h03;
		t_a01_00 = 8'h01; t_a01_01 = 8'h00; t_a01_10 = 8'h02; t_a01_11 = 8'hFB;
		t_a10_00 = 8'hFC; t_a10_01 = 8'h01; t_a10_10 = 8'h00; t_a10_11 = 8'h02;
		t_a11_00 = 8'h01; t_a11_01 = 8'h01; t_a11_10 = 8'hFF; t_a11_11 = 8'h02;

		t_b00_00 = 8'h01; t_b00_01 = 8'h02; t_b00_10 = 8'h03; t_b00_11 = 8'hFF;
		t_b01_00 = 8'hFE; t_b01_01 = 8'h01; t_b01_10 = 8'h00; t_b01_11 = 8'h02;
		t_b10_00 = 8'h02; t_b10_01 = 8'h00; t_b10_10 = 8'h01; t_b10_11 = 8'hFC;
		t_b11_00 = 8'h01; t_b11_01 = 8'h02; t_b11_10 = 8'h03; t_b11_11 = 8'h01;

		t_c00_00 = 16'hFFF6; t_c00_01 = 16'h000A; t_c00_10 = 16'h0005; t_c00_11 = 16'hFFFE;
		t_c01_00 = 16'h0000; t_c01_01 = 16'h0003; t_c01_10 = 16'h0004; t_c01_11 = 16'h0001;
		t_c10_00 = 16'hFFF0; t_c10_01 = 16'h0002; t_c10_10 = 16'h0001; t_c10_11 = 16'h0005;
		t_c11_00 = 16'h0002; t_c11_01 = 16'hFFFA; t_c11_10 = 16'h0003; t_c11_11 = 16'h0000;

		#10;
		instruction_in = 16'h4000; // UNIT_TENSOR_CORE + MATMUL
		#10;

		@(posedge clk);
		@(posedge clk);
		#10;

		$display("TEST 4: Signed Tensor MAC Result (A x B + C = D)");
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(t_a00_00), $signed(t_a00_01), $signed(t_a01_00), $signed(t_a01_01));
		$display("  A =|%4d %4d %4d %4d|", $signed(t_a00_10), $signed(t_a00_11), $signed(t_a01_10), $signed(t_a01_11));
		$display("     |%4d %4d %4d %4d|", $signed(t_a10_00), $signed(t_a10_01), $signed(t_a11_00), $signed(t_a11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(t_a10_10), $signed(t_a10_11), $signed(t_a11_10), $signed(t_a11_11));
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(t_b00_00), $signed(t_b00_01), $signed(t_b01_00), $signed(t_b01_01));
		$display("  B =|%4d %4d %4d %4d|", $signed(t_b00_10), $signed(t_b00_11), $signed(t_b01_10), $signed(t_b01_11));
		$display("     |%4d %4d %4d %4d|", $signed(t_b10_00), $signed(t_b10_01), $signed(t_b11_00), $signed(t_b11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(t_b10_10), $signed(t_b10_11), $signed(t_b11_10), $signed(t_b11_11));
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(t_c00_00), $signed(t_c00_01), $signed(t_c01_00), $signed(t_c01_01));
		$display("  C =|%4d %4d %4d %4d|", $signed(t_c00_10), $signed(t_c00_11), $signed(t_c01_10), $signed(t_c01_11));
		$display("     |%4d %4d %4d %4d|", $signed(t_c10_00), $signed(t_c10_01), $signed(t_c11_00), $signed(t_c11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(t_c10_10), $signed(t_c10_11), $signed(t_c11_10), $signed(t_c11_11));
		$display("----------------------------------------");
		$display("     ┌%4d %4d %4d %4d┐", $signed(T_D00_00), $signed(T_D00_01), $signed(T_D01_00), $signed(T_D01_01));
		$display("  D =|%4d %4d %4d %4d|", $signed(T_D00_10), $signed(T_D00_11), $signed(T_D01_10), $signed(T_D01_11));
		$display("     |%4d %4d %4d %4d|", $signed(T_D10_00), $signed(T_D10_01), $signed(T_D11_00), $signed(T_D11_01));
		$display("     └%4d %4d %4d %4d┘", $signed(T_D10_10), $signed(T_D10_11), $signed(T_D11_10), $signed(T_D11_11));
		$display("----------------------------------------");

		#10;
		$finish;
	end

endmodule