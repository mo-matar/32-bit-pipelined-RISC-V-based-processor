module PCSrc_generator (
    input logic funct3b0,
    input logic funct3b2,
    input logic zero,
    input logic sign,
    output logic taken
);

always_comb begin : truth_table
    casez ({funct3b2, funct3b0, sign, zero})
        //for beq, sign is don't care
        4'b00_0_1: taken = 1'b1;
        4'b00_1_1: taken = 1'b1;
        //for bne, sign is don't care
        4'b01_0_0: taken = 1'b1;
        4'b01_1_0: taken = 1'b1;
        //for blt, zero is don't care
        4'b10_1_0: taken = 1'b1;
        4'b10_1_1: taken = 1'b1;
        //for bge, zero is don't care
        4'b11_0_0: taken = 1'b1; 
        4'b11_0_1: taken = 1'b1; 
        
        default:   taken = 1'b0; 
    endcase
end


    
endmodule