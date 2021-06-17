/*
	File Name: condlogic.sv
	Written By: Harris and Harris 
	HDL Example 7.4
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Execute stage logic. Sets flags required.
*/

module condlogic(
	input logic [3:0] Cond, Flags, ALUFlags,
	input logic [1:0] FlagWrite,
	output logic CondEx,
	output logic [3:0] FlagsNext
);

	logic neg, zero, _carry, overflow, ge;
	
	assign {neg, zero, _carry, overflow} = Flags;
	assign ge = (neg == overflow);

	always_comb
		case(Cond)
			4'b0000: 
				begin 
					CondEx = zero; 					//EQ
				end
			4'b0001: 
				begin 
					CondEx = ~zero;					//NE
				end
			4'b0010: 
				begin 
					CondEx = _carry;					//CS
				end		
			4'b0011: 
				begin 
					CondEx = ~_carry;				//CC
				end			
			4'b0100: 
				begin 
					CondEx = neg;					//MI
		
				end
			4'b0101: 
				begin 
					CondEx = ~neg;					//PL
				end
			4'b0110: 
				begin 
					CondEx = overflow;				//VS
				end
			4'b0111: 
				begin 
					CondEx = ~overflow;				//VC
				end
			4'b1000: 
				begin 
					CondEx = _carry & ~zero;			//HI
				end
			4'b1001: 
				begin 
					CondEx = ~(_carry & ~zero);		//LS
				end
			4'b1010: 
				begin 
					CondEx = ge;					//GE
				end
			4'b1011: 
				begin 
					CondEx = ~ge;					//LT
				end
			4'b1100: 
				begin 
					CondEx = ~zero & ge;			//GT
				end
			4'b1101: 
				begin 
					CondEx = ~(~zero & ge);			//LE
				end
			4'b1110: 
				begin 
					CondEx = 1'b1;					//Always
				end
			default:
				CondEx = 1'bx;						//Undefined
		endcase
		
		always_comb
		begin
			if(FlagWrite[1] & CondEx)
				FlagsNext[3:2] = ALUFlags[3:2];
			else
				FlagsNext[3:2] = Flags[3:2];
		end
		
		always_comb
		begin
			if(FlagWrite[0] & CondEx)
				FlagsNext[1:0] = ALUFlags[1:0];
			else
				FlagsNext[1:0] = Flags[1:0];
		end
		
endmodule

