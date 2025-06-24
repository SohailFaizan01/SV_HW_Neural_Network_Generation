`timescale 1ns / 1ps
    //____________________________________________________________________________________________________________________________________________________________________________________
    //################################################################################### Testbench #########################################################################
    //____________________________________________________________________________________________________________________________________________________________________________________
    //____________________________________________________________________________________________________________________________________________________________________________________

package cfg_param;

    // parameter int       NUMBER_OF_LAYERS = 3 ;
    // parameter int       IPDATA_BNNENC [0:NUMBER_OF_LAYERS-1] = '{0, 1, 1}   ;                               //Is I/P BNN encoded? - 0 = no, 1 = yes
    // parameter int       IPWGHT_BNNENC [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               //Is I/P Weight BNN encoded? - 0 = no, 1 = yes
    // parameter int       OP_ACTV_LAYER [0:NUMBER_OF_LAYERS-1] = '{1, 1, 2}   ;                               //Type of OP Activation. 1:BNN, 2:ARGMAX , Default: NONE
    // parameter int       IP_DATA_WIDTH [0:NUMBER_OF_LAYERS-1] = '{8, 1, 1}   ;                               //I/P data width 
    // parameter int       IP_WGHT_WIDTH [0:NUMBER_OF_LAYERS-1] = '{2, 2, 2}   ;                               //I/P data width . BNN only compatible wit 2
    // parameter int       IP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{8, 7, 7}   ;                               //I/P Neur Width . (Pixels in image)
    // parameter int       OP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{7, 7, 7}   ;                               // Classification output
    // parameter int       IP_NEUR_HIGHT [0:NUMBER_OF_LAYERS-1] = '{3, 3, 3}   ;                               // Should be 1 generally
    // parameter int       IP_DECBIAS_EN [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               // Enable Biases Disable not supported rn
    // parameter int       IP_BIAS_WIDTH [0:NUMBER_OF_LAYERS-1] = '{32, 32, 32} ;                              // Signed width of biases


    // parameter int       NEUR_MAX_BSWT_WIDTH [0:NUMBER_OF_LAYERS-1] = '{32, 32, 32};
    
    // parameter int       MAX_NEUR_WIDTH = 8;
    // parameter int       MAX_BSWT_WIDTH = 32;
    //###################################################################################BNN Inference#########################################################################
    //____________________________________________________________________________________________________________________________________________________________________________________




    
    parameter int       NUMBER_OF_LAYERS = 3 ;
    parameter int       IPDATA_BNNENC [0:NUMBER_OF_LAYERS-1] = '{0, 1, 1}   ;                               //Is I/P BNN encoded? - 0 = no, 1 = yes
    parameter int       IPWGHT_BNNENC [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               //Is I/P Weight BNN encoded? - 0 = no, 1 = yes
    parameter int       OP_ACTV_LAYER [0:NUMBER_OF_LAYERS-1] = '{1, 1, 2}   ;                               //Type of OP Activation. 1:BNN, 2:ARGMAX , Default: NONE
    parameter int       IP_DATA_WIDTH [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               //I/P data width 
    parameter int       IP_WGHT_WIDTH [0:NUMBER_OF_LAYERS-1] = '{2, 2, 2}   ;                               //I/P data width . BNN only compatible wit 2
    parameter int       IP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{784, 512, 256}   ;                               //I/P Neur Width . (Pixels in image)
    parameter int       OP_NEUR_WIDTH [0:NUMBER_OF_LAYERS-1] = '{512, 256, 10}   ;                               // Classification output
    parameter int       IP_NEUR_HIGHT [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               // Should be 1 generally
    parameter int       IP_DECBIAS_EN [0:NUMBER_OF_LAYERS-1] = '{1, 1, 1}   ;                               // Enable Biases. Disable not supported rn
    parameter int       IP_BIAS_WIDTH [0:NUMBER_OF_LAYERS-1] = '{16, 16, 16} ;                              // Signed width of biases


    parameter int       NEUR_MAX_BSWT_WIDTH [0:NUMBER_OF_LAYERS-1] = '{16, 16, 16};
    parameter int       MAX_BSWT_WIDTH = 16;
    
    parameter int       MAX_NEUR_WIDTH = 784;

endpackage