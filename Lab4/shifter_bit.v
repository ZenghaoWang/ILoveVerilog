module shifter_bit(out, in, load_val, shift, load_n, clock, reset_n);
    input in, load_val, shift, load_n, clock, reset_n;
    output out;
    wire m0_to_m1, m1_to_flipflop;

    mux2to1 m0(
        .x(out),
        .y(in),
        .s(shift),
        .m(m0_to_m1)
    );

    mux2to1 m1(
        .x(load_val),
        .y(m0_to_m1),
        .s(load_n),
        .m(m1_to_flipflop)
    );

    flipflop ass(
        .q(out),
        .d(m1_to_flipflop),
        .clock(clock),
        .reset_n(reset_n)
    );

    

endmodule // shifter_bit

module flipflop(q, d, clock, reset_n);
    input d, clock, reset_n;
    output q;
    reg q;

    always @(posedge clock) 
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else
            q <= d;
    end
endmodule // flipflop

