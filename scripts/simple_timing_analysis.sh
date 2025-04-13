#!/bin/bash

cd "$(dirname "$0")"
echo "Performing simplified timing analysis..."

# Create a copy of instructions.txt in the current directory
echo "Setting up instruction file..."
cp ../RTL/modules/instructions.txt ./instructions.txt

cat > simple_timing.ys << EOF
# Read design files
read_verilog -sv ../RTL/ALUControl_Defines.sv
read_verilog -sv ../RTL/modules/*.sv
read_verilog -sv ../RTL/top.sv

# Prepare design
hierarchy -check -top top
proc; opt; fsm; opt; memory; opt

# Basic technology mapping
techmap; opt

# Generate logic depth report
tee -o timing_depth.txt stat -top top

# Identify potential timing paths
select -list top/*/t:$dff %x:+INPUT %x:+DRIVER %d

# Find longest paths in the design
tee -o critical_paths.txt show -format txt -long
EOF

# Run the simplified analysis
yosys -q simple_timing.ys

# Clean up
rm -f instructions.txt simple_timing.ys

echo "Simplified timing analysis complete."
echo "Check timing_depth.txt for logic depth information."
echo "Check critical_paths.txt for potential critical paths."