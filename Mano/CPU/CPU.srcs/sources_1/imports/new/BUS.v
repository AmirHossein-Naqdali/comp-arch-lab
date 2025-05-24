`timescale 1ns / 1ps

// BUS Module
module BUS
#
(
    // Data Width
    parameter Data_Width = 16
)
(
    // Select
    input [2 : 0] Select,
    
    // Inputs
    // Nothing
    input [(Data_Width - 1) : 0] Inp_0,
    // AR
    input [(Data_Width - 1) : 0] Inp_1,
    // PC
    input [(Data_Width - 1) : 0] Inp_2,
    // DR
    input [(Data_Width - 1) : 0] Inp_3,
    // AC
    input [(Data_Width - 1) : 0] Inp_4,
    // IR
    input [(Data_Width - 1) : 0] Inp_5,
    // TR
    input [(Data_Width - 1) : 0] Inp_6,
    // Memory
    input [(Data_Width - 1) : 0] Inp_7,
    
    // Outputs
    output [(Data_Width - 1) : 0] Out
);

// Outputs Variable Temporary
reg [(Data_Width - 1) : 0] Out_Temp;

// Combinational Circuit
always @(*)
begin
    Out_Temp = 'b0;
    
    case (Select)
        // Nothing
        3'b000:
        begin
            Out_Temp = Inp_0;
        end
        
        // AR
        3'b001:
        begin
            Out_Temp = Inp_1;
        end
        
        // PC
        3'b010:
        begin
            Out_Temp = Inp_2;
        end
        
        // DR
        3'b011:
        begin
            Out_Temp = Inp_3;
        end
        
        // AC
        3'b100:
        begin
            Out_Temp = Inp_4;
        end
        
        // IR
        3'b101:
        begin
            Out_Temp = Inp_5;
        end
        
        // TR
        3'b110:
        begin
            Out_Temp = Inp_6;
        end
        
        // Memory
        3'b111:
        begin
            Out_Temp = Inp_7;
        end
        
        // Defaults
        default:
        begin
            Out_Temp = 'b0;
        end
    endcase
end

// Assign to Output
assign Out = Out_Temp;

endmodule
