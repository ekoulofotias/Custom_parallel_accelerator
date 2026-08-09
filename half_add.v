module half_add (
	output wire s,
	output wire c,
	input wire a,
	input wire b
);
	assign s = a ^ b;
	assign c = a & b;

endmodule


