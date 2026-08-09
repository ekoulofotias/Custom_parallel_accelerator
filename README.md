# Custom Hardware Parallel Accelerator Architecture with Tensor Cores

**Author:** Stathis Koulofotias  
**Date:** July - August 2026  
**License:** MIT

---

## Overview

A custom hardware parallel accelerator architecture written in **Verilog**, designed from scratch with a focus on demonstrating modern GPU core concepts. This project features:

- **4×4 Tensor Core Grid** — Hardware-accelerated matrix multiplication via block matrix multiplication algorithm
- **Vector ALU** — Parallel vector operations (addition, subtraction, bitwise logic, shifts, Hadamard product, dot product)
- **Zero-Block Detection** — Power optimization mechanism for sparse computations
- **Custom 64-bit ISA** — Complete instruction set architecture with field-level control
- **Full RTL Design** — Comprehensive testbenches, synthesis scripts, and documentation

This is an **educational proof-of-concept** demonstrating the fundamental principles of modern parallel accelerator architecture (similar to NVIDIA/AMD GPU design).

---

## Key Features & Architecture

The system is based on a **top-down modular architecture**, combining specialized units:

### Tensor Cores
`tensor_grid_4x4.v` & `tensor_core_2x2.v`
- Structured grid of four 2×2 tensor cores
- Hardware-accelerated 4×4 matrix multiplications
- Block matrix multiplication algorithm with 2-stage pipelined execution
- Programmable zero-block skipping for power efficiency

### Vector ALU
`vector_alu.v`
- Parallel vector operations on 64-bit vectors (8 × 8-bit elements)
- **Operations:** Addition/Subtraction, Bitwise (AND, OR, XOR, NOT, NAND, NOR, XNOR), Shifting, Hadamard product, Dot product
- Carry and overflow flag generation

### Zero Block Detector
`zero_block_detector.v`
- Detects all-zero blocks in input matrices
- Enables pipeline bypass for energy efficiency
- Critical for sparse matrix acceleration

### Arithmetic Foundation
- Full & half adder primitives
- N-bit adder/subtractor
- Dot product accumulator

---

## Repository Structure

```
Custom_parallel_accelerator/
├── README.md                              # This file
├── LICENSE                                # MIT License
├── .gitignore                             # Git ignore rules
│
├── rtl/                                   # RTL Design (Verilog)
│   ├── parameters.vh                      # Global parameters & ISA definitions
│   ├── top_accelerator.v                  # Top-level module integration
│   │
│   ├── tensor_cores/
│   │   ├── tensor_grid_4x4.v              # 4×4 Tensor Core grid
│   │   └── tensor_core_2x2.v              # Basic 2×2 Tensor Core building block
│   │
│   ├── vector_alu/
│   │   ├── vector_alu.v                   # Vector ALU dispatcher
│   │   ├── vector_add_sub.v               # Vector addition/subtraction
│   │   ├── vector_bitwise.v               # Vector bitwise operations
│   │   ├── vector_hadamard.v              # Hadamard product
│   │   └── shifting.v                     # Barrel shifter
│   │
│   └── arithmetic/
│       ├── dot_product.v                  # Dot product unit
│       ├── add_sub_n_bit.v                # N-bit adder/subtractor
│       ├── full_add.v                     # Full adder primitive
│       ├── half_add.v                     # Half adder primitive
│       └── zero_block_detector.v          # Zero-block detection logic
│
├── sim/                                   # Simulation
│   └── tb.v                               # Comprehensive testbench
│
├── docs/                                  # Documentation
│   └── Custom_parallel_accelerator_Manual.txt  # ISA manual & architecture guide
│
└── synthesis/                             # Synthesis Scripts
    ├── yosys_tests.ys                     # Yosys synthesis script
    └── generate_schematics.ys             # Schematic generation script
```

---

## How to Simulate

### Requirements
- Verilog simulator (Icarus Verilog, ModelSim, VCS, or similar)
- (Optional) Yosys for synthesis

### Running the Testbench

```bash
# Using Icarus Verilog
cd rtl
iverilog -o sim_accelerator ../sim/tb.v top_accelerator.v vector_alu/vector_alu.v \
  vector_alu/vector_add_sub.v vector_alu/vector_bitwise.v \
  vector_alu/vector_hadamard.v vector_alu/shifting.v \
  tensor_cores/tensor_grid_4x4.v tensor_cores/tensor_core_2x2.v \
  arithmetic/dot_product.v arithmetic/add_sub_n_bit.v \
  arithmetic/full_add.v arithmetic/half_add.v arithmetic/zero_block_detector.v

# Run simulation
./sim_accelerator
```

The testbench demonstrates:
- Vector addition
- Dot product computation
- 4×4 matrix multiplication with tensor cores

---

## Instruction Set Architecture (ISA)

### 64-bit Instruction Format

```
[Bits 63:61]  EXEC_UNIT    (3 bits)  — Execution unit selector
[Bits 60:57]  OPCODE       (4 bits)  — Operation code
[Bits 56:54]  SUB_OP       (3 bits)  — Sub-operation selector
[Bits 53:51]  SHIFT_POS    (3 bits)  — Shift amount (0-7)
[Bit 50]      ZERO_BLOCK   (1 bit)   — Zero-block enable
[Bits 49:0]   RESERVED     (50 bits) — Reserved for future expansion
```

### Execution Units

- `3'b000` — UNIT_NONE (Idle/NOP)
- `3'b001` — UNIT_VECTOR_ALU (Vector operations)
- `3'b010` — UNIT_TENSOR_CORE (Matrix multiplication)

### Vector ALU Opcodes

- `4'b0001` — VOP_ADD_SUB (Addition/Subtraction)
- `4'b0010` — VOP_BITWISE (Bitwise logic)
- `4'b0011` — VOP_SHIFT (Data shifting)
- `4'b0100` — VOP_HADAMARD (Hadamard product)
- `4'b0101` — VOP_DOT (Dot product)

### Example Instructions

**Vector Addition:**
```
Instruction: 64'h2200_0000_0000_0000
Binary: 001 0001 000 000 0 [50 zeros]
Meaning: UNIT_VECTOR_ALU + VOP_ADD_SUB + OP_ADD
```

**Matrix Multiplication with Zero-Blocking:**
```
Instruction: 64'h4004_0000_0000_0000
Binary: 010 0000 000 000 1 [50 zeros]
Meaning: UNIT_TENSOR_CORE + TOP_MATMUL + ZERO_BLOCK_ENABLED
```

For complete ISA specification, see `docs/Custom_parallel_accelerator_Manual.txt`.

---

## Design Characteristics

- **Data Width:** 8-bit per element (customizable via `parameters.vh`)
- **Vector Size:** 8 elements per vector (64-bit total, customizable)
- **Matrix Operations:** 4×4 matrices (decomposed into 2×2 tiles)
- **Pipeline Depth:** 2 stages (tensor cores)
- **Parallel Lanes:** 8 vector ALU lanes + 8 parallel tensor multipliers

---

## Performance Notes

- **Tensor Core Latency:** 2 clock cycles per 4×4 matrix multiplication
- **Vector Operations:** 1 clock cycle (combinational)
- **Zero-Block Skip:** Saves ~50% energy on sparse matrices (conditional)

---

## Future Enhancements

- Multi-core orchestration & synchronization primitives
- Shared memory hierarchy
- Global memory interface
- Kernel scheduler
- Higher-order tensor support (8×8, 16×16)

---

## License

MIT License — See `LICENSE` file for details.

---

## Author Notes

This project was developed as a **proof-of-concept** to demonstrate fundamental GPU architecture concepts during computer science studies. It showcases:
- Modern parallel accelerator design patterns
- Custom ISA development
- RTL hardware description in Verilog
- Pipeline optimization techniques

**Next Steps:** Integrate with RISC-V CPU architecture as a specialized accelerator unit, or expand into a multi-core GPU design.
