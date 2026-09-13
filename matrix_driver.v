module matrix_driver (
	input clk,
	input rst,
	input enable,

	input wire [31:0] bus,
	input wire ready_in,
	output wire [127:0] matrix_out
);

	wire ready_out;
	wire [1:0] current_state;

	counter_matrix CNT_INST (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.ready_in(ready_in),
		.ready_out(ready_out),
		.current_state(current_state)
	);

	matrix_decoder MAT_DEC_INST (
		.clk(clk),
		.rst(rst),
		.bus(bus),
		.current_state(current_state),
		.write_enable(ready_out),
		.matrix_out(matrix_out)
	);

endmodule

