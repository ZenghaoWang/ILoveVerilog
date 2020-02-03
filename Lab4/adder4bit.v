
module adder4bit(A, B, cin, S, cout);
    input [3:0] A;
    input [3:0] B;
    input cin;
    output [3:0] S;
    output cout;

    wire c0, c1, c2;

    adder a0(
        .a(A[0]),
        .b(B[0]),
        .cin(cin),
        .s(S[0]),
        .cout(c0)
    );

        adder a1(
        .a(A[1]),
        .b(B[1]),
        .cin(c0),
        .s(S[1]),
        .cout(c1)
    );

        adder a2(
        .a(A[2]),
        .b(B[2]),
        .cin(c1),
        .s(S[2]),
        .cout(c2)
    );

        adder a3(
        .a(A[3]),
        .b(B[3]),
        .cin(c2),
        .s(S[3]),
        .cout(cout)
    );
    
    
endmodule // adder4bit


module adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));

endmodule // adder