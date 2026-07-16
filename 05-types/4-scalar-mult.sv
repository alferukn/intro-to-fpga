module scalar_mult #(
    parameter int VECTORS_SIZE = 9
)(
    input  logic [31:0] float_in [VECTORS_SIZE],
    input  byte unsigned uint8_in [VECTORS_SIZE],
    output byte unsigned uint8_res
);

    byte unsigned temp_storage [VECTORS_SIZE];

    genvar i;
    generate
        for (i = 0; i < VECTORS_SIZE; i++) begin : gen_mult
            float_mult_byte_modif mult (
                .float_in  (float_in[i]),
                .uint8_in  (uint8_in[i]),
                .uint8_out (temp_storage[i])
            );
        end
    endgenerate

    int unsigned sum; 

    always_comb begin
        sum = 0;
        for (int j = 0; j < VECTORS_SIZE; j++) begin
            sum = sum + temp_storage[j];
        end

        if (sum > 255)
            uint8_res = 8'd255;
        else
            uint8_res = 8'(sum);
    end

endmodule
