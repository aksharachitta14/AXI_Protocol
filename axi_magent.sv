class axi_magent extends uvm_agent;
	axi_driver 		drv_h;
	axi_sequencer 	sqr_h;
	axi_monitor 	mon_h;
	axi_coverage 	cov_h;
	`uvm_component_utils(axi_magent)
	`NEW_COMP
	function void build();
		drv_h=axi_driver::type_id::create("drv_h",this);
		sqr_h=axi_sequencer::type_id::create("sqr_h",this);
		mon_h=axi_monitor::type_id::create("mon_h",this);
		cov_h=axi_coverage::type_id::create("cov_h",this);
	endfunction
	function void connect();
		drv_h.seq_item_port.connect(sqr_h.seq_item_export);
		mon_h.ap_port.connect(cov_h.analysis_export);
	endfunction
endclass
