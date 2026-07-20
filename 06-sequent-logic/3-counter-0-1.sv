module counter_zero_one (
    input logic clk,
    input logic rst,
    input logic val,
    output logic [7:0] zero_out,
    output logic [7:0] one_out
);
  logic [7:0] zero_count;
  logic [7:0] one_count;

  assign zero_out = zero_count;
  assign one_out = one_count;

  always_ff @(posedge clk) begin
    if (rst) begin
      zero_count <= 8'd0;
      one_count  <= 8'd0;
    end else begin
      if (val == 1'd1) 
        one_count <= one_count + 1'b1;
      else if (val == 1'd0) begin
        zero_count <= zero_count + 1'b1;
      end
    end
  end
endmodule
