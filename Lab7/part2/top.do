vlib work
vlog -timescale 1ns/1ns part2.v
vsim test control
log {/*}
add wave {/*}

# Set Clock
    force {clock} 1 0, 0 1 -r 2

# Active-low reset
    force {resetn} 0 0, 1 1

# Load in (x, y)
    force {x} 2#000000
    force {y} 2#000000
    force {colour} 2#111
    force {go} 1 0, 0 5
    force {draw_square} 1 6, 0 8 

run 120ns



