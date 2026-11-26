class axi_tx extends uvm_sequence_item;
	rand bit wr_rd;
	rand bit [3:0]	tx_id;
	rand bit [31:0]	addr;
	rand bit [3:0]	burst_len;
	rand bit [2:0]	burst_size;
	rand bit [1:0]	burst_type;
	rand bit [31:0]	dataQ[$];
	rand bit [3:0]	strbQ[$];
	rand bit [31:0]	respQ[$];

	`uvm_object_utils_begin(axi_tx)
		`uvm_field_int	(wr_rd,UVM_ALL_ON)
		`uvm_field_int	(tx_id,UVM_ALL_ON)
		`uvm_field_int	(addr,UVM_ALL_ON)
		`uvm_field_int	(burst_len,UVM_ALL_ON)
		`uvm_field_int	(burst_size,UVM_ALL_ON)
		`uvm_field_int	(burst_type,UVM_ALL_ON)
		`uvm_field_queue_int	(dataQ,UVM_ALL_ON)
		`uvm_field_queue_int	(respQ,UVM_ALL_ON)
	`uvm_object_utils_end
	`NEW_OBJ
	constraint cc{
		burst_type!=2'b11;
		soft burst_size==2;
		soft burst_type==2'b01;
		(wr_rd==1) -> (dataQ.size()==burst_len+1);
		(wr_rd==0) -> (dataQ.size()==0);
	}
endclass
