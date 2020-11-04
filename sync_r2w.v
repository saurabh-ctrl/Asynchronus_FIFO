// 1. sync_r2w module define:	
// Purpose: Make the write pointer(wptr) synchronized with read clock domain(rclk). 
// 			Synchronnized wptr(rq2_wptr) used in fifo_empty operation.
module sync_r2w( wq2_rptr,rptr,wclk,wrstn );
	
	// Parameter Define:
	parameter ADDR_WIDTH = 3;
	
	// Port Define:
	input		[ADDR_WIDTH : 0]	rptr;
	input							wclk,wrstn;
	output reg	[ADDR_WIDTH : 0]	wq2_rptr;
	
	// Internal Variable:
	reg		[ADDR_WIDTH : 0]	wq1_rptr;
	
	// Code:
	always@(posedge wclk or negedge wrstn)
	begin
		if(!wrstn)	
		begin
			wq1_rptr <= 0;
			wq2_rptr <= 0;
		end
		else
		begin
			wq1_rptr <= rptr;
			wq2_rptr <= wq1_rptr;
			
			// One can use conctenation operator as well:
			// {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
		end
	end
endmodule
