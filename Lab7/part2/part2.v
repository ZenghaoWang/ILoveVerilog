// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	assign colour = SW[9:7];

	wire [6:0] x; 
	assign x = SW[6:0];
	wire [6:0] y;
	assign y = SW[6:0];
	wire writeEn;

	wire set_x;
	assign set_x = ~KEY[3];
	wire set_y;
	assign set_y = ~KEY[1];

	wire [2:0] colour_out;
	wire [7:0] x_out;
	wire [6:0] y_out;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour_out),
			.x(x_out),
			.y(y_out),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
	wire c_en, x_en, y_en, out_en;
	wire [1:0] x_shift_wire, y_shift_wire;
    control c0(
		.clock(clock),
		.resetn(resetn),
		.go(set_x),
		.draw_square(set_y),

		.load_colour(c_en),
		.load_x(x_en),
		.load_y(y_en),
		.load_out(out_en),

		.x_shift_right(x_shift_wire),
		.y_shift_down(y_shift_wire),
		.plot(writeEn)
	);


	datapath d0(
		.clock(clock),
		.resetn(resetn),
		.x(x),
		.y(y),
		.colour(colour),

		.load_x(x_en),
		.load_y(y_en),
		.load_colour(c_en),

		.x_shift_right(x_shift_wire),
		.y_shift_down(y_shift_wire),
		.load_out(out_en),

		.colour_out(colour_out),
		.x_out(x_out),
		.y_out(y_out)
	);
endmodule

module datapath(
	input clock,
	input resetn, // Active-low synchronous 
	input [6:0] x,
	input [6:0] y,
	input [2:0] colour,
	
	// control signals
	input load_x, load_y, load_colour,
	input [1:0] x_shift_right, y_shift_down,
	input load_out,
	 

	// Outputs to VGA
	output reg [2:0] colour_out,
	output reg [7:0] x_out,
	output reg [6:0] y_out
	);

	// input registers 
	reg [7:0] Rx;
	reg [6:0] Ry;
	


	// ALU output
	reg [7:0] alu_out_x;
	reg [6:0] alu_out_y;

	// Input logic for registers
	always @(posedge clock) begin
		if (!resetn) begin
			Rx <= 0;
			Ry <= 0;
			colour_out <= 0;
		end
		else begin
			if (load_x) 

				Rx[7:0] <= {1'b0, x[6:0]};
			if (load_y) 
				Ry <= y;
			if (load_colour)
				colour_out <= colour;
		end
	end

	// Output register: Increment x, y according to command signals from FSA
	always @(posedge clock) begin
		if (!resetn) begin
			x_out <= 0;
			y_out <= 0;
		end
		else 
			if (load_out)
				y_out <= alu_out_y;
				x_out <= alu_out_x;
	end
					
	// ALU
	always @(*) begin
		alu_out_x = Rx + {5'b00000, x_shift_right};
		alu_out_y = Ry + {4'b0000, y_shift_down};
	end
endmodule // datapath

module control(
	input clock,
	input resetn, 
	input go, // When user inputs X value and presses KEY[3]
	input draw_square,

	output reg load_colour, load_x, load_y, load_out,
	output reg [1:0] x_shift_right, y_shift_down,
	output reg plot // Tells the VGA whether to draw the pixel
	);

	// Keeps track of how to shift the input coordinates 
	reg [3:0] counter = 4'b0000;
	reg load_counter;
	wire done;
	assign done = (counter == 4'b1111);
	always @(posedge clock) begin
		if (done | !resetn) 
			counter = 4'b0000;
		else if (load_counter)
			counter = counter + 1;
	end

	reg [2:0] current_state, next_state;
	localparam // SA States
		S_LOAD_X = 0,
		S_LOAD_X_WAIT = 1,
		S_LOAD_Y = 2, 
		S_LOAD_Y_WAIT = 3,
		S_PRINT_SQUARE = 4,
		S_INCREMENT = 5,
		S_INCREMENT_FINAL = 6;
	
	// State Table
	always @(*) 
		begin: state_table
			case (current_state)
				// Loading in (x, y) coordinates
				S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X;
				S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_LOAD_Y;
				S_LOAD_Y: next_state = draw_square ? S_LOAD_Y_WAIT : S_LOAD_Y;
				S_LOAD_Y_WAIT: next_state = draw_square ? S_LOAD_Y_WAIT : S_PRINT_SQUARE;

				// Printing each pixel of the square
				S_PRINT_SQUARE: next_state = done ? S_INCREMENT_FINAL : S_INCREMENT;
				S_INCREMENT: next_state = S_PRINT_SQUARE;

				S_INCREMENT_FINAL: next_state = S_LOAD_X;
				
				default: next_state = S_LOAD_X;
			endcase
	end // state_table

	// data path control signals
	always @(*)
	begin: control_signals

		load_colour = 1;	
		load_x = 0;
		load_y = 0;
		load_out = 0;
		load_counter = 0;
		x_shift_right = 0;
		y_shift_down = 0;
		plot = 0;

		case (current_state)
			S_LOAD_X: load_x = 1;
			S_LOAD_Y: load_y = 1;

			S_PRINT_SQUARE: begin
				x_shift_right[1:0] = counter[1:0];
				y_shift_down[1:0] = counter[3:2];
				load_out = 1;
			end

			S_INCREMENT: begin
				load_counter = 1;
				plot = 1;
			end

			S_INCREMENT_FINAL: begin
				load_counter = 1;
				plot = 1;
			end
		endcase
	end // control_signals

	// Current state registers
	always @(posedge clock)
	begin: state_FFs
		if (!resetn)
			current_state <= S_LOAD_X;
		else
			current_state <= next_state;
	end // state_FFs

	
endmodule // control

