/*
	File Name: flopr.sv
	Written By: Harris and Harris 
	HDL Example 7.9
	Date: 11/14/2020
	Description:
				Resettable flip-flop without enable
*/

module flopr #(parameter WIDTH = 8)(
	input logic clk, reset,
	input logic [WIDTH-1:0] d,
	output logic [WIDTH-1:0] q
);

	always_ff @(negedge clk, posedge reset)
		if(reset) q <= 0;
		else q <= d;

endmodule 