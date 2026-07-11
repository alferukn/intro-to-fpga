module reduce_bitvector_and #(
        parameter int COUNT_OF_BITS = 4
) (
        input logic [COUNT_OF_BITS-1:0] vector,
        output logic res
);

        logic [COUNT_OF_BITS-2:0] temp_n;

        assign temp_n[0] = vector[0] & vector[1];

        genvar i;
        generate
                for (i = 1; i < COUNT_OF_BITS - 1; i++)
                        assign temp_n[i] = temp_n[i-1] & vector[i+1];
        endgenerate

        assign res = temp_n[COUNT_OF_BITS - 2];

endmodule
