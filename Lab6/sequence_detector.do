vlib work
vlog -timescale 1ns/1ns sequence_detector.v
vsim sequence_detector
log {/*}
add wave {/*}

# Set Clock
force {clock} 0 0, 1 5 -r 10

force {resetn} 0 0, 1 6

# Input 1111
force {input_signal} 1
run 50ns

# Reset 
force {resetn} 0 
run 10ns

# Input 1101
force {resetn} 1
force {input_signal} 1
run 20ns
force {input_signal} 0
run 10ns
force {input_signal} 1
run 20ns




