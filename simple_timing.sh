#!/bin/sh

# Stay in current directory
echo "Analyzing critical path..."

# Create a copy of instructions.txt in the current directory
echo "Setting up instruction file..."
cp ../RTL/modules/instructions.txt ./instructions.txt

cat > timing.ys << EOFYS
# Read design files
read_verilog -sv ../RTL/ALUControl_Defines.sv
read_verilog -sv ../RTL/modules/*.sv
read_verilog -sv ../RTL/top.sv

# Prepare design
hierarchy -check -top top
proc; opt; fsm; opt; memory; opt

# Map to a technology library
techmap; opt

# Timing analysis with the liberty file in current directory
tee -o critical_path.txt abc -liberty ./synth_gates.lib
EOFYS

yosys -q timing.ys

# Clean up
rm -f instructions.txt timing.ys

echo "Critical path analysis saved to critical_path.txt"