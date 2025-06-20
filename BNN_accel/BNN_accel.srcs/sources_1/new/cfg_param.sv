`timescale 1ns / 1ps

package cfg_param;

    parameter int       NUMBER_OF_LAYERS = 3 ;
    parameter string    WEIGHTS_FILE  [0:NUMBER_OF_LAYERS-1] = '{"wght.txt", "wght2.txt", "wght3.txt"}   ;
    parameter string    BIASES_FILE   [0:NUMBER_OF_LAYERS-1] = '{"bias0.txt", "bias0.txt", "bias0.txt"}   ;
    parameter int       IPDATA_BNNENC [0:NUMBER_OF_LAYERS-1] = '{0, 1, 1}   ;
    parameter int       IPWGHT_BNNENC [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;
    parameter string    OP_ACTV_LAYER [0:NUMBER_OF_LAYERS-1] = '{"BNN", "BNN", "ARGMAX"}   ;
    parameter int       IP_DATA_WIDTH [0:NUMBER_OF_LAYERS-1] = '{8, 1, 1}   ;
    parameter int       IP_WGHT_WIDTH [0:NUMBER_OF_LAYERS-1] = '{2, 2, 2}   ;
    parameter int       IP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{8, 7, 7}   ;
    parameter int       OP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{7, 7, 7}   ;
    parameter int       IP_NEUR_HIGHT [0:NUMBER_OF_LAYERS-1] = '{3, 3, 3}   ;
    parameter int       IP_DECBIAS_EN [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;
    parameter int       IP_BIAS_WIDTH [0:NUMBER_OF_LAYERS-1] = '{32, 32, 32} ;

endpackage