module logic_func (
    input  logic a, b, c,
    output logic out
);

    logic mux1_out;

// (¬b ∧ c)
    mux_2to1 mux1 (
        .in0 (c),
        .in1 (1'b0),
        .sel (b),
        .out (mux1_out) 
    );


    mux_2to1 mux2 (
        .in0 (mux1_out),
        .in1 (1'b0),
        .sel (a),
        .out (out)
    );

endmodule
