`timescale 1ps/1ps

//`define SIMULATION  

module top  

`ifndef SIMULATION 
(
	input clk_i,  

	input uart_rx,
	output uart_tx,  

  input [15:0] sw,
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
	
parameter CLKS_PER_BIT = 16'd100; // 1,000,000
//parameter CLKS_PER_BIT = 16'd10416; // 9,600

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
  wire				ui_rst = sw[15];

  reg tx_valid;
  reg [1:0] tx_state;

  wire tx_active, tx_done;

/////////////////////////////////////////////////INSTANTIATIONS/////////////////////////////////////////////////////////

`ifdef SIMULATION
    	 uart_tx  #(.CLKS_PER_BIT(CLKS_PER_BIT)) sim_tx(
		.i_Clock(ui_clk),
		.i_Tx_DV(sim_utx_dv),
		.i_Tx_Byte(sim_utx_data), 
		.o_Tx_Active(),
		.o_Tx_Serial(uart_rx),
		.o_Tx_Done()
	);
`endif



  uart_rx  #(.CLKS_PER_BIT(CLKS_PER_BIT)) rx(
   . i_Clock(ui_clk),
   .i_Rx_Serial(uart_rx),
   .o_Rx_DV(dv),
   .o_Rx_Byte(led)
   );


   uart_tx  #(.CLKS_PER_BIT(CLKS_PER_BIT)) tx(
   .i_Clock(ui_clk),
   .i_Tx_DV(tx_valid),
   .i_Tx_Byte(sw[7:0]), 
   .o_Tx_Active(tx_active),
   .o_Tx_Serial(uart_tx),
   . o_Tx_Done(tx_done)
   );
	

localparam IDLE = 2'd0;
localparam SEND = 2'd1;
localparam WAIT = 2'd2;

// State machine to set valid signal
always @(posedge ui_clk)begin
  if(ui_rst)begin
    tx_valid <= 1'b0;
    tx_state <= IDLE;
  end
  else begin
    case(tx_state)
      IDLE:begin
        if(sw[14])begin
          tx_valid <= 1'b1;
          tx_state <= SEND;
        end
      end
      SEND:begin
        tx_valid <= 1'b0;
        if(tx_done)begin
          tx_state <= WAIT;
        end
        else begin
          tx_state <= SEND;
        end
      end
      WAIT:begin
        if(sw[14])begin
          tx_state <= WAIT;
        end
        else begin
          tx_state <= IDLE;
        end
      end
    endcase
  end
end


endmodule



