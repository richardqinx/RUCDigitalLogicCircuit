`timescale 1ns/1ps

module tb_trigger;

  reg clk = 1'b0;
  always #5 clk = ~clk;
  
  reg s, r, j, k;
  reg rs_clr_n, rs_pre_n;
  reg jk_clr_n, jk_pre_n;

  wire rs_q, jk_q;

  sync_rs u_rs (
		.clk(clk),
		.s(s),
		.r(r),
		.clr_n(rs_clr_n),
		.pre_n(rs_pre_n),
		.q(rs_q)
		);

  edge_jk u_jk (
		.clk(clk),
		.j(j),
		.k(k),
		.clr_n(jk_clr_n),
		.pre_n(jk_pre_n),
		.q(jk_q)
		);

  task check;
    input expected_rs;
    input expected_jk;
    input [255:0] description;
    begin
      if (rs_q !== expected_rs ||
	  jk_q !== expected_jk) begin
	$fatal(1,
	       "FAIL: %0s | RS=%b JK=%b",
               description, rs_q, jk_q);
      end
      $display(
	       "PASS: %0s | RS=%b JK=%b",
	       description, rs_q, jk_q);
    end
  endtask

  initial begin
    $dumpfile("trigger.vcd");
    $dumpvars(0, tb_trigger);

    s = 0;
    r = 0;
    j = 0;
    k = 0;

    rs_clr_n = 0;
    rs_pre_n = 1;
    jk_clr_n = 0;
    jk_pre_n = 1;

    // 1. 异步清零
    #2;
    check(0, 0, "Asynchronous clear");

    // 2. 低电平状态保持
    rs_clr_n = 1;
    jk_clr_n = 1;
    s = 1; r = 0;
    j = 1; k = 0;

    #1;
    check(0, 0, "Clock low: hold");

    // 3. 时钟上升沿，两者置位
    @(posedge clk);
    #1;
    check(1, 1, "Set");

    // 4. 高电平期间改变输入
    s = 0; r = 1;
    j = 0; k = 1;

    #1;
    check(0, 1, "RS level-sensitive");

    // 5. JK在下一上升沿清零
    @(posedge clk);
    #1;
    check(0, 0, "JK reset");

    // 6. 高电平期间RS置位
    s = 1; r = 0;
    j = 1; k = 0;

    #1;
    check(1, 0, "RS set");

    // 7. 状态保持
    s = 0; r = 0;
    j = 0; k = 0;

    #1;
    check(1, 0, "Hold");

    // 8. CLK=0时RS保持
    @(negedge clk);
    s = 0; r = 1;

    #1;
    check(1, 0, "RS low clock hold");

    // 9. RS清零
    @(posedge clk);
    #1;
    check(0, 0, "RS reset");

    // 10. JK翻转：0 -> 1
    s = 0; r = 0;
    j = 1; k = 1;

    @(posedge clk);
    #1;
    check(0, 1, "JK toggle 0 to 1");

    // 11. JK翻转：1 -> 0
    @(posedge clk);
    #1;
    check(0, 0, "JK toggle 1 to 0");

    // 12. 异步置数
    @(negedge clk);
    rs_pre_n = 0;
    jk_pre_n = 0;

    #1;
    check(1, 1, "Asynchronous preset");

    // 13. 释放置数后保持
    rs_pre_n = 1;
    jk_pre_n = 1;
    j = 0; k = 0;

    #1;
    check(1, 1, "Hold after preset");

    @(posedge clk);
    #1;
    check(1, 1, "Hold at clock edge");

    // 14. 高电平期间异步清零
    rs_clr_n = 0;
    jk_clr_n = 0;

    #1;
    check(0, 0, "Async clear");

    rs_clr_n = 1;
    jk_clr_n = 1;

    #1;
    check(0, 0, "Hold after clear");

    // 15. RS禁止状态
    s = 1;
    r = 1;

    #1;
    $display("RS forbidden input: S=R=1");

    // 16. 通过异步清零恢复状态
    rs_clr_n = 0;

    #1;
    check(0, 0, "Recovery");

    rs_clr_n = 1;
    s = 0;
    r = 0;

    #2;
    check(0, 0, "Final hold");

    $display("All valid functional tests passed.");
    $finish;
  end

endmodule

