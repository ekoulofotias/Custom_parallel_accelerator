Custom Hardware Parallel Accelerator Architecture with Tensor Cores

Author: Stathis Koulofotias

Date: July - August 2026

--------------------------------------------------------------------------------------------------------------------------------
A custom hardware parallel accelerator architecture written in VERILOG, designed from scratch with a focus on HARDWARE PARALLELISM, VECTOR OPERATIONS,
and ACCELERATED MATRIX MULTIPLICATION via TENSOR CORES. The project encompasses full RTL design, testbench examples, synthesis
reports using YOSYS, automated generation of schematics as well as a full instruction manual featuring a custom instruction
set architecture.

--------------------------------------------------------------------------------------------------------------------------------
Key Features & Architecture

The system is based on a top-down architecture, combining specialized units:

 -> Tensor Cores (tensor_grid_4x4 & tensor_core_2x2 modules)
    A structured grid of four tensor cores designed to perform hardware-accelerated 4x4 matrix multiplications in minimal clock
    cycles, utilizing the block matrix multiplication algorithm. 

-> Vector ALU (vector_alu)
    Supports addition/subtraction operations, bitwise operations, bit shifting, dot products and vector hadamard products.

-> Zero Block Detector
    Optimization mechanism for detecting and bypassing zero blocks, saving energy and resources.

-> Arithmetic & Logic Foundation:
    Full and half adder, n-bit adder/subtractor and dot-product unit.

--------------------------------------------------------------------------------------------------------------------------------
Repository Structure:

```text
├── parameters.vh                       # Global parameters and configuration
├── top_accelerator.v                   # Top-level accelerator module integration
├── tensor_grid_4x4.v                   # 4x4 Tensor Core grid (Matrix Multiplication)
├── tensor_core_2x2.v                   # Basic 2x2 Tensor Core building block
├── vector_alu.v                        # Vector Arithmetic Logic Unit
├── vector_add_sub.v                    # Vector addition/subtraction unit
├── vector_bitwise.v                    # Vector bitwise operations
├── vector_hadamard.v                   # Vector Hadamard product unit
├── dot_product.v                       # Dot product calculation unit
├── add_sub_n_bit.v                     # N-bit Adder/Subtractor
├── full_add.v                          # Full adder arithmetic module
├── half_add.v                          # Half adder arithmetic module
├── shifting.v                          # Shifting logic
├── zero_block_detector.v               # Zero-block detection logic
├── tb.v                                # Comprehensive testbench
├── Custom_parallel_accelerator_Manual.txt # Hardware architectural manual
└── ACCELERATOR_HARDWARE_OVERVIEW.txt   # Technical overview and specs

## How to Simulate

```bash
iverilog -o tb *.v
vvp tb
