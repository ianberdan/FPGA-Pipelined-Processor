/*
	File Name: dmem
	Written By: Harris and Harris 
	HDL Example 7.14
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Data Memory file
*/
module dmem(
	input logic clk, we,
	input logic [31:0] a, wd,
	output logic [31:0] rd
);

	logic [31:0] RAM[63:0];
	
	assign rd = RAM[a[31:2]]; 
	
	always_ff @(posedge clk)
		if (we) RAM[a[31:2]] <= wd;
		
endmodule
