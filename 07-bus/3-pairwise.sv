module pairwise (
    input logic clk,
    input logic aresetn,

    input  logic s_valid,
    output logic s_ready,
    input  logic s_data,

    output logic m_valid,
    input logic m_ready,
    output logic [1:0] m_data
);

  logic prev_bit_ff;
  logic has_prev_ff;

  always_comb begin
    m_valid = has_prev_ff & s_valid;
    m_data  = {prev_bit_ff, s_data};
    s_ready = ~m_valid | m_ready;
  end

  always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      prev_bit_ff <= 1'b0;
      has_prev_ff <= 1'b0;
    end else begin
      if (s_valid & s_ready) begin
        prev_bit_ff <= s_data;
        has_prev_ff <= 1'b1;
      end
    end
  end

endmodule
