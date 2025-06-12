`timescale 1ns / 1ps

module tb_bnn_neuron;

    reg [783:0] in_vector;
    reg [783:0] weight_vector;
    wire out;

    reg [783:0] input_mem [0:0];
    reg [783:0] weight_mem [0:0];

    // DUT
    bnn_neuron #(784) uut (
        .in_vector(in_vector),
        .weight_vector(weight_vector),
        .threshold(392),
        .out(out)
    );

    // 初始化输入和权重
    initial begin
        $readmemb("test_input.mem", input_mem);
        $readmemb("fc1_weights.mem", weight_mem);

        in_vector     = input_mem[0];
        weight_vector = weight_mem[0];
        
        $display("Loaded input: %b", input_mem[0]);
        $display("Loaded weight: %b", weight_mem[0]);

    end

    // 显示输出
    initial begin
        #10;
        $display("BNN Output = %b", out);
        #10;
        $finish;
    end

endmodule
