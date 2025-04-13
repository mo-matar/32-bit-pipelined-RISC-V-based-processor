#!/bin/bash

# Navigate to the scripts directory
cd "$(dirname "$0")"

echo "Starting synthesis for RISC-V design..."

# Create a symbolic link to instructions.txt
ln -sf ../RTL/modules/instructions.txt instructions.txt

# Run synthesis
yosys synthesis.ys

# Clean up
rm -f instructions.txt

echo "Synthesis completed."

# Handle dot files separately with optimizations for large diagrams
for dot_file in *.dot; do
    if [ -f "$dot_file" ]; then
        echo "Converting $dot_file to PNG (more efficient for large diagrams)"
        # Using PNG instead of PDF for better handling of large diagrams
        dot -Tpng -Gdpi=72 "$dot_file" -o "${dot_file%.dot}.png"
    fi
done

echo "Done. Generated files:"
ls -la synth_output.v *.png