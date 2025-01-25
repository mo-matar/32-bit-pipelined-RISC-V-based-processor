module reg_file_tb;
logic clk, reg_write;
logic [4:0] rs1_addr, rs2_addr, rd_addr;
logic [31:0] regf_write_data;
logic [31:0] read_data1, read_data2;


 reg_file 
    uut (
        .clk(clk),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .regf_write_data(regf_write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
);

initial clk = 0;
    always #5 clk = ~clk; 

initial begin
    $dumpfile("reg_file_tb.vcd");
    $dumpvars(0, reg_file_tb);
end

initial begin
    
    rs1_addr = 5'd0;
    rs2_addr = 5'd0;
    rd_addr = 5'd0;
    regf_write_data = 32'd0;
    reg_write = 1'b0;

    //wait a bit
    #10;

    //test 1: write to register 1 and read back
    rd_addr = 5'd1;
    regf_write_data = 32'hA5A5A5A5;
    reg_write = 1'b1;
    #10;
    reg_write = 1'b0;

    rs1_addr = 5'd1;
    #5;
    $display("Test 1: Read_Data1 = %h (Expected: A5A5A5A5)", read_data1);

    //test 2: write to register 2 and read back from both registers
    rd_addr = 5'd2;
    regf_write_data = 32'h5A5A5A5A;
    reg_write = 1'b1;
    #10;
    reg_write = 1'b0;

    rs2_addr = 5'd2;
    #5;
    $display("Test 2: Read_Data2 = %h (Expected: 5A5A5A5A)", read_data2);

    //test 3: read from register 0 (should always be 0)
    rs1_addr = 5'd0;
    rs2_addr = 5'd0;
    #5;
    $display("Test 3: Read Data1 = %h, Read Data2 = %h (Expected: 0, 0)", read_data1, read_data2);

    //test 4: ensure no write occurs to register 0
    rd_addr = 5'd0;
    regf_write_data = 32'hFFFFFFFF;
    reg_write = 1'b1;
    #10;
    reg_write = 1'b0;

    rs1_addr = 5'd0;
    #5;
    $display("Test 4: Read Data1 = %h (Expected: 0)", read_data1);
    $stop;
end


endmodule	