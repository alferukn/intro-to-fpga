module windowed #(
    parameter int W_SIZE = 3
) (
    input  logic clk,
    input  logic aresetn,

    input  logic s_valid,
    output logic s_ready,
    input  logic s_data,

    output logic m_valid,
    input  logic m_ready,
    output logic [W_SIZE-1:0] m_data
);

  logic [W_SIZE-2:0] shift_ff;

  logic [$clog2(W_SIZE):0] count_ff;

always_comb begin
        m_data = {shift_ff, s_data};
        m_valid = (count_ff == (W_SIZE - 1)) && s_valid;
        s_ready = ~m_valid | m_ready;
end

  always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      shift_ff <= '0;
      count_ff     <= '0;
    end 
    else begin
      if (s_valid & s_ready) begin
        
        if (W_SIZE > 1) begin
            shift_ff <= {shift_ff[W_SIZE-3:0], s_data};
        end

        if (count_ff < (W_SIZE - 1)) begin
          count_ff <= count_ff + 1;
        end
      end
    end
  end

endmodule
