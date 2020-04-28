vlib work
vlog -timescale 1ns/1ns part2.v
vsim datapath
log {/*}
add wave {/*}

# Set clock
    force {clock} 0 0, 1 1 -r 2

# Reset
    force {resetn} 0 0, 1 2

# Load in x = 0000_0001, y = 000_0010
    force {x} 2#00000001
    force {y} 2#0000010

    force {x_shift_right} 2#10
    force {y_shift_down} 2#10

    force {load_x} 1 2
    force {load_y} 1 2


    

run 6ns
