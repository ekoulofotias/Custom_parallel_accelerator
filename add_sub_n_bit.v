`include "parameters.vh"

module add_sub_n_bit(
    output wire [`BIT_SIZE-1:0] S,
    output wire C,
    output wire OV,
    input wire [`BIT_SIZE-1:0] A,
    input wire [`BIT_SIZE-1:0] B,
    input wire OP
);

    wire [`BIT_SIZE-1:0] B_xor;
    wire [`BIT_SIZE:0] carry;

    assign B_xor = B ^ {`BIT_SIZE{OP}};
    assign carry[0] = OP;

	genvar i;
    generate
        for (i = 0; i < `BIT_SIZE; i = i + 1) begin : gen_fa
            full_add ADD_SUB (
                .a(A[i]),
                .b(B_xor[i]),
                .c_in(carry[i]),
                .s(S[i]),
                .c_out(carry[i+1])
            );
        end
    endgenerate

    assign C = carry[`BIT_SIZE];
    assign OV = carry[`BIT_SIZE] ^ carry[`BIT_SIZE-1];

endmodule