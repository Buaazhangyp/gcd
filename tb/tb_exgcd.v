`timescale 1ns / 1ps

module tb_exgcd;
  reg clk, rst_n, valid_in;
  reg [7 : 0] data_a, data_b;
  wire [7 : 0] gcd;
  wire [7 : 0] inv;
  wire valid_out;
  exgcd_recursion exgcd_inst
  (
    .clk              (clk), 
    .rst_n            (rst_n), 
    .data_a           (data_a), 
    .data_b           (data_b),
    .valid_in         (valid_in),
    .gcd              (gcd), 
    .inv              (inv),
    .valid_out        (valid_out)
  );

  initial begin
    # 5
    clk = 0;
    rst_n = 0;
    # 100
    @(negedge clk) rst_n = 1; // supposed to be gcd = 3, inv = -3
      valid_in = 1;
      data_a = 8'd15;
      data_b = 8'd24;
    # 5
    valid_in = 0;
    # 100
    @(negedge clk)//supposed to be gcd = 1 inv = -3
      valid_in = 1;
      data_a = 8'd9;
      data_b = 8'd7;
    # 5
    valid_in = 0;
    # 100
    @(negedge clk)// suppoed to be gcd = 27, inv = 0
      valid_in = 1;
      data_a = 8'd27;
      data_b = 8'd81;
    # 5
    valid_in = 0;
    # 100
    @(negedge clk)// suppoed to be gcd = 27, inv = 0
      valid_in = 1;
      data_a = 8'd27;
      data_b = 8'd12;
    # 5
    valid_in = 0;
    #100
    $finish();
  end

  always begin
    #1 clk = ~clk;
  end

endmodule

