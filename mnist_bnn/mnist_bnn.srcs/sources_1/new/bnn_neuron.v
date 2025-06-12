`timescale 1ns / 1ps

module bnn_neuron #(
    parameter SIZE = 784 // ����������λ�������� 28x28 = 784��
)(
    input  wire [SIZE-1:0] in_vector,      // ����ͼ��bit-vector��
    input  wire [SIZE-1:0] weight_vector,  // Ȩ��������bit-vector��
    input  wire [$clog2(SIZE+1)-1:0] threshold, // �Ƚ���ֵ
    output reg out                         // �������
);

    wire [SIZE-1:0] xnor_result;
    reg [$clog2(SIZE+1)-1:0] sum;
    integer i;

    // XNOR��1 ��ʾƥ�䣨1,1 �� 0,0��
    assign xnor_result = ~(in_vector ^ weight_vector);

    // Popcount������ƥ����
    always @(*) begin
        sum = 0;
        for (i = 0; i < SIZE; i = i + 1) begin
            sum = sum + xnor_result[i];
        end

        // Compare threshold���������ߣ�
        out = (sum >= threshold) ? 1'b1 : 1'b0;
    end

endmodule
