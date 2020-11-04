// 3. fifo_mem module: This module describe the Dual Port RAM module:
module fifo_mem( rdata,wdata,waddr,raddr,wfull,wen,wclk);
	
	// Parameter Define:
	parameter	DATA_WIDTH = 8;
	parameter	ADDR_WIDTH = 3;
	localparam	DEPTH = (1<<(ADDR_WIDTH));
	
	// Port Define:
	input	[DATA_WIDTH-1 : 0]	wdata;
	input	[ADDR_WIDTH-1 : 0]	waddr,raddr;
	input				wen,wclk,wfull;
	output	[DATA_WIDTH-1 : 0]	rdata;
	
	// Internal Variable:
	reg	[DATA_WIDTH-1 : 0] mem [0 : DEPTH-1];
	
	// Code:
	always@(posedge wclk)
	begin
		if(wen && !wfull)
		begin
			mem[waddr]	<= wdata;
		end
	end
	
	// Assign Statement:
	assign rdata = mem[raddr];
endmodule
