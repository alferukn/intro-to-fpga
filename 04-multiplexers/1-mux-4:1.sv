module mux_4to1_logic (
    input  logic [3:0] in,
    input  logic [1:0] sel,
    output logic out
);

    assign out = 
        ( ~sel[1] & ~sel[0] & in[0] ) | 
        
        ( ~sel[1] &  sel[0] & in[1] ) | 
        
        (  sel[1] & ~sel[0] & in[2] ) | 
        
        (  sel[1] &  sel[0] & in[3] );

endmodule
