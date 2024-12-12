module BrentKungAdder (
    input [63:0] A, B,
    output [63:0] Sum,
    output Cout
);
    wire [63:0] G, P, C;
    wire [31:0] G1, P1;
    wire [15:0] G2, P2;
    wire [7:0]  G3, P3;
    wire [3:0]  G4, P4;
    wire [1:0]  G5, P5;
    wire G_final, P_final;

    // Generate and Propagate Signals
    assign G = A & B;
    assign P = A ^ B;

    // Brent-Kung Prefix Network
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin : layer1
            CarryOperator co1 (G[2*i], P[2*i], G[2*i+1], P[2*i+1], G1[i], P1[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin : layer2
            CarryOperator co2 (G1[2*i], P1[2*i], G1[2*i+1], P1[2*i+1], G2[i], P2[i]);
        end
        for (i = 0; i < 8; i = i + 1) begin : layer3
            CarryOperator co3 (G2[2*i], P2[2*i], G2[2*i+1], P2[2*i+1], G3[i], P3[i]);
        end
        for (i = 0; i < 4; i = i + 1) begin : layer4
            CarryOperator co4 (G3[2*i], P3[2*i], G3[2*i+1], P3[2*i+1], G4[i], P4[i]);
        end
        for (i = 0; i < 2; i = i + 1) begin : layer5
            CarryOperator co5 (G4[2*i], P4[2*i], G4[2*i+1], P4[2*i+1], G5[i], P5[i]);
        end
    endgenerate

    CarryOperator co6 (G5[0], P5[0], G5[1], P5[1], G_final, P_final);

    // Compute Carry Signals
    assign C[0] = 0;
    assign C[63:1] = G[62:0] | (P[62:0] & C[62:0]);

    // Compute Sum and Carry-Out
    assign Sum = P ^ C;
    assign Cout = G_final | (P_final & C[63]);

endmodule

module CarryOperator (
    input G1, P1, G2, P2,
    output G_out, P_out
);
    assign G_out = G1 | (P1 & G2);
    assign P_out = P1 & P2;
endmodule

