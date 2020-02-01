 module mux7to1FPGA(SW, LEDR);
    // Use the FPGA switches as input and an LED as output
    input [9:0] SW;
    output [9:0] LEDR;

    // Instantiating a mux and connecting it to hardware ports
    mux7to1 m1(
        .Input(SW[6:0]),
        .MuxSelect(SW[9:7]),
        .Out(LEDR[0])
    );
 endmodule // mux7to1FPGA
 
 
 module mux7to1(Input, MuxSelect, Out);
    // 7-bit input, 3-bit select input
    input [6:0] Input;
    input [2:0] MuxSelect;
    output Out;

    reg Out;
    always @(*) 
    begin
        // Determines which input is outputted using the select switches
        case (MuxSelect[2:0])
            3'b000: Out = Input[0];
            3'b001: Out = Input[1];
            3'b010: Out = Input[2];
            3'b011: Out = Input[3];
            3'b100: Out = Input[4];
            3'b101: Out = Input[5];
            3'b110: Out = Input[6];
            default: Out = 1'b0;
        endcase
    end
 endmodule // mux7to1