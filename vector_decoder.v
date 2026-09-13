`include "parameters.vh"

module vector_decoder (

	input wire clk,
	input wire rst,
	input wire [31:0] bus,
	input wire current_state,
	input wire write_enable,
	
	output reg [`TOTAL_SIZE-1:0] vector_out
);

	always @(posedge clk or posedge rst) begin

		if (rst) begin
			vector_out <= {`TOTAL_SIZE{1'b0}};
		end else if (write_enable) begin
			case (current_state)
				1'b0: vector_out[31:0]  <= bus;
				1'b1: vector_out[63:32] <= bus;
				default: ;
			endcase
		end
	end

endmodule