module morse(SW, KEY, CLOCK50, LEDR);
	input [2:0] SW;
	input [1:0] KEY;
	input CLOCK50;
	output [0:0] LEDR;

	reg [13:0] letter;

	always@(*)
	begin
		case(SW[2:0])
			3'b000: letter = 14'b10101000000000;
			3'b001: letter = 14'b11100000000000;
			3'b010: letter = 14'b10101110000000;
			3'b011: letter = 14'b10101011100000;
			3'b100: letter = 14'b10111011100000;
			3'b101: letter = 14'b11101010111000;
			3'b110: letter = 14'b11101011101110;
			3'b111: letter = 14'b11101110101000;
			default: letter = 14'b00000000000000;
		endcase
	end

	wire clk = CLOCK50;
	wire load_n = KEY[1];
	wire shift;
	wire reset_n = KEY[0];
	wire [24:0] timer;
	wire [13:0] out;

	rateCounter r0(.clk(CLOCK50), .q(timer));

	// assign shift = (timer == 25'b1011111010111100000111111);
	assign shift = (timer == 3'b100);


	shiftregister s0(.load_val(letter), .load_n(load_n), .shift(shift), .clk(CLOCK50), .reset_n(reset_n), .out(out));

	assign LEDR[0] = out[0];

endmodule

module rateCounter(clk, q);

	input clk;
	output reg [24:0] q = 0;

	always @(posedge clk)
	begin
		if (q == 0)
			begin
				// q <= 25'b1011111010111100000111111;
				q <= 3'b100;
			end
		else
			begin
				q <= q - 1'b1;
			end
	end

endmodule

module shiftregister(load_val, load_n, shift, clk, reset_n, out);

	input [13:0] load_val;
	input load_n;
	input shift;
	input clk;
	input reset_n;
	output [13:0] out;

	wire [13:0] Q;

	shifter s13(.in(1'b0), .load_val(load_val[13]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[13]));
	shifter s12(.in(Q[13]), .load_val(load_val[12]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[12]));
	shifter s11(.in(Q[12]), .load_val(load_val[11]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[11]));
	shifter s10(.in(Q[11]), .load_val(load_val[10]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[10]));
	shifter s9(.in(Q[10]), .load_val(load_val[9]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[9]));
	shifter s8(.in(Q[9]), .load_val(load_val[8]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[8]));
	shifter s7(.in(Q[8]), .load_val(load_val[7]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[7]));
	shifter s6(.in(Q[7]), .load_val(load_val[6]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[6]));
	shifter s5(.in(Q[6]), .load_val(load_val[5]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[5]));
	shifter s4(.in(Q[5]), .load_val(load_val[4]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[4]));
	shifter s3(.in(Q[4]), .load_val(load_val[3]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[3]));
	shifter s2(.in(Q[3]), .load_val(load_val[2]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[2]));
	shifter s1(.in(Q[2]), .load_val(load_val[1]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[1]));
	shifter s0(.in(Q[1]), .load_val(load_val[0]), .load_n(load_n), .shift(shift), .clk(clk), .reset_n(reset_n), .out(Q[0]));

	assign out = Q[13:0];

endmodule

module shifter(in, load_val, load_n, shift, clk, reset_n, out);
	input in;
	input load_val;
	input load_n;
	input shift;
	input clk;
	input reset_n;
	output out;

	wire m0_output;
	wire m1_output;

	mux2to1 m0(.x(out), .y(in), .s(shift), .m(m0_output));

	mux2to1 m1(.x(load_val), .y(m0_output), .s(load_n), .m(m1_output));

	flipflop f0(.d(m1_output), .q(out), .clk(clk), .reset_n(reset_n));

endmodule

module flipflop(d, q, clk, reset_n);
	input d;
	input clk;
	input reset_n;
	output q;
	reg q;

	always@(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end

endmodule
	

module mux2to1(x, y, s, m);
	input x; //selected when s is 0
	input y; //selected when s is 1
	input s; //select signal
	output m; //output
  
 	assign m = s & y | ~s & x;

endmodule