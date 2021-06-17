/*
	File Name: controller.sv
	Written By: Based off of Harris and Harris 
	HDL Example 7.2 and 7.3
	Edited By: Ian Berdan and Eric Olson
	Date: 11/14/2020
	Description:
				Controlls the instructions given Goes through the decoder along with the conditional logic.
*/

module controller(
	input logic clk, reset,
	input logic [31:12] InstrDec,
	input logic [3:0] ALUFlagsExe,
	output logic [1:0] RegSrcDec, ImmSrcDec, ALUControlExe,
	output logic ALUSrcExe, MemWriteMem, MemtoRegWri, PCSrcWri, RegWriteWri
);

	logic [9:0] controlsDec;
	logic [3:0] FlagsExe, FlagsNextExe, CondExe;
	logic [1:0] ALUControlDec, FlagWriteDec, FlagWriteExe, op;
	logic CondExExe, ALUOpDec, RegWriteDec, RegWriteExe, RegWriteLogicExe, MemtoRegExe, MemWriteDec, MemWriteExe, MemWriteLogicExe;
	logic ALUSrcDec, PCSrcNew, MemtoRegDec, MemtoRegMem, BranchDec, BranchExe, PCSrcDec, PCSrcExe, PCSrcMem;
	logic PCSrcLogicExe, RegWriteMem, DataAdrMem, WriteDataMem, BTakenExe, funct5, funct0;
	
	assign op = InstrDec[27:26];
	assign funct5 = InstrDec[25];
	assign funct0 = InstrDec[20];
	
	//decodes each instruction set. Sets values based off of table 7.2 in the book
	always_comb
	casex(op)
		0: if (funct5 == 1'b1)
				controlsDec = 10'b0_0_0_1_00_1_00_1;
			else
				controlsDec = 10'b0_0_0_0_00_1_00_1;
		1: if (funct0 == 1'b1)
				controlsDec = 10'b0_1_0_1_01_1_00_0;
			else
				controlsDec = 10'b0_1_1_1_01_0_10_0;
		2: 	controlsDec = 10'b1_0_0_1_10_0_01_0;
		default: controlsDec = 10'bxxxxxxxxxx;
	endcase
	
	//order for the logic above. reduced to one variable
	assign {BranchDec, MemtoRegDec, MemWriteDec, ALUSrcDec, ImmSrcDec, RegWriteDec, RegSrcDec, ALUOpDec} = controlsDec;
	
	//decodes the alu instructions based off of table 7.3 in the book
	always_comb
	if (ALUOpDec) 
	begin
		case(InstrDec[24:21]) //takes the funct field
			4: ALUControlDec = 2'b00; // ADD 
			2: ALUControlDec = 2'b01; // SUB 
			0: ALUControlDec = 2'b10; // AND 
			12: ALUControlDec = 2'b11; // ORR 
			default: ALUControlDec = 2'bxx;
		endcase
		//logic based off of example 7.3 decoder
		FlagWriteDec[1] = funct0;
		FlagWriteDec[0] = funct0 & (ALUControlDec == 2'b00 | ALUControlDec == 2'b01); 
	end else begin
		ALUControlDec = 2'b00;
		FlagWriteDec = 2'b00; // no flag update
	end
	
	assign PCSrcDec = ( BranchDec | ((InstrDec[15:12] == 4'b1111) & RegWriteDec));
	
	condlogic cl(.Cond(CondExe), .Flags(FlagsExe), .ALUFlags(ALUFlagsExe), .FlagWrite(FlagWriteExe), .CondEx(CondExExe), .FlagsNext(FlagsNextExe));
	
	flopr #(18) regsExe(.clk(clk), .reset(reset),
		.d({FlagWriteDec, BranchDec, MemWriteDec, RegWriteDec, PCSrcDec, MemtoRegDec, ALUSrcDec, ALUControlDec, InstrDec[31:28], FlagsNextExe}),
		.q({FlagWriteExe, BranchExe, MemWriteExe, RegWriteExe, PCSrcExe, MemtoRegExe, ALUSrcExe, ALUControlExe, CondExe, FlagsExe}));
	
	//logic gates in execute stage coming from conditional logic
	assign PCSrcNew = BTakenExe | PCSrcLogicExe;
	assign PCSrcLogicExe = PCSrcExe & CondExExe;
	assign RegWriteLogicExe = RegWriteExe & CondExExe;
	assign MemWriteLogicExe = MemWriteExe & CondExExe;
	assign BTakenExe = BranchExe & CondExExe;
	
	//MemStage
	flopr #(4) regsM(.clk(clk), .reset(reset), .d({MemWriteLogicExe, MemtoRegExe, RegWriteLogicExe, PCSrcNew}),
						  .q({MemWriteMem, MemtoRegMem, RegWriteMem, PCSrcMem}));
	
	//Writeback stage
	flopr #(3) regsW(.clk(clk), .reset(reset), .d({MemtoRegMem, RegWriteMem, PCSrcMem}), .q({MemtoRegWri, RegWriteWri, PCSrcWri}));
	
endmodule 