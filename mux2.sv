/*
	File Name: mux2.sv
	Written By: Harris and Harris 
	HDL Example 7.11
	Date: 11/14/2020
	Description:
				creates a variable width 2 input mux.
*/

module mux2 #(parameter WIDTH = 8)(
	input logic [WIDTH-1:0] d0, d1,
	input logic s,
	output logic [WIDTH-1:0] y
);

	assign y = s ? d1 : d0;

endmodule 
