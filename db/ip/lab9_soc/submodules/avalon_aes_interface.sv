/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
	);

	logic [127:0] AES_KEY;
	logic [127:0] AES_MSG_EN;
	logic [127:0] AES_MSG_DE;
	logic [31:0] START;
	logic [31:0] DONE;
	logic [32:0] start_, done_;
	logic [16:0] load_en;
	
	always_comb
		begin
		load_en [15:0] = 16'b0000000000000000;
		if(AVL_WRITE)
			begin 
				case(AVL_ADDR)
					4'b0000:
						load_en[0] = 1;
					4'b0001:
						load_en[1] = 1;
					4'b0010:
						load_en[2] = 1;
					4'b0011:
						load_en[3] = 1;
					4'b0100:
						load_en[4] = 1;
					4'b0101:
						load_en[5] = 1;
					4'b0110:
						load_en[6] = 1;
					4'b0111:
						load_en[7] = 1;
					4'b1000:
						load_en[8] = 1;
					4'b1001:
						load_en[9] = 1;
					4'b1010:
						load_en[10] = 1;
					4'b1011:
						load_en[11] = 1;
					4'b1110:
						load_en[14] = 1;
					4'b1111:
						load_en[15] = 1;
					default: 
						load_en = 4'h0000;
				endcase
			end
		end
						
						
	
	always_comb 
		begin 
		if (AVL_READ)
			begin
				case(AVL_ADDR)
					4'b0000:
						EXPORT_DATA = AES_KEY[31:0];
					4'b0001:
						EXPORT_DATA = AES_KEY[63:32];
					4'b0010:
						EXPORT_DATA = AES_KEY[95:64];
					4'b0011:
						EXPORT_DATA = AES_KEY[127:96];
					4'b0100:
						EXPORT_DATA = AES_MSG_EN[31:0];
					4'b0101:
						EXPORT_DATA = AES_MSG_EN[63:32];
					4'b0110:
						EXPORT_DATA = AES_MSG_EN[95:64];
					4'b0111:
						EXPORT_DATA = AES_MSG_EN[127:96];
					4'b1000:
						EXPORT_DATA = AES_MSG_DE[31:0];
					4'b1001:
						EXPORT_DATA = AES_MSG_DE[63:32];
					4'b1010:
						EXPORT_DATA = AES_MSG_DE[95:64];
					4'b1011:
						EXPORT_DATA = AES_MSG_DE[127:96];
					4'b1110:
						EXPORT_DATA = start_;
					4'b1111:
						EXPORT_DATA = done_;
					default:
						EXPORT_DATA = 4'h0000;
				endcase
			end
		end
	
	register32 aes_key0 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_KEY[31:0])
	);	
	register32 aes_key1 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_KEY[63:32])
	);
	register32 aes_key2 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_KEY[95:64])
	);
	register32 aes_key3 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_KEY[127:96])
	);
	register32 aes_msg_en0 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_EN[31:0])
	);
	register32 aes_msg_en1 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_EN[63:32])
	);
	register32 aes_msg_en2 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_EN[95:64])
	);
	register32 aes_msg_en3 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_EN[127:96])
	);
	register32 aes_msg_de0 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_DE[31:0])
	);
	register32 aes_msg_de1 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_DE[63:32])
	);
	register32 aes_msg_de2 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_DE[95:64])
	);
	register32 aes_msg_de3 (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(AES_MSG_DE[127:96])
	);
	register32 start     (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(START)
	);
	register32 done      (.Clk(CLK), 
								.Reset(RESET), 
								.loadenable(AVL_ADDR), 
								.avl_byte_en(AVL_BYTE_EN), 
								.Din(AVL_WRITE), 
								.Dout(DONE)
	);
	
	
	


endmodule
