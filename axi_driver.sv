
class axi_driver extends uvm_driver#(axi_tx);
	virtual axi_intrf vif;
	`uvm_component_utils(axi_driver)
	`NEW_COMP
	function void build();
		uvm_resource_db#(virtual axi_intrf)::read_by_name("GLOBAL","AXI_INTRF",vif,this);
	endfunction
	task run();
		forever begin
			seq_item_port.get_next_item(req);
			drive_tx(req);
			$display("----------------------->%0t:",$time);
			req.print();
			seq_item_port.item_done();
		end
	endtask

	task drive_tx(axi_tx tx);
		wait(vif.arstn==0);
		vif.wr_rd=tx.wr_rd;
		if(vif.wr_rd==1)begin
			write_addr(tx);
			write_data(tx);
			write_resp(tx);
		end
		else begin
			read_addr(tx);
			read_data(tx);
		end
	endtask

//NO CLOCKING BLOCKS

	task write_addr(axi_tx tx);
			@(posedge vif.aclk);
			vif.awid =tx.tx_id;
			vif.awaddr =tx.addr;
			vif.awlen =tx.burst_len;
			vif.awsize =tx.burst_size;
			vif.awburst =tx.burst_type;
			vif.awvalid = 1;
			wait(vif.awready==1);
			@(posedge vif.aclk);
			vif.awvalid=0;
			vif.awid =0;
			vif.awaddr =0;
			vif.awlen =0;
			vif.awsize =0;
			vif.awburst =0;
	endtask
	task write_data(axi_tx tx);
		for(int i=0;i<=tx.burst_len;i++)begin
			@(posedge vif.aclk);
			vif.wdata=tx.dataQ.pop_front();
			vif.wstrb=4'b1111;
			vif.wid=tx.tx_id;
			vif.wlast=(i==tx.burst_len)? 1:0;
			vif.wvalid=1;
			wait(vif.wready==1);
		end
		@(posedge vif.aclk);
			vif.wvalid=0;
			vif.wid =0;
			vif.wdata =0;
			vif.wstrb =0;
			vif.wlast =0;
	endtask
	task write_resp(axi_tx tx);
		bit bvalid_f;
		while(bvalid_f==0)begin
			@(posedge vif.aclk);
			bvalid_f=vif.bvalid;
		end
		vif.bready=1;
		@(posedge vif.aclk);
		vif.bready=0;
	endtask
	task read_addr(axi_tx tx);
		@(posedge vif.aclk);
		vif.arid =tx.tx_id;
		vif.araddr =tx.addr;
		vif.arlen =tx.burst_len;
		vif.arsize =tx.burst_size;
		vif.arburst =tx.burst_type;
		vif.arvalid = 1;
		wait(vif.arready==1);
		@(posedge vif.aclk);
		vif.arvalid=0;
		vif.arid =0;
		vif.araddr =0;
		vif.arlen =0;
		vif.arsize =0;
		vif.arburst =0;
	endtask
	task read_data(axi_tx tx);
		bit rvalid_f;
		for(int i=0;i<=tx.burst_len;i++)begin
			while(rvalid_f==0)begin
				@(posedge vif.aclk);
				rvalid_f=vif.rvalid;
			end
			vif.rready=1;
			@(posedge vif.aclk);
			vif.rready=0;
		end
	endtask
endclass

/////////////////////////////////////////////////////////////////////////////////////
/*
class axi_driver extends uvm_driver#(axi_tx);
	virtual axi_intrf vif;
	`uvm_component_utils(axi_driver)
	`NEW_COMP
	function void build();
		uvm_resource_db#(virtual axi_intrf)::read_by_name("GLOBAL","AXI_INTRF",vif,this);
	endfunction
	task run();
		forever begin
			seq_item_port.get_next_item(req);
			drive_tx(req);
			$display("----------------------->%0t:",$time);
			req.print();
			seq_item_port.item_done();
		end
	endtask

	task drive_tx(axi_tx tx);
		wait(vif.arstn==0);
		vif.wr_rd=tx.wr_rd;
		if(vif.wr_rd==1)begin
			write_addr(tx);
			write_data(tx);
			write_resp(tx);
		end
		else begin
			read_addr(tx);
			read_data(tx);
		end
	endtask

//WITH CLOCKING BLOCKS

	task write_addr(axi_tx tx);
			@(vif.drv_cb);
			vif.drv_cb.awid <=tx.tx_id;
			vif.drv_cb.awaddr <=tx.addr;
			vif.drv_cb.awlen <=tx.burst_len;
			vif.drv_cb.awsize <=tx.burst_size;
			vif.drv_cb.awburst <=tx.burst_type;
			vif.drv_cb.awvalid <= 1;
			wait(vif.drv_cb.awready==1);
			@(vif.drv_cb);
			vif.drv_cb.awvalid<=0;
			vif.drv_cb.awid <=0;
			vif.drv_cb.awaddr <=0;
			vif.drv_cb.awlen <=0;
			vif.drv_cb.awsize <=0;
			vif.drv_cb.awburst <=0;
	endtask
	task write_data(axi_tx tx);
		for(int i=0;i<=tx.burst_len;i++)begin
			@(vif.drv_cb);
			vif.drv_cb.wdata<=tx.dataQ.pop_front();
			vif.drv_cb.wstrb<=4'b1111;
			vif.drv_cb.wid<=tx.tx_id;
			vif.drv_cb.wlast<=(i==tx.burst_len)? 1:0;
			vif.drv_cb.wvalid<=1;
			wait(vif.drv_cb.wready==1);
		end
		@(vif.drv_cb);
			vif.drv_cb.wvalid<=0;
			vif.drv_cb.wid <=0;
			vif.drv_cb.wdata <=0;
			vif.drv_cb.wstrb <=0;
			vif.drv_cb.wlast <=0;
	endtask
	task write_resp(axi_tx tx);
		bit bvalid_f;
		while(bvalid_f==0)begin
			@(vif.drv_cb);
			bvalid_f=vif.drv_cb.bvalid;
		end
		vif.drv_cb.bready<=1;
		@(vif.drv_cb);
		vif.drv_cb.bready<=0;
	endtask
	task read_addr(axi_tx tx);
		@(vif.drv_cb);
		vif.drv_cb.arid <=tx.tx_id;
		vif.drv_cb.araddr <=tx.addr;
		vif.drv_cb.arlen <=tx.burst_len;
		vif.drv_cb.arsize <=tx.burst_size;
		vif.drv_cb.arburst <=tx.burst_type;
		vif.drv_cb.arvalid <= 1;
		wait(vif.drv_cb.arready==1);
		@(vif.drv_cb);
		vif.drv_cb.arvalid<=0;
		vif.drv_cb.arid <=0;
		vif.drv_cb.araddr <=0;
		vif.drv_cb.arlen <=0;
		vif.drv_cb.arsize <=0;
		vif.drv_cb.arburst <=0;
	endtask
	task read_data(axi_tx tx);
		bit rvalid_f;
		for(int i=0;i<=tx.burst_len;i++)begin
			while(rvalid_f==0)begin
				@(vif.drv_cb);
				rvalid_f=vif.drv_cb.rvalid;
			end
			vif.drv_cb.rready<=1;
			@(vif.drv_cb);
			vif.drv_cb.rready<=0;
		end
	endtask
endclass
*/
