module mux_6x1_32bit (
    input [2:0] S,
    input [31:0] A, B, C, D, E, F,
    output reg [31:0] X
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
        else if (S == 3'b110)
            X <= F;
    end
endmodule