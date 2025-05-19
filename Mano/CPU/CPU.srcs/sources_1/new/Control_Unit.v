`timescale 1ns / 1ps

// Control Unit Module
module Control_Unit
#
(
    // Data Width
    parameter Data_Width = 16
)
(
    // Inputs
    // Registers
    input [(Data_Width - 1) : 0] AC,
    input [(Data_Width - 1) : 0] DR,
    input [(Data_Width - 4 - 1) : 0] IR,
    // Flip-Flops
    input I,
    input R,
    input E,
    input IEN,
    input FGI,
    input FGO,
    // Time Sequences
    input T0,
    input T1,
    input T2,
    input T3,
    input T4,
    input T5,
    input T6,
//    input T7,
//    input T8,
//    input T9,
//    input T10,
//    input T11,
//    input T12,
//    input T13,
//    input T14,
//    input T15,
    // Decoded Operator
    input D0,
    input D1,
    input D2,
    input D3,
    input D4,
    input D5,
    input D6,
    input D7,
    
    // Outputs
    // Memory Control Channel
    output Memory_Write,
    output Memory_Read,
    // Registers Controls
    // AC
    output AC_LD,
    output AC_INR,
    output AC_CLR,
    output AC_NOT,
    // DR
    output DR_LD,
    output DR_INR,
    output DR_CLR,
    // IR
    output IR_LD,
    // TR
    output TR_LD,
    output TR_INR,
    output TR_CLR,
    // AR
    output AR_LD,
    output AR_INR,
    output AR_CLR,
    // PC
    output PC_LD,
    output PC_INR,
    output PC_CLR,
    // OUTR
    output OUTR_LD,
    // Flip-Flops Controls
    // I
    output I_LOAD,
    // E
    output E_LOAD,
    output E_RESET,
    output E_NOT,
    // R
    output R_SET,
    output R_RESET,
    // S
    output S_RESET,
    // IEN
    output IEN_SET,
    output IEN_RESET,
    // FGI
    output FGI_RESET,
    // FGO
    output FGO_RESET,
    // Sequence Counter Reset
    output Sequence_Counter_Reset,
    // ALU Select
    output [2 : 0] ALU_Select,
    // BUS Select
    output [2 : 0] BUS_Select
);

// Internal Wires
// Registers
// DR
wire DR_Zero;
// AC
wire AC_Positive;
wire AC_Negative;
wire AC_Zero;
// Flip-Flops
// E
wire E_Zero;
wire FGI_One;
wire FGO_Zero;

// Combinational Logic
// Registers
// DR
assign DR_Zero = (DR == {(Data_Width){1'b0}}) ? (1'b1) : (1'b0);
// AC
assign AC_Positive = (~AC[15]);
assign AC_Negative = (AC[15]);
assign AC_Zero     = (AC == {(Data_Width){1'b0}}) ? (1'b1) : (1'b0);
// Flip-Flops
// E
assign E_Zero = ~E;
// FGI
assign FGI_One = (FGI);
// FGO
assign FGO_Zero = (~FGO);

// Assign to Outputs
// Memory Control Channel
// Memory
assign Memory_Read  = ((~R) & T1) | ((~D7) & I & T3) | (D0 & T4) | (D1 & T4) | (D2 & T4) |
                      (D6 & T4);
assign Memory_Write = (R & T1) | (D3 & T4) | (D5 & T4) | (D6 & T6);

// Registers Controls
// AC
assign AC_LD  = (D0 & T5) | (D1 & T5) | (D2 & T5) | ((D7 & (~I) & T3) & (IR[7])) |
                ((D7 & (~I) & T3) & (IR[6])) | ((D7 & I & T3) & (IR[11]));
assign AC_INR = ((D7 & (~I) & T3) & (IR[5]));
assign AC_CLR = ((D7 & (~I) & T3) & (IR[11]));
assign AC_NOT = ((D7 & (~I) & T3) & (IR[9]));
// DR
assign DR_LD  = (D0 & T4) | (D1 & T4) | (D2 & T4) | (D6 & T4);
assign DR_INR = (D6 & T5);
assign DR_CLR = (1'b0);
// IR
assign IR_LD = (~R) & T1;
// TR
assign TR_LD  = (R & T0);
assign TR_INR = (1'b0);
assign TR_CLR = (1'b0);
// AR
assign AR_LD  = ((~R) & T0) | ((~R) & T2) | ((~D7) & I & T3);
assign AR_INR = (D5 & T4);
assign AR_CLR = (R & T0);
// PC
assign PC_LD  = (D4 & T4) | (D5 & T5);
assign PC_INR = ((~R) & T1) | (R & T2) | (DR_Zero & D6 & T6) | (AC_Positive & ((D7 & (~I) & T3) & (IR[4]))) |
                (AC_Negative & ((D7 & (~I) & T3) & (IR[3]))) | (AC_Zero & ((D7 & (~I) & T3) & (IR[2]))) |
                (E_Zero & ((D7 & (~I) & T3) & (IR[1]))) | (FGI_One & ((D7 & I & T3) & (IR[9]))) |
                (FGO_Zero & ((D7 & I & T3) & (IR[8])));
assign PC_CLR = (R & T1);
// OUTR
assign OUTR_LD = ((D7 & I & T3) & (IR[10]));

// Flip-Flops Controls
// I
assign I_LOAD = ((~R) & T2);
// E
assign E_LOAD  = (D1 & T5) | ((D7 & (~I) & T3) & (IR[7])) | ((D7 & (~I) & T3) & (IR[6]));
assign E_RESET = ((D7 & (~I) & T3) & (IR[10]));
assign E_NOT   = ((D7 & (~I) & T3) & (IR[8]));
// R
assign R_SET   = (~T0) & (~T1) & (~T2) & IEN & (FGI | FGO);
assign R_RESET = (R & T2);
// S
assign S_RESET = ((D7 & (~I) & T3) & (IR[0]));
// IEN
assign IEN_SET   = ((D7 & I & T3) & (IR[7]));
assign IEN_RESET = (R & T2) | ((D7 & I & T3) & (IR[6]));
// FGI
assign FGI_RESET = ((D7 & I & T3) & (IR[11]));
// FGO
assign FGO_RESET = ((D7 & I & T3) & (IR[10]));

// Sequence Counter Reset
assign Sequence_Counter_Reset = (R & T2) | (D0 & T5) | (D1 & T5) | (D2 & T5) | (D3 & T4) |
                                (D4 & T4) | (D5 & T5) | (D6 & T6) | ((D7 & (~I) & T3) & (IR[11])) |
                                ((D7 & (~I) & T3) & (IR[10])) | ((D7 & (~I) & T3) & (IR[9])) |
                                ((D7 & (~I) & T3) & (IR[8])) | ((D7 & (~I) & T3) & (IR[7])) |
                                ((D7 & (~I) & T3) & (IR[6])) | ((D7 & (~I) & T3) & (IR[5])) |
                                ((D7 & (~I) & T3) & (IR[4])) | ((D7 & (~I) & T3) & (IR[3])) |
                                ((D7 & (~I) & T3) & (IR[2])) | ((D7 & (~I) & T3) & (IR[1])) |
                                ((D7 & (~I) & T3) & (IR[0])) | ((D7 & I & T3) & (IR[11])) |
                                ((D7 & I & T3) & (IR[10])) | ((D7 & I & T3) & (IR[9])) |
                                ((D7 & I & T3) & (IR[8])) | ((D7 & I & T3) & (IR[7])) |
                                ((D7 & I & T3) & (IR[6]));
 // ALU Select
assign ALU_Select[2] = (D2 & T5) | ((D7 & (~I) & T3) & (IR[7])) |
                                         ((D7 & (~I) & T3) & (IR[6])) | ((D7 & I & T3) & (IR[11]));
assign ALU_Select[1] = (D0 & T5) | (D1 & T5) | (D2 & T5) | ((D7 & I & T3) & (IR[11]));
assign ALU_Select[0] = (D1 & T5) | (D2 & T5) | ((D7 & (~I) & T3) & (IR[6]));

// ALU Select
assign BUS_Select[2] = ((D3 & T4) | ((D7 & I & T3) & (IR[10]))) | ((~R) & T2) | (R & T1) |
                              (((~R) & T1) | ((~D7) & I & T3) | (D0 & T4) | (D1 & T4) | (D2 & T4) | (D6 & T4));
assign BUS_Select[1] = (((~R) & T0) | (R & T0) | (D5 & T4)) | (D6 & T6) | (R & T1) |
                              (((~R) & T1) | ((~D7) & I & T3) | (D0 & T4) | (D1 & T4) | (D2 & T4) | (D6 & T4));
assign BUS_Select[0] = ((D4 & T4) | (D5 & T5)) | (D6 & T6) | ((~R) & T2) | (((~R) & T1) |
                              ((~D7) & I & T3) | (D0 & T4) | (D1 & T4) | (D2 & T4) | (D6 & T4));

endmodule
