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
    input Clock_125_Mhz,
    input Reset,
    
    // Input and Output Register
    //input  [((Data_Width / 2) - 1) : 0] INPR_In,
    //output [((Data_Width / 2) - 1) : 0] OUTR_Out,
    
    // S SET Key
    input S_SET_Key,
    
    // Test Key
    input Test_Key,
    
    // CPU Active LED
    output CPU_Active,
    
    // FPAG OK LED
    output FPGA_OK
);

// Flip-Flops and Register
reg          S_SET_Key_Curr;
reg          S_SET_Key_Prev;
reg          Test_Key_Curr;
reg          Test_Key_Prev;
reg          Active;
reg          S_SET;
reg          Memory_Read_Active;
reg          ILA_Trig;
reg          FPGA_OK_Reg;
reg [26 : 0] S_Active_Counter;
reg [12 : 0] Memory_Address_Counter;
reg [25 : 0] FPGA_OK_Counter;

// Temporary Variable
wire  [((Data_Width / 2) - 1) : 0] INPR_In;
wire [((Data_Width / 2) - 1) : 0] OUTR_Out;

// Internal Connections
// CPU
// CPU Flip-Flop
wire S_In;
// CPU Read Control Out
wire CPU_Read_Out;
// CPU Address Out
wire [(Address_Width - 1) : 0] CPU_Address_Out;
// Memroy
// Memory Control Channel
wire Memory_Write;
wire Memory_Read;
// Memory Address Channel
wire [(Address_Width - 1) : 0] Memory_Address;
// Memory Data Channel
wire  [(Data_Width - 1) : 0] Memory_Data_In;
wire  [(Data_Width - 1) : 0] Memory_Data_Out;
// MMCM
// Output Clock
wire Clock_100_Mhz;
// Instantiations
// CPU Module
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
    .Clock(Clock_100_Mhz),
    .Reset(Reset),
    
    // S SET
    .S_SET(S_SET),
    
    // Memory Interface
    // Memory Control Channel
    .Memory_Write(Memory_Write),
    .Memory_Read(CPU_Read_Out),
    // Memory Address Channel
    .Memory_Address(CPU_Address_Out),
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
    .Clock(Clock_100_Mhz),
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
// MMCM Module
clk_wiz_0
MMCM_Module
(
    // Input Clock
    .clk_in1(Clock_125_Mhz),
    
    // Output Clock
    .clk_out1(Clock_100_Mhz)
);
// ILA Module
ila_0
ILA_Module
(
    // Clock
    .clk(Clock_100_Mhz),
    
    // ILA Trigger
    .probe0(ILA_Trig),
    
    // Output Data
    .probe1(Memory_Data_Out)
);
// VIO Module
vio_0
VIO_Module
(
    // Clock
    .clk(Clock_100_Mhz),
    
    //Input Port
    .probe_in0(OUTR_Out),
    
    // Output Port
    .probe_out0(INPR_In)
);

// Initialization
initial
begin
    S_SET_Key_Curr         = 'b0;
    S_SET_Key_Prev         = 'b0;
    Test_Key_Curr          = 'b0;
    Test_Key_Prev          = 'b0;
    Active                 = 'b0;
    S_SET                  = 'b0;
    Memory_Read_Active     = 'b0;
    ILA_Trig               = 'b0;
    FPGA_OK_Reg            = 'b0;
    S_Active_Counter       = 'b0;
    Memory_Address_Counter = 'b0;
    FPGA_OK_Counter        = 'b0;
end

// Combinitional Circuit
assign Memory_Read    = (Memory_Read_Active == 1'b0) ? CPU_Read_Out    : 1'b1;
assign Memory_Address = (Memory_Read_Active == 1'b0) ? CPU_Address_Out : Memory_Address_Counter;

// Sequential Circuit
always @(posedge Clock_100_Mhz)
begin
    S_SET    <= 'b0;
    ILA_Trig <= 'b0;
    
    Test_Key_Curr  <= Test_Key;
    Test_Key_Prev  <= Test_Key_Curr;
    S_SET_Key_Curr <= S_SET_Key;
    S_SET_Key_Prev <= S_SET_Key_Curr;
    
    FPGA_OK_Counter <= FPGA_OK_Counter + 1'b1;
    
    // Edge on the Test Key
    if ((Test_Key_Prev == 1'b0) && (Test_Key_Curr == 1'b1))
    begin
        Memory_Read_Active     <= 1'b1;
        Memory_Address_Counter <=  'b0;
    end
    
    // Memory Read Active
    if (Memory_Read_Active == 1'b1)
    begin
        ILA_Trig <= 1'b1;
        
        Memory_Address_Counter <= Memory_Address_Counter + 1'b1;
        
        // Memory Read Inactive
        if (Memory_Address_Counter > 13'd4095)
        begin
            ILA_Trig               <= 'b0;
            Memory_Read_Active     <= 'b0;
            Memory_Address_Counter <= 'b0;
        end
    end
    
    // Edge on the S SET Key
    if ((S_SET_Key_Prev == 1'b0) && (S_SET_Key_Curr == 1'b1))
    begin
        S_SET  <= 1'b1;
        Active <= 1'b1;
    end
    
    // CPU Active
    if (Active == 1'b1)
    begin
        ILA_Trig               <= 'b0;
        Memory_Read_Active     <= 'b0;
        Memory_Address_Counter <= 'b0;
        S_SET                  <= 'b0;
        
        S_Active_Counter <= S_Active_Counter + 1'b1;
        
        // CPU Inactive
        if (S_Active_Counter > 27'd100000000)
        begin
            Active           <= 'b0;
            S_Active_Counter <= 'b0;
        end
    end
    
    // FPGA OK LED Logic
    if (FPGA_OK_Counter >= 26'd50000000)
    begin
        FPGA_OK_Reg     <= (~FPGA_OK_Reg);
        FPGA_OK_Counter <= 'b0;
    end
    
    // Reset Logic
    if (Reset == 1'b1)
    begin
        S_SET_Key_Curr         <= 'b0;
        S_SET_Key_Prev         <= 'b0;
        Test_Key_Curr          <= 'b0;
        Test_Key_Prev          <= 'b0;
        Active                 <= 'b0;
        S_SET                  <= 'b0;
        Memory_Read_Active     <= 'b0;
        ILA_Trig               <= 'b0;
        FPGA_OK_Reg            <= 'b0;
        S_Active_Counter       <= 'b0;
        Memory_Address_Counter <= 'b0;
        FPGA_OK_Counter        <= 'b0;
    end
end

// Assign to Outputs
// CPU Active LED
assign CPU_Active = Active;
// FPGA OK LED
assign FPGA_OK = FPGA_OK_Reg;

endmodule
