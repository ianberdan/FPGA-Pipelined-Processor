/*
	File Name: arm.sv
	Written By: Harris and Harris 
	HDL Example 7.1
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
		"Sub top level" file for the arm processor. Output logic was added for the displays.
*/

module arm(
	input logic clk, reset, peek, lowHigh, peekEn,
	input logic [31:0] InstrFet, ReadDataMem,
	input logic [3:0] SW,
	output logic MemWriteMem,
	output logic [31:0] ALUOutMem, WriteDataMem, PCFet,
	output logic [9:0] Instr,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

	logic ALUSrcExe, PCSrcNew, MemtoRegWri, PCSrcWri, RegWriteWri;
	logic [1:0] RegSrcDec, ImmSrcDec, ALUControlExe;
	logic [3:0] ALUFlagsExe;
	logic [31:0] InstrDec, RD1_, RD2_, PC_, InstrDec_, ALUOutMem_, ReadDataWri_;
	
	//holds data for which register is being peeked into
	logic [31:0] peekRF;
	
	//debugging logic, uses LED's for displaying the first 10 bits of each register
	assign Instr = peekRF[9:0];
	
	controller c(.reset(reset), .clk(clk), .InstrDec(InstrDec[31:12]), .ALUFlagsExe(ALUFlagsExe),
				.RegSrcDec(RegSrcDec), .ImmSrcDec(ImmSrcDec), 
				.ALUSrcExe(ALUSrcExe), .ALUControlExe(ALUControlExe),
				.MemWriteMem(MemWriteMem),
				.MemtoRegWri(MemtoRegWri), .PCSrcWri(PCSrcWri), .RegWriteWri(RegWriteWri));

	datapath dp(.reset(reset), .clk(clk), 
				.RegSrcDec(RegSrcDec), .ImmSrcDec(ImmSrcDec), 
				.ALUSrcExe(ALUSrcExe), .ALUControlExe(ALUControlExe), 
				.MemtoRegWri(MemtoRegWri), .PCSrcWri(PCSrcWri), .RegWriteWri(RegWriteWri),
				.PCFet(PCFet), .InstrFet(InstrFet), .InstrDec(InstrDec), .peekRF(peekRF),
				.ALUOutMem(ALUOutMem), .WriteDataMem(WriteDataMem), .ReadDataMem(ReadDataMem),
				.ALUFlagsExe(ALUFlagsExe), .RD1_(RD1_), .RD2_(RD2_), .PC_(PC_), .SW(SW),
				.InstrDec_(InstrDec_), .ALUOutMem_(ALUOutMem_), .ReadDataWri_(ReadDataWri_));

	//output logic added
	outputlogic outputlogic(.peek(peek), .lowHigh(lowHigh),
				.peekEn(peekEn), .SW(SW), .peekRF(peekRF), 
				.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), 
				.HEX4(HEX4), .HEX5(HEX5), .clk(clk), 
				.reset(reset), .PC(PC_), .InstrReg(InstrDec_), .RD1(RD1_), .RD2(RD2_), 
				.ReadDataW(ReadDataWri_), .result(ALUOutMem_));
				
endmodule
