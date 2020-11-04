// 2. sync_w2r module define:
// Purpose: Make the read pointer(rptr) synchronized with write clock domain(wclk). 
// 			Synchronnized rptr(wq2_rptr) used in fifo_full operation.
module sync_w2r( rq2_wptr,wptr,rclk,rrstn);

	// Parameter Define:
	parameter ADDR_WIDTH = 3;
	
	// Port Define:
	input		[ADDR_WIDTH : 0]	wptr;
	input							rclk,rrstn;
	output	reg	[ADDR_WIDTH : 0]	rq2_wptr;
	
	// Internal Variable:
	reg			[ADDR_WIDTH : 0]	rq1_wptr;
	
	// Code:
	always@(posedge rclk or negedge rrstn)
	begin
		if(!rrstn)
		begin
			rq1_wptr	<= 0;
			rq2_wptr	<= 0;
		end
		else
		begin
			rq1_wptr	<= wptr;
			rq2_wptr	<= rq1_wptr;
			
			// One can use conctenation operator as well:
			// {rq2_wptr,rq1_wptr}	<= {rq1_wptr,wptr};
		end
	end
endmodule
