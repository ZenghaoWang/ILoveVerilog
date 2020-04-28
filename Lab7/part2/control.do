vlib work
vlog -timescale 1ns/1ns part2.v
vsim control
log {/*}
add wave {/*}

# Set Clock
    force {clock} 1 0, 0 1 -r 2

# Reset
    force {resetn} 0 0, 1 1

# Load in (x, y)
    force {go} 1 0, 0 5
    force {draw_square} 1 6, 0 8 

run 120ns




