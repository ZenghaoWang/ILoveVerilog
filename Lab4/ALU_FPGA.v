
module register_8bit(
    q, d, clock, reset_n);

    input [7:0] d;
    input clock, reset_n;
    reg output [7:0] q;

    always @(posedge clock) //Triggered everytime clock rises to 1
    begin
        if (reset_n == 1'b0) //Active low
            q <= 8'b0000_0000
        else //Store the value of the input in the output
            q <= d;
    end

    


endmodule // register_8bit

// TODO: Modify for Lab 4
module ALU(
    A, B, fun, ALUout, 
    hex_zero1, hex_zero2, hex_A, hex_B, hex_out_30, hex_out_74);
    input [3:0] A, B;
    input [2:0] fun;
    output [7:0] ALUout;
    output [6:0] hex_zero1, hex_zero2, hex_A, hex_B, hex_out_30, hex_out_74;

    wire [7:0] fun0_output, fun1_output, fun2_output, fun3_output, 
        fun4_output, fun5_output,  fun6_output, fun7_output;

    // Increment A by 1
    adder4bit fun0(
        .A(A[3:0]),
        .B(4'b0001),
        .cin(1'b0),
        .S(fun0_output[3:0]),
        .cout(fun0_output[4])
    ); assign fun0_output[7:5] = 3'b000;

    // Add A + B
    adder4bit fun1(
        .A(A[3:0]),
        .B(B[3:0]),
        .cin(1'b0),
        .S(fun1_output[3:0]),
        .cout(fun1_output[4])
    ); assign fun1_output[7:5] = 3'b000;

    // A + B using '+' operator
    assign fun2_output[7:0] = {3'b000, A + B};

    //A OR B concat A XOR B
    assign fun3_output[7:0] = {A | B, A ^ B};

    // OR reduction on A concat B
    assign fun4_output[7:0] = {7'b000_0000, (| {A, B})};

    // (Logical) Left shift B by A bits 
    assign fun5_output[7:0] = B << A;

    // (Logical) Right shift B by A bits 
    assign fun6_output[7:0] = B >> A;

    // A x B
    assign fun7_output[7:0] = A * B;



    // Multiplexer structure
    reg [7:0] ALUout;
    always @(*)
    begin
        case (fun[2:0])
            3'b000: ALUout = fun0_output;
            3'b001: ALUout = fun1_output;
            3'b010: ALUout = fun2_output;
            3'b011: ALUout = fun3_output;
            3'b100: ALUout = fun4_output;
            3'b101: ALUout = fun5_output;
            3'b110: ALUout = fun6_output;
            3'b111: ALUout = fun7_output;
            default: ALUout = {8{1'b0}}; //Default: output 0s
        endcase
    end


    // Output a hex display 0
    wire [6:0] zero;
    decoder d0(
        .c({4{1'b0}}),
        .segment(zero)
    );
    assign hex_zero1 = zero;
    assign hex_zero2 = zero;


    // Output a hex display A
    decoder dA(
        .c(A),
        .segment(hex_A)
    );
   

    // Hex display B
    decoder dB(
        .c(B),
        .segment(hex_B)
    );

    //Hex display ALUout[3:0]
    decoder d30(
        .c(ALUout[3:0]),
        .segment(hex_out_30)
    );

    //Hex display ALUout[7:4]
    decoder d74(
        .c(ALUout[7:4]),
        .segment(hex_out_74)
    );
endmodule // ALU