class axi_env extends uvm_env;
	axi_magent magt_h;
	axi_sagent sagt_h;
	axi_scoreboard sbd_h;
	`uvm_component_utils(axi_env)
	`NEW_COMP
	function void build();
		magt_h=axi_magent::type_id::create("magt_h",this);
		sagt_h=axi_sagent::type_id::create("sagt_h",this);
		sbd_h=axi_scoreboard::type_id::create("sbd_h",this);
	endfunction

	function void connect();
		magt_h.mon_h.ap_port.connect(sbd_h.imp_mst);
		sagt_h.mon_h.ap_port.connect(sbd_h.imp_slv);
	endfunction
	
endclass
