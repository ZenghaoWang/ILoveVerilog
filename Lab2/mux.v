/* Inputs:
	SW[0] = u
	SW[1] = v
	SW[2] = w
	sw[3] = x
	
	Select signals:
	SW[8] = s1
	SW[9] = s2

*/
//LEDR[0] output display

module mux(LEDR, SW);
         input [9:0] SW;
         output [9:0] LEDR;
	 // Connections for the 3 multiplexers 
	 wire wire0;
	 wire wire1;
	 


	//Takes u and w, outputs u if s1 = 0 to wire 1
	mux2to1 u0(
        .x(SW[0]),
        .y(SW[2]),
        .s(SW[8]),
        .m(wire0)
        );

	 
	// Takes v and x, outputs v if s1 = 0 to wire 2
        mux2to1 u1(
        .x(SW[1]),
        .y(SW[3]),
        .s(SW[8]),
        .m(wire1)
        );
	
	/*Takes outputs from first 2 multiplexers and 
	outputs to LEDR[0] according to truth table */
	mux2to1 u2(
	.x(wire0),
	.y(wire1),
	.s(SW[9]),
	.m(LEDR[0])
	);
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule
