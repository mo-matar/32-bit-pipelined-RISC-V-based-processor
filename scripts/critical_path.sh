#!/bin/bash

cd "$(dirname "$0")"
echo "Analyzing critical path..."

# Create a copy of instructions.txt in the current directory
echo "Setting up instruction file..."
cp ../RTL/modules/instructions.txt ./instructions.txt

cat > timing.ys << EOF
# Read design files
read_verilog -sv ../RTL/ALUControl_Defines.sv
read_verilog -sv ../RTL/modules/*.sv
read_verilog -sv ../RTL/top.sv

# Prepare design
hierarchy -check -top top
proc; opt; fsm; opt; memory; opt

# Map to a technology library using the local liberty file
techmap; opt

# Timing analysis with the local liberty file
tee -o critical_path.txt abc -liberty ./scripts/synth_gates.lib
EOF

yosys -q timing.ys

# Clean up
rm -f instructions.txt timing.ys

echo "Critical path analysis saved to critical_path.txt"