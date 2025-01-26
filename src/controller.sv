 module controller(   input  logic       clk,
					  input  logic       reset,	
	                  input  logic [6:0] op,
                      input  logic [2:0] funct3,
                      input  logic       funct7b5,
                      input  logic       ZeroE,
					  input  logic       SignE,
                      input  logic       FlushE, //this is for the directly connected control registers ID/IE_C which are also part of the controller
                      output logic [1:0] ResultSrcW,
                      output logic       MemWriteM,
                      output logic       PCSrcE, ALUSrcAE, PCJalSrcE,
                      output logic [1:0] ALUSrcBE,
                      output logic       ResultSrcEb0,
                      output logic       RegWriteM,// output for hazard unit
                      output logic       RegWriteW,// output for hazard unit and datapath reg file
                      output logic [2:0] ImmSrcD,
                      output logic [2:0] ALUControlE);
    //some wires connecting the controller with external components
    logic RegWriteD, RegWriteE;
    logic [1:0] ResultSrcD, ResultSrcE, ResultSrcM;
    logic MemWriteD, MemWriteE;
    logic JumpD, JumpE;
    logic BranchD, BranchE;
    logic [2:0] ALUControlD;
    logic ALUSrcAD;
    logic [1:0] ALUSrcBD;
    logic [1:0] ALUOp;

    //TODO: write the connections of the intermediate control registers
 

    //TODO: write maindec and aludec
    maindec md(op, ResultSrc, MemWrite, Branch,ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
    aludec   ad(op[5], funct3, funct7b5, ALUOp, ALUControl);
    assign PCSrc = //TODO: write PCSrc logic
    assign PCJalSrcE = //TODO: write the jal/jalr mux logic
 endmodule
