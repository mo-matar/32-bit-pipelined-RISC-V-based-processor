module Instr_mem #(
    parameter MEM_SIZE = 1024
) 
(
    input  [31:0] addr,   
    output [31:0] instruction  
);
    reg [7:0] memory [0:MEM_SIZE-1];

    assign instruction = {memory[addr], 
                          memory[addr + 1],
                          memory[addr + 2],
                          memory[addr + 3]};//big-endian

    initial begin
        $readmemh("instructions.txt", memory);
    end

endmodule
