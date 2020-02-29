vlib work
vlog -timescale 1ns/1ns morse.v

vsim morse
log {/*}
add wave {/*}

# Inputs:
    # SW[2:0]: Choose one of 8 letters:
        # 000 S 
        # 001 T 
        # 010 U 
        # 011 V 
        # 100 W 
        # 101 X 
        # 110 Y
        # 111 Z
    # KEY[1]: Start displaying chosen letter
    # KEY[0]: Asynchronous reset
    # NOTE: The verilog code inverts the keys so pressing the key activates it 
# Set clock to 50MHz
force {CLOCK50} 0 0, 1 10ns -r 20ns
# Reset register for 10ns
force {KEY[0]} 0 1, 1 10

# Pick S
force {SW[2:0]} 000 20 

# Start displaying S 
force {KEY[1]} 1 20

run 1400 ns



