module mux_5x1_16bit (
    input [2:0] S,
    input [15:0] A, B, C, D, E,
    output reg [15:0] X
);

always @ (*) 
    begin
        if (S == 3'b001)
            X <= A;
        else if (S == 3'b010)
            X <= B;
        else if (S == 3'b011)
            X <= C;
        else if (S == 3'b100)
            X <= D;
        else if (S == 3'b101)
            X <= E;
    end
endmodule