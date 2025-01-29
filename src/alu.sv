`include "ALUControl_Defines.sv"
module alu (
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] ALUResult,
    input logic [3:0] ALUControl,//control signal
    output logic zero, sign//control signals

);

logic [31:0] condinvB, sum; 
logic        overflow;              // overflow 
logic        isAddSub;       // true when is add or subtract operation 
assign condinvB = ((ALUControl == `SUB) | (ALUControl == `SLT)) ? ~B : B; // conditionally inverted B
assign sum = A + condinvB + ALUControl[0]; //use 2's complement if B was inverted, add 0 if not
assign isAddSub = (ALUControl == `SUM) | (ALUControl == `SUB) | (ALUControl == `SLT);
always_comb begin
    case (ALUControl)
        `SUM : ALUResult = sum; // Addition
        `SUB : ALUResult = sum; // Subtraction (uses 2's complement)
        `AND : ALUResult = A & B; //bitwise AND
        `OR  : ALUResult = A | B; //bitwise OR
        `XOR : ALUResult = A ^ B; //bitwise XOR
        `SLT : ALUResult = {31'b0, overflow ^ sum[31]}; //set Less Than (signed) - result is 1 if A < B, else 0
        `SLTU: ALUResult = {31'b0, ($unsigned(A) < $unsigned(B))}; //set Less Than Unsigned - result is 1 if A < B, else 0
        `SLL : ALUResult = A << B[4:0]; //Shift Left Logical (shift amount is lower 5 bits of B)
        `SRL : ALUResult = A >> B[4:0]; //Shift Right Logical (shift amount is lower 5 bits of B)
        `SRA : ALUResult = $signed(A) >>> B[4:0]; //shift Right Arithmetic (preserves sign bit)
        `ROR : ALUResult = (A >> B[4:0]) | (A << (32 - B[4:0])); // Rotate Right
        default: ALUResult = 32'b0; // Default case (should never happen)
    endcase
end

assign zero = (ALUResult == 32'b0); 
assign sign = ALUResult[31];
assign overflow = ~(ALUControl[0] ^ A[31] ^ B[31]) & (A[31] ^ sum[31]) & isAddSub; 

/*Breaking the overflow down:

(ALUControl[0] ^ A[31] ^ B[31]): Determines whether A and B have opposite signs for subtraction (ALUControl[0] = 1) or same signs for addition (ALUControl[0] = 0).
Negating (~) this ensures the overflow check applies only when the signs are the same for addition, or different for subtraction.

(A[31] ^ sum[31]): Checks if the sign bit changed unexpectedly (indicating overflow).

isAddSub: Ensures this logic applies only to addition/subtraction, not logical operations.*/

    
endmodule