/*******************************************
* Author: Dr. Hansen
* Date: Feb. 8, 2017
* 
* Description: a button/switch debouncer. Takes always
*	noisy input (D) and ensures only one change
*   of logic appears at the output (D_deb). For 
*   a bouncy input, the output will change after 67ms.
* 
* Inputs: 
*     D: 	1-bit noisy input
*     clk_50M:	50 MHz clock from the Altera 
*				board
*
* Outputs:
*		D_deb:	the debounced input
*
* Change log:
* 		02/08/17 - initial creation of debouncer
*		02/08/18 - updated to SystemVerilog
********************************************/

module debouncer( 
	input logic D, clk_50M, 
	output logic D_deb 
);

	parameter deb_count = 32'd1_666_667; //15Hz

	integer count;

	logic deb_clk, A_out;

	D_FF_preset_reset A(.D( D ), 
						.clk( deb_clk ), 
						.pr_L( ~D_deb | ~D |  A_out ), 
						.clr_L( D_deb |  D | ~A_out ), 
						.Q( A_out ) );
								
	D_FF_preset_reset B(.D( A_out ), 
						.clk( deb_clk ), 
						.pr_L( 1'b1 ), //~D
						.clr_L( 1'b1 ), //D
						.Q( D_deb ) );
	
	always@(posedge clk_50M)
	begin
		count <= count + 1;
		if ( count == deb_count )
		begin
			deb_clk <= ~deb_clk;
			count <= 32'd0;
		end
	end

endmodule

//D-Flip Flip with Asynchronous preset/reset
//only to be used with debouncer!
module D_FF_preset_reset( 
	input logic D, clk, pr_L, clr_L, 
	output logic Q );
	
	always@(posedge clk, negedge pr_L, negedge clr_L)
	begin
	
		if (!pr_L)
			Q <= 1'b1;
		else if (!clr_L)
			Q <= 1'b0;
		else if (clk)
			Q <= D;
	
	end

endmodule
