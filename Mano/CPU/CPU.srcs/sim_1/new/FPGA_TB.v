`timescale 1ns / 1ps

// FPGA Module Testbench
module FPGA_TB();

// Localparams
// Data Width
localparam Data_Width = 16;
// Address Width
localparam Address_Width = 12;

// Ports
// Clock and Reset
reg Clock;
reg Reset;
// Input and Output Register
reg  [((Data_Width / 2) - 1) : 0] INPR_In;
wire [((Data_Width / 2) - 1) : 0] OUTR_Out;

// Time Delay
time Clock_Period = 10;

// UUT Instantiation
FPGA
#
(
    // Data Width
    .Data_Width(Data_Width),
    // Address Width
    .Address_Width(Address_Width)
)
UUT
(
    // Clock and Reset
    .Clock(Clock),
    .Reset(Reset),
    
    // Input and Output Register
    .INPR_In(INPR_In),
    .OUTR_Out(OUTR_Out)
);

// Initialization and Clock Generator
initial
begin
    Clock = 1'b0;
    Reset = 1'b0;
    
    forever #(Clock_Period / 2) Clock = ~Clock;
end

// Assign Values
initial
begin
    // First Dealy
    #(Clock_Period / 4);
    
    // Active Reset
    Reset = 1'b1;
    #(Clock_Period);
    
    // Diactive Reset and Filling the RAM
    Reset = 1'b0;
    FPGA_TB.UUT.Memory_Module.RAM[0]   = 16'b0_001_000001100100;
    FPGA_TB.UUT.Memory_Module.RAM[100] = 16'b0000_0000_0001_0000;
    #(Clock_Period);
    
    // Five Clocks Delay
    #(Clock_Period * 5);
    
    // Last Delay
    #(Clock_Period);
    
    // Finish Simulation
    $finish;
end

endmodule
