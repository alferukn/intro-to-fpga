module float_add (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] sum
);

  logic a_is_larger;
  logic [31:0] L, S;

  assign a_is_larger = (a[30:0] > b[30:0]);
  assign L = a_is_larger ? a : b;
  assign S = a_is_larger ? b : a;

  logic        sign_L;
  logic [7:0]  exp_L;
  logic [23:0] mant_L;

  assign sign_L = L[31];
  assign exp_L  = L[30:23];
  assign mant_L = (exp_L == 0) ? 24'd0 : {1'b1, L[22:0]};

  logic        sign_S;
  logic [7:0]  exp_S;
  logic [23:0] mant_S;

  assign sign_S = S[31];
  assign exp_S  = S[30:23];
  assign mant_S = (exp_S == 0) ? 24'd0 : {1'b1, S[22:0]};

  logic [ 7:0] exp_diff;
  logic [23:0] mant_S_aligned;

  assign exp_diff = exp_L - exp_S;
  assign mant_S_aligned = (exp_diff > 23) ? 24'd0 : (mant_S >> exp_diff);

  logic [24:0] mant_sum;

  always_comb begin
    if (sign_L == sign_S) begin
      mant_sum = mant_L + mant_S_aligned;
    end else begin
      mant_sum = mant_L - mant_S_aligned;
    end
  end


  logic [ 4:0] shift_left;
  logic [24:0] mant_norm;
  logic [ 7:0] exp_norm;

  always_comb begin
    shift_left = 0;
    mant_norm  = mant_sum;
    exp_norm   = exp_L;

    if (mant_sum == 0) begin
      exp_norm  = 0;
      mant_norm = 0;

    end else if (mant_sum[24] == 1'b1) begin
      mant_norm = mant_sum >> 1;
      exp_norm  = exp_L + 1;

    end else begin
      for (int i = 23; i >= 0; i--) begin
        if (mant_sum[i] == 1'b1) begin
          shift_left = 23 - i;
          break;
        end
      end

      mant_norm = mant_sum << shift_left;
      exp_norm  = exp_L - shift_left;
    end
  end

  always_comb begin
    if (mant_sum == 0) begin
      sum = 32'd0;
    end else begin
      sum = {sign_L, exp_norm, mant_norm[22:0]};
    end
  end

endmodule
