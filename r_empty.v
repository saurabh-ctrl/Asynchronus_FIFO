// 4.r_empty module
// Purpose: It generate the fifo_empty condition logic.
//			Generate the read address which is then passed to the fifo_mem.
module r_empty( raddr,rempty,rptr,rq2_wptr,ren,rclk,rrstn);
	
	// Parameter Define:
	parameter ADDR_WIDTH = 3;
	
	// Port Define:
	input		[ADDR_WIDTH : 0]	rq2_wptr;
	input 							ren,rclk,rrstn;
	output reg	[ADDR_WIDTH : 0]	rptr;
	output		[ADDR_WIDTH-1 : 0]	raddr;
	output reg						rempty;
	
	// Internal variable:
	reg 	[ADDR_WIDTH : 0]	rbin;
	wire	[ADDR_WIDTH : 0]	rbinnext;
	wire 						rempty_val;
	////////////////////////////
	// BINARY CODE for ADDRESS
	///////////////////////////
	
	always@(posedge rclk or negedge rrstn)
	begin
		if(!rrstn)
		begin
			rbin	<= 0;
			rptr	<= 0;
		end
		else
		begin
			rbin	<= rbinnext;
			rptr	<= rbinnext;
		end
	end
	
	//Assignement Statement:
	assign rbinnext = rbin + (ren && ~rempty);
	assign raddr	= rbin [ADDR_WIDTH-1 : 0];
	
	//---------------------------------------------------------------
	// FIFO is empty => rptr = synchronized wptr:
	//---------------------------------------------------------------
	
	assign rempty_val	= (rptr == rq2_wptr);
	
	// Purpose: For rempty output signal
	always@(posedge rclk or negedge rrstn)
	begin
		if(!rrstn)
		begin
			rempty 	<= 1'b1;
		end
		else
		begin
			rempty 	<= rempty_val; 
		end
	end
endmodule
