/*
	File Name: counter.sv
	Written By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
		Counts by 1 each time the clock is clicked since the last reset		
*/

module counter(
	input logic clk, reset,
	output logic [7:0] Q
);

	always_ff@(negedge clk)
		begin
			if(reset)
				Q <= 8'b0;
			else
				Q <= Q + 1'b1;
		end

endmodule 