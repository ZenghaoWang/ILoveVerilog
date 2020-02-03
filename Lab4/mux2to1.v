module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; 
  
    assign m = s & y | ~s & x;


endmodule // mux2to1