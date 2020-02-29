
// Wrapper module
module counter(SW, CLOCK50, HEX0);
	input [2:0] SW;
	input CLOCK50;
	output [6:0] HEX0;

	reg [27:0] count;
	wire [27:0] rate_out;

	wire [3:0] out;

	always@(*)
	begin
		case(SW[1:0])
			2'b00: count = 0;
			2'b01: count = 28'b0010111110101111000001111111;
			2'b10: count = 28'b0101111101011110000011111111;
			2'b11: count = 28'b1011111010111100000111111111;
			default: count = 0;
		endcase
	end

	rateCounter r0(.d(count), .clk(CLOCK50), .q(rate_out)); 

	wire enable;
	assign enable = (rate_out == 0);

	displayCounter d0(.clk(CLOCK50), .reset_n(SW[2]), .enable(enable), .q(out));

	seven_seg s0(.in(out), .hex(HEX0));

endmodule // counter

module rateCounter(d, clk, q);

	input [27:0] d;
	input clk;
	output reg [27:0] q = 0;

	always @(posedge clk)
	begin
		if (q == 1'b0)
			begin
				q <= d;
			end
		else
			begin
				q <= q - 1'b1;
			end
	end

endmodule //rateCounter

module displayCounter(clk, reset_n, enable, q);

	input clk;
	input reset_n;
	input enable;
	output reg [3:0] q;

	always @(posedge clk)
	begin
		if (reset_n == 1'b1)
			q <= 1'b0;
		else if (enable == 1'b1)
			q <= q + 1'b1;
	end

endmodule // displayCounter

module decoder(in, hex);
    input [3:0] in; //c3, c2, c1, c0
    output [6:0] hex; //The 7 segments of the decoder

    assign hex[0] = (~in[3] & ~in[2] & ~in[1] & in[0]) |
                        (~in[3] & in[2] & ~in[1] & ~in[0]) |
                        (in[3] & ~in[2] & in[1] & in[0]) |    
                        (in[3] & in[2] & ~in[1] & in[0]);
    
    assign hex[1] = (in[3] & in[2] & ~in[0]) |    
                        (in[3] & in[1] & in[0]) |
                        (in[2] & in[1] & ~in[0]) |
                        (~in[3] & in[2] & ~in[1] & in[0]);
    
    assign hex[2] = (in[3] & in[2] & ~in[0]) |
                        (in[3] & in[2] & in[1]) |
                        (~in[3] & ~in[2] & in[1] & ~in[0]);
                        
    assign hex[3] = (~in[3] & in[2] & ~in[1] & ~in[0]) |
                        (~in[3] & ~in[2] & ~in[1] & in[0]) |
                        (in[2] & in[1] & in[0]) | 
                        (in[3] & ~in[2] & in[1] & ~in[0]);
    
    assign hex[4] = (~in[3] & in[0]) | 
                        (~in[3] & in[2] & ~in[1]) |
                        (~in[2] & ~in[1] & in[0]);
    
    assign hex[5] = (~in[3] & ~in[2] & in[0]) |
                        (~in[3] & ~in[2] & in[1]) |
                        (~in[3] & in[1] & in[0]) |
                        (in[3] & in[2] & ~in[1] & in[0]);
    
    assign hex[6] = (~in[3] & ~in[2] & ~in[1]) |
                        (~in[3] & in[2] & in[1] & in[0]) |
                        (in[3] & in[2] & ~in[1] & ~in[0]);
endmodule