#!/bin/bash

# Navigate to the scripts directory
cd "$(dirname "$0")"

echo "RISC-V Processor Module Analysis"
echo "--------------------------------"

# Create a directory for module visualizations
mkdir -p module_views

# First, ensure we have a copy of the instructions.txt file in the current directory
echo "Setting up instruction file..."
cp ../RTL/modules/instructions.txt ./instructions.txt

# List of important modules to visualize individually
MODULES=(
  "top"
  "riscv"
  "datapath"
  "controller"
  "alu"
  "reg_file"
  "data_mem"
  "hazard_unit"
)

# Create a Yosys script for each module
for MODULE in "${MODULES[@]}"; do
  echo "Analyzing module: $MODULE"
  
  # Create a Yosys script for this module
  cat > module_analysis_temp.ys << EOF
# Read the design files - in the correct order for dependencies
read_verilog -sv ../RTL/ALUControl_Defines.sv
read_verilog -sv ../RTL/modules/adder.sv
read_verilog -sv ../RTL/modules/alu.sv
read_verilog -sv ../RTL/modules/aludec.sv 
read_verilog -sv ../RTL/modules/mux2.sv
read_verilog -sv ../RTL/modules/mux3.sv
read_verilog -sv ../RTL/modules/intermediate_registers.sv
read_verilog -sv ../RTL/modules/reg_file.sv
read_verilog -sv ../RTL/modules/imm_extender.sv
read_verilog -sv ../RTL/modules/PcSrc_generator.sv
read_verilog -sv ../RTL/modules/maindec.sv
read_verilog -sv ../RTL/modules/controller.sv
read_verilog -sv ../RTL/modules/data_mem.sv
read_verilog -sv ../RTL/modules/Instr_mem.sv
read_verilog -sv ../RTL/modules/hazard_unit.sv
read_verilog -sv ../RTL/modules/datapath.sv
read_verilog -sv ../RTL/modules/RV32I_core.sv
read_verilog -sv ../RTL/top.sv

# Just perform hierarchy analysis for visualization, not full synthesis
hierarchy -check

# Visualize just this module - if possible
select $MODULE
show -format dot -prefix module_views/${MODULE}_view -notitle
EOF

  # Run the analysis with reduced output
  if ! yosys -q module_analysis_temp.ys > /dev/null 2>&1; then
    echo "  Warning: Full module selection failed, trying alternative approach for $MODULE"
    
    # Create a more focused analysis - just read the single module file if possible
    MODULE_FILE="../RTL/modules/${MODULE}.sv"
    if [ -f "$MODULE_FILE" ]; then
      cat > module_specific.ys << EOF
read_verilog -sv ../RTL/ALUControl_Defines.sv
read_verilog -sv $MODULE_FILE
prep -top $MODULE
show -format dot -prefix module_views/${MODULE}_view -notitle
EOF
      yosys -q module_specific.ys
    fi
  fi
  
  # Convert to PNG if the dot file exists
  if [ -f "module_views/${MODULE}_view.dot" ]; then
    dot -Tpng -Gdpi=100 "module_views/${MODULE}_view.dot" -o "module_views/${MODULE}_view.png"
    echo "  Created module_views/${MODULE}_view.png"
  else
    echo "  Failed to create visualization for $MODULE"
  fi
done

# Clean up
rm -f module_analysis_temp.ys module_specific.ys instructions.txt

echo "--------------------------------"
echo "Module analysis complete!"
echo "Check the module_views directory for any generated PNG files"