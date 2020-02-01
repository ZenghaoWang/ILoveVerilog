# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux7to1FPGA.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns mux7to1FPGA.v

# Load simulation using mux7to1FPGA as the top level simulation module.
vsim mux7to1FPGA

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Toggle the select switches in a pattern that repeats every 640ns
force {SW[9]} 0 0, 1 2560 -repeat 5120
force {SW[8]} 0 0, 1 1280 -repeat 2560
force {SW[7]} 0 0, 1 640 -repeat 1280

# Cycle through every combination of inputs during this 640ms period
force {SW[6]} 0 0, 1 320 -repeat 640
force {SW[5]} 0 0, 1 160 -repeat 320
force {SW[4]} 0 0, 1 80 -repeat 160
force {SW[3]} 0 0, 1 40 -repeat 80
force {SW[2]} 0 0, 1 20 -repeat 40
force {SW[1]} 0 0, 1 10 -repeat 20
force {SW[0]} 0 0, 1 5 -repeat 10

run 5120ns


