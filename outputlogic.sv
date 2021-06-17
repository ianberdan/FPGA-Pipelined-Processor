/*
	File Name: outputlogic.sv
	Written By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
		Creates the output logic that includes a peek button. 
*/

module outputlogic(
	input logic peek, //key1
	input logic lowHigh, //sw5
	input logic peekEn, //sw4
	input logic [3:0] SW, //sw3:0
	input logic [31:0] peekRF,
	input logic clk, clk50, reset,
	input logic [31:0] PC, InstrReg, RD1, RD2, result, ReadDataW,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);


	logic [31:0] peekedReg;
	logic [15:0] truncReg;
	logic [3:0] hex[5:0];
	logic [7:0] Count;

	assign hex[0] = truncReg[3:0];
	assign hex[1] = truncReg[7:4];
	assign hex[2] = truncReg[11:8];
	assign hex[3] = truncReg[15:12];

	//module counter( input logic CLKb, CLK_50MHz, CLR, output logic [7:0] Q );
	counter counter(.clk(clk), .reset(reset), .Q(Count));
	
	//combinational logic to deciede what is displayed on the HEX displays
	always_comb
	begin
		case(peek)
			0:begin
				case(peekEn)
				0:begin
					peekedReg = peekRF;
				end
				1:begin
					case(SW)
					0: peekedReg = PC;
					1: peekedReg = InstrReg;
					2: peekedReg = RD1;
					3: peekedReg = RD2;
					4: peekedReg = result;
					5: peekedReg = ReadDataW;
					default: peekedReg = 32'b0;
					endcase
				end
				endcase
			end
			1: peekedReg = PC;
		endcase
	end
	
	always_comb
	begin
		if (lowHigh == 1'b0) //if sw5 is down
			truncReg = peekedReg[15:0]; //lower half is displayed on hex's
		else //if sw5 is down
			truncReg = peekedReg[31:16]; //upper half is displayed on hex's
	end
	
	//Hex Displays
	sevSegDec H0(.in(hex[0]), .HEX(HEX0));
	sevSegDec H1(.in(hex[1]), .HEX(HEX1));
	sevSegDec H2(.in(hex[2]), .HEX(HEX2));
	sevSegDec H3(.in(hex[3]), .HEX(HEX3));
	sevSegDec H4(.in(Count[3:0]), .HEX(HEX4));
	sevSegDec H5(.in(Count[7:4]), .HEX(HEX5));

endmodule 