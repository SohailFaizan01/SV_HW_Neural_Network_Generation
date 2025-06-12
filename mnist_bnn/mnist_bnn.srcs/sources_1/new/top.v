`timescale 1ns / 1ps

module top;

    parameter INPUT_SIZE  = 784;
    parameter HIDDEN_SIZE = 256;
    parameter NUM_CLASSES = 10;

    // ������Ȩ��
    reg [INPUT_SIZE-1:0] in_vector;
    reg [INPUT_SIZE-1:0] input_mem [0:0];

    reg [INPUT_SIZE-1:0]  fc1_weights [0:HIDDEN_SIZE-1];
    reg [HIDDEN_SIZE-1:0] fc2_weights [0:NUM_CLASSES-1];

    // չƽ���Ȩ��
    wire [INPUT_SIZE*HIDDEN_SIZE-1:0] fc1_weight_flatten;
    wire [HIDDEN_SIZE*NUM_CLASSES-1:0] fc2_weight_flatten;

    // ����ź�
    wire [HIDDEN_SIZE-1:0] fc1_output;
    wire [8*NUM_CLASSES-1:0] popcounts_flat;
    wire [$clog2(NUM_CLASSES)-1:0] predicted_label;

    // չƽ fc1 Ȩ��
    genvar i;
    generate
        for (i = 0; i < HIDDEN_SIZE; i = i + 1) begin
            assign fc1_weight_flatten[(i+1)*INPUT_SIZE-1 -: INPUT_SIZE] = fc1_weights[i];
        end
    endgenerate

    // չƽ fc2 Ȩ��
    generate
        for (i = 0; i < NUM_CLASSES; i = i + 1) begin
            assign fc2_weight_flatten[(i+1)*HIDDEN_SIZE-1 -: HIDDEN_SIZE] = fc2_weights[i];
        end
    endgenerate

    // ʵ���� fc1 ��
    fc1_layer #(
        .INPUT_SIZE(INPUT_SIZE),
        .NUM_NEURONS(HIDDEN_SIZE)
    ) fc1 (
        .in_vector(in_vector),
        .weight_flatten(fc1_weight_flatten),
        .threshold(INPUT_SIZE / 2),
        .fc1_output(fc1_output)
    );

    // ʵ���� fc2 ��
    fc2_layer #(
        .INPUT_SIZE(HIDDEN_SIZE),
        .NUM_CLASSES(NUM_CLASSES)
    ) fc2 (
        .in_vector(fc1_output),
        .weight_flatten(fc2_weight_flatten),
        .popcounts_flat(popcounts_flat)
    );

    // ʵ���� argmax
    argmax #(
        .NUM_CLASSES(NUM_CLASSES)
    ) am (
        .popcounts_flat(popcounts_flat),
        .predicted_label(predicted_label)
    );
    integer k;
    reg [7:0] popcounts [0:NUM_CLASSES-1];

    // ��ʼ������
    initial begin
        $readmemb("test_input_fc1.mem", input_mem);
        in_vector = input_mem[0];

        $readmemb("fc1_weights.mem", fc1_weights);
        $readmemb("fc2_weights.mem", fc2_weights);
    end

    // ��ʾ���
    initial begin
        #50;  // �ȴ�����
        
                // ��ӡ fc1 ����������ƣ�
        $display("FC1 Output (Binary): %b", fc1_output);

        // ��ӡ FC1 �����ʮ�����ƣ��ɶ��Ը��ã�
        $display("FC1 Output (Hex): %h", fc1_output);

        // �� popcounts_flat ��ֳ�ÿ�� class �� popcount
        for (k = 0; k < NUM_CLASSES; k = k + 1) begin
            popcounts[k] = popcounts_flat[(k+1)*8-1 -: 8];
            $display("Class %0d Popcount: %0d", k, popcounts[k]);
        end
        
        $display("Predicted Label: %d", predicted_label);
        $finish;
    end

endmodule
