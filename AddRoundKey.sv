module AddRoundKey(
						input logic [127:0] data_in, 
						input logic [1407:0] keySchedule, 
						input logic [3:0] sel,
						output logic [127:0] data_out
); 

logic [127:0] chooseBits;

always_comb
	begin 
		case(sel)
			4'b1010: 
				chooseBits = keySchedule[127:0];
			4'b1001: 
				chooseBits = keySchedule[255:128];
			4'b1000: 
				chooseBits = keySchedule[383:256];
			4'b0111: 
				chooseBits = keySchedule[511:384];
			4'b0110: 
				chooseBits = keySchedule[639:512];
			4'b0101: 
				chooseBits = keySchedule[767:640];
			4'b0100: 
				chooseBits = keySchedule[895:768];
			4'b0011: 
				chooseBits = keySchedule[1023:896];
			4'b0010: 
				chooseBits = keySchedule[1151:1024];
			4'b0001: 
				chooseBits = keySchedule[1279:1152];
			4'b0000: 
				chooseBits = keySchedule[1407:1280];
			default :
				chooseBits = 128'h0;
		endcase
	end

assign data_out[7:0] = chooseBits[7:0] ^ data_in[7:0];
assign data_out[15:8] = chooseBits[15:8] ^ data_in[15:8];
assign data_out[23:16] = chooseBits[23:16] ^ data_in[23:16];
assign data_out[31:24] = chooseBits[31:24] ^ data_in[31:24];
assign data_out[39:32] = chooseBits[39:32] ^ data_in[39:32];
assign data_out[47:40] = chooseBits[47:40] ^ data_in[47:40];
assign data_out[55:48] = chooseBits[55:48] ^ data_in[55:48];
assign data_out[63:56] = chooseBits[63:56] ^ data_in[63:56];
assign data_out[71:64] = chooseBits[71:64] ^ data_in[71:64];
assign data_out[79:72] = chooseBits[79:72] ^ data_in[79:72];
assign data_out[87:80] = chooseBits[87:80] ^ data_in[87:80];
assign data_out[95:88] = chooseBits[95:88] ^ data_in[95:88];
assign data_out[103:96] = chooseBits[103:96] ^ data_in[103:96];
assign data_out[111:104] = chooseBits[111:104] ^ data_in[111:104];
assign data_out[119:112] = chooseBits[119:112] ^ data_in[119:112];
assign data_out[127:120] = chooseBits[127:120] ^ data_in[127:120];

endmodule 