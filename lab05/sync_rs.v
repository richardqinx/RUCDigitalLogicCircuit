module sync_rs (
		input wire clk,
		input wire s,
		input wire r,
		input wire clr_n,
		input wire pre_n,
		output reg q
		);

  // verilator lint_off LATCH
  always @(*) begin
    if (!clr_n) begin
      q = 1'b0;
    end
    else if (!pre_n) begin
      q = 1'b1;
    end
    else if (clk) begin
      case ({s, r})
	2'b00: ;            // 保持
	2'b01: q = 1'b0;    // 清零
	2'b10: q = 1'b1;    // 置位
	2'b11: q = 1'bx;    // 禁止状态
      endcase
    end
    // 时钟为低电平时保持原状态
  end
  // verilator lint_on LATCH
endmodule

