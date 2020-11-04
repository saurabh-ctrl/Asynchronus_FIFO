// 5. w_full module:
// Purpose: It generate the fifo_full condition logic.
//			Generate the waddr signal which is then send to the fifo_mem.
module w_full( waddr,wptr,wfull,wq2_rptr,wen,wclk,wrstn);

	// Parameter Define:
	parameter ADDR_WIDTH = 3;
	
	// Port Define:
	input		[ADDR_WIDTH : 0]	wq2_rptr;
	input 							wclk,wen,wrstn;
	output reg 	[ADDR_WIDTH : 0]	wptr;
	output reg						wfull;
	output 		[ADDR_WIDTH-1 : 0]	waddr;
	
	// Internal Variable:
	reg 		[ADDR_WIDTH : 0]	wbin;
	wire 		[ADDR_WIDTH : 0] 	wbinnext;
	wire 							wfull_val;
	
	//------------------------------------------
	// BINARY CODE for ADDRESS
	//------------------------------------------
	always@(posedge wclk or negedge wrstn)
	begin
		if(!wrstn)
		begin
			wbin	<= 0;
			wptr	<= 0;
		end
		else
		begin
			wbin	<= wbinnext;
			wptr	<= wbinnext;
		end
	end
	
	// Assignment Statement.
	assign wbinnext 	= wbin + (wen && ~wfull);
	
	assign waddr		= wbin[ADDR_WIDTH-1 : 0];
	
	//----------------------------------------------------------------------------------------------------------------------
	// FIFO is full when => (MSB of wptr = ~(MSB of synchronized rptr)) && (remaining wptr = remaining synchronized rptr)
	//----------------------------------------------------------------------------------------------------------------------
	
	assign wfull_val	= (wptr == {~wq2_rptr[ADDR_WIDTH],wq2_rptr[ADDR_WIDTH-1 : 0]});
	
	always@(posedge wclk or negedge wrstn)
	begin
		if(!wrstn)
		begin
			wfull	<= 1'b0;
		end
		else
		begin
			wfull	<= wfull_val;
		end
	end
endmodule
