`timescale 1ns / 1ps

module fc1_layer #(
    parameter INPUT_SIZE = 784,
    parameter NUM_NEURONS = 256
)(
    input  wire [INPUT_SIZE-1:0] in_vector,
    input  wire [INPUT_SIZE*NUM_NEURONS-1:0] weight_flatten,  // Flattened weight array
    input  wire [$clog2(INPUT_SIZE+1)-1:0] threshold,
    output wire [NUM_NEURONS-1:0] fc1_output
);

    // 本地展开 weight 数组
    wire [INPUT_SIZE-1:0] weight_array [0:NUM_NEURONS-1];

    genvar i;
    generate
        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            assign weight_array[i] = weight_flatten[(i+1)*INPUT_SIZE-1 -: INPUT_SIZE];
        end
    endgenerate

    // 实例化多个 neuron
    generate
        for (i = 0; i < NUM_NEURONS; i = i + 1) begin : gen_fc1
            bnn_neuron #(.SIZE(INPUT_SIZE)) neuron_inst (
                .in_vector(in_vector),
                .weight_vector(weight_array[i]),
                .threshold(threshold),
                .out(fc1_output[i])
            );
        end
    endgenerate

endmodule
