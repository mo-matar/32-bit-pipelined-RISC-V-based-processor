 module maindec(      input  logic [6:0] op,//
                      output logic [1:0] ResultSrc,//
                      output logic       MemWrite,//
                      output logic       ALUSrcA, PCJalSrc,//23
                      output logic [1:0] ALUSrcB,//
                      output logic [2:0] ImmSrc,//
					  output logic       Jump,//
					  output logic       Branch,
					  output logic       RegWrite,
					  output logic [1:0] ALUOp);//
    logic [14:0] controls;
    assign {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUOp, Jump, PCJalSrc} = controls;
    always_comb
	case(op)
		//1RegWrite_3ImmSrc_1ALUSrcA_2ALUSrcB_1MemWrite_2ResultSrc_1Branch_2ALUOp_1Jump_1PCJalSrc
          7'b0000011: controls = 15'b1_000_0_01_0_01_0_00_0_0; // I-Type => lw
          7'b0010011: controls = 15'b1_000_0_01_0_00_0_10_0_0; // I-Type 
          7'b0010111: controls = 15'b1_100_1_10_0_00_0_00_0_0; // U-Type => auipc
          7'b0100011: controls = 15'b0_001_0_01_1_xx_0_00_0_0; // S-Type
          7'b0110011: controls = 15'b1_xxx_0_00_0_00_0_10_0_0; // R-Type
          7'b0110111: controls = 15'b1_100_1_01_0_00_0_00_0_0; // U-Type => lui
          7'b1100011: controls = 15'b0_010_0_00_0_xx_1_01_0_0; // B-Type
          7'b1101111: controls = 15'b1_011_0_00_0_10_0_00_1_0; // J-Type => jal
          7'b1100111: controls = 15'b1_000_0_01_0_10_0_00_1_1; // I-Type => jalr
          7'b0000000: controls = 15'b0_000_0_00_0_00_0_00_0_0;
          default: controls = 15'bx_xxx_x_xx_x_xx_x_xx_x_x;
          
          

		  
 
        endcase
 endmodule