vlib work
vlog -timescale 1ns/1ns poly_function_FPGA.v
vsim poly_function
log {/*}
add wave {/*}


# Set up clock: Posedge every even ns
    force {clk} 1 0, 0 1 -r 2   

# Active-low reset until 3ns
    force {resetn} 0 0, 1 3

# Load A = 1
    force {data_in} 2#001 3
    force {go} 1 3, 0 4

# Load B = 1
    force {data_in} 2#001 9
    force {go} 1 9, 0 10

# Load C = 1
    force {data_in} 2#001 15
    force {go} 1 15, 0 16

# Load x = 1
    force {data_in} 2#001 21
    force {go} 1 21, 0 22

# Expected Output: 3
run 35ns
