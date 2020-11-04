// fifo_top.v: Top module

module fifo_top (rdata,rempty,wfull,wdata,wen,ren,wclk,rclk,wrstn,rrstn);

	// Parameter Define:
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 3;
	
	// Port Define
	input	[DATA_WIDTH-1 : 0]	wdata;
	input 						wclk,wrstn,wen;
	input						rclk,rrstn,ren;
	output	[DATA_WIDTH-1:0]	rdata;
	output						rempty,wfull;
	
	// Internal Variable:
	wire	[ADDR_WIDTH-1 : 0]	waddr,raddr;
	wire	[ADDR_WIDTH : 0]	wptr,rptr,wq2_rptr,rq2_wptr;
	
	// Module Instantiation:
	
	// 1. sync_r2w (write clk domain)
	sync_r2w #(.ADDR_WIDTH(ADDR_WIDTH)) swd1(	.wq2_rptr(wq2_rptr),
												.rptr(rptr),
												.wclk(wclk),
												.wrstn(wrstn)
											);
											
	// 2.sync_w2r (read clk domain)
	sync_w2r #(.ADDR_WIDTH(ADDR_WIDTH)) srd1(	.rq2_wptr(rq2_wptr),
												.wptr(wptr),
												.rclk(rclk),
												.rrstn(rrstn)
											);
											
	// 3. fifo_mem.v (Dual Port RAM)
	fifo_mem #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))
										fm1(	.rdata(rdata),
												.wdata(wdata),
												.waddr(waddr),
												.raddr(raddr),
												.wfull(wfull),
												.wen(wen),
												.wclk(wclk)
											);
	
	// 4. r_empty.v (fifo_empty logic and raddr to mem)
	r_empty #(.ADDR_WIDTH(ADDR_WIDTH)) re1	(	.rempty(rempty),
												.raddr(raddr),
												.rptr(rptr),
												.rclk(rclk),
												.rrstn(rrstn),
												.rq2_wptr(rq2_wptr),
												.ren(ren)
											);
											
	// 5. w_full.v (fifo_full logic and waddr to mem)
	w_full #(.ADDR_WIDTH(ADDR_WIDTH)) wf1	(	.wfull(wfull),
												.waddr(waddr),
												.wptr(wptr),
												.wen(wen),
												.wq2_rptr(wq2_rptr),
												.wclk(wclk),
												.wrstn(wrstn)
											);
										
endmodule
