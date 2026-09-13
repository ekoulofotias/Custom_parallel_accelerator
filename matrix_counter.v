module counter_matrix(
	input clk,
	input rst,
	input enable,
	
	input ready_in,
	output reg ready_out,

	output reg [1:0] current_state
);

	parameter	block_a = 2'b00,
				block_b = 2'b01,
				block_c = 2'b10,
				block_d = 2'b11;

	reg [1:0] next_state;

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
						next_state = block_c;
						ready_out = 1'b1;
					end
				end
				
				block_c: begin
					if (ready_in) begin
						next_state = block_d;
						ready_out = 1'b1;
					end
				end
				
				block_d: begin
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
		if (rst) 
			current_state <= block_a;
		else 
			current_state <= next_state;
	end

endmodule

