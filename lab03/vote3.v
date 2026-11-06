
module vote3 (
    input  wire A,
    input  wire B,
    input  wire C,
    output wire Y
);

    // 三人表决：至少两人同意时输出1
    assign Y = (A & B) | (A & C) | (B & C);

endmodule

