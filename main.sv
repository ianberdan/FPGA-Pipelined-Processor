/*
	File Name: main.sv (from "top.sv" in the book)
	Written By: Harris and Harris 
	HDL Example 7.13
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Top Level File for pipelined arm processor
*/

module project3(
	input logic clk, reset, peek, clk50, lowHigh, peekEn,
	input logic [3:0] SW,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output logic [9:0] LED
);
	
	logic [31:0] PCFet, InstrFet, ReadDataMem, WriteDataMem, DataAdrMem;
	logic clkDeb, MemWriteMem;
	
	//debouncer provided by Dr. Hansen
	debouncer debbie(.D(clk), .clk_50M(clk50), .D_deb(clkDeb));
	
	//entire processor logic and connections here
	arm arm(.clk(clkDeb), .reset(reset), .Instr(LED), .PCFet(PCFet), .InstrFet(InstrFet), .MemWriteMem(MemWriteMem), .ALUOutMem(DataAdrMem), .WriteDataMem(WriteDataMem), .ReadDataMem(ReadDataMem),
		.peek(peek), .lowHigh(lowHigh), .peekEn(peekEn), .SW(SW), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
		
	//instruction and data memories
	imem imem(.a(PCFet), .rd(InstrFet));
	dmem dmem(.clk(clkDeb), .we(MemWriteMem), .a(DataAdrMem), .wd(WriteDataMem), .rd(ReadDataMem));
	
endmodule
