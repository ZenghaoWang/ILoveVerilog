vlib work
vlog -timescale 1ns/1ns ram32x4.v
vsim -L  altera_mf_ver ram32x4
log {/*}
add wave {/*}

# Set clock
    force {clock} 1 0ns, 0 1ns -r 2ns

# Write 1010 to address 00001
    force {address} 2#00001 1ns 
    force {dataIn} 2#1010 1ns
    force {WriteEnable} 1 1ns

# Write 0001 to address 10000
    force {address} 2#10000 3ns
    force {dataIn} 2#0001 3ns

# Read address 00001
    force {address} 2#00001 5ns
    force {WriteEnable} 0 5ns

# Read address 10000
    force {address} 2#10000 7ns
     


run 9ns     
