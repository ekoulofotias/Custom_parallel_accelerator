IVERILOG = iverilog
IVERILOG_VPI = iverilog-vpi
VVP = vvp

RTL_CODE = top_accelerator.v \
			vector_alu.v \
			vector_add_sub.v \
			vector_bitwise.v \
			vector_hadamard.v \
			shifting.v \
			tensor_grid_4x4.v \
			tensor_core_2x2.v \
			dot_product.v \
			zero_block_detector.v

# VPI Tracking Module
VPI_SRC = activity.c
VPI_MODULE = activity.vpi

# Testbench 1: Demo / General Tasks
TB_DEMO_SRC = tb.v
TB_DEMO_OUT = tb_demo.out

# Testbench 2: Zero Blocking Evaluation
TB_EVAL_SRC = zero_block_eval_tb.v
TB_EVAL_OUT = tb_eval.out

$(VPI_MODULE): $(VPI_SRC)
	$(IVERILOG_VPI) $(VPI_SRC)

$(TB_DEMO_OUT): $(TB_DEMO_SRC) $(RTL_CODE)
	$(IVERILOG) -o $(TB_DEMO_OUT) $(TB_DEMO_SRC) $(RTL_CODE)

$(TB_EVAL_OUT): $(TB_EVAL_SRC) $(RTL_CODE)
	$(IVERILOG) -o $(TB_EVAL_OUT) $(TB_EVAL_SRC) $(RTL_CODE)

demo: $(TB_DEMO_OUT)
	$(VVP) $(TB_DEMO_OUT)

eval: $(VPI_MODULE) $(TB_EVAL_OUT)
	$(VVP) -M. -mactivity $(TB_EVAL_OUT)

clean:
	rm -f *.o *.vpi $(TB_DEMO_OUT) $(TB_EVAL_OUT) *.vcd tb

.PHONY: demo eval clean