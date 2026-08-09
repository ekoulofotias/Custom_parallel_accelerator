`ifndef CONFIG_VH
`define CONFIG_VH

`ifndef PARAMETERS_VH
`define PARAMETERS_VH

`define BIT_SIZE      8
`define VEC_SIZE      8
`define TOTAL_SIZE    (`BIT_SIZE * `VEC_SIZE)
`define ADDR_SIZE     32

// --- EXECUTION UNIT SELECTORS ---
`define UNIT_NONE        3'b000
`define UNIT_VECTOR_ALU  3'b001
`define UNIT_TENSOR_CORE 3'b010

// --- VECTOR ALU OPCODES ---
`define VOP_ADD_SUB      4'b0001
`define VOP_BITWISE      4'b0010
`define VOP_SHIFT        4'b0011
`define VOP_HADAMARD     4'b0100
`define VOP_DOT          4'b0101

// ADD / SUB SUB-OPS (3-bit aligned for ISA format)
`define OP_ADD           3'b000
`define OP_SUB           3'b001

// BITWISE SUB-OPS
`define BITWISE_AND      3'b000
`define BITWISE_OR       3'b001
`define BITWISE_XOR      3'b010
`define BITWISE_NOT      3'b011
`define BITWISE_NAND     3'b100
`define BITWISE_NOR      3'b101
`define BITWISE_XNOR     3'b110

// SHIFT SUB-OPS (3-bit aligned)
`define SHIFT_LEFT       3'b000
`define SHIFT_RIGHT      3'b001

// --- TENSOR CORE OPCODES ---
`define TOP_MATMUL       4'b0000

// TENSOR ZERO BLOCKING MODES
`define TENSOR_ZB_OFF    1'b0
`define TENSOR_ZB_ON     1'b1

`endif

`endif // CONFIG_VH

