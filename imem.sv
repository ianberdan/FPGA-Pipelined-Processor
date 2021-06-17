/*
	File Name: imem.sv
	Written By: Harris and Harris 
	HDL Example 7.15
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Instruction memory. Reads a datafile for initialization
*/

module imem(
	input logic [31:0] a,
   output logic [31:0] rd
);

	logic [31:0] RAM[63:0];
	 
	initial
		$readmemb("memfile.dat",RAM);
	  
	assign rd = RAM[a[31:2]]; // word aligned
	 
endmodule
