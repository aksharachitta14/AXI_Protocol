`define NEW_COMP \
		function new(string name="",uvm_component parent=null);	\
			super.new(name,parent);	\
		endfunction

`define NEW_OBJ \
		function new(string name="");	\
			super.new(name);	\
		endfunction

`define ADDR_WIDTH 32
`define DATA_WIDTH 32
`define STRB_WIDTH `DATA_WIDTH/8
int match_count;
int mismatch_count;
`define N_TX 2 
