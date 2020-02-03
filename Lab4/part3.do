vlib work
vlog -timescale 1ns/1ns shifter_FPGA.v shifter.v shifter_bit.v mux2to1.v 

vsim shifter_FPGA
log {/*}
add wave {/*}

# Set clock to posedge every 10 ns
force {KEY[0]} 1 0, 0 5 -r 10

# Reset register; reset is active-low
force {SW[9]} 0 0, 1 10

# Set input to 1 0 0 0 0 0 0 0
force {SW[7:0]} 2#10000000 10

# Set Load_n = 0, ShiftRight = 0 for parallel load
# Maintain this for 1 clock cycle, starting at the 2nd cycle
force {KEY[1]} 0 0, 1 20
force {KEY[2]} 0 0, 1 20
force {KEY[3]} 0

# On 3rd clock cycle, logic shift right for 4 cycles
# Expected output after 4 cycles: 0 0 0 0 1 0 0 0

# At 60 ns, reset for 10 ns, parallel load for 10 ns, then arithmetic shift right for 4 cycles
force {KEY[3]} 1 60
force {SW[9]} 0 60, 1 70
force {KEY[1]} 0 70, 1 80
force {KEY[2]} 0 70, 1 80
force {SW[7:0]} 2#11110000 70


# =====Timeline=====
    # 0-10 ns: reset register
    # 10-20 ns: Parallel load input
    # 20-60 ns: Logic right shift 4 bits
    # 60-70 ns: Reset input to 1 1 1 1 0 0 0 0 
    # 70-80 ns: Parallel laod input
    # 70-110 ns: Arithmetic right shift 4 bits

run 120 ns



