module tensor_core_2x2 (
	input wire clk,
	input wire rst,
	input wire engage_zero_blocking, //Zero blocking switch

	// Result matrix
	output reg [`BIT_SIZE*2-1:0] D00, D01,
	output reg [`BIT_SIZE*2-1:0] D10, D11,

	// Matrix A (2x2)
	input wire [`BIT_SIZE-1:0] A00, A01,
	input wire [`BIT_SIZE-1:0] A10, A11,

	// Matrix B (2x2)
	input wire [`BIT_SIZE-1:0] B00, B01,
	input wire [`BIT_SIZE-1:0] B10, B11,

	output wire block_skipped
);

	zero_block_detector zb_inst (
		.engage(engage_zero_blocking),
		.A({A11, A10, A01, A00}),
		.B({B11, B10, B01, B00}),
		.skip(block_skipped)
	);

	// Multiplication Registers
	reg [`BIT_SIZE*2-1:0] p00_a_s1, p00_b_s1, p01_a_s1, p01_b_s1;
	reg [`BIT_SIZE*2-1:0] p10_a_s1, p10_b_s1, p11_a_s1, p11_b_s1;

	// Partial Sum Registers
	reg [`BIT_SIZE*2-1:0] sum00_s2, sum01_s2, sum10_s2, sum11_s2;

    reg block_skipped_s1;
    reg block_skipped_s2;

    always @(posedge clk) begin
        if (rst) begin
            // Reset Stage 1
            p00_a_s1 <= 0; p00_b_s1 <= 0;
            p01_a_s1 <= 0; p01_b_s1 <= 0;
            p10_a_s1 <= 0; p10_b_s1 <= 0;
            p11_a_s1 <= 0; p11_b_s1 <= 0;
            block_skipped_s1 <= 0;

            // Reset Stage 2
            sum00_s2 <= 0; sum01_s2 <= 0;
            sum10_s2 <= 0; sum11_s2 <= 0;
            block_skipped_s2 <= 0;

            // Reset Stage 3 (Outputs)
            D00 <= 0; D01 <= 0; D10 <= 0; D11 <= 0;
        end
        else begin
            // Dot products & Pipeline Control
            block_skipped_s1 <= block_skipped;

            if (block_skipped) begin
                p00_a_s1 <= 0; p00_b_s1 <= 0;
                p01_a_s1 <= 0; p01_b_s1 <= 0;
                p10_a_s1 <= 0; p10_b_s1 <= 0;
                p11_a_s1 <= 0; p11_b_s1 <= 0;
            end
            else begin
                p00_a_s1 <= A00 * B00;
                p00_b_s1 <= A01 * B10;
                p01_a_s1 <= A00 * B01;
	            p01_b_s1 <= A01 * B11;
                p10_a_s1 <= A10 * B00;
                p10_b_s1 <= A11 * B10;
                p11_a_s1 <= A10 * B01;
                p11_b_s1 <= A11 * B11;
            end

        	// Sum partial products
            block_skipped_s2 <= block_skipped_s1;

            if (block_skipped_s1) begin
                sum00_s2 <= 0; sum01_s2 <= 0;
                sum10_s2 <= 0; sum11_s2 <= 0;
            end
            else begin
                sum00_s2 <= p00_a_s1 + p00_b_s1;
                sum01_s2 <= p01_a_s1 + p01_b_s1;
                sum10_s2 <= p10_a_s1 + p10_b_s1;
                sum11_s2 <= p11_a_s1 + p11_b_s1;
            end

            // Register to final outputs
            if (block_skipped_s2) begin
                D00 <= 0; D01 <= 0;
                D10 <= 0; D11 <= 0;
            end
            else begin
                D00 <= sum00_s2; D01 <= sum01_s2;
                D10 <= sum10_s2; D11 <= sum11_s2;
            end
        end
    end

endmodule

