module Inst_mem_tb;
reg [31:0] addr;
wire [31:0] instruction;

 Instr_mem #(1024) 
    uut (
    .addr (addr),
    .instruction (instruction)
);


initial begin
    $dumpfile("Inst_mem_tb.vcd");
    $dumpvars(0, Inst_mem_tb);
end

initial begin
integer i; 
addr = 0;
	for (i = 0; i<= 20; i = i + 1)	begin
		addr = i*4;   
		#10
		$display("Address: %h, Instruction: %h", addr, instruction);
		
	end	   
$finish;
end


endmodule	