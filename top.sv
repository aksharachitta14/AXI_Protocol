module top;
	reg clk,rst;
	axi_intrf pif(clk,rst);
	initial uvm_resource_db#(virtual axi_intrf)::set("GLOBAL","AXI_INTRF",pif,null);
	always #5 clk=!clk;
	initial begin
		clk=0;
		rst=1;
		repeat(2)@(posedge clk);
		rst=0;
	end
	initial begin
		run_test("");
	end
endmodule
