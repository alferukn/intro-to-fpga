module implic_reduce (
    input  logic clk,
    input  logic rst,
    input  logic next_bit,
    output logic res
);

  logic acc;
  logic current_op_res;

  implic oper (
      .a(acc),
      .b(next_bit),
      .c(current_op_res)
  );

  assign res = acc;

  always_ff @(posedge clk) begin
    if (rst) begin
      acc <= 1'b1;
    end else begin
      acc <= current_op_res;
    end
  end

`ifdef FORMAL
  logic past_valid = 1'b0;
  always @(posedge clk) past_valid <= 1'b1;
  initial assume(rst);

  always @(posedge clk) begin
    if (past_valid) begin
      if ($past(rst)) begin
        assert(acc == 1'b1);
      end

      if (!$past(rst) && !rst) begin
        assert(acc == (~$past(acc) | $past(next_bit)));
      end
    end
  end

  logic [3:0] step_cnt = 0;
  always @(posedge clk) begin
    if (rst) 
      step_cnt <= 0;
    else if (past_valid)
      step_cnt <= step_cnt + 1;
  end

  always @(posedge clk) begin
    cover(step_cnt == 6 && acc == 1'b0);
  end

`endif

endmodule


module implic (
    input  logic a, b,
    output logic c
);
  assign c = ~a | b;
endmodule
