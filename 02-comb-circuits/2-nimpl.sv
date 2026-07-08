module not_implic (
        input logic a,
        input logic b,
        output logic c
);

assign c = a & ~b;

`ifdef FORMAL
  always @* begin
        assert (c == (a && !b));
        cover (c == 1'b1);
        cover (a == 1'b1 && b == 1'b1);
end
`endif

endmodule