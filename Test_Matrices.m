A1= [ ...     
        244, 079, 122, 027, 165, 011, 146, 060 ; ...
        219, 114, 095, 245, 049, 056, 155, 124 ; ...
        142, 192, 187, 060, 125, 082, 079, 244   ...
        ]


B1_a = [ ... 
        1, 0, 1, 0, 1, 1, 1 ; ...
		0, 1, 1, 0, 1, 1, 0 ; ...
		1, 0, 1, 0, 0, 1, 0 ; ...
		0, 1, 1, 0, 0, 0, 0 ; ...
		1, 0, 0, 1, 1, 0, 1 ; ...
		0, 1, 0, 1, 1, 0, 1 ; ...
		1, 0, 0, 1, 0, 1, 1 ; ...
		0, 1, 0, 1, 0, 1, 0   ...
        ]

B1 = (B1_a.*2) -1;

A2_b = A1*B1
A2   = sign(A2_b);
A2_a = (A2+1) / 2

B2_a = [ ... 
        1, 0, 1, 0, 1, 1, 1 ; ...
		0, 1, 1, 0, 1, 1, 0 ; ...
		1, 0, 1, 0, 0, 1, 0 ; ...
		0, 1, 1, 0, 0, 0, 0 ; ...
		1, 0, 0, 1, 1, 0, 1 ; ...
		0, 1, 0, 1, 1, 0, 1 ; ...
		1, 0, 0, 1, 0, 1, 1   ...
        ]

B2 = (B2_a.*2) -1;
A3_b = A2*B2
A3 = sign(A3_b);
A3_a = (A3+1)/2 

B3_c = [ ...
        1, 0, 1, 0, 1, 0, 1 ; ... 
        0, 1, 0, 1, 0, 1, 0 ; ... 
        1, 1, 1, 1, 0, 0, 0 ; ... 
        0, 0, 0, 0, 1, 1, 1 ; ... 
        1, 1, 0, 0, 1, 1, 0 ; ... 
        0, 1, 1, 0, 0, 1, 0 ; ... 
        1, 0, 0, 0, 1, 1, 1   ...
];
B3_a = transpose(B3_c)

B3 = (B3_a.*2) -1;
A4_b = A3*B3
A4 = sign(A4_b);
A4_a = (A4+1)/2 






%C= A*B

%C2 = sign(C);
%C3 = (C2+1)./2