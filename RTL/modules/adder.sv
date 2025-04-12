module adder (
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] result
);


assign result = A + B;
    
endmodule