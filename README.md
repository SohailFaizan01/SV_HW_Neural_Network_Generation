# Overview
This is an HDL script (in development) which can generate any conventional neural network.
A lot of the auto-generation features are disabled due to Vivado's limited SV support, but it will be updated after I can find a suitable compiler and simulator.
It is currently configured for a 3-layer Binary Neural Network - [784-512-256-10] for MNIST image recognition. It has been tested with both binarised and 8-bit images.
There are separate read tasks in the TB for reading each type of file (8b vs 1b), as the formats are weird due to flattening the images.
The input format to the accelerator is a 2d array, of height one, width 786 (configurable) and bit depth 1b or 8b.
The HW has an accuracy of 69% for 1b images, and 73% for 8b images. The inference was run on 1000 images.
It is a custom BNN, with 2-bit weights to allow for pruning. Thus 0 = -1, 1=1 (both as expected in normal BNNs) but 2/3 =0 to signify pruned weight. There are some planned optimisations to take advantage of the weight side sparsity.
It also uses an accumulator instead of a popcount as it is faster and not much more resource-intensive.
It also has support for biases, and the model implemented uses biases as the batch norm layer has been folded into the weights and biases. 
