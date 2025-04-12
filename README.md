# RV32I Pipelined Processor

This project implements a 5-stage pipelined processor that executes the RISC-V RV32I instruction set. The processor includes hazard detection, forwarding paths, and supports all the base integer instructions of the RISC-V architecture.

## Architecture Overview

The processor is designed with a classic 5-stage pipeline:

- **Fetch (F)**: Retrieves instructions from instruction memory
- **Decode (D)**: Decodes instructions and reads register operands
- **Execute (E)**: Performs ALU operations and calculates branch targets
- **Memory (M)**: Accesses data memory for loads and stores
- **Writeback (W)**: Writes results back to the register file

## Key Features

- Complete RV32I instruction set support
- 5-stage pipeline with forwarding logic
- Hazard detection and handling (data hazards, control hazards)
- Separate instruction and data memories
- 32x32-bit register file with x0 hardwired to zero
- Branch prediction and handling

## Supported Instructions

The following table shows the supported RV32I instructions, their formats, and functionality:

| Type       | Instruction | Format                            | Opcode  | Function | Description                         |
| ---------- | ----------- | --------------------------------- | ------- | -------- | ----------------------------------- |
| **R-type** | ADD         | R[rd] = R[rs1] + R[rs2]           | 0110011 | 000,0    | Add                                 |
|            | SUB         | R[rd] = R[rs1] - R[rs2]           | 0110011 | 000,1    | Subtract                            |
|            | AND         | R[rd] = R[rs1] & R[rs2]           | 0110011 | 111,0    | Bitwise AND                         |
|            | OR          | R[rd] = R[rs1] \| R[rs2]          | 0110011 | 110,0    | Bitwise OR                          |
|            | XOR         | R[rd] = R[rs1] ^ R[rs2]           | 0110011 | 100,0    | Bitwise XOR                         |
|            | SLT         | R[rd] = (R[rs1] < R[rs2]) ? 1 : 0 | 0110011 | 010,0    | Set Less Than (signed)              |
|            | SLL         | R[rd] = R[rs1] << R[rs2]          | 0110011 | 001,0    | Shift Left Logical                  |
|            | SRL         | R[rd] = R[rs1] >> R[rs2]          | 0110011 | 101,0    | Shift Right Logical                 |
|            | SRA         | R[rd] = R[rs1] >>> R[rs2]         | 0110011 | 101,1    | Shift Right Arithmetic              |
| **I-type** | ADDI        | R[rd] = R[rs1] + imm              | 0010011 | 000      | Add Immediate                       |
|            | ANDI        | R[rd] = R[rs1] & imm              | 0010011 | 111      | Bitwise AND Immediate               |
|            | ORI         | R[rd] = R[rs1] \| imm             | 0010011 | 110      | Bitwise OR Immediate                |
|            | XORI        | R[rd] = R[rs1] ^ imm              | 0010011 | 100      | Bitwise XOR Immediate               |
|            | SLTI        | R[rd] = (R[rs1] < imm) ? 1 : 0    | 0010011 | 010      | Set Less Than Immediate (signed)    |
|            | SLLI        | R[rd] =  R[rs1] <<  uimm          | 0010011 | 001      | shift left logical immediate        |
|            | SRLI        | R[rd] =  R[rs1] >>  uimm          | 0010011 | 101 0000000| shift right logical immediate       |
|            | SRLI        | R[rd] =  R[rs1] >>>  uimm          | 0010011 | 101 0100000| shift right arithmetic immediate    |
|            | LW          | R[rd] = Mem[R[rs1] + imm]         | 0000011 | 010      | Load Word                           |
|            | JALR        | R[rd] = PC+4; PC = R[rs1] + imm   | 1100111 | 000      | Jump And Link Register              |
| **S-type** | SW          | Mem[R[rs1] + imm] = R[rs2]        | 0100011 | 010      | Store Word                          |
| **B-type** | BEQ         | if(R[rs1] == R[rs2]) PC += imm    | 1100011 | 000      | Branch if Equal                     |
|            | BNE         | if(R[rs1] != R[rs2]) PC += imm    | 1100011 | 001      | Branch if Not Equal                 |
|            | BLT         | if(R[rs1] < R[rs2]) PC += imm     | 1100011 | 100      | Branch if Less Than (signed)        |
|            | BGE         | if(R[rs1] >= R[rs2]) PC += imm    | 1100011 | 101      | Branch if Greater or Equal (signed) |
| **U-type** | LUI         | R[rd] = imm << 12                 | 0110111 | -        | Load Upper Immediate                |
|            | AUIPC       | R[rd] = PC + (imm << 12)          | 0010111 | -        | Add Upper Imm to PC                 |
| **J-type** | JAL         | R[rd] = PC+4; PC += imm           | 1101111 | -        | Jump And Link                       |
|            | JALR        

## Module Details

### Top-Level Modules

- **top.sv**: Top-level module connecting processor core with memories
- **RV32I_core.sv**: Main processor module connecting datapath, controller, and hazard unit

### Datapath Components

- **datapath.sv**: Implements the data flow through the pipeline stages
- **alu.sv**: Arithmetic Logic Unit supporting all RV32I ALU operations
- **reg_file.sv**: 32x32-bit register file with x0 hardwired to zero
- **imm_extender.sv**: Generates immediate values from instruction fields
- **adder.sv**: Adder module used for PC incrementation and branch target computation

### Control Components

- **controller.sv**: Main control unit coordinating all datapath control signals
- **maindec.sv**: Main decoder that decodes instruction opcodes
- **aludec.sv**: ALU decoder that determines ALU operations
- **PcSrc_generator.sv**: Generates branch decision signal based on branch type and condition flags
- **hazard_unit.sv**: Detects and handles hazards through stalling, forwarding, and flushing

### Memory Components

- **Instr_mem.sv**: Instruction memory (read-only)
- **data_mem.sv**: Data memory (read-write)

### Pipeline Registers

- **intermediate_registers.sv**: Contains various flip-flop modules for pipeline registers:
  - `flopr`: Basic flip-flop with reset
  - `flopenr`: Flip-flop with enable and reset
  - `flopenrc`: Flip-flop with enable, reset, and clear
  - `floprc`: Flip-flop with reset and clear

### Multiplexers

- **mux2.sv**: 2-to-1 multiplexer
- **mux3.sv**: 3-to-1 multiplexer

## Hazard Handling

### Data Hazards

- **Forwarding**: The hazard unit detects when a result needs to be forwarded from later pipeline stages back to the Execute stage
- **Stalling**: When forwarding cannot resolve a hazard (e.g., load-use), the pipeline is stalled

### Control Hazards

- **Branch Prediction**: The processor employs branch flushing when branches are resolved
- **Pipeline Flushing**: Instructions in the pipeline are flushed when branches are taken

## Memory Organization

- **Instruction Memory**: Instructions are loaded from an "instructions.txt" file in hexadecimal format
- **Data Memory**: Word-addressable memory (4-byte alignment)

## Testing

The project includes several testbenches:

- **testbench.sv**: Main testbench for the entire processor
- **reg_file_tb.sv**: Testbench for the register file
- **Instr_mem_tb.sv**: Testbench for the instruction memory

## Usage

1. Set up the instruction memory by modifying the `instructions.txt` file with hexadecimal instruction bytes
2. Compile all the SystemVerilog files using a compatible simulator
3. Run the main testbench to simulate the processor execution
4. The simulation succeeds when the final expected store operation is performed

## Implementation Details

### Pipeline Registers

- **IF/ID**: Passes fetched instruction and PC to the decode stage
- **ID/EX**: Passes decoded instruction information to the execute stage
- **EX/MEM**: Passes execution results to the memory stage
- **MEM/WB**: Passes memory operation results to the writeback stage

## Tools Used

- **Simulation**: Aldec Active-HDL was used for design verification and debugging through waveform analysis.


## Helpful Resources

The following resources were used during development:

- [RISC-V Interpreter](https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/) - Helped with reading register values
- [RISC-V Assembly Hex Converter](https://riscvasm.lucasteske.dev/#) - Assisted with generating hex dumps for assembly code

## Acknowledgments

This processor design is based on the RISC-V architecture as specified in "The RISC-V Instruction Set Manual, Volume I: User-Level ISA, Document Version 2.2".
