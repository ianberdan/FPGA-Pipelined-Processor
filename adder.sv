/*
	File Name: adder.sv
	Written By: Harris and Harris 
	HDL Example 7.7 Adder
	Description:
				Adds input a and b. Outputs the sum.
*/
module adder #(parameter WIDTH=8)(
	input logic [WIDTH-1:0] a, b,
    output logic [WIDTH-1:0] y);
	 
 assign y = a + b;
endmodule
