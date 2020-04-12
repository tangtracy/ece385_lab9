/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC,
	output logic myReset
);

logic [2:0] controlSel;
logic [1:0] invmcSel;
logic [3:0] arkSel;
logic [127:0] invSBout, invmcOut_, invSRout, invARK;
logic [127:0] inReg, outReg;
logic [31:0] invmcMuxOut;
logic [31:0] invmcOut;
logic [1407:0] keySchedule;
logic crLE, wrLE;

mux5to1reg mux5to1reg_(
							.sel(controlSel),
							.DinA(invARK),
							.DinB(invSRout),
							.DinC(invmcOut_),
							.DinD(invSBout),
							.DinE(AES_MSG_ENC),
							.Dout(inReg)
						);
mux4to1invmc mux4to1invmc_(
							.sel(invmcSel),
							.DinA(outReg[31:0]),
							.DinB(outReg[63:32]),
							.DinC(outReg[95:64]),
							.DinD(outReg[127:96]),
							.Dout(invmcMuxOut)
						);
register128 register128_(
								.Din(inReg),
								.Dout(outReg),
								.Clk(CLK),
								.Reset(RESET),
								.LE(crLE)
								);
invSB16 invSB16_(
						.CLK(CLK),
						.Din(outReg),
						.Dout(invSBout)
				   	);
InvShiftRows InvShiftRows_(
						.data_in(outReg),
						.data_out(invSRout)
						);						

InvMixColumns InvMixColumns_(
						.in(invmcMuxOut),
						.out(invmcOut)
						);

waitreg waitreg_(
					.Clk(CLK),
					.Reset(RESET),
					.sel(invmcSel),
					.DinA(invmcOut),
					.DinB(invmcOut),
					.DinC(invmcOut),
					.DinD(invmcOut),
					.Dout(invmcOut_),
					.LE(wrLE)
					);

AddRoundKey AddRoundKey_(
					.data_in(outReg),
					.keySchedule(keySchedule),
					.sel(arkSel),
					.data_out(invARK)
					); 

KeyExpansion KeyExpansion_(
					.clk(CLK),
					.Cipherkey(AES_KEY),
					.KeySchedule(keySchedule)
);

assign AES_MSG_DEC = outReg;

enum logic[7:0] {
							Hold,
							KE_1,
							KE_2,
							KE_3,
							KE_4,
							KE_5,
							KE_6,
							KE_7,
							KE_8,
							KE_9,
							KE_10,
							KE_11,
							ARK_beg,
							
							ISR_1,
							ISB_1,
							ARK_1,
							IMC_1_1,
							IMC_1_2,
							IMC_1_3,
							IMC_1_4,
							IMC_1_5,
							
							ISR_2,
							ISB_2,
							ARK_2,
							IMC_2_1,
							IMC_2_2,
							IMC_2_3,
							IMC_2_4,
							IMC_2_5,
							
							ISR_3,
							ISB_3,
							ARK_3,
							IMC_3_1,
							IMC_3_2,
							IMC_3_3,
							IMC_3_4,
							IMC_3_5,
							
							ISR_4,
							ISB_4,
							ARK_4,
							IMC_4_1,
							IMC_4_2,
							IMC_4_3,
							IMC_4_4,
							IMC_4_5,
							
							ISR_5,
							ISB_5,
							ARK_5,
							IMC_5_1,		
							IMC_5_2,
							IMC_5_3,
							IMC_5_4,
							IMC_5_5,
							
							ISR_6,
							ISB_6,
							ARK_6,
							IMC_6_1,	
							IMC_6_2,
							IMC_6_3,
							IMC_6_4,
							IMC_6_5,
							
							ISR_7,
							ISB_7,
							ARK_7,
							IMC_7_1,	
							IMC_7_2,
							IMC_7_3,
							IMC_7_4,	
							IMC_7_5,
		
							ISR_8,
							ISB_8,
							ARK_8,
							IMC_8_1,
							IMC_8_2,
							IMC_8_3,
							IMC_8_4,
							IMC_8_5,
							
							ISR_9,
							ISB_9,
							ARK_9,
							IMC_9_1,	
							IMC_9_2,
							IMC_9_3,
							IMC_9_4,	
							IMC_9_5,
			
							ISR_end,
							ISB_end,
							ARK_end,
							done_1,
							done_2,
							done
							}  state, nextState;
							
			always_ff @ (posedge CLK)
			begin 
				if(RESET)
					state = Hold;
				else 
					state = nextState;
			end
			always_comb
			begin 
				nextState = state; 
				controlSel = 2'b00;
				invmcSel   = 2'b00;
				crLE		  = 1'b0;
				wrLE		  = 1'b0;
				arkSel     = 4'b0000;
				AES_DONE = 1'b0;
				myReset = 1'b0;
				unique case(state) 
					Hold:
						begin
							if(AES_START)
								nextState = KE_1;
						end
					KE_1:
						begin 
							nextState = KE_2;
						end 
					KE_2:
						begin 
							nextState = KE_3;
						end 
					KE_3:
						begin 
							nextState = KE_4;
						end 
					KE_4:
						begin 
							nextState = KE_5;
						end 
					KE_5:
						begin 
							nextState = KE_6;
						end 
					KE_6:
						begin 
							nextState = KE_7;
						end 
					KE_7:
						begin 
							nextState = KE_8;
						end 
					KE_8:
						begin 
							nextState = KE_9;
						end 
					KE_9:
						begin 
							nextState = KE_10;
						end 
					KE_10:
						begin 
							nextState = KE_11;
						end 
					KE_11:
						begin 
							nextState = ARK_beg;
						end 
					ARK_beg:
						begin 
							nextState = ISR_1;
						end 
					ISR_1:
						begin
							nextState = ISB_1;
						end
					ISB_1:
						begin
							nextState = ARK_1;
						end
					ARK_1:
						begin
							nextState = IMC_1_1;
						end
					IMC_1_1:
						begin
							nextState = IMC_1_2;
						end
					IMC_1_2:
						begin
							nextState = IMC_1_3;
						end
					IMC_1_3:
						begin
							nextState = IMC_1_4;
						end
					IMC_1_4:
						begin
							nextState = IMC_1_5;
						end
					IMC_1_5:
						begin
							nextState = ISR_2;
						end
					ISR_2:
						begin
							nextState = ISB_2;
						end
					ISB_2:
						begin
							nextState = ARK_2;
						end
					ARK_2:
						begin
							nextState = IMC_2_1;
						end
					IMC_2_1:
						begin
							nextState = IMC_2_2;
						end
					IMC_2_2:
						begin
							nextState = IMC_2_3;
						end
					IMC_2_3:
						begin
							nextState = IMC_2_4;
						end
					IMC_2_4:
						begin
							nextState = IMC_2_5;
						end
					IMC_2_5:
						begin
							nextState = ISR_3;
						end
					ISR_3:
						begin
							nextState = ISB_3;
						end
					ISB_3:
						begin
							nextState = ARK_3;
						end
					ARK_3:
						begin
							nextState = IMC_3_1;
						end
					IMC_3_1:
						begin
							nextState = IMC_3_2;
						end
					IMC_3_2:
						begin
							nextState = IMC_3_3;
						end
					IMC_3_3:
						begin
							nextState = IMC_3_4;
						end
					IMC_3_4:
						begin
							nextState = IMC_3_5;
						end
					IMC_3_5:
						begin
							nextState = ISR_4;
						end
					ISR_4:
						begin
							nextState = ISB_4;
						end
					ISB_4:
						begin
							nextState = ARK_4;
						end
					ARK_4:
						begin
							nextState = IMC_4_1;
						end
					IMC_4_1:
						begin
							nextState = IMC_4_2;
						end
					IMC_4_2:
						begin
							nextState = IMC_4_3;
						end
					IMC_4_3:
						begin
							nextState = IMC_4_4;
						end
					IMC_4_4:
						begin
							nextState = IMC_4_5;
						end
					IMC_4_5:
						begin
							nextState = ISR_5;
						end
					ISR_5:
						begin
							nextState = ISB_5;
						end
					ISB_5:
						begin
							nextState = ARK_5;
						end
					ARK_5:
						begin
							nextState = IMC_5_1;
						end
					IMC_5_1:
						begin
							nextState = IMC_5_2;
						end
					IMC_5_2:
						begin
							nextState = IMC_5_3;
						end
					IMC_5_3:
						begin
							nextState = IMC_5_4;
						end
					IMC_5_4:
						begin
							nextState = IMC_5_5;
						end
					IMC_5_5:
						begin
							nextState = ISR_6;
						end
					ISR_6:
						begin
							nextState = ISB_6;
						end
					ISB_6:
						begin
							nextState = ARK_6;
						end
					ARK_6:
						begin
							nextState = IMC_6_1;
						end
					IMC_6_1:
						begin
							nextState = IMC_6_2;
						end
					IMC_6_2:
						begin
							nextState = IMC_6_3;
						end
					IMC_6_3:
						begin
							nextState = IMC_6_4;
						end
					IMC_6_4:
						begin
							nextState = IMC_6_5;
						end
					IMC_6_5:
						begin
							nextState = ISR_7;
						end
					ISR_7:
						begin
							nextState = ISB_7;
						end
					ISB_7:
						begin
							nextState = ARK_7;
						end
					ARK_7:
						begin
							nextState = IMC_7_1;
						end
					IMC_7_1:
						begin
							nextState = IMC_7_2;
						end
					IMC_7_2:
						begin
							nextState = IMC_7_3;
						end
					IMC_7_3:
						begin
							nextState = IMC_7_4;
						end
					IMC_7_4:
						begin
							nextState = IMC_7_5;
						end
					IMC_7_5:
						begin
							nextState = ISR_8;
						end
					ISR_8:
						begin
							nextState = ISB_8;
						end
					ISB_8:
						begin
							nextState = ARK_8;
						end
					ARK_8:
						begin
							nextState = IMC_8_1;
						end
					IMC_8_1:
						begin
							nextState = IMC_8_2;
						end
					IMC_8_2:
						begin
							nextState = IMC_8_3;
						end
					IMC_8_3:
						begin
							nextState = IMC_8_4;
						end
					IMC_8_4:
						begin
							nextState = IMC_8_5;
						end
					IMC_8_5:
						begin
							nextState = ISR_9;
						end
					ISR_9:
						begin
							nextState = ISB_9;
						end
					ISB_9:
						begin
							nextState = ARK_9;
						end
					ARK_9:
						begin
							nextState = IMC_9_1;
						end
					IMC_9_1:
						begin
							nextState = IMC_9_2;
						end
					IMC_9_2:
						begin
							nextState = IMC_9_3;
						end
					IMC_9_3:
						begin
							nextState = IMC_9_4;
						end
					IMC_9_4:
						begin
							nextState = IMC_9_5;
						end
					IMC_9_5:
						begin
							nextState = ISR_end;
						end
					ISR_end:
						begin
							nextState = ISB_end;
						end
					ISB_end:
						begin
							nextState = ARK_end;
						end
					ARK_end:
						begin
							nextState = done_1;
						end
					done_1:
						begin
							if(AES_START)
								nextState = done_1;
							else
								nextState = done_2;
						end
					done_2:
						begin
							if(~AES_START)
								nextState = done;
							else
								nextState = done_2;
						end
					done:
						begin
							if(AES_START)
								nextState = KE_1;
						end
					default: ;
				endcase
				
				
				
				
				
				
				
				case(state)
					Hold: 
						begin
							controlSel =3'b100;
							crLE = 1'b1;
						end
					KE_1: ;
					
					KE_2: ;

					KE_3: ;

					KE_4: ;

					KE_5: ;

					KE_6: ;

					KE_7: ; 

					KE_8: ;

					KE_9: ; 

					KE_10: ;

					KE_11: ;

					ARK_beg: 
						begin
							arkSel = 4'b1010;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					ISR_1:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_1:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_1:
						begin
							arkSel = 4'b1001;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_1_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_1_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_1_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_1_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_1_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_2:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_2:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end

					ARK_2:
						begin
							arkSel = 4'b1000;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_2_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_2_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_2_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_2_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_2_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_3:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_3:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_3:
						begin
							arkSel = 4'b0111;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_3_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_3_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_3_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_3_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_3_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_4:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_4:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_4:
						begin
							arkSel = 4'b0110;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_4_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_4_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_4_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_4_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_4_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_5:
						begin 
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_5:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_5:
						begin
							arkSel = 4'b0101;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_5_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_5_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_5_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_5_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_5_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_6:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_6:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_6:
						begin
							arkSel = 4'b0100;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_6_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_6_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_6_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_6_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_6_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_7:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_7:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_7:
						begin
							arkSel = 4'b0011;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_7_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_7_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_7_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_7_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_7_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_8:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_8:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_8:
						begin
							arkSel = 4'b0010;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_8_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_8_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_8_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_8_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_8_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_9:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_9:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_9:
						begin
							arkSel = 4'b0001;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					IMC_9_1:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b00;
						end 
					IMC_9_2:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b01;
						end 
					IMC_9_3:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b10;
						end 
					IMC_9_4:
						begin 
							wrLE = 1'b1;
							invmcSel = 2'b11;
						end 
					IMC_9_5:
						begin 
							controlSel = 3'b010;
							crLE = 1'b1;
						end 
					ISR_end:
						begin
							controlSel = 3'b001;
							crLE = 1'b1;
						end
					ISB_end:
						begin
							controlSel = 3'b011;
							crLE = 1'b1;
						end
					ARK_end:
						begin
							arkSel = 4'b0000;
							controlSel = 3'b000;
							crLE = 1'b1;
						end
					done_1:
						begin
							AES_DONE = 1'b1;
						end
					done_2:
						begin
							AES_DONE = 1'b1;
						end
					done: 
						myReset = 1'b1;
					default: ;
				endcase
			
			end
endmodule
