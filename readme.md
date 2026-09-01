# Custom Hardware Parallel Accelerator Architecture with Tensor Cores

**Author:** Stathis Koulofotias
**Date:** July - September 2026
**License:** MIT

---

## Overview

<img src="top_accelerator_sch.png" alt="Top Accelerator" align="right" width="45%" style="margin-left: 20px;"/>

A custom hardware parallel accelerator architecture written in **Verilog**, designed from scratch with a focus on demonstrating modern GPU core concepts. This project features:

- **4×4 Tensor Core Grid** — Hardware-accelerated matrix multiplication with MAC support ($A \times B + C$) via block matrix multiplication algorithm
- **Vector ALU** — Parallel vector operations (addition, bitwise logic, shifts, Hadamard product, dot product)
- **Zero-Block Detection** — Power optimization mechanism for sparse computations
- **Custom 16-bit ISA** — Highly optimized, dense instruction set architecture with field-level control
- **Full RTL Design** — Comprehensive testbenches, synthesis scripts, and documentation

This is an **educational proof-of-concept** demonstrating the fundamental principles of modern parallel accelerator architecture (similar to NVIDIA/AMD design).
<br clear="right"/>

---

## Key Features & Architecture

The system is based on a **top-down modular architecture**, combining specialized units:

### Tensor Cores
<img src="tensor_grid_4x4_sch.png" alt="Tensor Grid" align="left" width="40%" style="margin-right: 20px;"/>

`tensor_grid_4x4.v` & `tensor_core_2x2.v`

- Structured grid of four 2×2 tensor cores
- Hardware-accelerated 4×4 matrix multiply-accumulate operations (MAC)
- Block matrix multiplication algorithm with 2-stage pipelined execution
- Programmable zero-block skipping for power efficiency
<br clear="left"/>

### Vector ALU
`vector_alu.v`
- Parallel vector operations on 64-bit vectors (8 × 8-bit elements)
- **Operations:** Addition (Subtraction is software-driven via Two's Complement), Bitwise (AND, OR, XOR, NOT, NAND, NOR, XNOR), Shifting, Hadamard product, Dot product
- Hardware-optimized inference mapping
<p align="center">
  <img src="vector_alu_sch.png" alt="Vector ALU Schematic" width="85%"/>
</p>

### Zero Block Detector
`zero_block_detector.v`
- Detects all-zero blocks in input matrices
- Enables pipeline bypass for energy efficiency
- Critical for sparse matrix acceleration

### Arithmetic Foundation
- Native Two's Complement signed arithmetic
- RTL-inferred adders and multipliers optimized for standard DSP / LUT mapping

---

## Repository Structure

```text
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
├── vector_add_sub.v                       # Vector addition
├── vector_bitwise.v                       # Vector bitwise operations
├── vector_hadamard.v                      # Hadamard product
├── shifting.v                             # Barrel shifter
│
├── dot_product.v                          # Dot product unit
├── zero_block_detector.v                  # Zero-block detection logic
│
├── tb.v                                   # Comprehensive testbench
│
├── Custom_parallel_accelerator_Manual.txt # ISA manual & architecture guide
│
├── yosys_tests.ys                         # Yosys synthesis script
├── generate_schematics.ys                 # Schematic generation script
│
└── zero_blocking_evaluation.pdf           # Performance & Power Evaluation
```

---

## Performance & Power Evaluation
For a detailed breakdown of the hardware evaluation, check out the `zero_blocking_evaluation.pdf`.
* **Core Metric:** Τracking **switching activity (toggling)** extracted from VCD simulation files as a direct indicator of **dynamic power consumption**.
* **Key Findings:** The zero-blocking optimization successfully reduces switching activity by up to 14% in sparse configurations, proving its effectiveness in lowering dynamic power dissipation.

---

## How to Simulate

### Requirements
- Icarus Verilog (or another Verilog compiler)
- (Optional) Yosys for synthesis, system statistics and schematics generation
- (Optional) GTKWave for viewing waveforms as .vcd files

### Running the Testbench

```bash
# Using Icarus Verilog:

iverilog -o tb *.v

# Run simulation

vvp tb
```
### Running the Yosys Scripts

```bash
yosys <script_name>.ys
```
### Viewing the waveforms

```bash
gtkwave tb.vcd
```

The testbench demonstrates:
- Signed vector addition & arithmetic
- Dot product computation
- Vector shift & bitwise operations
- 4×4 Signed Matrix MAC (Multiply-Accumulate) with tensor cores

**Note**

This testbench can be easily customized to support further functionalities. I highly recommend experimenting with other operations by providing the appropriate opcode (see `Custom_parallel_accelerator_Manual.txt`) and any other necesary modifications.

### Output example

```bash
VCD info: dumpfile tb.vcd opened for output.
========================================
TEST 1: Signed Vector Addition (A + B)
----------------------------------------
A[7..0] = (10, -5, 15, -10, 3, 8, -128, 1)
B[7..0] = (5, 5, -5, 10, 2, -2, 1, 2)
OUT     = (15, 0, 10, 0, 5, 6, -127, 3)
----------------------------------------
TEST 2: Signed Dot Product (A . B)
----------------------------------------
A . B = -286
----------------------------------------
TEST 3: Vector Shift Left by 2
----------------------------------------
Shifted OUT[5] = 60
----------------------------------------
TEST 4: Signed Tensor MAC Result (A x B + C = D)
----------------------------------------
     ┌   2   -1    1    0┐
  A =|  -2    3    2   -5|
     |  -4    1    1    1|
     └   0    2   -1    2┘
----------------------------------------
     ┌   1    2   -2    1┐
  B =|   3   -1    0    2|
     |   2    0    1    2|
     └   1   -4    3    1┘
----------------------------------------
     ┌ -10   10    0    3┐
  C =|   5   -2    4    1|
     | -16    2    2   -6|
     └   1    5    3    0┘
----------------------------------------
     ┌  -9   15   -3    5┐
  D =|  11   11   -5    4|
     | -14  -11   14   -5|
     └   7   -5    8    4┘
----------------------------------------
tb.v:224: $finish called at 135 (1s)
```

---

## License

MIT License — See `LICENSE` file for details.