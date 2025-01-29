`include "ALUControl_Defines.sv"
 module aludec(         input    logic opb5,
                        input    logic [2:0] funct3,
                        input    logic       funct7b5,
                        input    logic [1:0] ALUOp,
                        output logic [3:0] ALUControl);
    logic  RtypeSub;
    assign RtypeSub = funct7b5 & opb5;  // TRUE for R-type subtract
    always_comb
       case(ALUOp)
           2'b00:                      ALUControl = `SUM; // addition => sw, lw
           2'b01:                      ALUControl = `SUB; // subtraction => beq
           default: case(funct3) // R-type or I-type ALU
                         3'b000:       ALUControl = (RtypeSub ? `SUB : `SUM);					  
                         3'b001:       ALUControl = (funct7b5 ? `ROR : `SLL);
                         3'b010:       ALUControl = `SLT; // slt, slti
                         3'b011:       ALUControl = `SLTU; //sltu, sltui
                         3'b100:       ALUControl = `XOR; // xor, xori
                         3'b101:       ALUControl = (funct7b5 ? `SRA : `SRL); //srl srli, sra srai
                         3'b110:       ALUControl = `OR;//or, ori
                         3'b111:       ALUControl = `AND;//and, andi
                         default:      ALUControl = 4'bxxxx; // ???
                         endcase
         endcase
 endmodule