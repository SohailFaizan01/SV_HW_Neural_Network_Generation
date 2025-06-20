`timescale 1ns / 1ps

package cfg_param;

    parameter int       NUMBER_OF_LAYERS = 3 ;
    parameter string    WEIGHTS_FILE  [0:NUMBER_OF_LAYERS-1] = '{"wght.txt", "wght2.txt", "wght3.txt"}   ;  // Weight files in order of layers from I/P to O/P. YOU NEED TO IMPORT THE FILES INTO VIVADO SEPERATELY ASWELL
    parameter string    BIASES_FILE   [0:NUMBER_OF_LAYERS-1] = '{"bias0.txt", "bias0.txt", "bias0.txt"}   ; // Bias files in order of layers from I/P to O/P. YOU NEED TO IMPORT THE FILES INTO VIVADO SEPERATELY ASWELL
    parameter int       IPDATA_BNNENC [0:NUMBER_OF_LAYERS-1] = '{0, 1, 1}   ;                               //Is I/P BNN encoded? - 0 = no, 1 = yes
    parameter int       IPWGHT_BNNENC [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               //Is I/P Weight BNN encoded? - 0 = no, 1 = yes
    parameter string    OP_ACTV_LAYER [0:NUMBER_OF_LAYERS-1] = '{"BNN", "BNN", "ARGMAX"}   ;                //Type of OP given
    parameter int       IP_DATA_WIDTH [0:NUMBER_OF_LAYERS-1] = '{8, 1, 1}   ;                               //I/P data width 
    parameter int       IP_WGHT_WIDTH [0:NUMBER_OF_LAYERS-1] = '{2, 2, 2}   ;                               //I/P data width . BNN only compatible wit 2
    parameter int       IP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{8, 7, 7}   ;                               //I/P Neur Width . (Pixels in image)
    parameter int       OP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{7, 7, 7}   ;                               // Classification output
    parameter int       IP_NEUR_HIGHT [0:NUMBER_OF_LAYERS-1] = '{3, 3, 3}   ;                               // Should be 1 generally
    parameter int       IP_DECBIAS_EN [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               // Enable Biases Disable not supported rn
    parameter int       IP_BIAS_WIDTH [0:NUMBER_OF_LAYERS-1] = '{32, 32, 32} ;                              // Signed width of biases

endpackage