vlib work
vlog -timescale 1ns/1ns ALU_FPGA.v 
vsim ALU_FPGA
log {/*}
add wave {/*}

# function0: Incrementing A by 1
    force {KEY[2:0]} 2#000
    force {SW[3:0]} 2#0000
    # no carry
    force {SW[7:4]} 2#0000
    run 10ns
    # carry
    force {SW[7:4]} 2#0001
    run 10ns

# function1: A + B 
    force {KEY[2:0]} 2#001

    force {SW[7:4]} 2#0001
    force {SW[3:0]} 2#0001
    run 10ns

    force {SW[7:4]} 2#0101
    force {SW[3:0]} 2#0011
    run 10ns

    force {SW[7:4]} 2#1111
    force {SW[3:0]} 2#1111
    run 10ns

    force {SW[7:4]} 2#1010
    force {SW[3:0]} 2#0101
    run 10ns
        

# function2: Should be same output
    force {KEY[2:0]} 2#010

    force {SW[7:4]} 2#0001
    force {SW[3:0]} 2#0001
    run 10ns

    force {SW[7:4]} 2#0101
    force {SW[3:0]} 2#0011
    run 10ns

    force {SW[7:4]} 2#1111
    force {SW[3:0]} 2#1111
    run 10ns

    force {SW[7:4]} 2#1010
    force {SW[3:0]} 2#0101
    run 10ns

# function3: A|B concat A^B 
    force {KEY[2:0]} 2#011
    # Expected: 11110000
    force {SW[7:4]} 2#1111
    force {SW[3:0]} 2#1111
    run 10ns
    # Expected: 00001111
    force {SW[7:4]} 2#0000
    force {SW[3:0]} 2#1111
    run 10ns
    # Expected: 00001111
    force {SW[7:4]} 2#1010
    force {SW[3:0]} 2#0101
    run 10ns
    # Expected: 00000000
    force {SW[7:4]} 2#0000
    force {SW[3:0]} 2#0000
    run 10ns
    



# function4: 8bit -> 1bit OR reduction
    force {KEY[2:0]} 2#100
    # All bits low
    force {SW[7:4]} 2#0000 
    force {SW[3:0]} 2#0000
    run 10ns
    # Some bits high
    force {SW[7:4]} 2#0100 
    force {SW[3:0]} 2#0010
    run 10ns

    # All bits high
    force {SW[7:4]} 2#1111
    force {SW[3:0]} 2#1111
    run 10ns

# function5: Send A concat B to output
    force {KEY[2:0]} 2#101
    force {SW[7:4]} 2#0000 
    force {SW[3:0]} 2#0000
    run 10ns
    force {SW[7:4]} 2#0100 
    force {SW[3:0]} 2#0010
    run 10ns
    force {SW[7:4]} 2#1111
    force {SW[3:0]} 2#1111
    run 10ns