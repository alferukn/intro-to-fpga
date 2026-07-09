module or_pirs (
        input logic a,
        input logic b,
        output logic out
);

        logic temp_c;

        pirs first_pirs(
                .a(a),
                .b(b),
                .c(temp_c)
        );

        pirs second_pirs(
                .a(temp_c),
                .b(temp_c),
                .c(out)
        );
endmodule

module and_pirs (
        input logic a,
        input logic b,
        output logic out
);
        logic temp_c, temp_a, temp_b;

        pirs not_a(
                .a(a),
                .b(a),
                .c(temp_a)
        );
        pirs not_b(
                .a(b),
                .b(b),
                .c(temp_b)
        );
        or_pirs na_or_nb(
                .a(temp_a),
                .b(temp_b),
                .out(temp_c)
        );
        pirs not_temp_c(
                .a(temp_c),
                .b(temp_c),
                .c(out)
        );
endmodule

module impl_pirs (
        input logic a,
        input logic b,
        output logic out
);
        logic temp_a;

        pirs not_a(
                .a(a),
                .b(a),
                .c(temp_a)
        );

        or_pirs na_or_b(
                .a(temp_a),
                .b(b),
                .out(out)
        );
endmodule
