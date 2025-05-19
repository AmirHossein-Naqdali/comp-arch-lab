`timescale 1ns / 1ps

// Memory Module Testbench
module Memory_TB();

// Localparams
// Data Width
localparam Data_Width = 16;
// Address Width
localparam Address_Width = 12;

// Ports
// Clock and Reset
reg Clock;
reg Reset;
// Control Channel
reg Write;
reg Read;
// Address Channel
reg [(Address_Width - 1) : 0] Address;
// Data Channel
reg  [(Data_Width - 1) : 0] Data_In;
wire [(Data_Width - 1) : 0] Data_Out;

// Time Delay
time Clock_Period = 10;

// UUT Instantiation
Memory
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
    
    // Control Channel
    .Write(Write),
    .Read(Read),
    
    // Address Channel
    .Address(Address),
    
    // Data Channel
    .Data_In(Data_In),
    .Data_Out(Data_Out)
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
    
    // Diactive Reset and Active Write
    Reset = 1'b0;
    Write = 1'b1;
    Address = 12'h000;
    Data_In = 16'h1234;
    #(Clock_Period);
    
    // Continue Write
    Address = 12'h001;
    Data_In = 16'hAABB;
    #(Clock_Period);
    
    // Diactive Write and Active Read
    Write = 1'b0;
    Read  = 1'b1;
    Address = 12'h000;
    #(Clock_Period);
    
    // Continue Read
    Address = 12'h001;
    #(Clock_Period);
    
    // Diactive Read
    Read = 1'b0;
    #(Clock_Period);
    
    // Active Reset
    Reset = 1'b1;
    #(Clock_Period);
    
    // Diactive Reset
    Reset = 1'b0;
    #(Clock_Period);
    
    // Last Delay
    #(Clock_Period);
    
    // Finish Simulation
    $finish;
end

endmodule
