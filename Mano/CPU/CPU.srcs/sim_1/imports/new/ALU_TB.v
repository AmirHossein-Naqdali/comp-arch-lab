`timescale 1ns / 1ps

// ALU Module Testbench
module ALU_TB();

// Localparam
// Data Width
localparam Data_Width = 16;

// Ports
// Operation Select
reg [2 : 0] Operation_Select;
// Inputs
// INPR
reg [((Data_Width / 2) - 1) : 0] Inp_0;
// DR
reg [(Data_Width - 1) : 0] Inp_1;
// AC
reg [(Data_Width - 1) : 0] Inp_2;
// Input E
reg E_In;
// Outputs
// Output E
wire E_Out;
// Calculation Output
wire [(Data_Width - 1) : 0] Out;

// Time Delay
time Delay = 1;

// UUT Instantiation
ALU
#
(
    // Data Width
   .Data_Width(Data_Width)
)
UUT
(
    // Operation Select
    .Operation_Select(Operation_Select),
    
    // Inputs
    // INPR
    .Inp_0(Inp_0),
    // DR
    .Inp_1(Inp_1),
    // AC
    .Inp_2(Inp_2),
    // Input E
    .E_In(E_In),
    
    // Outputs
    // Output E
    .E_Out(E_Out),
    // Calculation Output
    .Out(Out)
);

// Assign Values
initial
begin
    // First Dealy
    #(Delay);
    
    // Set Inputs
    // INPR
    Inp_0 = 16'h00AA;
    // DR
    Inp_1 = 16'h1111;
    // AC
    Inp_2 = 16'hFFFF;
    // Input E
    E_In = 1'b1;
    #(Delay);
    
    // Set Select (AND)
    Operation_Select = 3'b010;
    #(Delay);
    
    // Set Select (ADD)
    Operation_Select = 3'b011;
    #(Delay);
    
    // Set Select (SHL)
    Operation_Select = 3'b100;
    #(Delay);
    
    // Set Select (PASS 1 (AC[7 : 0] <- INPR))
    Operation_Select = 3'b110;
    #(Delay);
    
    // Last Delay
    #(Delay);
    
    // Finish Simulation
    $finish;
end

endmodule
