module shifter(Q, LoadVal, Load_n, ShiftRight, ASR, clock, reset_n);
    input [7:0] LoadVal;
    input Load_n, ShiftRight, ASR, clock, reset_n;
    output[7:0] Q;
    wire w76, w65, w54, w43, w32, w21, w10;

    reg most_sig_digit;
    always @(*) 
    begin
        if (ASR == 1'b1)
            most_sig_digit = Q[7]; // If arithmetic shifting, copy the most significant digit to the right
        else
            most_sig_digit = 1'b0; // Extend with 0s
    end


    // Most significant bit: Behavior varies depending on ASR
    shifter_bit b7(
        .out(Q[7]),
        .in(most_sig_digit),
        .load_val(LoadVal[7]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    ); assign w76 = Q[7];

    shifter_bit b6(
        .out(Q[6]),
        .in(w76),
        .load_val(LoadVal[6]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    ); assign w65 = Q[6];

    shifter_bit b5(
        .out(Q[5]),
        .in(w65),
        .load_val(LoadVal[5]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    ); assign w54 = Q[5];

    shifter_bit b4(
        .out(Q[4]),
        .in(w54),
        .load_val(LoadVal[4]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    ); assign w43 = Q[4];

    shifter_bit b3(
        .out(Q[3]),
        .in(w43),
        .load_val(LoadVal[3]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    ); assign w32 = Q[3];

    shifter_bit b2(
        .out(Q[2]),
        .in(w32),
        .load_val(LoadVal[2]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    ); assign w21 = Q[2];

    shifter_bit b1(
        .out(Q[1]),
        .in(w21),
        .load_val(LoadVal[1]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    ); assign w10 = Q[1];

    shifter_bit b0(
        .out(Q[0]),
        .in(w10),
        .load_val(LoadVal[0]),
        .shift(ShiftRight),
        .load_n(Load_n),
        .clock(clock),
        .reset_n(reset_n)
    );



endmodule // shifter



