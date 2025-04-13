`define RD_Ex 2'b00
`define RD_Mem 2'b10
`define RD_WB 2'b01
module hazard_unit(input  logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW, 
input  logic       PCSrcE, ResultSrcEb0,  
input  logic       RegWriteM, RegWriteW, 
output logic [1:0] ForwardAE, ForwardBE, 
output logic       StallF, StallD, FlushD, FlushE); 
logic lwStallD; 
// forwarding logic 
always_comb begin 
    ForwardAE = `RD_Ex; 
    ForwardBE = `RD_Ex; 
    if (Rs1E != 5'b0) 
    if      ((Rs1E == RdM) & RegWriteM) ForwardAE = `RD_Mem; 
    else if ((Rs1E == RdW) & RegWriteW) ForwardAE = `RD_WB; 
    if (Rs2E != 5'b0) 
    if      ((Rs2E == RdM) & RegWriteM) ForwardBE = `RD_Mem; 
    else if ((Rs2E == RdW) & RegWriteW) ForwardBE = `RD_WB; 
end 
// stalls and flushes 
assign lwStallD = ResultSrcEb0 & ((Rs1D == RdE) | (Rs2D == RdE));   
assign StallD   = lwStallD; 
assign StallF   = lwStallD; 
assign FlushD   = PCSrcE; 
assign FlushE   = lwStallD | PCSrcE; 
endmodule 