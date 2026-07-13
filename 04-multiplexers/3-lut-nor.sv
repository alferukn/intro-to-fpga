module lut_nor (
    input  logic a, b,
    output logic c
);

    mux_4to1 lut (
        .in  ({1'b0, 1'b0, 1'b0, 1'b1}), 

        .sel ({a, b}), 

        .out (c)
    );

endmodule
