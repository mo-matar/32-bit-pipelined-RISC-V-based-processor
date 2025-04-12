module top (input logic clk, reset,
            output logic [31:0] WriteDataM, DataAdrM,
            output logic MemWriteM
            );

    logic [31:0] PCF, InstrF, ReadDataM;
    riscv core (clk, reset, PCF, InstrF, MemWriteM, DataAdrM, WriteDataM, ReadDataM);
    Instr_mem Instruction_memory (PCF, InstrF);
    data_mem Data_memory (clk, DataAdrM, WriteDataM, MemWriteM, ReadDataM);

endmodule