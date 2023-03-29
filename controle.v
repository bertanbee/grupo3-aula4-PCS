module controle (
    input clk, start,
    output reg load_reg2, load_reg3,load_reg1, op,
    output reg [3:0] mux_load_reg1
    output reg [] mux_control_sum_sub;
    output reg [] mux_control_rom;
);

reg [2:0] estado_atual, prox_estado;

// declaracao dos estados
parameter   inicial = 4'b0000, estado_1 = 4'b0001, 
            estado_2 = 4'b0010, estado_3 = 4'b0011,
            estado_4 = 4'b0100, estado_5 = 4'b0101, 
            estado_6 = 4'b0110, estado_7 = 4'b0111, 
            estado_8 = 4'b1000, estado_9 = 4'b1001;


// bloco que percorre todos os estados
always @(posedge clk or posedge start)
begin
    // start da o inicio da multiplicacao
    if (start == 1'b1)
        estado_atual <= inicial;
    else if (estado_atual == estado_9)
        estado_atual <= estado_9;
    else
        estado_atual <= estado_atual + 1;     
end

// bloco que manda os sinais para os outros modulos do sistema
always@(*)
begin
    case (estado_atual)
        inicial:
            begin
                mux_load_reg1 <= 1'b001;
            end

        estado_1:
            begin
                load_reg3 = 1'b1;
            end  

        estado_2:
            begin
                load_reg2 = 1'b1;
            end

        estado_3:
            begin
                mux_load_reg1 = 1'b010;
            end

        estado_4:
            begin
                mux_load_reg1 = 1'b011;
            end

        estado_5:
            begin
                load_reg3 = 1'b1;
            end

        estado_6:
            begin
                mux_load_reg1 = 1'b100;
            end

        estado_7:
            begin
                mux_load_reg1 = 1'b101;
            end

        estado_8:
            begin
                load_reg3 = 1'b1;
            end

        estado_9:
            begin
                mux_load_reg1 = 1'b0;
                load_reg2 = 1'b0;
                load_reg3 = 1'b0;
            end
    endcase
end
    
endmodule