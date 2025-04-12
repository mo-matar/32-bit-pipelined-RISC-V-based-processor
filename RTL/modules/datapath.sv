module datapath (
    input logic clk, reset,
    // Memory data
    input logic [31:0] InstrF, ReadDataM,
    output logic [31:0] PCF, ALUResultM, writeDataM,
    // Control signals
    input logic RegWriteW, ALUSrcAE,
    input logic [1:0] ALUSrcBE,
    input logic [1:0] result_srcW,
    input logic PCJalSrcE, PCSrcE,
    input logic [3:0] ALUControlE,
    input logic [2:0] ImmSrcD,
    output logic signE, zeroE,
    output logic [6:0] opD,
    output logic [2:0] funct3D, 
    output logic funct7b5D,
    // output logic [31:0] InstrD,
    // Hazard Unit
    input logic stallF, stallD, flushD, flushE,
    input logic [1:0] forwardAE, forwardBE,
    output logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
);

    // Fetch stage signals 
    logic [31:0] PCPlus4F; 
    logic [31:0] jal_jalr_PC;
    logic [31:0] PCNextF;
    // Decode stage signals 
    logic [31:0] InstrD; 
    logic [31:0] PCD, PCPlus4D; 
    logic [31:0] RD1D, RD2D; 
    logic [31:0] ImmExtD; 
    logic [4:0]  RdD; 
    // Execute stage signals 
    logic [31:0] RD1E, RD2E; 
    logic [31:0] PCE, ImmExtE; 
    logic [31:0] SrcAE, SrcBE, SrcAEforward; 
    logic [31:0] ALUResultE; //!good
    logic [31:0] WriteDataE; 
    logic [31:0] PCPlus4E; 
    logic [31:0] PCTargetE; //!good
    // Memory stage signals 
    logic [31:0] PCPlus4M; 
    // Writeback stage signals 
    logic [31:0] ALUResultW; 
    logic [31:0] ReadDataW; 
    logic [31:0] PCPlus4W; 
    logic [31:0] ResultW;

    //Internal signals
    


    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~PIPELINED STAGES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    //Fetch Stage
    mux2 jal_jalr_mux (PCTargetE, ALUResultE, PCJalSrcE, jal_jalr_PC);
    mux2 NextPC (PCPlus4F, jal_jalr_PC, PCSrcE, PCNextF);
    flopenr #(32) PC_reg (clk, reset, ~stallF, PCNextF, PCF);
    adder PC_Plus4_Adder (PCF, 4, PCPlus4F);

    //IF\ID reg
    flopenrc #(96) IF_ID_reg (clk, reset, flushD, ~stallD,
                        {InstrF, PCF, PCPlus4F},
                        {InstrD, PCD, PCPlus4D});
    
    // Decode stage
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];
    assign funct3D = InstrD[14:12];
    assign funct7b5D = InstrD[30];
    assign opD = InstrD[6:0];

    reg_file rf (
                .clk(clk),
                .rs1_addr(Rs1D),
                .rs2_addr(Rs2D),
                .rd_addr(RdW),
                .regf_write_data(ResultW),
                .reg_write(RegWriteW),
                .read_data1(RD1D),
                .read_data2(RD2D)
                );


    imm_extender imm_extender (
                .instr(InstrD[31:7]),
                .immSrc(ImmSrcD),
                .imm(ImmExtD)
                );

    //ID\EX reg
    floprc #(175) ID_EX_reg (clk, reset, flushE,
                        {RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D},
                        {RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E});
    
    // Execute stage
    mux3 forwardA_mux (RD1E, ResultW, ALUResultM, forwardAE, SrcAEforward);
    mux2 srcA_mux (SrcAEforward, 32'b0, ALUSrcAE, SrcAE);
    mux3 forwardB_mux (RD2E, ResultW, ALUResultM, forwardBE, WriteDataE);
    mux3 srcB_mux (WriteDataE, ImmExtE, PCTargetE, ALUSrcBE, SrcBE);
    adder jal_adder (PCE, ImmExtE, PCTargetE);
    alu ALU (
                .A(SrcAE),
                .B(SrcBE),
                .ALUControl(ALUControlE),
                .ALUResult(ALUResultE),
                .zero(zeroE),
                .sign(signE)
                
            );
    
    //EX\MEM reg
    flopr #(101) EX_MEM_reg (clk, reset,
                            {ALUResultE, WriteDataE, RdE, PCPlus4E},
                            {ALUResultM, writeDataM, RdM, PCPlus4M}
                            );

    //MEM\WB reg
    flopr #(101) MEM_WB_reg (clk, reset,
                            {ALUResultM, ReadDataM, RdM, PCPlus4M},
                            {ALUResultW, ReadDataW, RdW, PCPlus4W}
                            );
    // Writeback stage
    mux3 result_mux (ALUResultW, ReadDataW, PCPlus4W, result_srcW, ResultW);
    
endmodule