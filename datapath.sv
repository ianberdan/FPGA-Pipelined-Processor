/*
	File Name: controller.sv
	Written By: Harris and Harris 
	HDL Example 7.5
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Creates the connections between the five stages of the pipelined processor and the modules.
*/

module datapath(
	input logic clk, reset, ALUSrcExe, MemtoRegWri, PCSrcWri, RegWriteWri,
	input logic [1:0] RegSrcDec, ImmSrcDec, ALUControlExe,
	input logic [3:0] SW,
	input logic [31:0] InstrFet, ReadDataMem,
	output logic [3:0] ALUFlagsExe,
	output logic [31:0] PCFet, InstrDec, ALUOutMem, WriteDataMem, peekRF, RD1_, RD2_, PC_, InstrDec_, ALUOutMem_, ReadDataWri_
);
	
	//logic outputs for peek displays
	assign RD1_ = rd1E;
	assign RD2_ = rd2E;
	assign PC_ = PCFet;
	assign InstrDec_ = InstrDec;
	assign ALUOutMem_ = ALUOutMem;
	assign ReadDataWri_ = ReadDataWri;
	
	//used to skip register
	assign PCPlus8Dec = PCPlus4Fet;
	
	//wires
	logic [3:0] RA1D, RA2D, WA3E, WA3M, WA3W;
	logic [31:0] PCPlus4Fet, PCnext1Fet, PCnextFet, ExtImmDec, rd1D, rd2D, PCPlus8Dec, rd1E, rd2E, ExtImmExe, SrcBExe, ALUResultExe, 
		ReadDataWri, ALUOutWri, ResultWri;
	
	
	//* All stages for the actual pipelined processor are connected here *\\
	
	//Fetch stage
	flopr #(32) pcreg(.clk(clk), .reset(reset), .d(PCnext1Fet), .q(PCFet));
	mux2 #(32) nextpc(.d0(PCPlus4Fet), .d1(ResultWri), .s(PCSrcWri), .y(PCnext1Fet));
	adder #(32) pcP4(.a(PCFet), .b(32'h4), .y(PCPlus4Fet));
	
	//Decode Stage
	flopr #(32) instruction(.clk(clk), .reset(reset), .d(InstrFet), .q(InstrDec));
	mux2 #(4) adr1(.d0(InstrDec[19:16]), .d1(4'b1111), .s(RegSrcDec[0]), .y(RA1D));
	mux2 #(4) adr2(.d0(InstrDec[3:0]), .d1(InstrDec[15:12]), .s(RegSrcDec[1]), .y(RA2D));
	regfile registerFile(.clk(clk), .ra1(RA1D), .we3(RegWriteWri), .ra2(RA2D), .wa3(WA3W), .wd3(ResultWri),
				  .r15(PCPlus8Dec), .rd1(rd1D), .rd2(rd2D), .peekRF(peekRF), .SW(SW));
	extend extImm(.Instr(InstrDec[23:0]), .ImmSrc(ImmSrcDec), .ExtImm(ExtImmDec));
	
	//Execute Stage	
	flopr #(100) regsExe(.clk(clk), .reset(reset),
		.d({rd1D, rd2D, ExtImmDec, InstrDec[15:12]}),
		.q({rd1E, rd2E, ExtImmExe, WA3E}));
	mux2 #(32) muxb(.d0(rd2E), .d1(ExtImmExe), .s(ALUSrcExe), .y(SrcBExe));
	alu alu(.A(rd1E), .B(SrcBExe), .ALUControl(ALUControlExe), .result(ALUResultExe), .ALUFlags(ALUFlagsExe));
	
	//Memory Stage
	flopr #(68) regsMem(.clk(clk), .reset(reset),
		.d({ALUResultExe, rd2E, WA3E}),
		.q({ALUOutMem, WriteDataMem, WA3M}));

	//Write Stage	
	flopr #(68) regsWri(.clk(clk), .reset(reset),
		.d({ALUOutMem, ReadDataMem, WA3M}),
		.q({ALUOutWri, ReadDataWri, WA3W}));
	mux2 #(32) resmux(.d0(ALUOutWri), .d1(ReadDataWri), .s(MemtoRegWri), .y(ResultWri));
	
endmodule
