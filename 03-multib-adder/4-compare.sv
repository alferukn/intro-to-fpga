module compare (
    input logic a,
    input logic b
);
    logic out_pirs;
    logic out_sch;

    and_pirs and_p (.a(a), .b(b), .out(out_pirs));
    and_sch  and_sch (.a(a), .b(b), .out(out_sch));

        `ifdef FORMAL
                always @* begin
                assert (out_pirs == out_sch);
                end
        `endif
endmodule
