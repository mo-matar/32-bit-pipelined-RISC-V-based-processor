module riscv (
    input logic clk, reset,
    output logic [31:0] PCF,
    input logic [31:0] InstrF, 
    output logic MemWriteM,
    output logic [31:0] ALUResultM, WriteDataM,
    input logic [31:0] readDataM
);
    logic RegWriteW, ALUSrcAE, PCJalSrcE, PCSrcE;
    logic [2:0] ImmSrcD;
    logic [1:0] ALUSrcBE;
    logic [1:0] ResultSrcW;
    


    datapath dp (clk, reset, InstrF, readDataM, PCF, ALUResultM, WriteDataM, RegWriteW,
                 ALUSrcAE, ALUSrcBE, MemWriteM, ResultSrcW, PCJalSrcE, PCSrcE, 
                );

    controlpath c ();
    hazard_unit h ();
endmodule