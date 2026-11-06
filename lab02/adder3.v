// SPDX-License-Identifier: GPL-3.0-or-later
//
// Copyright (C) 2026 Richard Qin

`timescale 1ns/1ns

module half_adder (
		   input wire  a,
		   input wire  b,
		   output wire sum,
		   output wire cout
		   );

   assign sum = a ^ b;
   assign cout = a & b;

endmodule // half_adder

module full_adder (
		   input wire a,
		   input wire b,
		   input wire cin,
		   output wire sum,
		   output wire cout
		   );

   assign sum = a ^ b ^ cin;
   assign cout = (a & b) | (a & cin) | (b & cin);

endmodule // full_adder

module adder3 (
	       input wire [2:0] A,
	       input wire [2:0] B,
	       output wire [2:0] S,
	       output wire cout
	       );

   wire c1, c2;

   half_adder HA0 (
		   .a(A[0]),
		   .b(B[0]),
		   .sum(S[0]),
		   .cout(c1)
		   );

   full_adder FA0 (
		   .a(A[1]),
		   .b(B[1]),
		   .cin(c1),
		   .sum(S[1]),
		   .cout(c2)
		   );

   full_adder FA1 (
		   .a(A[2]),
		   .b(B[2]),
		   .cin(c2),
		   .sum(S[2]),
		   .cout(cout)
		   );

endmodule // adder3

