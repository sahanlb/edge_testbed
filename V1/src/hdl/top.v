`timescale 1ps/1ps

//`define SIMULATION  

module top  

`ifndef SIMULATION 
(
	input clk_i,  

	input uart_rx,
	output uart_tx,  

  input sw,
	output [7:0] led,
  output dv
); 


`else
;
	reg clk_i;
	wire uart_rx;
	wire uart_tx;

	reg [3:0] sw;
	wire [7:0] led;
	reg sim_utx_dv;
    	reg [7:0] sim_utx_data;
	initial clk_i = 0;
	always #5000 clk_i = ~clk_i;
	initial begin
		sw = 1'b1;
		sim_utx_dv = 0;
		sim_utx_data = 8'd0;
		#20000;
		sw = 1'b0;
		#200_000;
		sim_utx_data = 8'd6;
		sim_utx_dv = 1'b1;
		#40_000;
		sim_utx_dv = 1'b0;
		#200_000;
		sim_utx_data = 8'd17;
		sim_utx_dv = 1'b1;
		#40_000;
		sim_utx_dv = 1'b0;
		#200_000;
		sim_utx_data = 8'd157;
		sim_utx_dv = 1'b1;
		#40_000;
		sim_utx_dv = 1'b0;
	end
	
`endif

	
/////////////////////////////////////////////DESIGN PARAMETERS////////////////////////////////////////////////////
	
	`include "config.vh"
	
/////////////////////////////////////////////////SIGNALS/////////////////////////////////////////////////////////
	


	// GPIO Controller
	wire	[31:0]			gpio_axi_araddr;
	wire				gpio_axi_arvalid;
	wire				gpio_axi_arready;
	wire	[31:0]			gpio_axi_awaddr;
	wire				gpio_axi_awvalid;
	wire				gpio_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	gpio_axi_rdata;
	wire				gpio_axi_rvalid;
	wire				gpio_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	gpio_axi_wdata;
	wire	[3:0]			gpio_axi_wstrb;
	wire				gpio_axi_wvalid;
	wire				gpio_axi_wready;
	wire				gpio_b_ready;
	wire				gpio_b_valid;
	wire	[1:0]			gpio_b_response;
	
	// UART Controller
	wire	[31:0]			uart_axi_araddr;
	wire				uart_axi_arvalid;
	wire				uart_axi_arready;
	wire	[31:0]			uart_axi_awaddr;
	wire				uart_axi_awvalid;
	wire				uart_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	uart_axi_rdata;
	wire				uart_axi_rvalid;
	wire				uart_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	uart_axi_wdata;
	wire	[3:0]			uart_axi_wstrb;
	wire				uart_axi_wvalid;
	wire				uart_axi_wready;
	wire				uart_b_ready;
	wire				uart_b_valid;
	wire	[1:0]			uart_b_response;  
	
	
	
	wire				ui_clk = clk_i;
  wire				ui_rst = sw;

/////////////////////////////////////////////////INSTANTIATIONS/////////////////////////////////////////////////////////

`ifdef SIMULATION
    	 uart_tx  #(.CLKS_PER_BIT(16'd10416)) sim_tx(
		.i_Clock(ui_clk),
		.i_Tx_DV(sim_utx_dv),
		.i_Tx_Byte(sim_utx_data), 
		.o_Tx_Active(),
		.o_Tx_Serial(uart_rx),
		.o_Tx_Done()
	);
`endif



  uart_rx  #(.CLKS_PER_BIT(16'd10416)) rx(
   . i_Clock(ui_clk),
   .i_Rx_Serial(uart_rx),
   .o_Rx_DV(dv),
   .o_Rx_Byte(led)
   );
	

	//uart_axi #(.CLKS_PER_BIT(16'd10416))
  //  uart (
	//	.clk(ui_clk),
	//	.rst(ui_rst),
	//	.axi_araddr(uart_axi_araddr),
	//	.axi_arvalid(uart_axi_arvalid),
	//	.axi_arready(uart_axi_arready),
	//	.axi_awaddr(uart_axi_awaddr),
	//	.axi_awvalid(uart_axi_awvalid),
	//	.axi_awready(uart_axi_awready),
	//	.axi_rdata(uart_axi_rdata),
	//	.axi_rvalid(uart_axi_rvalid),
	//	.axi_rready(uart_axi_rready),
	//	.axi_wdata(uart_axi_wdata),
	//	.axi_wvalid(uart_axi_wvalid),
	//	.axi_wready(uart_axi_wready),
	//	.b_ready(uart_b_ready),
	//	.b_valid(uart_b_valid),
	//	.b_response(uart_b_response),
	//	.utx(uart_tx),
	//	.urx(uart_rx)
	//);


//////////////////// Continuous assignments ////////////////////////////
//assign uart_axi_araddr = 0;
//assign uart_axi_arvalid = 0;
//assign uart_axi_awaddr = 0;
//assign uart_axi_awvalid = 0;
//assign uart_axi_rready = 1'b1;
//assign uart_b_ready = 1'b1;
//
//assign gpio_axi_wvalid = uart_axi_rvalid;
//assign gpio_axi_wdata = uart_axi_rdata;
//assign gpio_axi_awaddr = 0;
//assign gpio_axi_awvalid = 1'b1;
//assign gpio_axi_araddr = 0;
//assign gpio_axi_arvalid = 0;

endmodule



