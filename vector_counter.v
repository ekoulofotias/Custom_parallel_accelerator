`include "parameters.vh"

module vector_counter (

	input clk,
	input rst,
	input enable,
	input ready_in,
	
	output reg ready_out,
	output reg current_state
);

	parameter	block_a = 1'b0,
				block_b = 1'b1;

	reg next_state;

	always @(*) begin
		next_state = current_state;
		ready_out = 1'b0;

		if (enable) begin
			case (current_state)
				block_a: begin
					if (ready_in) begin
						next_state = block_b;
						ready_out = 1'b1;
					end
				end

				block_b: begin
					if (ready_in) begin
						next_state = block_a;
						ready_out = 1'b1;
					end
				end

				default: next_state = block_a;
			endcase
		end
	end

	always @(posedge clk or posedge rst) begin
		
		if (rst) begin
			current_state <= block_a;
		end else begin
			current_state <= next_state;
		end
	end

endmodule