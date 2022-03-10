`timescale 1ps/1ps

//`define SIMULATION  

module top  

`ifndef SIMULATION 
(
	input clk_i,  
	input [3:0] sw,
	input uart_rx,
	output uart_tx,  
	output [7:0] led
	//output [0:0] ddr2_cke, output [0:0] ddr2_ck_p, output [0:0]  ddr2_ck_n,
	//output [0:0] ddr2_cs_n, output ddr2_ras_n, output ddr2_cas_n, output ddr2_we_n,
	//output [2:0] ddr2_ba, output [12:0] ddr2_addr, output [0:0] ddr2_odt, output [1:0] ddr2_dm,
	//inout [1:0] ddr2_dqs_p, inout [1:0] ddr2_dqs_n, inout [15:0] ddr2_dq
); 

	wire i2c_sda; wire i2c_scl;
	wire spi_miso; wire spi_mosi; wire spi_clk; wire spi_cs;

`else
;
	reg clk_i;
	wire uart_rx;
	wire uart_tx;
	wire i2c_sda; wire i2c_scl;
	wire ddr3_reset_n; wire [0:0] ddr2_cke; wire [0:0] ddr2_ck_p; wire [0:0]  ddr2_ck_n;
	wire [0:0] ddr2_cs_n; wire ddr2_ras_n; wire ddr2_cas_n; wire ddr2_we_n;
	wire [2:0] ddr2_ba; wire [13:0] ddr2_addr; wire [0:0] ddr2_odt; wire [1:0] ddr2_dm;
	wire [1:0] ddr2_dqs_p; wire [1:0] ddr2_dqs_n; wire [15:0] ddr2_dq;
	wire spi_miso; wire spi_mosi; wire spi_clk; wire spi_cs;
	
	reg [3:0] sw;
	wire [7:0] led;
	reg sim_utx_dv;
    	reg [7:0] sim_utx_data;
	initial clk_i = 0;
	always #5000 clk_i = ~clk_i;
	initial begin
		sw[0] = 1'b1;
		sw[1] = 0;
		sim_utx_dv = 0;
		sim_utx_data = 8'd0;
		#20000;
		sw[0] = 1'b0;
		// #130_000_000;
		// sw[1] = 1'b1;
		// #200_000_000;
		// sw[1] = 1'b0;
		// #20_000_000;
		// sim_utx_data = 8'd6;
		// sim_utx_dv = 1'b1;
		// #40_000;
		// sim_utx_dv = 1'b0;
		// #12_000_000;    
	end
	
	reg [8:0] spi_mosi_reg;
	initial spi_mosi_reg = 9'b101010101;
	always @(negedge spi_clk)
	   spi_mosi_reg = {spi_mosi_reg[7:0], spi_mosi_reg[8]}; 
	assign spi_miso = spi_mosi_reg[8];
`endif

	
/////////////////////////////////////////////DESIGN PARAMETERS////////////////////////////////////////////////////
	
	`include "config.vh"
	
/////////////////////////////////////////////////SIGNALS/////////////////////////////////////////////////////////
	
	// RISCV Core  
	wire	[31:0]			rv_axi_araddr;
	wire				rv_axi_arvalid;
	wire	[2:0]			rv_axi_arprot;
	wire				rv_axi_arready;
	wire	[31:0]			rv_axi_awaddr;
	wire				rv_axi_awvalid;
	wire	[2:0]			rv_axi_awprot;
	wire				rv_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	rv_axi_rdata;
	wire				rv_axi_rvalid;
	wire				rv_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	rv_axi_wdata;
	wire	[3:0]			rv_axi_wstrb;
	wire				rv_axi_wvalid;
	wire				rv_axi_wready;
	wire				rv_b_ready;
	wire				rv_b_valid;
	wire	[1:0]			rv_b_response;


	// L1 Cache Controller
    	wire	[31:0]			cachecontroller_axi_araddr;
	wire				cachecontroller_axi_arvalid;
	wire				cachecontroller_axi_arready;
	wire	[31:0]			cachecontroller_axi_awaddr;
	wire				cachecontroller_axi_awvalid;
	wire				cachecontroller_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	cachecontroller_axi_rdata;
	wire				cachecontroller_axi_rvalid;
	wire				cachecontroller_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	cachecontroller_axi_wdata;
	wire	[3:0]			cachecontroller_axi_wstrb;
	wire				cachecontroller_axi_wvalid;
	wire				cachecontroller_axi_wready;
	wire				cachecontroller_b_ready;
	wire				cachecontroller_b_valid;
	wire	[1:0]			cachecontroller_b_response;
	wire				cachecontroller_w_processing;
	
	
	// Cache Table
    	wire	[31:0]			table_axi_araddr;
	wire				table_axi_arvalid;
	wire				table_axi_arready;
	wire	[31:0]			table_axi_awaddr;
	wire				table_axi_awvalid;
	wire				table_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	table_axi_rdata;
	wire				table_axi_rvalid;
	wire				table_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	table_axi_wdata;
	wire	[3:0]			table_axi_wstrb;
	wire				table_axi_wvalid;
	wire				table_axi_wready;
	wire				table_b_ready;
	wire				table_b_valid;
	wire	[1:0]			table_b_response;


	// L1 Cache
	wire	[31:0]			L1_axi_araddr;
	wire				L1_axi_arvalid;
	wire				L1_axi_arready;
	wire	[31:0]			L1_axi_awaddr;
	wire				L1_axi_awvalid;
	wire				L1_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	L1_axi_rdata;
	wire				L1_axi_rvalid;
	wire				L1_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	L1_axi_wdata;
	wire	[3:0]			L1_axi_wstrb;
	wire				L1_axi_wvalid;
	wire				L1_axi_wready;
	wire				L1_b_ready;
	wire				L1_b_valid;
	wire	[1:0]			L1_b_response;


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
	
	
	// Camera Module
	wire	[31:0]			camera_axi_araddr;
	wire				camera_axi_arvalid;
	wire				camera_axi_arready;
	wire	[31:0]			camera_axi_awaddr;
	wire				camera_axi_awvalid;
	wire				camera_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	camera_axi_rdata;
	wire				camera_axi_rvalid;
	wire				camera_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	camera_axi_wdata;
	wire	[3:0]			camera_axi_wstrb;
	wire				camera_axi_wvalid;
	wire				camera_axi_wready;
	wire				camera_b_ready;
	wire				camera_b_valid;
	wire	[1:0]			camera_b_response;  
	
	
	// RISCV Program Loader
	wire	[31:0]			progloader_axi_awaddr;
	wire				progloader_axi_awvalid;
	wire	[AXI_DATA_WIDTH-1:0]	progloader_axi_wdata;
	wire	[3:0]			progloader_axi_wstrb;
	wire				progloader_axi_wvalid;
	wire				progloader_b_ready;
	wire                		progloader_busy;
	wire				reprogram = (sw[1] | progloader_busy);
	
	
	// Custom RTL for Application Acceleration
	wire	[31:0]			customlogic_axi_araddr;
	wire				customlogic_axi_arvalid;
	wire				customlogic_axi_arready;
	wire	[31:0]			customlogic_axi_awaddr;
	wire				customlogic_axi_awvalid;
	wire				customlogic_axi_awready;
	wire	[AXI_DATA_WIDTH-1:0]	customlogic_axi_rdata;
	wire				customlogic_axi_rvalid;
	wire				customlogic_axi_rready;
	wire	[AXI_DATA_WIDTH-1:0]	customlogic_axi_wdata;
	wire	[3:0]			customlogic_axi_wstrb;
	wire				customlogic_axi_wvalid;
	wire				customlogic_axi_wready;
	wire				customlogic_b_ready;
	wire				customlogic_b_valid;
	wire	[1:0]			customlogic_b_response;
	
	// I2C Tristate Signals
	wire 				i2c_sda_sel;
	wire 				i2c_sda_out;
	wire 				i2c_sda_in = 1'b0;
	
	// DRAM Controller
	wire				ui_clk;
        wire				ui_rst;
        wire				mmcm_locked;
        wire				app_sr_active;
        wire				app_ref_ack;
        wire				app_zq_ack;
        wire	[31:0]			ddr_axi_awaddr;
        wire	[7:0]			ddr_axi_awlen = 8'b0; // 1
        wire	[2:0]			ddr_axi_awsize = 3'b010; // 4 bytes
        wire	[1:0]			ddr_axi_awburst = 2'b0; // fixed
        wire				ddr_axi_awvalid;
        wire				ddr_axi_awready;
        wire	[AXI_DATA_WIDTH-1:0]	ddr_axi_wdata;
        wire	[3:0]			ddr_axi_wstrb;
        wire				ddr_axi_wlast;
        wire				ddr_axi_wvalid;
        wire				ddr_axi_wready;
        wire				ddr_axi_bready;
        wire	[3:0]			ddr_axi_bid;
        wire	[1:0]			ddr_axi_bresp;
        wire				ddr_axi_bvalid;
        wire	[31:0]			ddr_axi_araddr;
        wire	[7:0]			ddr_axi_arlen = 8'b0; // 1
        wire	[2:0]			ddr_axi_arsize = 3'b010; // 4 bytes
        wire	[1:0]			ddr_axi_arburst = 2'b0; // fixed
        wire				ddr_axi_arvalid;
        wire				ddr_axi_arready;
        wire				ddr_axi_rready;
        wire	[3:0]			ddr_axi_rid;
        wire	[AXI_DATA_WIDTH-1:0]	ddr_axi_rdata;
        wire	[1:0]			ddr_axi_rresp;
        wire				ddr_axi_rlast;
        wire				ddr_axi_rvalid;
        wire 				ddr_sys_clk;
        wire 				ddr_clk_ref_i;

assign ui_clk = clk_i;
assign ui_rst = sw[0];
	

/////////////////////////////////////////////////INSTANTIATIONS/////////////////////////////////////////////////////////

`ifdef SIMULATION
    	 uart_tx  #(.CLKS_PER_BIT(16'd100)) sim_tx(
		.i_Clock(ui_clk),
		.i_Tx_DV(sim_utx_dv),
		.i_Tx_Byte(sim_utx_data), 
		.o_Tx_Active(),
		.o_Tx_Serial(uart_rx),
		.o_Tx_Done()
	);
`endif

	progloader_axi #(
    .CLKS_PER_BIT(16'd100)
  ) loader (
		.clk(ui_clk),
		.rst(ui_rst),
		.urx(uart_rx),
		.reprogram(reprogram),
		.axi_awaddr(progloader_axi_awaddr),
		.axi_awvalid(progloader_axi_awvalid),
		.axi_awready(cachecontroller_axi_awready),
		.axi_wdata(progloader_axi_wdata),
		.axi_wstrb(progloader_axi_wstrb),
		.axi_wvalid(progloader_axi_wvalid),
		.axi_wready(cachecontroller_axi_wready),
		.b_ready(progloader_b_ready),
		.b_valid(cachecontroller_b_valid),
		.b_response(cachecontroller_b_response),
		.w_processing(cachecontroller_w_processing),
		.busy(progloader_busy)
	);


/* Cache controller */
	cachecontroller_axi #(.CACHE_ADDR_SIZE(CACHE_ADDR_SIZE),.MEM_ADDR_SIZE(MEM_ADDR_SIZE))  cachecontroller (
		.clk(ui_clk),
		.rst(ui_rst),
		.axi_araddr(cachecontroller_axi_araddr),
		.axi_arvalid(cachecontroller_axi_arvalid),
		.axi_arready(cachecontroller_axi_arready),
		.axi_awaddr((reprogram) ? progloader_axi_awaddr : cachecontroller_axi_awaddr),
		.axi_awvalid((reprogram) ? progloader_axi_awvalid : cachecontroller_axi_awvalid),
		.axi_awready(cachecontroller_axi_awready),
		.axi_rdata(cachecontroller_axi_rdata),
		.axi_rvalid(cachecontroller_axi_rvalid),
		.axi_rready((reprogram) ? 1'b1 : cachecontroller_axi_rready),
		.axi_wdata((reprogram) ? progloader_axi_wdata : cachecontroller_axi_wdata),
		.axi_wstrb((reprogram) ? progloader_axi_wstrb : cachecontroller_axi_wstrb),
		.axi_wvalid((reprogram) ? progloader_axi_wvalid : cachecontroller_axi_wvalid),
		.axi_wready(cachecontroller_axi_wready),
		.b_ready((reprogram) ? progloader_b_ready : cachecontroller_b_ready),
		.b_valid(cachecontroller_b_valid),
		.b_response(cachecontroller_b_response),
		.ddr_axi_araddr(ddr_axi_araddr),
		.ddr_axi_arvalid(ddr_axi_arvalid),
		.ddr_axi_arready(ddr_axi_arready),
		.ddr_axi_awaddr(ddr_axi_awaddr),
		.ddr_axi_awvalid(ddr_axi_awvalid),
		.ddr_axi_awready(ddr_axi_awready),
		.ddr_axi_rdata(ddr_axi_rdata),
		.ddr_axi_rvalid(ddr_axi_rvalid),
		.ddr_axi_rready(ddr_axi_rready),
		.ddr_axi_wdata(ddr_axi_wdata),
		.ddr_axi_wstrb(ddr_axi_wstrb),
		.ddr_axi_wvalid(ddr_axi_wvalid),
		.ddr_axi_wready(ddr_axi_wready),
		.ddr_b_ready(ddr_axi_bready),
		.ddr_b_valid(ddr_axi_bvalid),
		.ddr_b_response(ddr_axi_bresp),
		.L1_axi_araddr(L1_axi_araddr),
		.L1_axi_arvalid(L1_axi_arvalid),
		.L1_axi_arready(L1_axi_arready),
		.L1_axi_awaddr(L1_axi_awaddr),
		.L1_axi_awvalid(L1_axi_awvalid),
		.L1_axi_awready(L1_axi_awready),
		.L1_axi_rdata(L1_axi_rdata),
		.L1_axi_rvalid(L1_axi_rvalid),
		.L1_axi_rready(L1_axi_rready),
		.L1_axi_wdata(L1_axi_wdata),
		.L1_axi_wstrb(L1_axi_wstrb),
		.L1_axi_wvalid(L1_axi_wvalid),
		.L1_axi_wready(L1_axi_wready),
		.L1_b_ready(L1_b_ready),
		.L1_b_valid(L1_b_valid),
		.L1_b_response(L1_b_response),		
		.table_axi_araddr(table_axi_araddr),
		.table_axi_arvalid(table_axi_arvalid),
		.table_axi_arready(table_axi_arready),
		.table_axi_awaddr(table_axi_awaddr),
		.table_axi_awvalid(table_axi_awvalid),
		.table_axi_awready(table_axi_awready),
		.table_axi_rdata(table_axi_rdata),
		.table_axi_rvalid(table_axi_rvalid),
		.table_axi_rready(table_axi_rready),
		.table_axi_wdata(table_axi_wdata),
		.table_axi_wstrb(table_axi_wstrb),
		.table_axi_wvalid(table_axi_wvalid),
		.table_axi_wready(table_axi_wready),
		.table_b_ready(table_b_ready),
		.table_b_valid(table_b_valid),
		.table_b_response(table_b_response),
		.w_processing(cachecontroller_w_processing)
	);


	bram_axi #(.ADDR_WIDTH(CACHE_ADDR_SIZE),.DATA_WIDTH(MEM_ADDR_SIZE-CACHE_ADDR_SIZE-2))  cache_table (
		.clk(ui_clk),
		.rst(ui_rst),
		.axi_araddr(table_axi_araddr),
		.axi_arvalid(table_axi_arvalid),
		.axi_arready(table_axi_arready),
		.axi_awaddr(table_axi_awaddr),
		.axi_awvalid(table_axi_awvalid),
		.axi_awready(table_axi_awready),
		.axi_rdata(table_axi_rdata),
		.axi_rvalid(table_axi_rvalid),
		.axi_rready(table_axi_rready),
		.axi_wdata(table_axi_wdata),
		.axi_wstrb(table_axi_wstrb),
		.axi_wvalid(table_axi_wvalid),
		.axi_wready(table_axi_wready),
		.b_ready(table_b_ready),
		.b_valid(table_b_valid),
		.b_response(table_b_response)
	);
	
	bram_axi #(.ADDR_WIDTH(CACHE_ADDR_SIZE),.DATA_WIDTH(AXI_DATA_WIDTH))  L1 (
		.clk(ui_clk),
		.rst(ui_rst),
		.axi_araddr(L1_axi_araddr),
		.axi_arvalid(L1_axi_arvalid),
		.axi_arready(L1_axi_arready),
		.axi_awaddr(L1_axi_awaddr),
		.axi_awvalid(L1_axi_awvalid),
		.axi_awready(L1_axi_awready),
		.axi_rdata(L1_axi_rdata),
		.axi_rvalid(L1_axi_rvalid),
		.axi_rready(L1_axi_rready),
		.axi_wdata(L1_axi_wdata),
		.axi_wstrb(L1_axi_wstrb),
		.axi_wvalid(L1_axi_wvalid),
		.axi_wready(L1_axi_wready),
		.b_ready(L1_b_ready),
		.b_valid(L1_b_valid),
		.b_response(L1_b_response)
	);


/*****************************************************************************/
// Replace caches and DRAM with a single BRAM
/* Total size = 2^13 x 2^2 = 2^15 = 32K */
	bram_axi #(.ADDR_WIDTH(13),.DATA_WIDTH(AXI_DATA_WIDTH), .INIT(0))  mem (
		.clk(ui_clk),
		.rst(ui_rst),
		.axi_araddr(ddr_axi_araddr>>2),
		.axi_arvalid(ddr_axi_arvalid),
		.axi_arready(ddr_axi_arready),
		.axi_awaddr(ddr_axi_awaddr>>2),
		.axi_awvalid(ddr_axi_awvalid),
		.axi_awready(ddr_axi_awready),
		.axi_rdata(ddr_axi_rdata),
		.axi_rvalid(ddr_axi_rvalid),
		.axi_rready(ddr_axi_rready),
		.axi_wdata(ddr_axi_wdata),
		.axi_wstrb(ddr_axi_wstrb),
		.axi_wvalid(ddr_axi_wvalid),
		.axi_wready(ddr_axi_wready),
		.b_ready(ddr_axi_bready),
		.b_valid(ddr_axi_bvalid),
		.b_response(ddr_axi_bresp)
	);

/*****************************************************************************/


	gpio_axi   gpio (
		.clk(ui_clk),
		.rst(ui_rst  | reprogram),
		.axi_araddr(gpio_axi_araddr),
		.axi_arvalid(gpio_axi_arvalid),
		.axi_arready(gpio_axi_arready),
		.axi_awaddr(gpio_axi_awaddr),
		.axi_awvalid(gpio_axi_awvalid),
		.axi_awready(gpio_axi_awready),
		.axi_rdata(gpio_axi_rdata),
		.axi_rvalid(gpio_axi_rvalid),
		.axi_rready(gpio_axi_rready),
		.axi_wdata(gpio_axi_wdata),
		.axi_wvalid(gpio_axi_wvalid),
		.axi_wready(gpio_axi_wready),
		.b_ready(gpio_b_ready),
		.b_valid(gpio_b_valid),
		.b_response(gpio_b_response),
		.sw(sw),
		.led(led)
	);


	picorv32_axi 
	#(
		.PROGADDR_IRQ(32'h 0000_0000),
		.BARREL_SHIFTER(0),
		.COMPRESSED_ISA(0),
		.ENABLE_MUL(0),
		.ENABLE_DIV(0),
		.ENABLE_IRQ(0),
		.ENABLE_IRQ_QREGS(0),
		.ENABLE_COUNTERS(0),
		.TWO_STAGE_SHIFT(0),
		.ENABLE_REGS_16_31(1),
		//.STACKADDR(GPIO_START_ADDRESS)
		.STACKADDR(MEM_END_ADDRESS+1)
	) 
	cpu (
		.clk(ui_clk),
		.resetn(~(ui_rst|reprogram)),
		.mem_axi_awvalid(rv_axi_awvalid),
		.mem_axi_awready(rv_axi_awready),
		.mem_axi_awaddr(rv_axi_awaddr),
		.mem_axi_awprot(rv_axi_awprot),
		.mem_axi_wvalid(rv_axi_wvalid),
		.mem_axi_wready(rv_axi_wready),
		.mem_axi_wdata(rv_axi_wdata),
		.mem_axi_wstrb(rv_axi_wstrb),
		.mem_axi_bvalid(rv_b_valid),
		.mem_axi_bready(rv_b_ready),
		.mem_axi_arvalid(rv_axi_arvalid),
		.mem_axi_arready(rv_axi_arready),
		.mem_axi_araddr(rv_axi_araddr),
		.mem_axi_arprot(rv_axi_arprot),
		.mem_axi_rvalid(rv_axi_rvalid),
		.mem_axi_rready(rv_axi_rready),
		.mem_axi_rdata(rv_axi_rdata),
		.irq(0),
		.eoi(),
		.trace_valid(),
		.trace_data()
	);
	

	crossbar_axi #(
	   .ENDPOINTS(ENDPOINTS),
	   .BUSWIDTH(AXI_DATA_WIDTH)  
	   ) crossbar(
	    .clk(ui_clk),
	    .rst(ui_rst | reprogram),
	    .rv_axi_araddr(rv_axi_araddr),
	    .rv_axi_arvalid(rv_axi_arvalid),
	    .rv_axi_arready(rv_axi_arready),
	    .rv_axi_awaddr(rv_axi_awaddr),
	    .rv_axi_awvalid(rv_axi_awvalid),
	    .rv_axi_awready(rv_axi_awready),
	    .rv_axi_rdata(rv_axi_rdata),
	    .rv_axi_rvalid(rv_axi_rvalid),
	    .rv_axi_rready(rv_axi_rready),
	    .rv_axi_wdata(rv_axi_wdata),
	    .rv_axi_wstrb(rv_axi_wstrb),
	    .rv_axi_wvalid(rv_axi_wvalid),
	    .rv_axi_wready(rv_axi_wready),
	    .rv_b_ready(rv_b_ready),
	    .rv_b_valid(rv_b_valid),
	    .rv_b_response(rv_b_response),
	    .address_ranges({UART_END_ADDRESS,UART_START_ADDRESS,GPIO_END_ADDRESS,GPIO_START_ADDRESS, MEM_END_ADDRESS,MEM_START_ADDRESS}),
	    .axi_araddr({uart_axi_araddr,gpio_axi_araddr,cachecontroller_axi_araddr}),
	    .axi_arvalid({uart_axi_arvalid,gpio_axi_arvalid,cachecontroller_axi_arvalid}),
	    .axi_arready({uart_axi_arready,gpio_axi_arready,cachecontroller_axi_arready}),
	    .axi_awaddr({uart_axi_awaddr,gpio_axi_awaddr,cachecontroller_axi_awaddr}),
	    .axi_awvalid({uart_axi_awvalid,gpio_axi_awvalid,cachecontroller_axi_awvalid}),
	    .axi_awready({uart_axi_awready,gpio_axi_awready,cachecontroller_axi_awready}),
	    .axi_rdata({uart_axi_rdata,gpio_axi_rdata,cachecontroller_axi_rdata}),
	    .axi_rvalid({uart_axi_rvalid,gpio_axi_rvalid,cachecontroller_axi_rvalid}),
	    .axi_rready({uart_axi_rready,gpio_axi_rready,cachecontroller_axi_rready}),
	    .axi_wdata({uart_axi_wdata,gpio_axi_wdata,cachecontroller_axi_wdata}),
	    .axi_wstrb({uart_axi_wstrb,gpio_axi_wstrb,cachecontroller_axi_wstrb}),
	    .axi_wvalid({uart_axi_wvalid,gpio_axi_wvalid,cachecontroller_axi_wvalid}),
	    .axi_wready({uart_axi_wready,gpio_axi_wready,cachecontroller_axi_wready}),
	    .b_ready({uart_b_ready,gpio_b_ready,cachecontroller_b_ready}),
	    .b_valid({uart_b_valid,gpio_b_valid,cachecontroller_b_valid}),
	    .b_response({uart_b_response,gpio_b_response,cachecontroller_b_response}));

 

	uart_axi #(.CLKS_PER_BIT(16'd100))
    uart (
		.clk(ui_clk),
		.rst(ui_rst  | reprogram),
		.axi_araddr(uart_axi_araddr),
		.axi_arvalid(uart_axi_arvalid),
		.axi_arready(uart_axi_arready),
		.axi_awaddr(uart_axi_awaddr),
		.axi_awvalid(uart_axi_awvalid),
		.axi_awready(uart_axi_awready),
		.axi_rdata(uart_axi_rdata),
		.axi_rvalid(uart_axi_rvalid),
		.axi_rready(uart_axi_rready),
		.axi_wdata(uart_axi_wdata),
		.axi_wvalid(uart_axi_wvalid),
		.axi_wready(uart_axi_wready),
		.b_ready(uart_b_ready),
		.b_valid(uart_b_valid),
		.b_response(uart_b_response),
		.utx(uart_tx),
		.urx(uart_rx)
	);



endmodule



