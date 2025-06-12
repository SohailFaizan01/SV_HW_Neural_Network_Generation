`timescale 1ns / 1ps

module tb_fc1_layer;

    parameter INPUT_SIZE = 784;
    parameter NUM_NEURONS = 256;

    // ����ͼ���Ȩ��
    reg [INPUT_SIZE-1:0] in_vector;
    reg [INPUT_SIZE-1:0] input_mem [0:0];
    reg  [INPUT_SIZE-1:0] weight_mem [0:NUM_NEURONS-1];
    wire [INPUT_SIZE*NUM_NEURONS-1:0] weight_flatten;
    wire [NUM_NEURONS-1:0] fc1_output;

    // �� weight_mem ��ƽ��һ������
    genvar i;
    generate
        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            assign weight_flatten[(i+1)*INPUT_SIZE-1 -: INPUT_SIZE] = weight_mem[i];
        end
    endgenerate

    // ʵ��������ģ��
    fc1_layer #(
        .INPUT_SIZE(INPUT_SIZE),
        .NUM_NEURONS(NUM_NEURONS)
    ) uut (
        .in_vector(in_vector),
        .weight_flatten(weight_flatten),
        .threshold(INPUT_SIZE / 2),
        .fc1_output(fc1_output)
    );

    // ��ʼ�������ڴ�
    initial begin
        $readmemb("fc1_weights.mem", weight_mem);  // OK ?
        $readmemb("test_input.mem", input_mem);    // ? ��ȷʹ�� memory
        in_vector = input_mem[0];                  // ? ȡ�� 1 ��������Ϊ����
    end

    // ��ʾ���
    initial begin
        #20;  // �ȴ������ȶ�
        $display("FC1 output (256-bit): %b", fc1_output);
        #10;
        $finish;
    end

endmodule
