#!/bin/bash

# Navigate to the scripts directory
cd "$(dirname "$0")"

echo "Starting synthesis for RISC-V design..."

# Create a symbolic link to instructions.txt in the current directory
echo "Setting up instruction file..."
ln -sf ../RTL/modules/instructions.txt instructions.txt

# Run synthesis using the Yosys script file
yosys synthesis.ys

# Remove the symbolic link after synthesis
rm -f instructions.txt

echo "Synthesis complete!"

# Convert all dot files to PDF if graphviz is installed
if command -v dot &> /dev/null; then
    echo "Converting diagrams to PDF..."
    
    for dot_file in *.dot; do
        if [ -f "$dot_file" ]; then
            pdf_file="${dot_file%.dot}.pdf"
            echo "  Converting $dot_file to $pdf_file..."
            dot -Tpdf "$dot_file" > "$pdf_file"
        fi
    done
    
    echo "All diagrams converted to PDF"
else
    echo "Note: Install graphviz (sudo apt install graphviz) to convert the diagrams to PDF"
fi

# Check if output file was created
if [ -f "synth_output.v" ]; then
    echo "Synthesis results:"
    echo "  - synth_output.v (synthesized netlist)"
    
    echo "Visualization files:"
    for pdf_file in *.pdf; do
        if [ -f "$pdf_file" ]; then
            echo "  - $pdf_file"
        fi
    done
else
    echo "Error: Synthesis did not complete successfully"
fi