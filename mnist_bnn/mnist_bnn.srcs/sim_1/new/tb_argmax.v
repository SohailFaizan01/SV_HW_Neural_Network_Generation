`timescale 1ns / 1ps

module tb_argmax;

    // ��������
    parameter NUM_CLASSES = 10;
    parameter POPCOUNT_WIDTH = 8;

    // �ź�����
    reg  [NUM_CLASSES*POPCOUNT_WIDTH-1:0] popcounts_flat;
    wire [$clog2(NUM_CLASSES)-1:0] predicted_label;

    // ʵ���� argmax ģ��
    argmax #(
        .NUM_CLASSES(NUM_CLASSES),
        .POPCOUNT_WIDTH(POPCOUNT_WIDTH)
    ) uut (
        .popcounts_flat(popcounts_flat),
        .predicted_label(predicted_label)
    );

    // ���Լ���
    initial begin
        // Ĭ�����
        popcounts_flat = 80'd0;
        #10;

        // ģ�� 10 �� popcount�����ֵ�� index 7 (value = 150)
        popcounts_flat[7*8 +: 8] = 8'd150;  // �� 7 �� popcount = 150
        popcounts_flat[3*8 +: 8] = 8'd123;  // �� 3 �� popcount = 123
        popcounts_flat[9*8 +: 8] = 8'd100;  // �� 9 �� popcount = 100
        #10;

        $display("Predicted class index: %0d", predicted_label);  // ������� 7
        #10;

        // ��һ�����ԣ����ֵ�� index 2 (value = 255)
        popcounts_flat = 80'd0;
        popcounts_flat[2*8 +: 8] = 8'd255;
        #10;
        $display("Predicted class index: %0d", predicted_label);  // ������� 2

        #10;
        $finish;
    end

endmodule
