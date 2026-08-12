module tb_accelerator;

    reg clk;
    reg rst;
    reg [63:0] instruction_in; // Full instruction

    // Vector Data Buses
    reg [`TOTAL_SIZE-1:0] vec_a_in;
    reg [`TOTAL_SIZE-1:0] vec_b_in;
    wire [`TOTAL_SIZE-1:0] vec_alu_out;
    wire [`BIT_SIZE*2-1:0] dot_out;
    wire [`VEC_SIZE-1:0] carry_out;
    wire [`VEC_SIZE-1:0] overflow_out;

    // Tensor Grid Inputs / Outputs
    reg [`BIT_SIZE-1:0] T_A00_00, T_A00_01, T_A00_10, T_A00_11;
    reg [`BIT_SIZE-1:0] T_A01_00, T_A01_01, T_A01_10, T_A01_11;
    reg [`BIT_SIZE-1:0] T_A10_00, T_A10_01, T_A10_10, T_A10_11;
    reg [`BIT_SIZE-1:0] T_A11_00, T_A11_01, T_A11_10, T_A11_11;

    reg [`BIT_SIZE-1:0] T_B00_00, T_B00_01, T_B00_10, T_B00_11;
    reg [`BIT_SIZE-1:0] T_B01_00, T_B01_01, T_B01_10, T_B01_11;
    reg [`BIT_SIZE-1:0] T_B10_00, T_B10_01, T_B10_10, T_B10_11;
    reg [`BIT_SIZE-1:0] T_B11_00, T_B11_01, T_B11_10, T_B11_11;

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
        .carry_out(carry_out),
        .overflow_out(overflow_out),
        .T_A00_00(T_A00_00), .T_A00_01(T_A00_01), .T_A00_10(T_A00_10), .T_A00_11(T_A00_11),
        .T_A01_00(T_A01_00), .T_A01_01(T_A01_01), .T_A01_10(T_A01_10), .T_A01_11(T_A01_11),
        .T_A10_00(T_A10_00), .T_A10_01(T_A10_01), .T_A10_10(T_A10_10), .T_A10_11(T_A10_11),
        .T_A11_00(T_A11_00), .T_A11_01(T_A11_01), .T_A11_10(T_A11_10), .T_A11_11(T_A11_11),
        .T_B00_00(T_B00_00), .T_B00_01(T_B00_01), .T_B00_10(T_B00_10), .T_B00_11(T_B00_11),
        .T_B01_00(T_B01_00), .T_B01_01(T_B01_01), .T_B01_10(T_B01_10), .T_B01_11(T_B01_11),
        .T_B10_00(T_B10_00), .T_B10_01(T_B10_01), .T_B10_10(T_B10_10), .T_B10_11(T_B10_11),
        .T_B11_00(T_B11_00), .T_B11_01(T_B11_01), .T_B11_10(T_B11_10), .T_B11_11(T_B11_11),
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
        instruction_in = 64'b0;

        // Input vectors
        vec_a_in = 64'h01_04_0F_03_0A_08_00_01;
        vec_b_in = 64'h06_02_0F_02_01_0A_0C_02;

        // Initialize Input matrices to 0
        T_A00_00 = 0; T_A00_01 = 0; T_A00_10 = 0; T_A00_11 = 0;
        T_A01_00 = 0; T_A01_01 = 0; T_A01_10 = 0; T_A01_11 = 0;
        T_A10_00 = 0; T_A10_01 = 0; T_A10_10 = 0; T_A10_11 = 0;
        T_A11_00 = 0; T_A11_01 = 0; T_A11_10 = 0; T_A11_11 = 0;

        T_B00_00 = 0; T_B00_01 = 0; T_B00_10 = 0; T_B00_11 = 0;
        T_B01_00 = 0; T_B01_01 = 0; T_B01_10 = 0; T_B01_11 = 0;
        T_B10_00 = 0; T_B10_01 = 0; T_B10_10 = 0; T_B10_11 = 0;
        T_B11_00 = 0; T_B11_01 = 0; T_B11_10 = 0; T_B11_11 = 0;

        #20 rst = 0;

        // Vector ALU TEST

        // Feel free to insert diffirent instructions or input
        // vectors or matrices. This is merely a demonstration.

        #10;
        instruction_in = 64'h2200_0000_0000_0000; 
        #10;

        $display("Vector ALU test result:");
        $display("----------------------------------------");
        $display("A + B = C");
        $display("A = ( %0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d )",
            vec_a_in[7*`BIT_SIZE +: `BIT_SIZE],
            vec_a_in[6*`BIT_SIZE +: `BIT_SIZE],
            vec_a_in[5*`BIT_SIZE +: `BIT_SIZE],
            vec_a_in[4*`BIT_SIZE +: `BIT_SIZE],
            vec_a_in[3*`BIT_SIZE +: `BIT_SIZE],
            vec_a_in[2*`BIT_SIZE +: `BIT_SIZE],
            vec_a_in[1*`BIT_SIZE +: `BIT_SIZE],
            vec_a_in[0*`BIT_SIZE +: `BIT_SIZE]
        );

        $display("B = ( %0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d )",
            vec_b_in[7*`BIT_SIZE +: `BIT_SIZE],
            vec_b_in[6*`BIT_SIZE +: `BIT_SIZE],
            vec_b_in[5*`BIT_SIZE +: `BIT_SIZE],
            vec_b_in[4*`BIT_SIZE +: `BIT_SIZE],
            vec_b_in[3*`BIT_SIZE +: `BIT_SIZE],
            vec_b_in[2*`BIT_SIZE +: `BIT_SIZE],
            vec_b_in[1*`BIT_SIZE +: `BIT_SIZE],
            vec_b_in[0*`BIT_SIZE +: `BIT_SIZE]
        );

        $display("C = ( %0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d )",
            vec_alu_out[7*`BIT_SIZE +: `BIT_SIZE],
            vec_alu_out[6*`BIT_SIZE +: `BIT_SIZE],
            vec_alu_out[5*`BIT_SIZE +: `BIT_SIZE],
            vec_alu_out[4*`BIT_SIZE +: `BIT_SIZE],
            vec_alu_out[3*`BIT_SIZE +: `BIT_SIZE],
            vec_alu_out[2*`BIT_SIZE +: `BIT_SIZE],
            vec_alu_out[1*`BIT_SIZE +: `BIT_SIZE],
            vec_alu_out[0*`BIT_SIZE +: `BIT_SIZE]
        );
        $display("----------------------------------------");

        // DOT PRODUCT TEST
        #10;
        instruction_in = 64'h2A00_0000_0000_0000; // UNIT_VECTOR_ALU + VOP_DOT
        #10;

        $display("Dot Product test result:");
        $display("----------------------------------------");
        $display("A . B = %0d", dot_out);
        $display("----------------------------------------");

        // Matrix TENSOR GRID TEST
        @(posedge clk);
    
        // Matrix A
        // Tile A00
        T_A00_00 = 8'd1; T_A00_01 = 8'd1; 
        T_A00_10 = 8'd0; T_A00_11 = 8'd1; 
    
        // Tile A01
        T_A01_00 = 8'd1; T_A01_01 = 8'd1; 
        T_A01_10 = 8'd0; T_A01_11 = 8'd1; 

        // Tile A10
        T_A10_00 = 8'd1; T_A10_01 = 8'd0; 
        T_A10_10 = 8'd1; T_A10_11 = 8'd1; 

        // Tile A11
        T_A11_00 = 8'd1; T_A11_01 = 8'd0; 
        T_A11_10 = 8'd0; T_A11_11 = 8'd0; 


        // Matrix B
        // Tile B00
        T_B00_00 = 8'd2; T_B00_01 = 8'd0; 
        T_B00_10 = 8'd0; T_B00_11 = 8'd2; 

        // Tile B01
        T_B01_00 = 8'd1; T_B01_01 = 8'd1; 
        T_B01_10 = 8'd1; T_B01_11 = 8'd0; 

        // Tile B10
        T_B10_00 = 8'd1; T_B10_01 = 8'd1; 
        T_B10_10 = 8'd2; T_B10_11 = 8'd0; 

        // Tile B11
        T_B11_00 = 8'd2; T_B11_01 = 8'd0; 
        T_B11_10 = 8'd0; T_B11_11 = 8'd2; 

        // Matrix C
        // Tile B00
        T_B00_00 = 8'd2; T_B00_01 = 8'd0; 
        T_B00_10 = 8'd0; T_B00_11 = 8'd2; 

        // Tile B01
        T_B01_00 = 8'd1; T_B01_01 = 8'd1; 
        T_B01_10 = 8'd1; T_B01_11 = 8'd0; 

        // Tile B10
        T_B10_00 = 8'd1; T_B10_01 = 8'd1; 
        T_B10_10 = 8'd2; T_B10_11 = 8'd0; 

        // Tile B11
        T_B11_00 = 8'd2; T_B11_01 = 8'd0; 
        T_B11_10 = 8'd0; T_B11_11 = 8'd2;

        instruction_in = 64'h4000_0000_0000_0000; // UNIT_TENSOR_CORE + MATMUL

        // Tensor grid operations are broken down in 2 clock cycles
        // Dot products & Partial sums

        @(posedge clk);
        @(posedge clk);

        #10;

        $display("Matrix Multiplication Result:");
        $display("----------------------------------------");
        $display("A x B = C");
        $display("      ┌%3d %3d %3d %3d┐", T_A00_00, T_A00_01, T_A01_00, T_A01_01);
        $display("  A = |%3d %3d %3d %3d|", T_A00_10, T_A00_11, T_A01_10, T_A01_11);
        $display("      |%3d %3d %3d %3d|", T_A10_00, T_A10_01, T_A11_00, T_A11_01);
        $display("      └%3d %3d %3d %3d┘", T_A10_10, T_A10_11, T_A11_10, T_A11_11);
        $display("----------------------------------------");
        $display("      ┌%3d %3d %3d %3d┐", T_B00_00, T_B00_01, T_B01_00, T_B01_01);
        $display("  B = |%3d %3d %3d %3d|", T_B00_10, T_B00_11, T_B01_10, T_B01_11);
        $display("      |%3d %3d %3d %3d|", T_B10_00, T_B10_01, T_B11_00, T_B11_01);
        $display("      └%3d %3d %3d %3d┘", T_B10_10, T_B10_11, T_B11_10, T_B11_11);
        $display("----------------------------------------");
        $display("      ┌%3d %3d %3d %3d┐", T_D00_00, T_D00_01, T_D01_00, T_D01_01);
        $display("  C = |%3d %3d %3d %3d|", T_D00_10, T_D00_11, T_D01_10, T_D01_11);
        $display("      |%3d %3d %3d %3d|", T_D10_00, T_D10_01, T_D11_00, T_D11_01);
        $display("      └%3d %3d %3d %3d┘", T_D10_10, T_D10_11, T_D11_10, T_D11_11);

        #20 $finish;
    end

endmodule
