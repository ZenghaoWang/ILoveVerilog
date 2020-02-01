`include "hex_decoder.v"
`include "adder4bitFPGA.v"

// Wrapper Module
module ALU_FPGA(
    SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [7:0] SW;
    input [2:0] KEY;
    output [7:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Connecting to ports of FPGA board
    ALU alu(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .fun(KEY),
        .ALUout(LEDR),
        .hex_zero1(HEX1),
        .hex_zero2(HEX3),
        .hex_A(HEX2),
        .hex_B(HEX0),
        .hex_out_30(HEX4),
        .hex_out_74(HEX5)
    );

endmodule // ALU_FPGA

module ALU(
    A, B, fun, ALUout, 
    hex_zero1, hex_zero2, hex_A, hex_B, hex_out_30, hex_out_74);
    input [3:0] A, B;
    input [2:0] fun;
    output [7:0] ALUout;
    output [6:0] hex_zero1, hex_zero2, hex_A, hex_B, hex_out_30, hex_out_74;

    wire [7:0] fun0_output, fun1_output, fun2_output, fun3_output, fun4_output, fun5_output;

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

    // Send input to output
    assign fun5_output[7:0] = {A, B};


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

