module reg_file ( 
	input logic clk,
	input logic [4:0] rs1_addr, rs2_addr, rd_addr,
	input logic [31:0] regf_write_data,
	input logic reg_write,
	output logic [31:0] read_data1, read_data2);
	
	logic [31:0] registers [31:0]; 
	//synchronous write to ensure consistent updates
	always_ff @(negedge clk)begin
		if(reg_write && (rd_addr != 5'b00000)) registers[rd_addr] <= regf_write_data;//writing to address 00000 won't do anything since we read the value 0 in the case of that address anyways
	end	  
	
	//asynchronous reads for minimal latency
	//hardwiring the address 00000 to the value 0
	assign read_data1 = (rs1_addr == 5'b00000) ? 0 : registers[rs1_addr];
	assign read_data2 = (rs2_addr == 5'b00000) ? 0 : registers[rs2_addr];
endmodule