module adder_k_n_bit_num #(
        parameter int COUNT_OF_NUM = 4,
        parameter int COUNT_OF_BITS = 4
) (
        input logic [COUNT_OF_BITS-1:0] numbers [COUNT_OF_NUM],
        output logic [COUNT_OF_BITS-1:0] sum,
        output logic [COUNT_OF_NUM-2:0] all_carries
);

        logic [COUNT_OF_BITS-1:0] temp_n [COUNT_OF_NUM-1];
        assign sum = temp_n[COUNT_OF_NUM-2]; 

        adder_multibits_reuse #(
                .COUNT_OF_BITS(COUNT_OF_BITS)
                ) first_add (
                .a(numbers[0]),
                .b(numbers[1]),
                .c_in(1'b0),
                .c_out(all_carries[0]),
                .sum(temp_n[0])
        );

        genvar i;
        generate
                for (i = 1; i < COUNT_OF_NUM-1; i++)
                adder_multibits_reuse #(
                        .COUNT_OF_BITS(COUNT_OF_BITS)
                        ) add (
                        .a(temp_n[i-1]),
                        .b(numbers[i+1]),
                        .c_in(1'b0),
                        .c_out(all_carries[i]),
                        .sum(temp_n[i])
                );
        endgenerate
endmodule
