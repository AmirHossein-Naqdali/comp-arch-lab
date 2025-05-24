`timescale 1ns / 1ps

// BUS Module Testbench
module BUS_TB();

// Localparam
// Data Width
localparam Data_Width = 16;

// Ports
// Select
reg [2 : 0] Select;
// Inputs
// Nothing
reg [(Data_Width - 1) : 0] Inp_0;
// AR
reg [(Data_Width - 1) : 0] Inp_1;
// PC
reg [(Data_Width - 1) : 0] Inp_2;
// DR
reg [(Data_Width - 1) : 0] Inp_3;
// AC
reg [(Data_Width - 1) : 0] Inp_4;
// IR
reg [(Data_Width - 1) : 0] Inp_5;
// TR
reg [(Data_Width - 1) : 0] Inp_6;
// Memory
reg [(Data_Width - 1) : 0] Inp_7;
// Outputs
wire [(Data_Width - 1) : 0] Out;

// Time Delay
time Delay = 1;

// UUT Instantiation
BUS
#
(
    // Data Width
   .Data_Width(Data_Width)
)
UUT
(
    // Select
    .Select(Select),
    
    // Inputs
    // Nothing
    .Inp_0(Inp_0),
    // AR
    .Inp_1(Inp_1),
    // PC
    .Inp_2(Inp_2),
    // DR
    .Inp_3(Inp_3),
    // AC
    .Inp_4(Inp_4),
    // IR
    .Inp_5(Inp_5),
    // TR
    .Inp_6(Inp_6),
    // Memory
    .Inp_7(Inp_7),
    
    // Outputs
    .Out(Out)
);

// Assign Values
initial
begin
    // First Dealy
    #(Delay);
    
    // Set Inputs
    // Nothing
    Inp_0 = 16'h0000;
    // AR
    Inp_1 = 16'h1111;
    // PC
    Inp_2 = 16'h2222;
    // DR
    Inp_3 = 16'h3333;
    // AC
    Inp_4 = 16'h4444;
    // IR
    Inp_5 = 16'h5555;
    // TR
    Inp_6 = 16'h6666;
    // Memory
    Inp_7 = 16'h7777;
    #(Delay);
    
    // Set Select (AR)
    Select = 3'b001;
    #(Delay);
    
    // Set Select (PC)
    Select = 3'b010;
    #(Delay);
    
    // Set Select (AC)
    Select = 3'b100;
    #(Delay);
    
    // Set Select (Memory)
    Select = 3'b111;
    #(Delay);
    
    // Last Delay
    #(Delay);
    
    // Finish Simulation
    $finish;
end

endmodule
