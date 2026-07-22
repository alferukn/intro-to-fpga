module conv_1d #(
    parameter int KERNEL_SIZE = 3
) (
    input  logic clk,
    input  logic aresetn,

    input  logic [31:0] weights [KERNEL_SIZE],

    input  logic s_valid,
    output logic s_ready,
    input  byte unsigned s_data,

    output logic m_valid,
    input  logic m_ready,
    output byte unsigned m_data
);

  logic [KERNEL_SIZE-1:0] windowed_out_bits [8];
  
  logic [7:0] w_s_ready;
  logic [7:0] w_m_valid;

  genvar i;
  generate
    for (i = 0; i < 8; i++) begin
      windowed #(
          .W_SIZE(KERNEL_SIZE)
      ) win_inst (
          .clk(clk),
          .aresetn(aresetn),
          .s_valid(s_valid),
          .s_ready(w_s_ready[i]),
          .s_data(s_data[i]),
          .m_valid(w_m_valid[i]),
          .m_ready(m_ready),
          .m_data(windowed_out_bits[i])
      );
    end
  endgenerate

  assign s_ready = w_s_ready[0];
  assign m_valid = w_m_valid[0];

  byte unsigned window_bytes [KERNEL_SIZE];

  always_comb begin
    for (int k = 0; k < KERNEL_SIZE; k++) begin
      for (int b = 0; b < 8; b++) begin
        window_bytes[k][b] = windowed_out_bits[b][k];
      end
    end
  end

  scalar_mult #(
      .VECTORS_SIZE(KERNEL_SIZE)
  ) mult_inst (
      .float_in(weights),
      .uint8_in(window_bytes),
      .uint8_res(m_data)
  );

endmodule
