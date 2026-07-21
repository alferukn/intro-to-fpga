module serial_adder (
    input  logic clk,
    input  logic aresetn,

    input  logic s_valid,
    output logic s_ready,
    input  logic s_data_a,
    input  logic s_data_b,
    input  logic s_last,

    output logic m_valid,
    input  logic m_ready,
    output logic m_data,
    output logic m_last
);

  logic carry_ff;

  logic sum;
  logic next_carry;

  always_comb begin
    {next_carry, sum} = s_data_a + s_data_b + carry_ff;
  end

  always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      carry_ff <= 1'b0;
    end else if (s_valid && s_ready) begin
      if (s_last) begin
        carry_ff <= 1'b0;
      end else begin
        carry_ff <= next_carry;
      end
    end
  end

  always_comb begin
    s_ready = m_ready;
    m_valid = s_valid;
    m_data = sum;
    m_last = s_last;
  end

endmodule
