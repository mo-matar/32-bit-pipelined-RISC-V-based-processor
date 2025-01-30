module imm_extender (
    input logic [31:0] instr,
    input logic [2:0] immSrc,
    output logic [31:0] imm
);
 
always_comb begin
    case (immSrc)
        3'b000:  imm = {{20{instr[31]}}, instr[31:20]};//I-Type
        3'b001:  imm =  {{20{instr[31]}}, instr[31:25], instr[11:7]};//S-Type
        3'b010:  imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};//B-Type
        3'b011:  imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};//J-Type
        3'b100:  imm = {instr[31:12], 12'b0};//U-Type
        default: imm = 32'bx;
    endcase
end 	  
endmodule