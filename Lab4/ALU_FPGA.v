// Wrapper module that connects the ALU and 8-bit register to an FPGA board
module ALU_FPGA(
    LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW, KEY);

    input [9:0] SW;
    input [0:0] KEY;
    output [7:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire [7:0] out;
    wire [3:0] least_sig, most_sig;

    // Display value of A in hexadecimal
    decoder dA(
        .c(SW[3:0]),
        .segment(HEX0)
    );

    // The ALU does its thing and 
    ALU alu(
        .A(SW[3:0]),
        .B(least_sig),
        .fun(SW[7:5]),
        .ALUout(out)
    );

    // Transfers the output to the register, which sends the 4 least-sig
    // digits back into the ALU as input B
    register_8bit register(
        .d(out),
        .clock(KEY[0]),
        .reset_n(SW[9]),
        .q({most_sig, least_sig})
    );

    // Display output on LEDs
    assign LEDR[7:0] = {most_sig, least_sig};


    assign HEX1 = {7{1'b1}}; // Active low; display nothing
    assign HEX2 = {7{1'b1}};
    assign HEX3 = {7{1'b1}};

    // Output the 4 least and 4 most sig digits to hex 4 and 5 respectively
    decoder virgin(
        .c(least_sig),
        .segment(HEX4)
    );

    decoder chad(
        .c(most_sig),
        .segment(HEX5)
    );

endmodule // ALU_FPGA

    


    


// Stores output of ALU
module register_8bit(
    q, d, clock, reset_n);

    input [7:0] d;
    input clock, reset_n;
    output [7:0] q;
    reg [7:0] q;

    always @(posedge clock) //Triggered everytime clock rises to 1
    begin
        if (reset_n == 1'b0) //Active low
            q <= 8'b0000_0000;
        else //Store the value of the input in the output
            q <= d;
    end
endmodule // register_8bit

// ALU with 8 functions
module ALU(A, B, fun, ALUout);
    input [3:0] A, B;
    input [2:0] fun;
    output [7:0] ALUout;


    wire [7:0] fun0_output, fun1_output, fun2_output, fun3_output, 
        fun4_output, fun5_output, fun6_output, fun7_output;

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
   
endmodule // ALU