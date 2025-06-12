`timescale 1ns / 1ps

module tb_top;

    // 实例化顶层模块
    top uut();

    // 可选：用于查看波形（如果你想用 waveform viewer）
    initial begin
        $dumpfile("top.vcd");   // 如果你使用 GTKWave 或其他工具
        $dumpvars(0, tb_top);
    end

endmodule
