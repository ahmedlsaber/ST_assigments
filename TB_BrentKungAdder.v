module TB_BrentKungAdder;
    reg [63:0] A, B;
    wire [63:0] Sum;
    wire Cout;

    // Instantiate the BrentKungAdder
    BrentKungAdder uut (
        .A(A),
        .B(B),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        // Test Case 1
        A = 64'h000000000000000F; // 15
        B = 64'h0000000000000001; // 1
        #10;

        // Test Case 2
        A = 64'hFFFFFFFFFFFFFFFF; // Max
        B = 64'h0000000000000001; // 1
        #10;

        // Test Case 3
        A = 64'hAAAAAAAAAAAAAAAA; // Alternating 1/0
        B = 64'h5555555555555555; // Alternating 0/1
        #10;

        // Additional cases can be added as needed
        $stop;
    end
endmodule

