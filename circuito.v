`include "controle.v"
`include "rom.v"
`include "addsub.v"
`include "mux_4x1_16bit.v"
`include "mux_6x1_32bit.v"
`include "mux_5x1_16bit.v"


module multiplicador8b (
    START, CLK, A, B,
    DONE, RES
);
    /*
        CONFIGURACAO INICIAL
    */
    // sinal para a unidade de controle iniciar a multiplicacao
    input START;
    // este e o clock universao do circuito
    input CLK;
    // esses sao os numeros a serem multiplicados, cada um de 8 bits
    input [7:0] A, B;

    // sinal de que a multiplicacao acabou
    output DONE;
    // resposta, ela e guardada em um registrador e pode ser reutilizado
    // recebe diretamente os resultados das somas
    output reg [15:0] RES;

    /* 
        REGISTRADORES
    */
    // O registrador 1 recebe os numeros a serem multiplicados na configuracao
    // [Al,Bl, Ah, Bh], sendo l para low-bits e h para high-bits 
    // ele tambem possui um multiplexador que escolhe outras entradas pertinentes
    reg [15:0] REG1;
    // O registrador 2 recebe os resultados das multiplicacoes da ROM
    reg [15:0] REG2;

    /*
        WIRES DE CONTROLE
    */
    // controles de load de cada um dos registradores
    wire LOAD_REG1;
    wire LOAD_REG2;
    wire LOAD_REG3;
    // seta a operacao realizada pelo somador/subtrator, uma mini ALU
    wire OP;

    /*
        WIRES COM RESULTADOS
    */
    // wire com o resultado da multiplicacao da ROM
    wire [9:0] RESULTADO_ROM;
    // wire com o resultado da soma/subtracao
    wire [15:0] RESULTADO_SOMA_SUB;

    /*
        CONTROLES MUX
    */
    // controla o multiplexador do que sera escrito no registrador 1 
    wire [2:0] MUX_CONTROL_LOAD_REG1;
    // controla o mux do que entra na mini ALU
    // ARRUMAR BITS
    wire [2:0] MUX_CONTROL_SUM_SUB;
    // controla o mux dos dados que entram na ROM
    wire [1:0] MUX_CONTROL_ROM;

    /*
        WIRES COM RESULTADOS DOS MUX
    */
    wire [15:0] MUX_REG1_RESULT;
    wire [15:0] MUX_ROM_RESULT;
    wire [31:0] MUX_ADDSUB_RESULT;

    
    /*
        DECLARACAO DE UNIDADES EXTERNAS
    */
    // Soma e subtracao
    addsub addsub (.data1(MUX_ADDSUB_RESULT[31:16]), .data2(MUX_ADDSUB_RESULT[15:0]), .add_sub(OP),
                   .clk(CLK), .resultado(RESULTADO_SOMA_SUB));
    // ROM que multiplica 2 numeros de 5 bits
    rom_multiplicador rom_multiplicador (.Fatores(MUX_ROM_RESULT), .Produto(RESULTADO_ROM));

    // Unidade de controle do multiplicador

    /*
        ESTA E A IMPLEMENTACAO COM O CONTROLE
    */
    // controle controle (.clk(CLK), .start(START), .load_reg1(LOAD_REG1), .load_reg2(LOAD_REG2),
    //                    .load_reg3(LOAD_REG3), .mux_load_reg1(MUX_CONTROL_LOAD_REG1),
    //                    .mux_control_sum_sub(MUX_CONTROL_SUM_SUB), .mux_control_rom(MUX_CONTROL_ROM));

    /*
        LOGICA DO MUX DA ROM 
        2'b00: REG3 * SUM 
        2'b01: xl * yl
        2'b10: xh * yh

        O ultimo nao pode ser selecionado
    */
    // ver se esta selecionando certo
    mux_4x1_16bit mux_4x1_16bit (
        .I0({8'd0, REG3[3:0], RESULTADO_SOMA_SUB[3:0]}),
        .I1({8'd0, REG1[15:12], REG1[11:8]}),
        .I2({8'd0, REG1[7:4], REG1[3:0]}),
        .I3(16'd0),
        .A0(MUX_CONTROL_ROM[1])
        .A1(MUX_CONTROL_ROM[0]));

    /*
        LOGICA DO MUX DA SUM/SUB
        3'b000: 12'd0, xh, 12'd0, xl
        3'b001: 12'd0, yh, 12'd0, yl
        3'b010: 8'd0, REG1[15:8], REG1[7:0], 8d'0

        Neste aqui, o << 4 e dado antes da operacao,
        resulta na mesma coisa
        3'b011: 8'd0, REG1[15:8], 12'd0, REG1[7:0], 4d'0
        3'b100: REG2, REG1
        3'b100: REG3, REG1
    */
    mux_6x1_32bit mux_6x1_32bit (
        .A({12'd0, REG1[7:4], 12'd0, REG1[15:12]}),
        .B({12'd0, REG1[3:0], 12'd0, REG1[11:8]}),
        .C({8'd0, REG1[15:8], REG1[7:0], 8d'0}),
        .D({8'd0, REG1[15:8], 12'd0, REG1[7:0], 4d'0}),
        .E({REG2, REG1}),
        .F({REG3, REG1}),
        .X({MUX_ADDSUB_RESULT}),
        .S1(MUX_CONTROL_SUM_SUB)
        );

    /*
        LOGICA DO MUX DO REG1
        3'b000: A[3:0], B[3:0], A[7:4], B[7:4]
        3'b001: ROM[7:0], REG1[7:0]
        3'b010: REG1[15:8], ROM[7:0]
        3'b011: SUM[15:0]
        // verificamos que era a mesma operacao depois
        3'b100: SUM[15:0]
    */
    mux_5x1_16bit mux_5x1_16bit(
        .S(MUX_CONTROL_LOAD_REG1),
        .A({A[3:0], B[3:0], A[7:4], B[7:4]}),
        .B({RESULTADO_ROM[7:0], REG1[7:0]}),
        .C({REG1[15:8], RESULTADO_ROM[7:0]}),
        .D(RESULTADO_SOMA_SUB[15:0]),
        .E(RESULTADO_SOMA_SUB[15:0]),
        .X(MUX_REG1_RESULT));
    
    /*
        Logica do circuito
    */
    always @(posedge CLK or posedge START) begin
        // load do REG1
        if (LOAD_REG1 == 1'b1)
            REG1 <= MUX_REG1_RESULT;
        if (LOAD_REG2 == 1'b1)
            REG2 <= RESULTADO_ROM;
        if (LOAD_REG3 == 1'b1)
            REG3 <= RESULTADO_SOMA_SUB;
    end
    
endmodule