// Wrapper module to connect to the FPGA
module tff_final(SW, KEY, HEX0, HEX1);
	input [1:0] SW;
	input [0:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;

	wire clk = ~KEY[0];
	wire enable = SW[1];
	wire clear_b = SW[0];
	wire [7:0] Q;

	t_flipflop t0(.clk(clk), .enable(enable), .clear_b(clear_b), .Q(Q));

	seven_seg h0(.in(Q[3:0]), .hex(HEX0));
	seven_seg h1(.in(Q[7:4]), .hex(HEX1));

endmodule // tff_final

// Instantiates 8 flip-flops
module t_flipflop(clk, enable, clear_b, Q);
	input clk;
	input enable;
	input clear_b;
	output [7:0] Q;

	wire [7:0] q;

	flipflop t0(.clk(clk), .enable(enable), .clear_b(clear_b), .Q(q[0]));
	wire w0 = enable && q[0];
	flipflop t1(.clk(clk), .enable(w0), .clear_b(clear_b), .Q(q[1]));
	wire w1 = w0 && q[1];
	flipflop t2(.clk(clk), .enable(w1), .clear_b(clear_b), .Q(q[2]));
	wire w2 = w1 && q[2];
	flipflop t3(.clk(clk), .enable(w2), .clear_b(clear_b), .Q(q[3]));
	wire w3 = w2 && q[3];
	flipflop t4(.clk(clk), .enable(w3), .clear_b(clear_b), .Q(q[4]));
	wire w4 = w3 && q[4];
	flipflop t5(.clk(clk), .enable(w4), .clear_b(clear_b), .Q(q[5]));
	wire w5 = w4 && q[5];
	flipflop t6(.clk(clk), .enable(w5), .clear_b(clear_b), .Q(q[6]));
	wire w6 = w5 && q[6];
	flipflop t7(.clk(clk), .enable(w6), .clear_b(clear_b), .Q(q[7]));

	assign Q[7:0] = q[7:0];

endmodule

module flipflop(clk, enable, clear_b, Q);
	input clk;
	input enable;
	input clear_b;	
	output reg Q;

	always@(posedge clk, negedge clear_b)
	begin
		if (clear_b == 1'b0)
			Q <= 1'b0;
		
		else
			Q <= Q ^ enable;
	end

endmodule

// Converts a 4-bit input to an output that displays the input in hexadecimal
module seven_seg(in, hex);
	input [3:0] in;
	output [6:0] hex;

	assign hex[0] = (~in[3] & ~in[2] & ~in[1] & in[0]) | (~in[3] & in[2] & ~in[1] & ~in[0]) | (in[3] & ~in[2] & in[1] & in[0]) | (in[3] & in[2] & ~in[1] & in[0]);
	assign hex[1] = (~in[3] & in[2] & ~in[1] & in[0])  | (in[3] & in[1] & in[0]) | (in[2] & in[1] & ~in[0]) | (in[3] & in[2] & ~in[0]);
	assign hex[2] = (~in[3] & ~in[2] & in[1] & ~in[0]) | (in[3] & in[2] & ~in[1] & ~in[0]) | (in[3] & in[2] & in[1]);
	assign hex[3] = (~in[2] & ~in[1] & in[0]) | (in[2] & in[1] & in[0]) | (~in[3] & in[2] & ~in[1] & ~in[0]) | (in[3] & ~in[2] & in[1] & ~in[0]);
	assign hex[4] = (~in[3] & in[0]) | (~in[2] & ~in[1] & in[0]) | (~in[3] & in[2] & ~in[1]);
	assign hex[5] = (~in[3] & ~in[2] & in[0]) | (~in[3] & ~in[2] & in[1]) | (~in[3] & in[1] & in[0]) | (~in[2] & ~in[1] & in[0]);
	assign hex[6] = (~in[3] & ~in[2] & ~in[1])| (~in[3] & in[2] & in[1] & in[0]) | (in[3] & in[2] & ~in[1] & ~in[0]);
	
endmodule