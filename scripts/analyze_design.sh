#!/bin/bash

cd "$(dirname "$0")"
echo "Generating detailed design statistics..."

# Create a copy of instructions.txt in the current directory
echo "Setting up instruction file..."
cp ../RTL/modules/instructions.txt ./instructions.txt

cat > design_stats.ys << EOF
# Read design files
read_verilog -sv ../RTL/ALUControl_Defines.sv
read_verilog -sv ../RTL/modules/*.sv
read_verilog -sv ../RTL/top.sv

# Process design
hierarchy -check -top top
proc; opt; fsm; opt; memory; opt

# Generate statistics
stat -top top
stat -width
EOF

# Run the analysis
echo "Running design analysis..."
yosys design_stats.ys > design_statistics.txt

# Clean up
rm -f instructions.txt design_stats.ys

echo "Analysis complete!"
echo "Statistics saved to design_statistics.txt"