module adder_k_int #(
        parameter int COUNT_OF_NUM = 4
) (
        input  int numbers [COUNT_OF_NUM],
        output int sum
);

        int temp_n [COUNT_OF_NUM];

        assign temp_n[0] = numbers[0] + numbers[1];
        assign sum = temp_n[COUNT_OF_NUM-2];

        genvar i;
        generate
                for (i = 1; i < COUNT_OF_NUM - 1; i++)
                        assign temp_n[i] = temp_n[i-1] + numbers[i+1];
        endgenerate

endmodule
