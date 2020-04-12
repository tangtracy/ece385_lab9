module register128 (

	input logic Clk,
	input logic Reset, LE,

	input logic [127:0] Din,
	
	output logic [127:0] Dout
	);
	
	always_ff @ (posedge Clk) 
	begin
		if (Reset) 	Dout = 128'h0;
		else if(LE) 
			Dout <= Din;	
	end
endmodule 


module register32 (

	input logic Clk,
	input logic Reset,
	input logic load_enable,
	input logic [3:0] avl_byte_en,
	
	input logic [31:0] Din,

	output logic [31:0] Dout
	);

	always_ff @ (posedge Clk) begin 
		if(Reset)
		begin
			Dout <= 32'h00000000000000000000000000000000;
		end
		else if(load_enable) 
		begin 
			if(avl_byte_en[0])
				Dout[7:0] <= Din[7:0];
			if(avl_byte_en[1])
				Dout[15:8] <= Din[15:8];
			if(avl_byte_en[2])
				Dout[23:16] <= Din[23:16];
			if(avl_byte_en[3])
				Dout[31:24] <= Din[31:24];
		end
		end
endmodule 

module waitreg(
			input logic Reset,
			input logic Clk, LE,
			input logic [1:0] sel,
			input logic [31:0] DinA, DinB, DinC, DinD,
			output logic [127:0] Dout
	);
		always_ff @ (posedge Clk)
        begin
		  if(LE)
		  begin
           unique case (sel)
                2'b00 : Dout[31:0] <= DinA;
                2'b01 : Dout[63:32] <= DinB;
					 2'b10 : Dout[95:64] <= DinC;
                2'b11 : Dout[127:96] <= DinD;
           endcase
			end
			 if (Reset)
				begin 
					Dout <= 128'h0;
				end 
		  end
endmodule 