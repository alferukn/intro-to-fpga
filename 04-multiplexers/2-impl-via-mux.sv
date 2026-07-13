module imply_via_mux2to1 (
    input  logic a, b,
    output logic out
);

    mux_2to1 mux (
        .in0 (1'b1),
        .in1 (b),
        .sel (a),
        .out (out)
    );

endmodule
