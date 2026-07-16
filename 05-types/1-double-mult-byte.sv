module double_mult_byte (
    input logic [63:0] double_in,
    input byte unsigned uint8_in,
    output byte unsigned uint8_out
);
  logic sign;
  logic [10:0] exponent;
  logic [51:0] mantissa;

  int          exp_shift;
  logic [63:0] scaled_mantissa;
  logic [63:0] mantissa_mult;
  logic [63:0] uint_extended;
  logic [64:0] fraction_sum;

  always_comb begin
    sign          = double_in[63];
    exponent      = double_in[62:52];
    mantissa      = double_in[51:0];

    exp_shift     = int'(exponent) - 1023;

    mantissa_mult = mantissa * uint8_in;
    uint_extended = uint8_in;

    if ((exp_shift - 52) >= 0) begin
      scaled_mantissa = (mantissa_mult << (exp_shift - 52)) + (uint_extended << exp_shift);

    end else if (exp_shift >= 0) begin
      scaled_mantissa = (mantissa_mult >> -(exp_shift - 52)) + (uint_extended << exp_shift);

    end else begin

      if ((uint_extended << (64 + exp_shift)) == 0) begin
        fraction_sum = (mantissa_mult << (64 + (exp_shift - 52)));
      end else begin
        fraction_sum = (mantissa_mult << (64 + (exp_shift - 52))) +
                             (uint_extended << (64 + exp_shift));
      end

      scaled_mantissa = (mantissa_mult >> -(exp_shift - 52)) +
                            (uint_extended >> -exp_shift) + 
                            fraction_sum[64];
    end

    if (scaled_mantissa > 255) begin
      uint8_out = 8'd255;
    end else if (scaled_mantissa == 0 || sign) begin
      uint8_out = 8'd0;
    end else begin
      uint8_out = scaled_mantissa[7:0];
    end
  end

endmodule
