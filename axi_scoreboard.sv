`uvm_analysis_imp_decl(_mst)
`uvm_analysis_imp_decl(_slv)
class axi_scoreboard extends uvm_scoreboard;
	axi_tx mst_txQ[$];
	axi_tx slv_txQ[$];
	axi_tx exp_mst_tx,exp_slv_tx;
	uvm_analysis_imp_mst#(axi_tx,axi_scoreboard)imp_mst;
	uvm_analysis_imp_slv#(axi_tx,axi_scoreboard)imp_slv;
	`uvm_component_utils(axi_scoreboard)
	`NEW_COMP
	function void build();
		imp_mst=new("imp_mst",this);
		imp_slv=new("imp_slv",this);
	endfunction
	
	function void write_mst(axi_tx t);
//		$display("%0t:",$time);
//		t.print();
		mst_txQ.push_back(t);
	endfunction
	
	function void write_slv(axi_tx t);
//		$display("%0t:",$time);
//		t.print();
		slv_txQ.push_back(t);
	endfunction
	
	task run();
		forever begin
			wait(mst_txQ.size() > 0 && slv_txQ.size() > 0 );
			exp_mst_tx=mst_txQ.pop_front();
			exp_slv_tx=slv_txQ.pop_front();
			if(exp_mst_tx.compare(exp_slv_tx))match_count++;
			else mismatch_count++;
		end
	endtask
endclass
