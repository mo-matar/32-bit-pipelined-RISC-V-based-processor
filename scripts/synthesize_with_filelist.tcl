# Read design files from filelist
set fp [open "filelist.txt" r]
set file_data [read $fp]
close $fp

# Process each file in the list
set files [split $file_data "\n"]
foreach file $files {
    if {[string length [string trim $file]] > 0 && ![string match "#*" $file]} {
        puts "Reading file: $file"
        read_verilog -sv $file
    }
}

# Set the top module (top.sv contains the top module)
hierarchy -check -top top

# Process and optimize the design
proc; opt; fsm; opt; memory; opt
techmap; opt
write_verilog -noattr synth_output.v
show -format dot -prefix synth_diagram
stat