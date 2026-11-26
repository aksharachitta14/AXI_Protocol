class axi_test extends uvm_test;
	axi_env env_h;
	`uvm_component_utils(axi_test)
	`NEW_COMP
	function void build();
		env_h=axi_env::type_id::create("env_h",this);
	endfunction
	function void end_of_elaboration();
		uvm_top.print_topology();
	endfunction

	function void report();
		if(match_count!=0 && mismatch_count==0)begin
			`uvm_info("UVM_TEST",$psprintf("test_passed matchs=%0d,mismatches=%0d",match_count,mismatch_count),UVM_MEDIUM)
		end
		else `uvm_error("UVM_TEST",$psprintf("test_failed matchs=%0d,mismatches=%0d",match_count,mismatch_count))
	endfunction

endclass

class axi_wr_rd_test extends axi_test;
	`uvm_component_utils(axi_wr_rd_test)
	`NEW_COMP
	task run_phase(uvm_phase phase);
		axi_wr_rd_seq wr_rd_seq;
		wr_rd_seq=axi_wr_rd_seq::type_id::create("wr_rd_seq");
		phase.raise_objection(this);
		phase.phase_done.set_drain_time(this,20);
		wr_rd_seq.start(env_h.magt_h.sqr_h);
		phase.drop_objection(this);
	endtask
endclass

class axi_nwr_nrd_test extends axi_test;
	`uvm_component_utils(axi_nwr_nrd_test)
	`NEW_COMP
	task run_phase(uvm_phase phase);
		axi_nwr_nrd_seq n_seq;
		n_seq=axi_nwr_nrd_seq::type_id::create("n_seq");
		phase.raise_objection(this);
		phase.phase_done.set_drain_time(this,20);
		uvm_resource_db#(int)::set("GLOBAL","TX_COUNT",`N_TX,this);
		n_seq.start(env_h.magt_h.sqr_h);
		phase.drop_objection(this);
	endtask
endclass
