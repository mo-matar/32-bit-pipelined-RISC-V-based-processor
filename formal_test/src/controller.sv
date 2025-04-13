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
                      output logic       ResultSrcEb0,// used to know if the instruction is related to memory (hazard unit)
                      output logic       RegWriteM,// output for hazard unit
                      output logic       RegWriteW,// output for hazard unit and datapath reg file
                      output logic [2:0] ImmSrcD,
                      output logic [3:0] ALUControlE);
    //some wires connecting the controller with external components
    logic RegWriteD, RegWriteE;
    logic [1:0] ResultSrcD, ResultSrcE, ResultSrcM;
    logic MemWriteD, MemWriteE;
    logic JumpD, JumpE;
    logic BranchD, BranchE;
    logic [3:0] ALUControlD;
    logic ALUSrcAD;
    logic [1:0] ALUSrcBD;
    logic [1:0] ALUOp;
    logic branchTaken, PCJalSrcD;


 maindec md(op, ResultSrcD, MemWriteD, ALUSrcAD, PCJalSrcD, ALUSrcBD, 
            ImmSrcD, JumpD, BranchD, RegWriteD, ALUOp);
 aludec  ad(op[5], funct3, funct7b5, ALUOp, ALUControlD);


 floprc #(14) controlRegE (clk, reset, FlushE, 
                        {RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcAD, ALUSrcBD, PCJalSrcD},
                        {RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcAE, ALUSrcBE, PCJalSrcE});

 flopr #(4) controlRegM (clk, reset,
                         {RegWriteE, ResultSrcE, MemWriteE},
                         {RegWriteM, ResultSrcM, MemWriteM});
 
 flopr #(3) controlRegW (clk, reset,
                         {RegWriteM, ResultSrcM},
                         {RegWriteW, ResultSrcW});



 PCSrc_generator branch_taken_generator (funct3[0], funct3[2], ZeroE, SignE, branchTaken);
 assign PCSrcE = JumpE | (BranchE & branchTaken);
 assign ResultSrcEb0 = ResultSrcE[0];
 endmodule