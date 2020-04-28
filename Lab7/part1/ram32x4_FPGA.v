module ram32x4_FPGA(HEX5, HEX4, HEX2, HEX0, 
SW, KEY);
    input [9:0] SW;
    input [0:0] KEY;
    output [6:0] HEX5; // Address
    output [6:0] HEX4; // Address
    output [6:0] HEX2; // Input data
    output [6:0] HEX0; // Output data

    wire [3:0] dataIn;
    assign dataIn = SW[3:0];

    wire [4:0] address;
    assign address = SW[8:4];

    wire writeEnable;
    assign writeEnable = SW[9];
    
    wire clock;
    assign clock = KEY[0];
    wire [3:0] dataOut;
    

    ram32x4 ram_ranch(
        .address(address),
        .clock(clock),
        .dataIn(dataIn),
        .writeEnable(writeEnable),
        .dataOut(dataOut) 
    );

    hex_decoder hex_output(
        .hex_digit(dataOut),
        .segments(HEX0)
    );

    hex_decoder hex_input( 
        .hex_digit(dataIn),
        .segments(HEX2)
    );

    wire [3:0] address_dig0;
    assign address_dig0 = address[3:0];
    wire [3:0] address_dig1;
    assign address_dig1[3:0] = {4{address[4]}};


    hex_decoder hex_address1( 
        .hex_digit(address_dig1),
        .segments(HEX5)
    );

    hex_decoder hex_address0( 
    .hex_digit(address_dig0),
    .segments(HEX4)
    );


endmodule // ram32x4_FPGA

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule // hex_decoder