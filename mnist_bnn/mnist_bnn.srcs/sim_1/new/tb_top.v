`timescale 1ns / 1ps

module tb_top;

    // ʵ��������ģ��
    top uut();

    // ��ѡ�����ڲ鿴���Σ���������� waveform viewer��
    initial begin
        $dumpfile("top.vcd");   // �����ʹ�� GTKWave ����������
        $dumpvars(0, tb_top);
    end

endmodule
