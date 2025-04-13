#!/bin/sh

echo "Setting up formal verification with relative paths..."

# Create a formal_test directory to work in
rm -rf formal_test
mkdir -p formal_test/src

# Copy all needed files to the formal_test directory
echo "Copying RTL files to formal_test directory..."
cp RTL/ALUControl_Defines.sv formal_test/src/
cp RTL/modules/*.sv formal_test/src/
cp RTL/top.sv formal_test/src/
cp RTL/modules/instructions.txt formal_test/

# Create a proper SBY file with relative paths
cat > formal_test/formal.sby << 'EOF'
[options]
mode bmc
depth 20
append 1

[engines]
smtbmc

[script]
# Use relative paths within the formal_test directory
read -sv src/ALUControl_Defines.sv
read -sv src/*.sv
prep -top top

[files]
src/ALUControl_Defines.sv
src/*.sv
EOF

echo "Created formal_test directory with all needed files."
echo "To run formal verification:"
echo "  cd formal_test"
echo "  sby -f formal.sby"