`timescale 1ns / 1ps

// FPGA Module
module FPGA
#
(
    // Data Width
    parameter Data_Width = 16,
    // Address Width
    parameter Address_Width = 12
)
(
    // Clock and Reset
    input Clock,
    input Reset,
    
    // Input and Output Register
    input  [((Data_Width / 2) - 1) : 0] INPR_In,
    output [((Data_Width / 2) - 1) : 0] OUTR_Out
);

// Internal Signals
// Memory Control Channel
wire Memory_Write;
wire Memory_Read;
// Memory Address Channel
wire [(Address_Width - 1) : 0] Memory_Address;
// Memory Data Channel
wire [(Data_Width - 1) : 0] Memory_Data_In;
wire  [(Data_Width - 1) : 0] Memory_Data_Out;

// Instantiations
CPU
#
(
    // Data Width
    .Data_Width(Data_Width),
    // Address Width
    .Address_Width(Address_Width)
)
CPU_Module
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
// Memory Module
Memory
#
(
    // Data Width
    .Data_Width(Data_Width),
    // Address Width
    .Address_Width(Address_Width)
)
Memory_Module
(
    // Clock and Reset
    .Clock(Clock),
    .Reset(Reset),
    
    // Control Channel
    .Write(Memory_Write),
    .Read(Memory_Read),
    
    // Address Channel
    .Address(Memory_Address),
    
    // Data Channel
    .Data_In(Memory_Data_In),
    .Data_Out(Memory_Data_Out)
);

endmodule
