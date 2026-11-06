// SPDX-License-Identifier: GPL-3.0-or-later
//
// Copyright (C) 2026 Richard Qin

`timescale 1ns/1ns

module tb_adder3;
   reg  [2:0] A;
   reg  [2:0] B;
   wire [2:0] S;
   wire       cout;

   reg [3:0]   expected;
   integer     i, j;
   integer     errors;

   adder3 dut (
	       .A(A),
	       .B(B),
	       .S(S),
	       .cout(cout)
	       );

   initial begin
      errors = 0;

      for (i = 0; i < 8; i = i + 1) begin
	 for (j = 0; j < 8; j = j + 1) begin

	    A = i[2:0];
	    B = j[2:0];

	    expected = {1'b0, A} + {1'b0, B};

	    #1;

	    if ({cout, S} !== expected) begin
	       $display("FAIL: A=%d B=%d S=%d cout=%b expected=%d",
			A, B, S, cout, expected);
	       errors = errors + 1;

	    end
	 end // for (j = 0; j < 8; j = j + 1)
      end // for (i = 0; i < 8; i = i + 1)

      if (errors == 0) begin
	 $display("PASS: All 64 tests passed!");
      end
      else begin
	 $display("FAIL: %0d tests failed", errors);
	 $stop;
      end

      $finish;
   end // initial begin

   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(0, tb_adder3);
   end

endmodule // tb_adder3
