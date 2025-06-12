`timescale 1ns / 1ps

module tb_fc2_layer;

    parameter INPUT_SIZE = 256;
    parameter NUM_CLASSES = 10;

    // Inputs
    reg [INPUT_SIZE-1:0] in_mem [0:0];                   // ? 内存类型用于 $readmemb
    reg [INPUT_SIZE-1:0] weight_mem [0:NUM_CLASSES-1];   // ? 权重内存数组
    reg [INPUT_SIZE-1:0] in_vector;
    wire [INPUT_SIZE*NUM_CLASSES-1:0] weight_flatten;

    // Output
    wire [8*NUM_CLASSES-1:0] popcounts_flat;

    // Flatten weights
    genvar i;
    generate
        for (i = 0; i < NUM_CLASSES; i = i + 1) begin
            assign weight_flatten[(i+1)*INPUT_SIZE-1 -: INPUT_SIZE] = weight_mem[i];
        end
    endgenerate

    // DUT
    fc2_layer #(
        .INPUT_SIZE(INPUT_SIZE),
        .NUM_CLASSES(NUM_CLASSES)
    ) dut (
        .in_vector(in_vector),
        .weight_flatten(weight_flatten),
        .popcounts_flat(popcounts_flat)
    );

    // Test
    integer k;
    initial begin
        $readmemb("test_input_fc2.mem", in_mem);        // ? 从文件读
        $readmemb("fc2_weights.mem", weight_mem);
        in_vector = in_mem[0];                          // ? 抽出数据
        #20;

        $display("FC2 Output popcounts:");
        for (k = 0; k < NUM_CLASSES; k = k + 1) begin
            $display("Class %0d: %0d", k, popcounts_flat[(k+1)*8-1 -: 8]);
        end

        #10;
        $finish;
    end

endmodule
