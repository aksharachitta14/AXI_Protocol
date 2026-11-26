class axi_responder extends uvm_component;
	bit [7:0] mem[*];
	bit [`ADDR_WIDTH-1:0]awaddr_t;
	bit [3:0]awlen_t;
	bit [2:0]awsize_t;
	bit [3:0]awid_t;
	bit [1:0]awburst_t;
	bit [`ADDR_WIDTH-1:0]araddr_t;
	bit [3:0]arlen_t;
	bit [2:0]arsize_t;
	bit [3:0]arid_t;
	bit [1:0]arburst_t;
	virtual axi_intrf vif;
	`uvm_component_utils(axi_responder)
	`NEW_COMP
	function void build();
		uvm_resource_db#(virtual axi_intrf)::read_by_name("GLOBAL","AXI_INTRF",vif,this);
	endfunction
	task run();
		forever begin
			@(vif.resp_cb);
//write_addr
			if(vif.resp_cb.awvalid==1)begin
				vif.resp_cb.awready<=1;
				awaddr_t=vif.resp_cb.awaddr;
				awlen_t=vif.resp_cb.awlen;
				awsize_t=vif.resp_cb.awsize;
				awburst_t=vif.resp_cb.awburst;
			end
			else vif.resp_cb.awready<=0;
//read_addr
			if(vif.resp_cb.arvalid==1)begin
				vif.resp_cb.arready<=1;
				araddr_t=vif.resp_cb.araddr;
				arlen_t=vif.resp_cb.arlen;
				arsize_t=vif.resp_cb.arsize;
				arburst_t=vif.resp_cb.arburst;
				read_data(vif.arid,vif.araddr,vif.arlen);
			end
			else vif.resp_cb.arready<=0;	
//write_data
			if(vif.resp_cb.wvalid==1)begin
				vif.resp_cb.wready<=1;
				mem[awaddr_t]=vif.resp_cb.wdata[7:0];
				mem[awaddr_t+1]=vif.resp_cb.wdata[15:8];
				mem[awaddr_t+2]=vif.resp_cb.wdata[23:16];
				mem[awaddr_t+3]=vif.resp_cb.wdata[31:24];
				awaddr_t+=4;
				if(vif.resp_cb.wlast==1)begin
					fork
						write_resp(vif.resp_cb.wid);
					join_none
				end
			end
			else vif.resp_cb.wready<=0;
		end
	endtask
//write_resp
	task write_resp(bit [3:0]id);
		@(vif.resp_cb);
		vif.resp_cb.bid<=id;
		vif.resp_cb.bresp<=2'b00;
		vif.resp_cb.bvalid<=1;
		wait(vif.resp_cb.bready==1);
		@(vif.resp_cb);
		vif.resp_cb.bid<=0;
		vif.resp_cb.bresp<=0;
		vif.resp_cb.bvalid<=0;
	endtask
//read_data
	task read_data(bit[3:0]id, bit[31:0]addr, bit[3:0]burst_len);
		for(int i=0;i<=burst_len;i++)begin
			@(vif.resp_cb);
			vif.resp_cb.rdata<={mem[araddr_t+3],mem[araddr_t+2],mem[araddr_t+1],mem[araddr_t]};
			vif.resp_cb.rid<=id;
			vif.resp_cb.rresp<=2'b00;
			vif.resp_cb.rlast<=(i==burst_len)? 1:0;
			vif.resp_cb.rvalid<=1;
			wait(vif.resp_cb.rready==1);
			araddr_t+=4;
		end
		@(vif.resp_cb);
		vif.resp_cb.rdata<=0;
		vif.resp_cb.rid<=0;
		vif.resp_cb.rresp<=0;
		vif.resp_cb.rlast<= 0;
		vif.resp_cb.rvalid<=0;
	endtask
endclass


//No clocking block code 
/*

task run();
		forever begin
			@(posedge vif.aclk);
//write_addr
			if(vif.awvalid==1)begin
				vif.awready<=1;
				awaddr_t=vif.awaddr;
				awlen_t=vif.awlen;
				awsize_t=vif.awsize;
				awburst_t=vif.awburst;
			end
			else vif.awready<=0;
//read_addr
			if(vif.arvalid==1)begin
				vif.arready<=1;
				araddr_t=vif.araddr;
				arlen_t=vif.arlen;
				arsize_t=vif.arsize;
				arburst_t=vif.arburst;
				read_data(vif.arid,vif.araddr,vif.arlen);
			end
			else vif.arready<=0;	
//write_data
			if(vif.wvalid==1)begin
				vif.wready<=1;
				mem[awaddr_t]=vif.wdata[7:0];
				mem[awaddr_t+1]=vif.wdata[15:8];
				mem[awaddr_t+2]=vif.wdata[23:16];
				mem[awaddr_t+3]=vif.wdata[31:24];
				awaddr_t+=4;
				if(vif.wlast==1)begin
					fork
						write_resp(vif.wid);
					join_none
				end
			end
			else vif.wready<=0;
		end
	endtask
//write_resp
	task write_resp(bit [3:0]id);
		@(posedge vif.aclk);
		vif.bid<=id;
		vif.bresp<=2'b00;
		vif.bvalid<=1;
		wait(vif.bready==1);
		@(posedge vif.aclk);
		vif.bid<=0;
		vif.bresp<=0;
		vif.bvalid<=0;
	endtask
//read_data
	task read_data(bit[3:0]id, bit[31:0]addr, bit[3:0]burst_len);
		for(int i=0;i<=burst_len;i++)begin
			@(posedge vif.aclk);
			vif.rdata<={mem[araddr_t+3],mem[araddr_t+2],mem[araddr_t+1],mem[araddr_t]};
			vif.rid<=id;
			vif.rresp<=2'b00;
			vif.rlast<=(i==burst_len)? 1:0;
			vif.rvalid<=1;
			wait(vif.rready==1);
			araddr_t+=4;
		end
		@(posedge vif.aclk);
		vif.rdata<=0;
		vif.rid<=0;
		vif.rresp<=0;
		vif.rlast<= 0;
		vif.rvalid<=0;
	endtask
*/
