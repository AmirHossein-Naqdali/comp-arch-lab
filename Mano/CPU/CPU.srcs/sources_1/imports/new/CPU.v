`timescale 1ns / 1ps

// CPU Module
module CPU
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
    
    // S SET
    input S_SET,
    
    // Memory Interface
    // Memory Control Channel
    output Memory_Write,
    output Memory_Read,
    // Memory Address Channel
    output [(Address_Width - 1) : 0] Memory_Address,
    // Memory Data Channel
    output [(Data_Width - 1) : 0] Memory_Data_In,
    input  [(Data_Width - 1) : 0] Memory_Data_Out,
    
    // Input and Output Register
    input  [((Data_Width / 2) - 1) : 0] INPR_In,
    output [((Data_Width / 2) - 1) : 0] OUTR_Out
);

// Internal Signals
// Registers
reg [(Data_Width - 1) : 0]       AC;
reg [(Data_Width - 1) : 0]       DR;
reg [(Data_Width - 1) : 0]       IR;
reg [(Data_Width - 1) : 0]       TR;
reg [(Address_Width - 1) : 0]    AR;
reg [(Address_Width - 1) : 0]    PC;
reg [((Data_Width / 2) - 1) : 0] INPR;
reg [((Data_Width / 2) - 1) : 0] OUTR;
// Flip-Flops
reg I;
reg E;
reg R;
reg S;
reg IEN;
reg FGI;
reg FGO;
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
// Sequence Counter
// Counter
reg [3 : 0] Counter;
// Sequence Counter Reset
wire Sequence_Counter_Reset;
// Sequence Counter Outputs
reg Sequence_Counter_T0;
reg Sequence_Counter_T1;
reg Sequence_Counter_T2;
reg Sequence_Counter_T3;
reg Sequence_Counter_T4;
reg Sequence_Counter_T5;
reg Sequence_Counter_T6;
reg Sequence_Counter_T7;
reg Sequence_Counter_T8;
reg Sequence_Counter_T9;
//reg Sequence_Counter_T10;
//reg Sequence_Counter_T11;
//reg Sequence_Counter_T12;
//reg Sequence_Counter_T13;
//reg Sequence_Counter_T14;
//reg Sequence_Counter_T15;
// Decoder Outputs
reg Decoder_D0;
reg Decoder_D1;
reg Decoder_D2;
reg Decoder_D3;
reg Decoder_D4;
reg Decoder_D5;
reg Decoder_D6;
reg Decoder_D7;

// Instantiated Modules Signals
// ALU Module
wire [2 : 0]                ALU_Module_Operation_Select;
wire                        ALU_Module_E_Out;
wire [(Data_Width - 1) : 0] ALU_Module_Out;
// BUS Module
wire [2 : 0]                BUS_Module_Select;
wire [(Data_Width - 1) : 0] BUS_Module_Out;

// Instantiations
// Control Unit Module
Control_Unit
#
(
    // Data Width
    .Data_Width(Data_Width)
)
Control_Unit_Module
(
    // Inputs
    // Registers
    .AC(AC),
    .DR(DR),
    .IR(IR[11 : 0]),
    // Flip-Flops
    .I(I),
    .R(R),
    .E(E),
    .IEN(IEN),
    .FGI(FGI),
    .FGO(FGO),
    // Time Sequences
    .T0(Sequence_Counter_T0),
    .T1(Sequence_Counter_T1),
    .T2(Sequence_Counter_T2),
    .T3(Sequence_Counter_T3),
    .T4(Sequence_Counter_T4),
    .T5(Sequence_Counter_T5),
    .T6(Sequence_Counter_T6),
    .T7(Sequence_Counter_T7),
    .T8(Sequence_Counter_T8),
    .T9(Sequence_Counter_T9),
    //.T10(Sequence_Counter_T10),
    //.T11(Sequence_Counter_T11),
    //.T12(Sequence_Counter_T12),
    //.T13(Sequence_Counter_T13),
    //.T14(Sequence_Counter_T14),
    //.T15(Sequence_Counter_T15),
    // Decoded Operator
    .D0(Decoder_D0),
    .D1(Decoder_D1),
    .D2(Decoder_D2),
    .D3(Decoder_D3),
    .D4(Decoder_D4),
    .D5(Decoder_D5),
    .D6(Decoder_D6),
    .D7(Decoder_D7),
    
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
    .ALU_Select(ALU_Module_Operation_Select),
    // BUS Select
    .BUS_Select(BUS_Module_Select)
);
// ALU Module
ALU
#
(
    // Data Width
    .Data_Width(Data_Width)
)
ALU_Module
(
    // Operation Select
    .Operation_Select(ALU_Module_Operation_Select),
    
    // Inputs
    // INPR
    .Inp_0(INPR),
    // DR
    .Inp_1(DR),
    // AC
    .Inp_2(AC),
    // Input E
    .E_In(E),
    
    // Outputs
    // Output E
    .E_Out(ALU_Module_E_Out),
    // Calculation Output
    .Out(ALU_Module_Out)
);
// BUS Module
BUS
#
(
    // Data Width
    .Data_Width(Data_Width)
)
BUS_Module
(
    // Select
    .Select(BUS_Module_Select),
    
    // Inputs
    // Nothing
    .Inp_0({(Data_Width){1'b0}}),
    // AR
    .Inp_1(AR),
    // PC
    .Inp_2(PC),
    // DR
    .Inp_3(DR),
    // AC
    .Inp_4(AC),
    // IR
    .Inp_5(IR),
    // TR
    .Inp_6(TR),
    // Memory
    .Inp_7(Memory_Data_Out),
    
    // Outputs
    .Out(BUS_Module_Out)
);

// Initialization
initial
begin
    // Registers
    AC   = 'b0;
    DR   = 'b0;
    IR   = 'b0;
    TR   = 'b0;
    AR   = 'b0;
    PC   = 'b0;
    INPR = 'b0;
    OUTR = 'b0;
    
    // Flip-Flops
    I   = 1'b0;
    E   = 1'b0;
    R   = 1'b0;
    S   = 1'b0;
    IEN = 1'b0;
    FGI = 1'b0;
    FGO = 1'b0;
    
    // Sequence Counter
    Counter = 'b0;
end

// Sequential Circuit
always @(posedge Clock)
begin
    // Registers
    // AC Logic
    // NOT
    if (AC_NOT == 1'b1)
    begin
        AC <= ~AC;
    end
    // INR
    if (AC_INR == 1'b1)
    begin
        AC <= AC + 1'b1;
    end
    // LD
    if (AC_LD == 1'b1)
    begin
        AC <= ALU_Module_Out;
    end
    // CLR
    if (AC_CLR == 1'b1)
    begin
        AC <= 'b0;
    end
    // DR Logic
    // INR
    if (DR_INR == 1'b1)
    begin
        DR <= DR + 1'b1;
    end
    // LD
    if (DR_LD == 1'b1)
    begin
        DR <= BUS_Module_Out;
    end
    // CLR
    if (DR_CLR == 1'b1)
    begin
        DR <= 'b0;
    end
    // IR Logic
    // LD
    if (IR_LD == 1'b1)
    begin
        IR <= BUS_Module_Out;
    end
    // TR Logic
    // INR
    if (TR_INR == 1'b1)
    begin
        TR <= TR + 1'b1;
    end
    // LD
    if (TR_LD == 1'b1)
    begin
        TR <= BUS_Module_Out;
    end
    // CLR
    if (TR_CLR == 1'b1)
    begin
        TR <= 'b0;
    end
    // AR Logic
    // INR
    if (AR_INR == 1'b1)
    begin
        AR <= AR + 1'b1;
    end
    // LD
    if (AR_LD == 1'b1)
    begin
        AR <= BUS_Module_Out;
    end
    // CLR
    if (AR_CLR == 1'b1)
    begin
        AR <= 'b0;
    end
    // PC Logic
    // INR
    if (PC_INR == 1'b1)
    begin
        PC <= PC + 1'b1;
    end
    // LD
    if (PC_LD == 1'b1)
    begin
        PC <= BUS_Module_Out;
    end
    // CLR
    if (PC_CLR == 1'b1)
    begin
        PC <= 'b0;
    end
    // INPR Logic
    // LD
    INPR <= INPR_In;
    // OUTR Logic
    // LD
    if (OUTR_LD == 1'b1)
    begin
        OUTR <= BUS_Module_Out;
    end
    
    // Flip-Flops
    // I
    // LOAD
    if (I_LOAD == 1'b1)
    begin
        I <= IR[Data_Width - 1];
    end
    // E
    // NOT
    if (E_NOT == 1'b1)
    begin
        E <= ~E;
    end
    // SET
    if (E_RESET == 1'b1)
    begin
        E <= 1'b0;
    end
    // LOAD
    if (E_LOAD == 1'b1)
    begin
        E <= ALU_Module_E_Out;
    end
    // R
    // SET
    if (R_SET == 1'b1)
    begin
        R <= 1'b1;
    end
    // RESET
    if (R_RESET == 1'b1)
    begin
        R <= 1'b0;
    end
    // S
    // SET
    if (S_SET == 1'b1)
    begin
        S <= 1'b1;
    end
    // RESET
    if (S_RESET == 1'b1)
    begin
        S <= 1'b0;
    end
    // IEN
    // SET
    if (IEN_SET == 1'b1)
    begin
        IEN <= 1'b1;
    end
    // RESET
    if (IEN_RESET == 1'b1)
    begin
        IEN <= 1'b0;
    end
    // FGI
    // RESET
    if (FGI_RESET == 1'b1)
    begin
        FGI <= 1'b0;
    end
    //FGO
    // RESET
    if (FGO_RESET == 1'b1)
    begin
        FGO <= 1'b0;
    end
    
    // Sequence Counter
    if (S == 1'b1)
    begin
        Counter <= Counter + 1'b1;
    end
    if (Sequence_Counter_Reset == 1'b1)
    begin
        Counter <= 'b0;
    end
    
    // Reset Logic
    if (Reset == 1'b1)
    begin
        // Registers
        AC   <= 'b0;
        DR   <= 'b0;
        IR   <= 'b0;
        TR   <= 'b0;
        AR   <= 'b0;
        PC   <= 'b0;
        INPR <= 'b0;
        OUTR <= 'b0;
        
        // Flip-Flops
        I   <= 1'b0;
        E   <= 1'b0;
        R   <= 1'b0;
        S   <= 1'b0;
        IEN <= 1'b0;
        FGI <= 1'b0;
        FGO <= 1'b0;
        
        // Sequence Counter
        Counter <= 'b0;
    end
end

// Combinitional Circuit
// Sequence Counter
always @(*)
begin
    Sequence_Counter_T0  = 1'b0;
    Sequence_Counter_T1  = 1'b0;
    Sequence_Counter_T2  = 1'b0;
    Sequence_Counter_T3  = 1'b0;
    Sequence_Counter_T4  = 1'b0;
    Sequence_Counter_T5  = 1'b0;
    Sequence_Counter_T6  = 1'b0;
    Sequence_Counter_T7  = 1'b0;
    Sequence_Counter_T8  = 1'b0;
    Sequence_Counter_T9  = 1'b0;
    //Sequence_Counter_T10 = 1'b0;
    //Sequence_Counter_T11 = 1'b0;
    //Sequence_Counter_T12 = 1'b0;
    //Sequence_Counter_T13 = 1'b0;
    //Sequence_Counter_T14 = 1'b0;
    //Sequence_Counter_T15 = 1'b0;
    
    case ({S, Counter})
        // Active T0
        5'b10000:
        begin
            Sequence_Counter_T0 = 1'b1;
        end
        
        // Active T1
        5'b10001:
        begin
            Sequence_Counter_T1 = 1'b1;
        end
        
        // Active T2
        5'b10010:
        begin
            Sequence_Counter_T2 = 1'b1;
        end
        
        // Active T3
        5'b10011:
        begin
            Sequence_Counter_T3 = 1'b1;
        end
        
        // Active T4
        5'b10100:
        begin
            Sequence_Counter_T4 = 1'b1;
        end
        
        // Active T5
        5'b10101:
        begin
            Sequence_Counter_T5 = 1'b1;
        end
        
        // Active T6
        5'b10110:
        begin
            Sequence_Counter_T6 = 1'b1;
        end
        
        // Active T7
        5'b10111:
        begin
            Sequence_Counter_T7 = 1'b1;
        end
        
        // Active T8
        5'b11000:
        begin
            Sequence_Counter_T8 = 1'b1;
        end
        
        // Active T9
        5'b11001:
        begin
            Sequence_Counter_T9 = 1'b1;
        end
        
        // Active T10
        //5'b11010:
        //begin
            //Sequence_Counter_T10 = 1'b1;
        //end
        
        // Active T11
        //5'b11011:
        //begin
            //Sequence_Counter_T11 = 1'b1;
        //end
        
        // Active T12
        //5'b11100:
        //begin
            //Sequence_Counter_T12 = 1'b1;
        //end
        
        // Active T13
        //5'b11101:
        //begin
            //Sequence_Counter_T13 = 1'b1;
        //end
        
        // Active T14
        //5'b11110:
        //begin
            //Sequence_Counter_T14 = 1'b1;
        //end
        
        // Active T15
        //5'b11111:
        //begin
            //Sequence_Counter_T15 = 1'b1;
        //end
        
        // Defaults
        default:
        begin
            Sequence_Counter_T0  = 1'b0;
            Sequence_Counter_T1  = 1'b0;
            Sequence_Counter_T2  = 1'b0;
            Sequence_Counter_T3  = 1'b0;
            Sequence_Counter_T4  = 1'b0;
            Sequence_Counter_T5  = 1'b0;
            Sequence_Counter_T6  = 1'b0;
            Sequence_Counter_T7  = 1'b0;
            Sequence_Counter_T8  = 1'b0;
            Sequence_Counter_T9  = 1'b0;
            //Sequence_Counter_T10 = 1'b0;
            //Sequence_Counter_T11 = 1'b0;
            //Sequence_Counter_T12 = 1'b0;
            //Sequence_Counter_T13 = 1'b0;
            //Sequence_Counter_T14 = 1'b0;
            //Sequence_Counter_T15 = 1'b0;
        end
    endcase
end
// Decoder
always @(*)
begin
    Decoder_D0 = 1'b0;
    Decoder_D1 = 1'b0;
    Decoder_D2 = 1'b0;
    Decoder_D3 = 1'b0;
    Decoder_D4 = 1'b0;
    Decoder_D5 = 1'b0;
    Decoder_D6 = 1'b0;
    Decoder_D7 = 1'b0;
    
    case (IR[14 : 12])
        // AND
        3'b000:
        begin
            Decoder_D0 = 1'b1;
        end
        
        // ADD
        3'b001:
        begin
            Decoder_D1 = 1'b1;
        end
        
        // LDA
        3'b010:
        begin
            Decoder_D2 = 1'b1;
        end
        
        // STA
        3'b011:
        begin
            Decoder_D3 = 1'b1;
        end
        
        // BUN
        3'b100:
        begin
            Decoder_D4 = 1'b1;
        end
        
        // BSA
        3'b101:
        begin
            Decoder_D5 = 1'b1;
        end
        
        // ISZ
        3'b110:
        begin
            Decoder_D6 = 1'b1;
        end
        
        // Register and Input/Output Instruction
        3'b111:
        begin
            Decoder_D7 = 1'b1;
        end
        
        // Defaults
        default:
        begin
            Decoder_D0 = 1'b0;
            Decoder_D1 = 1'b0;
            Decoder_D2 = 1'b0;
            Decoder_D3 = 1'b0;
            Decoder_D4 = 1'b0;
            Decoder_D5 = 1'b0;
            Decoder_D6 = 1'b0;
            Decoder_D7 = 1'b0;
        end
    endcase
end

// Assign to Outputs
// Memory Interface
assign Memory_Address = AR;
assign Memory_Data_In = BUS_Module_Out;
// Input and Output Register
assign OUTR_Out = OUTR;

endmodule
