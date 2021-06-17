/*
	File Name: alu.sv
	Written By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Arithmetic Logic Unit (ALU) that performs arethmetic operaions:
				Addition, Subtraction, bitwise AND, and bitwise OR
				
*/
module alu(
	input logic [31:0] A, B,
	input logic [1:0] ALUControl,
	output logic [3:0] ALUFlags,
	output logic [31:0] result

);

	//negative, zero, carry, overflow
	logic n, z, c, o;
	logic [31:0] test;
	
	// the sum was given an extra bit to test for carry
	logic [32:0] sum;
	
	//uses two's compliment
	always_comb
	begin
		if(ALUControl[0] == 1'b1)
			test = ~B + 1'b1;
		else
			test = B;
	end
	
	//assigns sum to either be addition or two's compliment subtraction
	assign sum = test + A;
	
	always_comb
	begin
		casex (ALUControl[1:0])
			0: result = sum;          //add
			1: result = sum;  		  //sub (uses same logic)
			2: result = A & B;		  //and
			3: result = A | B; 		  //or
		endcase
	end
	
	assign n = result[31]; //tests the most significant bit for a 1 (negative) or a 0 (positive)
	assign z = (result == 32'b0); //tests if every bit is 0 to show a zero value
	assign c = (~ALUControl[1]) & sum[32]; // tests to see if carry bit occured in addition sum[32] = 1'b1 (can only happen in case 0,1)
	assign o = (~ALUControl[1]) & (A[31] ^ sum[31]) & ~(A[31] ^ B[31] ^ ALUControl[0]); //tests overflow (can only happen in case 0,1)
	assign ALUFlags = {n, z, c, o}; //reduces overall output of the flags
	
endmodule 
