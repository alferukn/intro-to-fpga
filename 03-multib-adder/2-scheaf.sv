module and_sch(
        input logic a,
        input logic b,
        output logic out
);

        logic temp_c;

        schaeffer f_sch(
                .a(a),
                .b(b),
                .c(temp_c)
        );

        schaeffer s_sch(
                .a(temp_c),
                .b(temp_c),
                .c(out)
        );
endmodule

module or_sch (
        input logic a,
        input logic b,
        output logic out
);
        logic temp_a, temp_b, temp_c;

        schaeffer not_a(
                .a(a),
                .b(a),
                .c(temp_a)
        );

        schaeffer not_b(
                .a(b),
                .b(b),
                .c(temp_b)
        );

        and_sch na_and_nb(
                .a(temp_a),
                .b(temp_b),
                .out(temp_c)
        );
        schaeffer not_temp_c(
                .a(temp_c),
                .b(temp_c),
                .c(out)
        );
endmodule

module impl_sch (
        input logic a,
        input logic b,
        output logic out
);
        logic temp_a;

        schaeffer not_a(
                .a(a),
                .b(a),
                .c(temp_a)
        );

        or_sch na_or_b(
                .a(temp_a),
                .b(b),
                .out(out)
        );
endmodule
