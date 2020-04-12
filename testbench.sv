module testbench();
	
	timeunit 10ns;
	
	timeprecision 1ns;

	
//	logic CLK;
//	logic RESET;
//	logic AES_START;
//	logic AES_DONE;
//	logic [127:0] AES_KEY;
//	logic [127:0] AES_MSG_ENC;
//	logic [127:0] AES_MSG_DEC;			
	

	logic CLK;
	
//	lon Reset Input
	logic RESET;
	
//	lon-MM Slave Signals
	 logic AVL_READ;				// Avalon-MM Read
	 logic AVL_WRITE;				// Avalon-MM Write
	 logic AVL_CS;						// Avalon-MM Chip Select
	 logic [3:0] AVL_BYTE_EN;		// Avalon-MM Byte Enable
	 logic [3:0] AVL_ADDR;			// Avalon-MM Address
	 logic [31:0] AVL_WRITEDATA;	// Avalon-MM Write Data
	 logic [31:0] AVL_READDATA;	// Avalon-MM Read Data
	
//	orted Conduit
	 logic [31:0] EXPORT_DATA;		// Exported Conduit Signal to LEDs
	
	
	
//	AES AEStest(.*);
	avalon_aes_interface aes(.*);
	always begin : CLOCK_GENERATION
		#1 CLK = ~CLK;
	end

	initial begin: CLOCK_INITIALIZATION
		CLK = 0;
	end 

	initial begin: TEST_VECTORS
	RESET = 1;
//	AES_KEY <= 128'h000102030405060708090a0b0c0d0e0f;
//	AES_KEY <= 128'h13111d7fe3944a17f307a78b4d2b30c5;
//	AES_MSG_ENC <= 128'hdaec3055df058e1c39e814ea76f6747e;
	
	#2 RESET = 0;
	#2 AVL_ADDR = 4'b1110; AVL_WRITE = 1'b1; AVL_CS = 1'b1; AVL_WRITEDATA = 1'b1; AVL_BYTE_EN = 4'b1111;
	#10 AVL_WRITEDATA = 1'b0;
	

	
	end
	
	
endmodule