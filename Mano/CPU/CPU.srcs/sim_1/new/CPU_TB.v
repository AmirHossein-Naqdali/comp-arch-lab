`timescale 1ns / 1ps

// CPU Module Testbench
module CPU_TB();

// Localparams
// Data Width
localparam Data_Width = 16;
// Address Width
localparam Address_Width = 12;

// Ports
// Clock and Reset
reg Clock;
reg Reset;
// Memory Interface
// Memory Control Channel
wire Memory_Write;
wire Memory_Read;
// Memory Address Channel
wire [(Address_Width - 1) : 0] Memory_Address;
// Memory Data Channel
wire [(Data_Width - 1) : 0] Memory_Data_In;
reg  [(Data_Width - 1) : 0] Memory_Data_Out;
// Input and Output Register
reg  [((Data_Width / 2) - 1) : 0] INPR_In;
wire [((Data_Width / 2) - 1) : 0] OUTR_Out;

// Time Delay
time Clock_Period = 10;

// UUT Instantiation
CPU
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
    
    // Memory Interface
    // Memory Control Channel
    .Memory_Write(Memory_Write),
    .Memory_Read(Memory_Read),
    // Memory Address Channel
    .Memory_Address(Memory_Address),
    // Memory Data Channel
    .Memory_Data_In(Memory_Data_In),
    .Memory_Data_Out(Memory_Data_Out),
    
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
    
    // Diactive Reset and Assign Instruction
    Reset = 1'b0;
    Memory_Data_Out = 16'b0_001_000001100100;
    INPR_In = 'b0;
    #(Clock_Period);
    
    // Assign Data
    Memory_Data_Out = 16'b0000_0000_0001_0000;
    #(Clock_Period);
    
    // Five Clocks Delay
    #(Clock_Period * 5);
    
    // Last Delay
    #(Clock_Period);
    
    // Finish Simulation
    $finish;
end

endmodule
