interface axi_intrf (input aclk,arstn);
	bit wr_rd;
//write channel signals
	bit [3:0]awid;
	bit [`ADDR_WIDTH-1:0]awaddr;
	bit [3:0]awlen;
	bit [2:0]awsize;
	bit [1:0]awburst;
	bit	[1:0]awlock;
	bit	[3:0]awcache;
	bit	[2:0]awprot;
	bit awvalid;
	bit awready;
	bit [3:0]wid;
	bit [`DATA_WIDTH-1:0]wdata;
	bit [`STRB_WIDTH-1:0]wstrb;
	bit wlast;
	bit wvalid;
	bit wready;
	bit [3:0]bid;
	bit [1:0]bresp;
	bit bvalid;
	bit bready;
//read channel signnals
	bit [3:0]arid;
	bit [`ADDR_WIDTH-1:0]araddr;
	bit [3:0]arlen;
	bit [2:0]arsize;
	bit [1:0]arburst;
	bit	[1:0]arlock;
	bit	[3:0]arcache;
	bit	[2:0]arprot;
	bit arvalid;
	bit arready;
	bit [3:0]rid;
	bit [`DATA_WIDTH-1:0]rdata;
	bit [1:0]rresp;
	bit rlast;
	bit rvalid;
	bit rready;

	clocking drv_cb@(posedge aclk);
		default input #0 output #0;
		output wr_rd;
		//write tx signals
		output awid,awaddr,awlen,awsize,awburst,awvalid;
		input awready;
		output wid,wdata,wstrb,wlast,wvalid;
		input wready;
		output bready;
		input bid,bresp,bvalid;
		//read tx signals
		output arid,araddr,arlen,arsize,arburst,arvalid;
		input arready;
		output rready;
		input rid,rdata,rresp,rlast,rvalid;
	endclocking

	clocking mon_cb@(posedge aclk);
		default input #1;
		input wr_rd;
		//write tx signals
		input awid,awaddr,awlen,awsize,awburst,awvalid;
		input awready;
		input wid,wdata,wstrb,wlast,wvalid;
		input wready;
		input bready;
		input bid,bresp,bvalid;
	//read tx signals
		input arid,araddr,arlen,arsize,arburst,arvalid;
		input arready;
		input rready;
		input rid,rdata,rresp,rlast,rvalid;
	endclocking

	clocking resp_cb@(posedge aclk);
		default input #0 output #1;
		//write tx signals
		input awid,awaddr,awlen,awsize,awburst,awvalid;
		output awready;
		input wid,wdata,wstrb,wlast,wvalid;
		output wready;
		input bready;
		output bid,bresp,bvalid;
	//read tx signals
		input arid,araddr,arlen,arsize,arburst,arvalid;
		output arready;
		input rready;
		output rid,rdata,rresp,rlast,rvalid;
	endclocking
endinterface
