module edge_jk (
		input wire clk,
		input wire j,
		input wire k,
		input wire clr_n,
		input wire pre_n,
		output reg q
		);
  always @(posedge clk or negedge clr_n or negedge pre_n) begin
    if (!clr_n) begin
      q <= 1'b0;
    end
    else if (!pre_n) begin
      q <= 1'b1;
    end
    else begin
      case ({j, k})
	2'b00: q <= q;      // 保持
        2'b01: q <= 1'b0;   // 清零
        2'b10: q <= 1'b1;   // 置位
        2'b11: q <= ~q;     // 翻转
      endcase
    end
  end

endmodule

