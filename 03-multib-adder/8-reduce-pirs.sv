module reduce_and_pirs #(
        parameter int COUNT_OF_BITS = 4
) (
        input logic [COUNT_OF_BITS-1:0] vector,
        output logic res
);

        logic [COUNT_OF_BITS-2:0] temp_n;

        and_pirs first_and (
                .a(vector[0]),
                .b(vector[1]),
                .out(temp_n[0])
        );

        genvar i;
        generate
                for (i = 1; i < COUNT_OF_BITS - 1; i++)
                        and_pirs chain_and (
                                .a(temp_n[i-1]),
                                .b(vector[i+1]),
                                .out(temp_n[i])
                        );
        endgenerate

        assign res = temp_n[COUNT_OF_BITS - 2];
endmodule
