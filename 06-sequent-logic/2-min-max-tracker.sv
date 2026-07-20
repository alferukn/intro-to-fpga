module min_max_tracker (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] val,
    output logic [7:0] min_out,
    output logic [7:0] max_out
);

  logic [7:0] min_reg;
  logic [7:0] max_reg;

  assign min_out = min_reg;
  assign max_out = max_reg;

  always_ff @(posedge clk) begin
    if (rst) begin
      min_reg <= 8'd255; 
      max_reg <= 8'd0;
    end else begin
      if (val < min_reg) begin
        min_reg <= val;
      end
      if (val > max_reg) begin
        max_reg <= val;
      end
    end
  end

endmodule
