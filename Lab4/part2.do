vlib work
vlog -timescale 1ns/1ns ALU_FPGA.v decoder.v adder4bit.v 

vsim ALU_FPGA
log {/*}
add wave {/*}

# Set Clock
force {KEY[0]} 0 0, 1 5 -r 10
# Reset register
force {SW[9]} 0 0, 1 10

# function0: Incrementing A by 1
    force {SW[7:5]} 2#000

    # no carry
    force {SW[3:0]} 2#0000
    run 10ns
    # carry
    force {SW[3:0]} 2#0001
    run 10ns

# function1: A + B 
    force {SW[7:5]} 2#001

    # Set A to 0001; B should be 0010
    force {SW[3:0]} 2#0001
    run 10ns

    # B should be 0011 now 
    force {SW[3:0]} 2#0011
    run 10ns


# function2: A + B but *differently*
    force {SW[7:5]} 2#010

    # Set A to 0001; B should be 0110
    force {SW[3:0]} 2#0001
    run 10ns

    # B should be 0111 now 
    force {SW[3:0]} 2#0011
    run 10ns

# function3: A|B concat A^B 
    force {SW[7:5]} 2#011
    # B should currently be 1010; Expected: 11110101
    force {SW[3:0]} 2#1111
    run 10ns

    
# function4: 8bit -> 1bit OR reduction
    force {SW[7:5]} 2#100

    # Reset register to 0
    force {SW[9]} 0 
    run 10ns
    force {SW[9]} 1
    # All bits low
    force {SW[3:0]} 2#0000
    run 10ns
    # Some bits high
    force {SW[3:0]} 2#0011
    run 10ns

# function5: Left shift B by A bits
    force {SW[7:5]} 2#101

    # B is currently 0001
    force {SW[3:0]} 2#0010
    run 10ns

# function6: Right shift B by A bits
    force {SW[7:5]} 2#110

    # B is currently 0100
    force {SW[3:0]} 2#0010
    run 10ns

# Function 7: A x B
    force {SW[7:5]} 2#111

    # B is currently 0001
    force {SW[3:0]} 2#0110
    run 10ns

    # B is currently 2#0110
    force {SW[3:0]} 2#0010
    run 10ns

