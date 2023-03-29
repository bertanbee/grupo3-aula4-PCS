`timescale 1ns/1ps

module rom_multiplicador_tb();

  // Inputs
  reg [9:0] Fatores;

  // Outputs
  wire [9:0] Produto;

  // Instantiate the Unit Under Test (UUT)
  rom_multiplicador uut (
    .Fatores(Fatores),
    .Produto(Produto)
  );

  initial begin
    // Initialize inputs
    Fatores = 10'b0;

    // Wait for 100 ns for global reset to finish
    #100;

    // Test case 1: 10 x 10 = 100
    Fatores = 10'b01010_01010; 
    #100;
    $display("Produto = %d", Produto); // Expected output: 100;

    // Test case 2: 10 x 0 = 0
    Fatores = 10'b01010_00000;
    #100;
    $display("Produto = %d", Produto); // Expected output: 0
    // Test case 3: 31 x 31 = 961
    Fatores = 10'b11111_11111;
    #100;
    $display("Produto = %d", Produto); // Expected output: 961
    // Test case 4: 27 x 19 = 513
    Fatores = 10'b11011_10011;
    #100;
    $display("Produto = %d", Produto); // Expected output: 513
    // Test case 5: 15 x 19 = 285
    Fatores = 10'b01111_10011;
    #100;
    $display("Produto = %d", Produto); // Expected output: 285
    // Test case 6: 13 x 7 = 91
    Fatores = 10'b01111_10011;
    #100;
    $display("Produto = %d", Produto); // Expected output: 91
    // Test case 7: 9 x 22 = 198
    Fatores = 10'b01001_10110;
    #100;
    $display("Produto = %d", Produto); // Expected output: 198
    // Add more test cases as necessary

  end
endmodule


