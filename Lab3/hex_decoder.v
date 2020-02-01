module hex_decoder(SW, HEX0);
    input [3:0] SW;
    output [6:0] HEX0;

    decoder d0(
        .c(SW),
        .segment(HEX0)
    );

endmodule



module decoder(c, segment);
    input [3:0] c; //c3, c2, c1, c0
    output [6:0] segment; //The 7 segments of the decoder

    assign segment[0] = (~c[3] & ~c[2] & ~c[1] & c[0]) |
                        (~c[3] & c[2] & ~c[1] & ~c[0]) |
                        (c[3] & ~c[2] & c[1] & c[0]) |    
                        (c[3] & c[2] & ~c[1] & c[0]);
    
    assign segment[1] = (c[3] & c[2] & ~c[0]) |    
                        (c[3] & c[1] & c[0]) |
                        (c[2] & c[1] & ~c[0]) |
                        (~c[3] & c[2] & ~c[1] & c[0]);
    
    assign segment[2] = (c[3] & c[2] & ~c[0]) |
                        (c[3] & c[2] & c[1]) |
                        (~c[3] & ~c[2] & c[1] & ~c[0]);
                        
    assign segment[3] = (~c[3] & c[2] & ~c[1] & ~c[0]) |
                        (~c[3] & ~c[2] & ~c[1] & c[0]) |
                        (c[2] & c[1] & c[0]) | 
                        (c[3] & ~c[2] & c[1] & ~c[0]);
    
    assign segment[4] = (~c[3] & c[0]) | 
                        (~c[3] & c[2] & ~c[1]) |
                        (~c[2] & ~c[1] & c[0]);
    
    assign segment[5] = (~c[3] & ~c[2] & c[0]) |
                        (~c[3] & ~c[2] & c[1]) |
                        (~c[3] & c[1] & c[0]) |
                        (c[3] & c[2] & ~c[1] & c[0]);
    
    assign segment[6] = (~c[3] & ~c[2] & ~c[1]) |
                        (~c[3] & c[2] & c[1] & c[0]) |
                        (c[3] & c[2] & ~c[1] & ~c[0]);
endmodule
