`timescale 1ns / 1ps

// Control Unit Module Testbench
module Control_Unit_TB();

// Localparam
// Data Width
localparam Data_Width = 16;

// Ports
// Inputs
// Registers
reg [(Data_Width - 1) : 0] AC;
reg [(Data_Width - 1) : 0] DR;
reg [(Data_Width - 1) : 0] IR;
// Flip-Flops
reg I;
reg R;
reg E;
reg IEN;
reg FGI;
reg FGO;
// Time Sequences
reg T0;
reg T1;
reg T2;
reg T3;
reg T4;
reg T5;
reg T6;
reg T7;
reg T8;
reg T9;
reg T10;
reg T11;
reg T12;
reg T13;
reg T14;
reg T15;
// Decoded Operator
reg D0;
reg D1;
reg D2;
reg D3;
reg D4;
reg D5;
reg D6;
reg D7;
// Outputs
// Memory Control Channel
wire Memory_Write;
wire Memory_Read;
// Registers Controls
// AC
wire AC_LD;
wire AC_INR;
wire AC_CLR;
wire AC_NOT;
// DR
wire DR_LD;
wire DR_INR;
wire DR_CLR;
// IR
wire IR_LD;
// TR
wire TR_LD;
wire TR_INR;
wire TR_CLR;
// AR
wire AR_LD;
wire AR_INR;
wire AR_CLR;
// PC
wire PC_LD;
wire PC_INR;
wire PC_CLR;
// OUTR
wire OUTR_LD;
// Flip-Flops Controls
// I
wire I_LOAD;
// E
wire E_LOAD;
wire E_RESET;
wire E_NOT;
// R
wire R_SET;
wire R_RESET;
// S
wire S_RESET;
// IEN
wire IEN_SET;
wire IEN_RESET;
// FGI
wire FGI_RESET;
// FGO
wire FGO_RESET;
// Sequence Counter Reset
wire Sequence_Counter_Reset;
// ALU Select
wire [2 : 0] ALU_Select;
// BUS Select
wire [2 : 0] BUS_Select;

// Time Delay
time Delay = 1;

// UUT Instantiation
Control_Unit
#
(
    // Data Width
    .Data_Width(Data_Width)
)
UUT
(
    // Inputs
    // Registers
    .AC(AC),
    .DR(DR),
    .IR(IR),
    // Flip-Flops
    .I(I),
    .R(R),
    .E(E),
    .IEN(IEN),
    .FGI(FGI),
    .FGO(FGO),
    // Time Sequences
    .T0(T0),
    .T1(T1),
    .T2(T2),
    .T3(T3),
    .T4(T4),
    .T5(T5),
    .T6(T6),
    .T7(T7),
    .T8(T8),
    .T9(T9),
    .T10(T10),
    .T11(T11),
    .T12(T12),
    .T13(T13),
    .T14(T14),
    .T15(T15),
    // Decoded Operator
    .D0(D0),
    .D1(D1),
    .D2(D2),
    .D3(D3),
    .D4(D4),
    .D5(D5),
    .D6(D6),
    .D7(D7),
    
    // Outputs
    // Memory Control Channel
    .Memory_Write(Memory_Write),
    .Memory_Read(Memory_Read),
    // Registers Controls
    // AC
    .AC_LD(AC_LD),
    .AC_INR(AC_INR),
    .AC_CLR(AC_CLR),
    .AC_NOT(AC_NOT),
    // DR
    .DR_LD(DR_LD),
    .DR_INR(DR_INR),
    .DR_CLR(DR_CLR),
    // IR
    .IR_LD(IR_LD),
    // TR
    .TR_LD(TR_LD),
    .TR_INR(TR_INR),
    .TR_CLR(TR_CLR),
    // AR
    .AR_LD(AR_LD),
    .AR_INR(AR_INR),
    .AR_CLR(AR_CLR),
    // PC
    .PC_LD(PC_LD),
    .PC_INR(PC_INR),
    .PC_CLR(PC_CLR),
    // OUTR
    .OUTR_LD(OUTR_LD),
    // Flip-Flops Controls
    // I
    .I_LOAD(I_LOAD),
    // E
    .E_LOAD(E_LOAD),
    .E_RESET(E_RESET),
    .E_NOT(E_NOT),
    // R
    .R_SET(R_SET),
    .R_RESET(R_RESET),
    // S
    .S_RESET(S_RESET),
    // IEN
    .IEN_SET(IEN_SET),
    .IEN_RESET(IEN_RESET),
    // FGI
    .FGI_RESET(FGI_RESET),
    // FGO
    .FGO_RESET(FGO_RESET),
    // Sequence Counter Reset
    .Sequence_Counter_Reset(Sequence_Counter_Reset),
    // ALU Select
    .ALU_Select(ALU_Select),
    // BUS Select
    .BUS_Select(BUS_Select)
);

// Initialization
initial
begin
    // Registers
    AC = 'b0;
    DR = 'b0;
    IR = 'b0;
    
    // Flip-Flops
    I   = 1'b0;
    R   = 1'b1;
    E   = 1'b0;
    IEN = 1'b0;
    FGI = 1'b0;
    FGO = 1'b0;
    
    // Time Sequences
    T0  = 1'b0;
    T1  = 1'b0;
    T2  = 1'b0;
    T3  = 1'b0;
    T4  = 1'b0;
    T5  = 1'b0;
    T6  = 1'b0;
    T7  = 1'b0;
    T8  = 1'b0;
    T9  = 1'b0;
    T10 = 1'b0;
    T11 = 1'b0;
    T12 = 1'b0;
    T13 = 1'b0;
    T14 = 1'b0;
    T15 = 1'b0;
    
    // Decoded Operator
    D0 = 1'b0;
    D1 = 1'b0;
    D2 = 1'b0;
    D3 = 1'b0;
    D4 = 1'b0;
    D5 = 1'b0;
    D6 = 1'b0;
    D7 = 1'b0;
end

// Assign Values
initial
begin
    // First Dealy
    #(Delay);
    
    // Active Control Signals 1
    // LD(AR) = 1; S2S1S0 = 010;
    R  = 1'b0;
    T0 = 1'b1;
    #(Delay);
    
    // Active Control Signals 2
    // LD(IR) = 1; INC(PC) = 1; READ = 1; S2S1S0 = 111;
    T0 = 1'b0;
    T1 = 1'b1;
    #(Delay);
    
    // Active Control Signals 3
    // LD(AC) = 1; SC <- 0; ALU-OP = 010;
    R  = 1'b1;
    T1 = 1'b0;
    D0 = 1'b1;
    T5 = 1'b1;
    #(Delay);
    
    // Active Control Signals 4
    // LD(AC) = 1; Load(E) = 1; SC <- 0; ALU-OP = 011;
    D0 = 1'b0;
    D1 = 1'b1;
    #(Delay);
    
    // Active Control Signals 4
    // LD(AC) = 1; Load(E) = 1; SC <- 0; ALU-OP = 100;
    D1 = 1'b0;
    T5 = 1'b0;
    D7    = 1'b1;
    I     = 1'b0;
    T3    = 1'b1;
    IR[7] = 1'b1;
    #(Delay);
    
    // Active Control Signals 4
    // LD(AC) = 1; Load(E) = 1; SC <- 0; ALU-OP = 101;
    IR[7] = 1'b0;
    IR[6] = 1'b1;
    #(Delay);
    
    // Active Control Signals 4
    // LD(AC) = 1; RESET(FGI) = 1; SC <- 0; ALU-OP = 110;
    IR[6] = 1'b0;
    I      = 1'b1;
    IR[11] = 1'b1;
    #(Delay);
    
    // Last Delay
    #(Delay);
    
    // Finish Simulation
    $finish;
end

endmodule
