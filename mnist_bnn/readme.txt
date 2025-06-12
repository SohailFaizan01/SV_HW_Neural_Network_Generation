To make this run in your vivado, do the following

1. create a vivado project and add the design sources as well as simulation sources.

2. put the ".mem" files (for fc layer weight, and input ) into the 'your projectname.sim/sim_1/behav/xsim' in your project.

---------
'....\Xsim' folder file explanation:


' fc1_weights.mem' and  'fc2_weights.mem' are the weights
' test_input_fc1.mem ' was for the input of fc1, also the input of whole system
' test_input_fc2.mem ' was just to test the fc2.
 