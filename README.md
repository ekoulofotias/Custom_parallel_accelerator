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
- Full & half adder modules
- N-bit adder/subtractor
- Dot product module

---

## Repository Structure

```
Custom_parallel_accelerator
├── README.md                              # This file
├── LICENSE                                # MIT License
├── .gitignore                             # Git ignore rules
│
├── parameters.vh                          # Global parameters & ISA definitions
├── top_accelerator.v                      # Top-level module integration
│
├── tensor_grid_4x4.v                      # 4×4 Tensor Core grid
├── tensor_core_2x2.v                      # Basic 2×2 Tensor Core building block
│
├── vector_alu.v                           # Vector ALU dispatcher
├── vector_add_sub.v                       # Vector addition/subtraction
├── vector_bitwise.v                       # Vector bitwise operations
├── vector_hadamard.v                      # Hadamard product
├── shifting.v                             # Barrel shifter
│ 
├── dot_product.v                          # Dot product unit
├── add_sub_n_bit.v                        # N-bit adder/subtractor
├── full_add.v                             # Full adder primitive
├── half_add.v                             # Half adder primitive
├── zero_block_detector.v                  # Zero-block detection logic
│                                
├── tb.v                                   # Comprehensive testbench
│
├── Custom_parallel_accelerator_Manual.txt # ISA manual & architecture guide
│
├── yosys_tests.ys                         # Yosys synthesis script
└── generate_schematics.ys                 # Schematic generation script
```

---

## How to Simulate

### Requirements
- Verilog simulator (Icarus Verilog, ModelSim, VCS, or similar)
- (Optional) Yosys for synthesis

### Running the Testbench

```bash
# Using Icarus Verilog:

        iverilog -o tb *.v

# Run simulation

        vvp tb
```

The testbench demonstrates:
- Vector addition
- Dot product computation
- 4×4 matrix multiplication with tensor cores

---

## License

MIT License — See `LICENSE` file for details.
