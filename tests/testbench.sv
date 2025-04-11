module testbench();
    logic        clk;
    logic        reset;
    logic [31:0] WriteData, DataAdr;
    logic        MemWrite;	
	integer counter = 0;

    // Instantiate device under test
    top dut(clk, reset, WriteData, DataAdr, MemWrite);

    // Initialize test
    initial begin  
		$display("Simulation started");
        reset <= 1; #22; reset <= 0;
    end

    // Generate clock
    always begin
        clk <= 1; #5; clk <= 0; #5;
    end

    always @(negedge clk) begin	  
		
		
		
        if (MemWrite) begin

            // check for final store of 25 (0x19) at address 100 (0x64)
            if (DataAdr === 32'h64 && WriteData === 32'h00000019) begin
                $display("Simulation succeeded");
				#40;
                $finish;
            end	

        end
    end
endmodule