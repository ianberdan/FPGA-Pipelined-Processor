//File Name: sevsegdec.sv
//Authors: Bailey Dergan & Ian Berdan
//Date: 4/6/2020
//Description: 
		// seven segment display to display the numbers 

module sevSegDec(
	input logic [3:0] in,
	output logic [6:0] HEX
);

always_comb
	case(in)
		0:	HEX=7'b100_0000;
		1:	HEX=7'b111_1001;
		2:	HEX=7'b010_0100;
		3:	HEX=7'b011_0000;
		4:	HEX=7'b001_1001;
		5:	HEX=7'b001_0010;
		6:	HEX=7'b000_0010;
		7:	HEX=7'b111_1000;
		8:	HEX=7'b000_0000;
		9:	HEX=7'b001_1000;
		10:	HEX=7'b000_1000;
		11:	HEX=7'b000_0011;
		12:	HEX=7'b010_0111;
		13:	HEX=7'b010_0001;
		14:	HEX=7'b000_0110;
		15:	HEX=7'b000_1110;
		default: HEX=7'b111_1111;
	endcase
	
endmodule
