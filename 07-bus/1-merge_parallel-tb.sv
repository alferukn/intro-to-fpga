`timescale 1ns / 1ps
module merge_parallel_tb;

  localparam int InWidth_1 = 3;
  localparam int InWidth_2 = 8;
  localparam int OutWidth = InWidth_1 + InWidth_2;

  logic clk;
  logic aresetn;


  logic s_valid_1;
  logic s_ready_1;
  logic [InWidth_1-1:0] s_data_1;

  logic s_valid_2;
  logic s_ready_2;
  logic [InWidth_2-1:0] s_data_2;


  logic m_valid;
  logic m_ready;
  logic [OutWidth-1:0] m_data;

  merge_parallel #(
      .IN_WIDTH_1(InWidth_1),
      .IN_WIDTH_2(InWidth_2),
      .OUT_WIDTH (OutWidth)
  ) DUT (
      .clk      (clk),
      .aresetn  (aresetn),
      .s_valid_1(s_valid_1),
      .s_ready_1(s_ready_1),
      .s_data_1 (s_data_1),
      .s_valid_2(s_valid_2),
      .s_ready_2(s_ready_2),
      .s_data_2 (s_data_2),
      .m_valid  (m_valid),
      .m_ready  (m_ready),
      .m_data   (m_data)
  );

  localparam int ClkPeriod = 10;

  initial begin
    clk <= '0;
    forever begin
      #(ClkPeriod / 2) clk <= ~clk;
    end
  end

  initial begin
    aresetn <= '0;
    #(ClkPeriod);
    aresetn <= '1;
  end

  localparam int NOfIterations = 1000;

  initial begin
    s_valid_1 <= 0;
    s_data_1  <= 0;
    wait (aresetn);

    repeat (NOfIterations) begin
      @(posedge clk);
      s_valid_1 <= 1;
      s_data_1  <= $urandom;
      do begin
        @(posedge clk);
      end while (!s_ready_1);
      s_valid_1 <= 0;
    end
  end

  initial begin
    s_valid_2 <= 0;
    s_data_2  <= 0;
    wait (aresetn);

    repeat (NOfIterations) begin
      @(posedge clk);
      s_valid_2 <= 1;
      s_data_2  <= $urandom;
      do begin
        @(posedge clk);
      end while (!s_ready_2);
      s_valid_2 <= 0;
    end
    $display("All tests were run");
    $finish();
  end

  initial begin
    wait (~aresetn);
    m_ready <= $urandom();
    wait (aresetn);

    forever begin
      @(posedge clk);
      m_ready <= $urandom();
    end
  end

  logic [InWidth_1-1:0] expected_1;
  logic [InWidth_2-1:0] expected_2;
  logic seen_1 = 0, seen_2 = 0;

  always @(posedge clk) begin
    if (!aresetn) begin
      seen_1 <= 0;
      seen_2 <= 0;
    end else begin
      if (s_valid_1 && s_ready_1) begin
        expected_1 <= s_data_1;
        seen_1     <= 1;
      end
      if (s_valid_2 && s_ready_2) begin
        expected_2 <= s_data_2;
        seen_2     <= 1;
      end
      if (m_valid && m_ready) begin
        seen_1 <= 0;
        seen_2 <= 0;
      end
    end
  end

  initial begin
    wait (aresetn);
    forever begin
      @(posedge clk);
      if (m_valid !== (seen_1 && seen_2)) begin
        $error("Time %0t: Protocol Error. m_valid=%b, but seen_1=%b, seen_2=%b", $time(), m_valid,
               seen_1, seen_2);
      end

      if (m_valid && m_ready) begin
        if (m_data !== {expected_2, expected_1}) begin
          $error("Time %0t: Incorrect m_data. Got %h, expected %h", $time(), m_data, {expected_2,
                                                                                      expected_1});
        end
      end
    end
  end


  initial begin
    repeat (100000) @(posedge clk);
    $stop();
  end

endmodule
