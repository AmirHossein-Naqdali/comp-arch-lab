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
    input T7,
    input T8,
    input T9,
    //input T10,
    //input T11,
    //input T12,
    //input T13,
    //input T14,
    //input T15,
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
// Register Instructions Tag
wire r;
// Input/Output Instructions Tag
wire p;

// Combinational Logic
// Registers
// DR
assign DR_Zero = ((DR == {(Data_Width){1'b0}}) ? (1'b1) : (1'b0));
// AC
assign AC_Positive = (~AC[15]);
assign AC_Negative = (AC[15]);
assign AC_Zero     = ((AC == {(Data_Width){1'b0}}) ? (1'b1) : (1'b0));
// Flip-Flops
// E
assign E_Zero = (~E);
// FGI
assign FGI_One = (FGI);
// FGO
assign FGO_Zero = (~FGO);
// Register Instructions Tag
assign r = (D7 & (~I) & T4);
// Input/Output Instructions Tag
assign p = (D7 & I & T4);

// Assign to Outputs
// Memory Control Channel
// Memory
assign Memory_Read  = (((~R) & T1) | ((~D7) & I & T4) | (D0 & T6) | (D1 & T6) | (D2 & T6) |
                      (D6 & T6));
assign Memory_Write = ((R & T1) | (D3 & T6) | (D5 & T6) | (D6 & T9));

// Registers Controls
// AC
assign AC_LD  = ((D0 & T8) | (D1 & T8) | (D2 & T8) | (r & IR[7]) | (r & IR[6]) | (p & IR[11]));
assign AC_INR = (r & IR[5]);
assign AC_CLR = (r & IR[11]);
assign AC_NOT = (r & IR[9]);
// DR
assign DR_LD  = ((D0 & T7) | (D1 & T7) | (D2 & T7) | (D6 & T7));
assign DR_INR = (D6 & T8);
assign DR_CLR = (1'b0);
// IR
assign IR_LD = ((~R) & T2);
// TR
assign TR_LD  = (R & T0);
assign TR_INR = (1'b0);
assign TR_CLR = (1'b0);
// AR
assign AR_LD  = (((~R) & T0) | ((~R) & T3) | ((~D7) & I & T5));
assign AR_INR = (D5 & T6);
assign AR_CLR = (R & T0);
// PC
assign PC_LD  = ((D4 & T6) | (D5 & T7));
assign PC_INR = (((~R) & T2) | (R & T2) | (DR_Zero & D6 & T9) | (AC_Positive & (r & IR[4])) |
                (AC_Negative & (r & IR[3])) | (AC_Zero & (r & IR[2])) |
                (E_Zero & (r & IR[1])) | (FGI_One & (p & IR[9])) |
                (FGO_Zero & (p & IR[8])));
assign PC_CLR = (R & T1);
// OUTR
assign OUTR_LD = (p & IR[10]);

// Flip-Flops Controls
// I
assign I_LOAD = ((~R) & T3);
// E
assign E_LOAD  = ((D1 & T8) | (r & IR[7]) | (r & IR[6]));
assign E_RESET = (r & IR[10]);
assign E_NOT   = (r & IR[8]);
// R
assign R_SET   = ((~T0) & (~T1) & (~T2) & (~T3) & IEN & (FGI | FGO));
assign R_RESET = (R & T2);
// S
assign S_RESET = (r & IR[0]);
// IEN
assign IEN_SET   = (p & IR[7]);
assign IEN_RESET = ((R & T2) | (p & IR[6]));
// FGI
assign FGI_RESET = (p & IR[11]);
// FGO
assign FGO_RESET = (p & IR[10]);

// Sequence Counter Reset
assign Sequence_Counter_Reset = ((R & T2) | (D0 & T8) | (D1 & T8) | (D2 & T8) | (D3 & T6) |
                                (D4 & T6) | (D5 & T7) | (D6 & T9) | (r) | (p));
 // ALU Select
assign ALU_Select[2] = ((D2 & T8) | (r & IR[7]) | (r & IR[6]) | (p & IR[11]));
assign ALU_Select[1] = ((D0 & T8) | (D1 & T8) | (D2 & T8) | (p & IR[11]));
assign ALU_Select[0] = ((D1 & T8) | (D2 & T8) | (r & IR[6]));

// ALU Select
assign BUS_Select[2] = ((D3 & T6) | (p & IR[10]) | ((~R) & T3) | (R & T1) |
                       ((~R) & T1) | ((~D7) & I & T4) | (D0 & T6) | (D1 & T6) | (D2 & T6) | (D6 & T6));
assign BUS_Select[1] = (((~R) & T0) | (R & T0) | (D5 & T6) | (D6 & T9) | (R & T1) |
                       ((~R) & T1) | ((~D7) & I & T4) | (D0 & T6) | (D1 & T6) | (D2 & T6) | (D6 & T6));
assign BUS_Select[0] = ((D4 & T6) | (D5 & T7) | (D6 & T9) | ((~R) & T3) |
                       ((~R) & T1) | ((~D7) & I & T4) | (D0 & T6) | (D1 & T6) | (D2 & T6) | (D6 & T6));

endmodule
