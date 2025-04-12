module riscv (
    input logic clk, reset,
    output logic [31:0] PCF,
    input logic [31:0] InstrF, 
    output logic MemWriteM,
    output logic [31:0] ALUResultM, WriteDataM,
    input logic [31:0] readDataM
);
    logic RegWriteW, ALUSrcAE, PCJalSrcE, PCSrcE, signE, zeroE, funct7b5D,
          stallF, stallD, flushD, flushE, ResultSrcEb0, RegWriteM;
    logic [2:0] ImmSrcD, funct3D;
    logic [1:0] ALUSrcBE;
    logic [1:0] ResultSrcW, forwardAE, forwardBE;
    logic [3:0] ALUControlE;
    logic [6:0] opD;
    logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
    


    datapath dp (
                clk, reset, InstrF, readDataM, PCF, ALUResultM, WriteDataM,
                //control signals
                RegWriteW, ALUSrcAE, ALUSrcBE, ResultSrcW, PCJalSrcE, PCSrcE, ALUControlE, ImmSrcD,
                signE, zeroE, opD, funct3D, funct7b5D,
                //hazard unit signals
                stallF, stallD, flushD, flushE, forwardAE, forwardBE,
                Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW
                );

    controller c (
                  clk, reset, opD, funct3D, funct7b5D, zeroE, signE, flushE,
                  ResultSrcW, MemWriteM, PCSrcE, ALUSrcAE, PCJalSrcE, ALUSrcBE,
                  ResultSrcEb0, RegWriteM, RegWriteW, ImmSrcD, ALUControlE
                  );
    hazard_unit h (
                  Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
                  PCSrcE, ResultSrcEb0, RegWriteM, RegWriteW,
                  forwardAE, forwardBE,
                  stallF, stallD, flushD, flushE
                  );
endmodule