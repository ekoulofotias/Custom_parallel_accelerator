module full_add (
	output wire s,
	output wire c_out,
	input wire a,
	input wire b,
	input wire c_in
);

	wire s_1, c_1, c_2;

	half_add A1 (.s(s_1), .c(c_1), .a(a), .b(b));
	half_add A2 (.s(s), .c(c_2), .a(s_1), .b(c_in));

	assign c_out = c_1 | c_2;

endmodule

