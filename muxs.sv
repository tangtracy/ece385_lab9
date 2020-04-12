module mux5to1reg (input logic [127:0] DinA,
                              DinB,
										DinC,
										DinD,
										DinE,
                input logic [2:0] sel,
                output logic [127:0] Dout
                );

        always_comb
        begin
            case (sel)
                3'b000 : Dout = DinA;
                3'b001 : Dout = DinB;
					 3'b010 : Dout = DinC;
                3'b011 : Dout = DinD;
					 3'b100 : Dout = DinE;
					 default : Dout = 128'h0;
					 
            endcase
			end
endmodule

module mux4to1invmc (input [31:0] DinA,
											 DinB,
											 DinC,
											 DinD,
                input logic [1:0] sel,
                output logic [31:0] Dout
                );

        always_comb
        begin
            case (sel)
                2'b00 : Dout = DinA;
                2'b01 : Dout = DinB;
					 2'b10 : Dout = DinC;
                2'b11 : Dout = DinD;
            endcase
			end
endmodule