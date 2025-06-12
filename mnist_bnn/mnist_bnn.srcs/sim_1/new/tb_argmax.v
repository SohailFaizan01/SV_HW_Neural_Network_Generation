`timescale 1ns / 1ps

module tb_argmax;

    // 参数定义
    parameter NUM_CLASSES = 10;
    parameter POPCOUNT_WIDTH = 8;

    // 信号声明
    reg  [NUM_CLASSES*POPCOUNT_WIDTH-1:0] popcounts_flat;
    wire [$clog2(NUM_CLASSES)-1:0] predicted_label;

    // 实例化 argmax 模块
    argmax #(
        .NUM_CLASSES(NUM_CLASSES),
        .POPCOUNT_WIDTH(POPCOUNT_WIDTH)
    ) uut (
        .popcounts_flat(popcounts_flat),
        .predicted_label(predicted_label)
    );

    // 测试激励
    initial begin
        // 默认情况
        popcounts_flat = 80'd0;
        #10;

        // 模拟 10 个 popcount，最大值在 index 7 (value = 150)
        popcounts_flat[7*8 +: 8] = 8'd150;  // 第 7 个 popcount = 150
        popcounts_flat[3*8 +: 8] = 8'd123;  // 第 3 个 popcount = 123
        popcounts_flat[9*8 +: 8] = 8'd100;  // 第 9 个 popcount = 100
        #10;

        $display("Predicted class index: %0d", predicted_label);  // 期望输出 7
        #10;

        // 另一个测试：最大值在 index 2 (value = 255)
        popcounts_flat = 80'd0;
        popcounts_flat[2*8 +: 8] = 8'd255;
        #10;
        $display("Predicted class index: %0d", predicted_label);  // 期望输出 2

        #10;
        $finish;
    end

endmodule
