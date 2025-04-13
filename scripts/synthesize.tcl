# Yosys 0.9 synthesis script for RISC-V processor

# First read the defines file
yosys -import
read_verilog -sv ../RTL/ALUControl_Defines.sv

# Read the module files
read_verilog -sv ../RTL/modules/Instr_mem.sv
read_verilog -sv ../RTL/modules/PcSrc_generator.sv
read_verilog -sv ../RTL/modules/adder.sv
read_verilog -sv ../RTL/modules/alu.sv
read_verilog -sv ../RTL/modules/aludec.sv
read_verilog -sv ../RTL/modules/controller.sv
read_verilog -sv ../RTL/modules/data_mem.sv
read_verilog -sv ../RTL/modules/datapath.sv
read_verilog -sv ../RTL/modules/hazard_unit.sv
read_verilog -sv ../RTL/modules/imm_extender.sv
read_verilog -sv ../RTL/modules/intermediate_registers.sv
read_verilog -sv ../RTL/modules/maindec.sv
read_verilog -sv ../RTL/modules/mux2.sv
read_verilog -sv ../RTL/modules/mux3.sv
read_verilog -sv ../RTL/modules/reg_file.sv
read_verilog -sv ../RTL/modules/RV32I_core.sv
read_verilog -sv ../RTL/top.sv

# Set the top module
hierarchy -check -top top

# Process and optimize the design
proc
opt
fsm; opt
memory; opt
techmap; opt

# Write synthesized netlist
write_verilog -noattr synth_output.v

# Generate a visualization
show -format dot -prefix synth_diagram

# Print statistics
stat