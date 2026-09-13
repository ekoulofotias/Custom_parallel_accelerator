`include "parameters.vh"

module vector_driver (
	input clk,
	input rst,
	input enable,

	input wire [31:0] bus,
	input wire ready_in,
	output wire [`TOTAL_SIZE-1:0] vector_out
);

	wire ready_out;
	wire current_state;

	vector_counter CNT_VEC (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.ready_in(ready_in),
		.ready_out(ready_out),
		.current_state(current_state)
	);

	vector_decoder VEC_DEC_INST (
		.clk(clk),
		.rst(rst),
		.bus(bus),
		.current_state(current_state),
		.write_enable(ready_out),
		.vector_out(vector_out)
	);

endmodule