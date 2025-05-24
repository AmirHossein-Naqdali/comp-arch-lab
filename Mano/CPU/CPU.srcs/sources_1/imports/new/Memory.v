`timescale 1ns / 1ps

// Memory Module
module Memory
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
    
    // Control Channel
    input Write,
    input Read,
    
    // Address Channel
    input [(Address_Width - 1) : 0] Address,
    
    // Data Channel
    input  [(Data_Width - 1) : 0] Data_In,
    output [(Data_Width - 1) : 0] Data_Out
);

// Output Register
reg [(Data_Width - 1) : 0] Data_Out_Reg;

// RAM
(* ram_style = "block" *)
reg [(Data_Width - 1) : 0] RAM [0 : (2**Address_Width - 1)];

// Loop Variable
integer i;

// Initialization
initial
begin
    // Output Register Initialization
    Data_Out_Reg = 'b0;
    
    // Memory Initialization
    $readmemb("Initial_RAM_Values.data", RAM);
end

// Sequential Circuit
always @(posedge Clock)
begin
    // Read Logic
    if ((Write == 1'b0) && (Read == 1'b1))
    begin
        Data_Out_Reg <= RAM[Address];
    end
    
    // Write Logic
    if (Write == 1'b1)
    begin
        RAM[Address] <= Data_In;
    end
    
    // Reset Logic
    if (Reset == 1'b1)
    begin
        Data_Out_Reg <= 'b0;
    end
end

// Assign to Output
assign Data_Out = Data_Out_Reg;

endmodule
