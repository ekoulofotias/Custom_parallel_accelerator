`include "parameters.vh"

module tensor_core_2x2 (
		input wire clk,
		input wire rst,
		input wire engage_zero_blocking,

		// Result matrix D (2x2, 16-bit)
		output reg [`BIT_SIZE*2-1:0] D00, D01,
		output reg [`BIT_SIZE*2-1:0] D10, D11,

		// Matrix A & B
		input wire [`BIT_SIZE-1:0] A00, A01, A10, A11,
		input wire [`BIT_SIZE-1:0] B00, B01, B10, B11,

		// Matrix C
		input wire [`BIT_SIZE*2-1:0] C00, C01, C10, C11,

		output wire block_skipped
);

		zero_block_detector zb_inst (
				.engage(engage_zero_blocking),
				.A({A11, A10, A01, A00}),
				.B({B11, B10, B01, B00}),
				.skip(block_skipped)
		);

		// Multiplications & C delay
		reg [`BIT_SIZE*2-1:0] p00_a_s1, p00_b_s1, p01_a_s1, p01_b_s1;
		reg [`BIT_SIZE*2-1:0] p10_a_s1, p10_b_s1, p11_a_s1, p11_b_s1;
		reg [`BIT_SIZE*2-1:0] c00_s1, c01_s1, c10_s1, c11_s1;
		reg block_skipped_s1;

		// Accumulations
		reg [`BIT_SIZE*2-1:0] sum00_s2, sum01_s2, sum10_s2, sum11_s2;
		reg block_skipped_s2;

		always @(posedge clk) begin
			if (rst) begin
				p00_a_s1 <= 0; p00_b_s1 <= 0; p01_a_s1 <= 0; p01_b_s1 <= 0;
				p10_a_s1 <= 0; p10_b_s1 <= 0; p11_a_s1 <= 0; p11_b_s1 <= 0;
				c00_s1 <= 0; c01_s1 <= 0; c10_s1 <= 0; c11_s1 <= 0;
				block_skipped_s1 <= 0;

				sum00_s2 <= 0; sum01_s2 <= 0; sum10_s2 <= 0; sum11_s2 <= 0;
				block_skipped_s2 <= 0;

				D00 <= 0; D01 <= 0; D10 <= 0; D11 <= 0;
			end
			else begin
				// Multiplication & Zero Skip
				block_skipped_s1 <= block_skipped;
				
				p00_a_s1 <= block_skipped ? 0 : ($signed(A00) * $signed(B00));
				p00_b_s1 <= block_skipped ? 0 : ($signed(A01) * $signed(B10));
				p01_a_s1 <= block_skipped ? 0 : ($signed(A00) * $signed(B01));
				p01_b_s1 <= block_skipped ? 0 : ($signed(A01) * $signed(B11));
				p10_a_s1 <= block_skipped ? 0 : ($signed(A10) * $signed(B00));
				p10_b_s1 <= block_skipped ? 0 : ($signed(A11) * $signed(B10));
				p11_a_s1 <= block_skipped ? 0 : ($signed(A10) * $signed(B01));
				p11_b_s1 <= block_skipped ? 0 : ($signed(A11) * $signed(B11));

				c00_s1 <= block_skipped ? 0 : C00;
				c01_s1 <= block_skipped ? 0 : C01;
				c10_s1 <= block_skipped ? 0 : C10;
				c11_s1 <= block_skipped ? 0 : C11;

				// MAC Accumulation
				block_skipped_s2 <= block_skipped_s1;

				sum00_s2 <= block_skipped_s1 ? 0 : ($signed(p00_a_s1) + $signed(p00_b_s1) + $signed(c00_s1));
				sum01_s2 <= block_skipped_s1 ? 0 : ($signed(p01_a_s1) + $signed(p01_b_s1) + $signed(c01_s1));
				sum10_s2 <= block_skipped_s1 ? 0 : ($signed(p10_a_s1) + $signed(p10_b_s1) + $signed(c10_s1));
				sum11_s2 <= block_skipped_s1 ? 0 : ($signed(p11_a_s1) + $signed(p11_b_s1) + $signed(c11_s1));

				// Output Registration
				D00 <= block_skipped_s2 ? 0 : sum00_s2;
				D01 <= block_skipped_s2 ? 0 : sum01_s2;
				D10 <= block_skipped_s2 ? 0 : sum10_s2;
				D11 <= block_skipped_s2 ? 0 : sum11_s2;
			end
		end

endmodule

