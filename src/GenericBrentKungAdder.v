module GenericBrentKungAdder #(parameter WIDTH = 64) (
    input [WIDTH-1:0] A, B,
    output [WIDTH-1:0] Sum,
    output Cout
);
    localparam STAGES = $clog2(WIDTH); // Calculate number of stages required

    wire [WIDTH-1:0] G, P, C;
    wire [WIDTH-1:0] G_stage[STAGES:0], P_stage[STAGES:0];

    // Generate and Propagate Signals
    assign G = A & B;
    assign P = A ^ B;

    // Initialize first stage
    assign G_stage[0] = G;
    assign P_stage[0] = P;

    // Brent-Kung Prefix Network
    generate
        genvar i, stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : prefix_stages
            for (i = 0; i < WIDTH >> (stage + 1); i = i + 1) begin : stage_logic
                CarryOperator co (
                    .G1(G_stage[stage][2*i]),
                    .P1(P_stage[stage][2*i]),
                    .G2(G_stage[stage][2*i+1]),
                    .P2(P_stage[stage][2*i+1]),
                    .G_out(G_stage[stage+1][i]),
                    .P_out(P_stage[stage+1][i])
                );
            end
        end
    endgenerate

    // Final carry generation
    assign C[0] = 0;
    assign C[WIDTH-1:1] = G_stage[STAGES][0:WIDTH-2] | (P_stage[STAGES][0:WIDTH-2] & C[WIDTH-2:0]);

    // Compute Sum and Carry-Out
    assign Sum = P ^ C;
    assign Cout = G_stage[STAGES][0] | (P_stage[STAGES][0] & C[WIDTH-1]);

endmodule

module CarryOperator (
    input G1, P1, G2, P2,
    output G_out, P_out
);
    assign G_out = G1 | (P1 & G2);
    assign P_out = P1 & P2;
endmodule

