/*description: data memory unit to read and write data for lw and sw.
note that the memory in RISC-V is word addressable and cannot be accessed by byte,
if that was the case it would produce a memory misaligned exception*/

module data_mem #(
    parameter MEM_SIZE = 1024
) 
(   input logic clk,
    input logic [31:0] dataAdr,
    input logic [31:0] writeData,
    input logic writeEnable,
    output logic [31:0] readData
);

logic [31:0] DATA [0:MEM_SIZE-1];
assign readData = DATA[dataAdr[31:2]];


always_ff @( posedge clk ) begin
    if (writeEnable) begin
        DATA[dataAdr[31:2]] <= writeData; //memory writes should be synchronous in hardware designs
    end
end

    
endmodule