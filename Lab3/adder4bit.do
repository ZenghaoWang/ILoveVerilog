vlib work
vlog -timescale 1ns/1ns adder4bitFPGA.v

vsim adder4bitFPGA
log {/*}
add wave {/*}

# Test Case 1: Adding 2 1s, no input carry
force {SW[7:4]} 2#0001
force {SW[3:0]} 2#0001
force {SW[8]} 0
run 10ns
# Expected 2#0010

# Test Case 2: Adding 2 1s w/ input carry
force {SW[7:4]} 2#0001
force {SW[3:0]} 2#0001
force {SW[8]} 1
run 10ns
#Expected: 2#0011

# Test Case 3: Carried 1s over multiple bits
force {SW[7:4]} 2#0101
force {SW[3:0]} 2#0011
force {SW[8]} 0
run 10ns
#Expected: 2#1000

# Test Case 4: Largest possible 4-bit integers, no carry
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
force {SW[8]} 0
run 10ns
#Expected: 2#11110

# Test Case 5: Largest possible 4-bit integers, with a carry
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
force {SW[8]} 1
run 10ns
#Expected: 2#11111

# Test Case 6: No carrying 
force {SW[7:4]} 2#1010
force {SW[3:0]} 2#0101
force {SW[8]} 0
run 10ns
#Expected: 2#1111

