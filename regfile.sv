/*
	File Name: regfile.sv
	Written By: Harris and Harris 
	HDL Example 7.6
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Creates a 16 wide register file. A peek button was added to the origional file
*/

module regfile(
	input logic clk, we3,
	input logic [3:0] ra1, ra2, wa3, SW, //peek was added to loook into registers
	input logic [31:0] wd3, r15,
	output logic [31:0]  rd1, rd2, peekRF
);

	logic [31:0] rf[14:0]; //two dimensional array
  
	always_ff @(negedge clk) 
		if (we3) rf[wa3] <= wd3; //!! if we3 = 1, wd3 is loaded into rf number wa3 
	  
	assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1]; // if ra1 = 4'b1111, rd1 = 15, else rd1 = rf number ra1
	assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2]; // if ra2 = 4'b1111, rd2 = 15, else rd2 = rf number ra2
	assign peekRF = (SW == 4'b1111) ? r15 : rf[SW]; // if SW = 4'b1111, peakRF = 15, else peakRF = rf number SW
  
endmodule 

