`timescale 1ns / 1ps

module bnn_neuron #(
    parameter SIZE = 784 // 输入向量的位数（例如 28x28 = 784）
)(
    input  wire [SIZE-1:0] in_vector,      // 输入图像（bit-vector）
    input  wire [SIZE-1:0] weight_vector,  // 权重向量（bit-vector）
    input  wire [$clog2(SIZE+1)-1:0] threshold, // 比较阈值
    output reg out                         // 输出激活
);

    wire [SIZE-1:0] xnor_result;
    reg [$clog2(SIZE+1)-1:0] sum;
    integer i;

    // XNOR：1 表示匹配（1,1 或 0,0）
    assign xnor_result = ~(in_vector ^ weight_vector);

    // Popcount：计算匹配数
    always @(*) begin
        sum = 0;
        for (i = 0; i < SIZE; i = i + 1) begin
            sum = sum + xnor_result[i];
        end

        // Compare threshold（多数决策）
        out = (sum >= threshold) ? 1'b1 : 1'b0;
    end

endmodule
