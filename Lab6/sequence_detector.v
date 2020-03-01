// SW[0]:       Synchronous active-low reset signal
// SW[1]:       input signal 

// KEY[0]:      clock

// LEDR[2:0]:   current state
// LEDR[9]:     output (z)

module sequence_detector(SW, KEY, LEDR);
    input [9:0] SW;
    input [3:0] KEY;
    output [9:0] LEDR;

    wire input_signal, clock, resetn, z;
    
    reg [2:0] current_state, next_state; 

    localparam A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101, G = 3'b110;
    
    // Connect inputs and outputs to internal wires
    assign input_signal = SW[1];
    assign clock = ~KEY[0];
    assign resetn = SW[0];
    assign LEDR[9] = z;
    assign LEDR[2:0] = current_state;

    // State table
    // The state table should only contain the logic for state transitions
    // Do not mix in any output logic.  The output logic should be handled separately.
    // This will make it easier to read, modify and debug the code.
    always @(*)
    begin   // Start of state_table
        case (current_state)
            A: begin
                   if (!input_signal) next_state = A;
                   else next_state = B;
               end
            B: begin
                   if(!input_signal) next_state = A;
                   else next_state = C;
               end
            C: begin
                   if (!input_signal) next_state = E;
                   else next_state = D;
               end                                 
            D: begin
                   if (!input_signal) next_state = E;
                   else next_state = F;
               end 
            E: begin
                   if (!input_signal) next_state = A;
                   else next_state = G;
               end 
            F: begin
                   if (!input_signal) next_state = E;
                   else next_state = F;
               end 
            G: begin
                   if (!input_signal) next_state = A;
                   else next_state = C;
               end                                              
            default: next_state = A;
        endcase
    end     // End of state_table

    // State Register (i.e., FFs)
    always @(posedge clock)
    begin   // Start of state_FFs (state register)
        if(resetn == 1'b0)
            current_state <= A;
        else
            current_state <= next_state
;
    end     // End of state_FFs (state register)

    // Output logic
    // Set z to 1 to turn on LED when in relevant states
    assign z = ((current_state == F) || (current_state == G));  
endmodule
