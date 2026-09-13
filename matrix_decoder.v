module matrix_decoder (

	input wire clk,
	input wire rst,

	input wire [31:0] bus,
	input wire [1:0] current_state,
	input wire write_enable,
	
	output reg [127:0] matrix_out
);

	always @(posedge clk or posedge rst) begin

		if (rst) begin

			matrix_out <= 128'd0;
			
		end else if (write_enable) begin
			case (current_state)
				2'b00: matrix_out[31:0]   <= bus;
				2'b01: matrix_out[63:32]  <= bus;
				2'b10: matrix_out[95:64]  <= bus;
				2'b11: matrix_out[127:96] <= bus;
				default: ;
			endcase
		end
	end

endmodule

