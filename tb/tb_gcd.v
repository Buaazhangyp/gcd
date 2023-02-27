`timescale 1ns / 1ps

module tb_gcd;
  reg clk, rst_n;
  reg [7 : 0] data_a, data_b;
  wire [7 : 0] gcd;
  wire [1: 0] current_state;
  gcd gcd_inst
  (
    .clk(clk), 
    .rst_n(rst_n), 
    .data_a(data_a), 
    .data_b(data_b), 
    .gcd(gcd), 
    .current_state_out(current_state)
  );

  initial begin
    # 5
    clk = 0;
    rst_n = 0;
    # 5
    @(negedge clk) rst_n = 1;
      data_a = 8'd15;
      data_b = 8'd24;
    # 5
    @(negedge clk)
      data_a = 8'd9;
      data_b = 8'd7;
    # 5
    @(negedge clk)
      data_a = 8'd27;
      data_b = 8'd81;
  end

  always begin
    #1 clk = ~clk;
  end

endmodule

