parameter MEM_START_ADDRESS = 	32'h00000000;
parameter MEM_END_ADDRESS	= 	32'h0FFFFFFF;

parameter GPIO_START_ADDRESS = 	32'h10000000;
parameter GPIO_END_ADDRESS = 		32'h10000000;

parameter UART_START_ADDRESS = 	32'h10000018;
parameter UART_END_ADDRESS	=   	32'h10000018;
	
parameter CAMERA_START_ADDRESS =    	32'h1000001C;  
parameter CAMERA_I2C_END_ADDRESS    =	32'h10000418;  
parameter CAMERA_SPI_START_ADDRESS = 	32'h1000041C;  
parameter CAMERA_END_ADDRESS    =   	32'h10000818;  


parameter CUSTOMLOGIC_START_ADDRESS 	= 	32'h1000081C;
parameter CUSTOMLOGIC_END_ADDRESS	=   	32'h1000091C;

parameter CACHE_ADDR_SIZE = 32'd10;
parameter MEM_ADDR_SIZE = 32'd28;
parameter AXI_DATA_WIDTH = 32'd32;

parameter ENDPOINTS = 3;
