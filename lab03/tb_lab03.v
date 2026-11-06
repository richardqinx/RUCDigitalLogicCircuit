
`timescale 1ns / 1ps

module tb_lab03;

    // 表决电路测试信号
    reg A, B, C;
    wire Y;

    // 循环码转换测试信号
    reg  [3:0] B_in;
    wire [3:0] G_out;

    integer i;
    integer errors;

    reg [7:0] vote_expected;

    // 按照实验真值表存放16组格雷码
    // 从右往左依次对应输入0到15
    localparam [63:0] GRAY_TABLE =
        64'h89BAEFDC45762310;

    reg [3:0] gray_expected;

    // 实例化表决电路
    vote3 u_vote (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );

    // 实例化循环码转换电路
    bin_to_gray u_gray (
        .B(B_in),
        .G(G_out)
    );

    initial begin
        // 启用VCD波形记录
        $dumpfile("lab03.vcd");
        $dumpvars(0, tb_lab03);
       
        errors = 0;
        vote_expected = 8'b11101000;

        A = 0;
        B = 0;
        C = 0;
        B_in = 4'b0000;

        // 测试三人表决电路
        $display("=== Voting Circuit ===");

        for (i = 0; i < 8; i = i + 1) begin
            {A, B, C} = i[2:0];
            #10;

            $display("ABC=%b%b%b Y=%b",
                     A, B, C, Y);

            if (Y !== vote_expected[i]) begin
                $display("ERROR: Voting mismatch");
                errors = errors + 1;
            end
        end

        // 测试二进制码到循环码
        $display("=== Binary to Gray ===");

        for (i = 0; i < 16; i = i + 1) begin
            B_in = i[3:0];

            gray_expected = GRAY_TABLE[i*4 +: 4];

            #10;

            $display("B=%b G=%b", B_in, G_out);

            if (G_out !== gray_expected) begin
                $display("ERROR: Gray mismatch");
                errors = errors + 1;
            end
        end

        // 输出最终测试结果
        if (errors == 0)
            $display("All tests passed!");
        else
            $display("Total errors: %0d", errors);

        $finish;
    end

endmodule

