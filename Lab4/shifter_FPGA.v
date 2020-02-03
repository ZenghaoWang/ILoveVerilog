module shifter_FPGA(LEDR, SW, KEY);
    input [9:0] SW;
    input [3:0] KEY;
    output [7:0] LEDR;

    shifter shitter(
        .Q(LEDR[7:0]),
        .LoadVal(SW[7:0]),
        .Load_n(KEY[1]),
        .ShiftRight(KEY[2]),
        .ASR(KEY[3]),
        .clock(KEY[0]),
        .reset_n(SW[9])
    );

endmodule // shifter_FPGA