module datapath (
    input logic clk, reset,
    // Memory data
    input logic [31:0] instF, readDataM,
    output logic [31:0] PCF, ALUResultM, writeDataM,
    // Control signals
    input logic reg_writeD, immsrcD, ALUSrcAE,
    input logic [1:0] ALUSrcBE,
    input logic mem_writeM,
    input logic [1:0] result_srcW, ALUOp,
    input logic jumpE, PCJalSrcE, PCSrcE,
    input logic [3:0] ALUControl,
    input logic [2:0] immSrcD,
    output logic sign, zero,
    output logic [31:0] InstD,
    // Hazard Unit
    input logic stallF, stallD, flushD, flushE,
    input logic [1:0] forwardAE, forwardBE,
    output logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
);

    // Fetch stage signals 
    logic [31:0] PCPlus4F; 
    // Decode stage signals 
    logic [31:0] InstrD; 
    logic [31:0] PCD, PCPlus4D; 
    logic [31:0] RD1D, RD2D; 
    logic [31:0] ImmExtD; 
    logic [4:0]  RdD; 
    // Execute stage signals 
    logic [31:0] RD1E, RD2E; 
    logic [31:0] PCE, ImmExtE; 
    logic [31:0] SrcAE, SrcBE; 
    logic [31:0] ALUResultE; 
    logic [31:0] WriteDataE; 
    logic [31:0] PCPlus4E; 
    logic [31:0] PCTargetE; 
    // Memory stage signals 
    logic [31:0] PCPlus4M; 
    // Writeback stage signals 
    logic [31:0] ALUResultW; 
    logic [31:0] ReadDataW; 
    logic [31:0] PCPlus4W; 
    logic [31:0] ResultW;

    //Internal signals

    logic [31:0] PCTargetE;
    logic [31:0] ALUResultE, ALUResultW;
    logic [31:0] jal_jalr_PC, PCNextF, PCPlus4F,
                PCPlus4D, PCPlus4E, PCPlus4W, PCD, PCE; 
    logic [31:0] instD;
    


    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~PIPELINED STAGES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    //Fetch
    mux2 jal_jalr_mux (PCTargetE, ALUResultE, PCJalSrcE, jal_jalr_PC);
    mux2 NextPC (PCPlusF, jal_jalr_PC, PCSrcE, PCNextF);
    flopenr #(32) PC_reg (clk, reset, ~stallF, PCNextF, PCF);
    adder PC_Plus4_Adder (PCF, 32d'4, PCPlus4F);

    //IF\ID reg
    flopenrc #(96) IF_ID_reg (clk, reset, flushD, ~stallD,
                        {instF, PCF, PCPlus4F},
                        {instD, PCD, PCPlus4D});
    
    assign Rs1D = instD[19:15];
    assign Rs2D = instD[24:20];
    assign RdD = instD[11:7];
    assign InstD = instD;
    
    // Decode stage
    regfile rf (
        .clk(clk),
        .we3(reg_writeW),
        .a1(instD[19:15]), 
        .a2(instD[24:20]), 
        .a3(RdW),
        .wd3(ResultW),
        .rd1(RD1D), 
        .rd2(RD2D)
    );
    
    imm_extender ext_unit (
        .instr(instD[31:7]),
        .immsrc(immSrcD),
        .immext(ImmExtD)
    );

    // ID/EX register
    flopenrc #(174) ID_EX_reg (
        .clk(clk),
        .reset(reset),
        .clear(flushE),
        .en(1'b1),
        .d({RD1D, RD2D, PCD, ImmExtD, instD[19:15], instD[24:20], instD[11:7], PCPlus4D}),
        .q({RD1E, RD2E, PCE, ImmExtE, Rs1E, Rs2E, RdE, PCPlus4E})
    );

    // Execute stage
    mux3 #(32) forwardAmux (
        .d0(RD1E),
        .d1(ResultW),
        .d2(ALUResultM),
        .s(forwardAE),
        .y(ForwardAEOut)
    );
    
    mux3 #(32) forwardBmux (
        .d0(RD2E),
        .d1(ResultW),
        .d2(ALUResultM),
        .s(forwardBE),
        .y(WriteDataE)
    );
    
    mux2 #(32) srcAmux (
        .d0(ForwardAEOut),
        .d1(PCE),
        .s(ALUSrcAE),
        .y(SrcAE)
    );
    
    mux3 #(32) srcBmux (
        .d0(WriteDataE),
        .d1(ImmExtE),
        .d2(32'd4),
        .s(ALUSrcBE),
        .y(SrcBE)
    );
    
    alu alu_unit (
        .a(SrcAE),
        .b(SrcBE),
        .ALUControl(ALUControl),
        .ALUResult(ALUResultE),
        .Zero(zero),
        .Sign(sign)
    );
    
    adder pc_target_adder (
        .a(PCE),
        .b(ImmExtE),
        .y(PCTargetE)
    );
    
    // EX/MEM register
    flopr #(101) EX_MEM_reg (
        .clk(clk),
        .reset(reset),
        .d({ALUResultE, WriteDataE, RdE, PCPlus4E}),
        .q({ALUResultM, writeDataM, RdM, PCPlus4M})
    );
    
    // Memory stage implemented through inputs/outputs
    // (memory operations handled externally)
    
    // MEM/WB register
    flopr #(101) MEM_WB_reg (
        .clk(clk),
        .reset(reset),
        .d({ALUResultM, readDataM, RdM, PCPlus4M}),
        .q({ALUResultW, ReadDataW, RdW, PCPlus4W})
    );
    
    // Writeback stage
    mux3 #(32) result_mux (
        .d0(ALUResultW),
        .d1(ReadDataW),
        .d2(PCPlus4W),
        .s(result_srcW),
        .y(ResultW)
    );
endmodule