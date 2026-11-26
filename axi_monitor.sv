/*
class axi_monitor extends uvm_monitor;
	axi_tx tx;
	uvm_analysis_port#(axi_tx)ap_port;
	virtual axi_intrf vif;
	`uvm_component_utils(axi_monitor)
	`NEW_COMP
	function void build();
		ap_port=new("ap_port",this);
		uvm_resource_db#(virtual axi_intrf)::read_by_name("GLOBAL","AXI_INTRF",vif,this);
	endfunction

//NO CLOCKING BLOCKS

	task run();
		forever begin
			tx=new("tx");
			//tx.wr_rd=vif.wr_rd;
			@(posedge vif.aclk);
//write_addr
			if(vif.awvalid && vif.awready)begin
				tx.wr_rd=1;
				tx.tx_id=vif.awid;
				tx.addr=vif.awaddr;
				tx.burst_len=vif.awlen;
				tx.burst_size=vif.awsize;
				tx.burst_type=vif.awburst;
			end
//write_data
			if(vif.wvalid && vif.wready)begin
				tx.dataQ.push_back(vif.wdata);
				tx.strbQ.push_back(vif.wstrb);
			end
//write_resp
			if(vif.bvalid && vif.bready)begin
				tx.respQ.push_back(vif.bresp);
				tx.print();
				ap_port.write(tx);
			end
//read_addr
			if(vif.arvalid && vif.arready)begin 
				tx.wr_rd=0;
				tx.tx_id=vif.arid;
				tx.addr=vif.araddr;
				tx.burst_len=vif.arlen;
				tx.burst_size=vif.arsize;
				tx.burst_type=vif.arburst;
			end
//read_data
			if(vif.rvalid && vif.rready)begin 
				tx.dataQ.push_back(vif.rdata);
				tx.respQ.push_back(vif.rresp);
				if(vif.rlast==1)begin
					tx.print();
					ap_port.write(tx);
				end
			end
		end
	endtask
endclass

*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class axi_monitor extends uvm_monitor;
	axi_tx tx;
	uvm_analysis_port#(axi_tx)ap_port;
	virtual axi_intrf vif;
	`uvm_component_utils(axi_monitor)
	`NEW_COMP
	function void build();
		ap_port=new("ap_port",this);
		uvm_resource_db#(virtual axi_intrf)::read_by_name("GLOBAL","AXI_INTRF",vif,this);
	endfunction

//WITH CLOCKING BLOCK

	task run();
		forever begin
			@(vif.mon_cb);
//write_addr
			if(vif.mon_cb.awvalid && vif.mon_cb.awready)begin
				tx=new("tx");
				tx.wr_rd=1;
				tx.tx_id=vif.mon_cb.awid;
				tx.addr=vif.mon_cb.awaddr;
				tx.burst_len=vif.mon_cb.awlen;
				tx.burst_size=vif.mon_cb.awsize;
				tx.burst_type=vif.mon_cb.awburst;
			end
//write_data
			if(vif.mon_cb.wvalid && vif.mon_cb.wready)begin
				if(tx.wr_rd==1)begin
					tx.dataQ.push_back(vif.mon_cb.wdata);
					tx.strbQ.push_back(vif.mon_cb.wstrb);
				end
			end
//write_resp
			if(vif.mon_cb.bvalid && vif.mon_cb.bready)begin
				if(tx.wr_rd==1)begin
					tx.respQ.push_back(vif.mon_cb.bresp);
//					$display("%0t:",$time);
//					tx.print();
					ap_port.write(tx);
				end
			end
//read_addr
			if(vif.mon_cb.arvalid && vif.mon_cb.arready)begin 
				tx=new("tx");
				tx.wr_rd=0;
				tx.tx_id=vif.mon_cb.arid;
				tx.addr=vif.mon_cb.araddr;
				tx.burst_len=vif.mon_cb.arlen;
				tx.burst_size=vif.mon_cb.arsize;
				tx.burst_type=vif.mon_cb.arburst;
			end
//read_data
			if(vif.mon_cb.rvalid && vif.mon_cb.rready)begin 
				if(tx.wr_rd==0)begin
					tx.dataQ.push_back(vif.mon_cb.rdata);
					tx.respQ.push_back(vif.mon_cb.rresp);
					if(vif.mon_cb.rlast==1)begin
//						$display("%0t:",$time);
//						tx.print();
						ap_port.write(tx);
					end
				end
			end
		end
	endtask
endclass

