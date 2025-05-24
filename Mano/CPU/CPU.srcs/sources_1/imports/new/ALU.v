`timescale 1ns / 1ps

// ALU Module
module ALU
#
(
    // Data Width
    parameter Data_Width = 16
)
(
    // Operation Select
    input [2 : 0] Operation_Select,
    
    // Inputs
    // INPR
    input [((Data_Width / 2) - 1) : 0] Inp_0,
    // DR
    input [(Data_Width - 1) : 0] Inp_1,
    // AC
    input [(Data_Width - 1) : 0] Inp_2,
    // Input E
    input E_In,
    
    // Outputs
    // Output E
    output E_Out,
    // Calculation Output
    output [(Data_Width - 1) : 0] Out
);

// Outputs Variable Temporary
reg                        E_Out_Temp;
reg [(Data_Width - 1) : 0] Out_Temp;

// Combinational Circuit
always @(*)
begin
    E_Out_Temp = 1'b0;
    Out_Temp   =  'b0;
    
    case (Operation_Select)
        // Nothing
        3'b000:
        begin
            E_Out_Temp = 1'b0;
            Out_Temp   =  'b0;
        end
        
        // Nothing
        3'b001:
        begin
            E_Out_Temp = 1'b0;
            Out_Temp   =  'b0;
        end
        
        // AND
        3'b010:
        begin
            Out_Temp = Inp_1 & Inp_2;
        end
        
        // ADD
        3'b011:
        begin
            {E_Out_Temp, Out_Temp} = Inp_1 + Inp_2;
        end
        
        // CIR
        3'b100:
        begin
            E_Out_Temp = Out_Temp[0];
            Out_Temp   = {E_In, Inp_2[(Data_Width - 1) : 1]};
        end
        
        // CIL
        3'b101:
        begin
            E_Out_Temp = Inp_2[Data_Width - 1];
            Out_Temp   = {Inp_2[(Data_Width - 2) : 0], E_In};
        end
        
        // PASS 1 (AC[7 : 0] <- INPR)
        3'b110:
        begin
            Out_Temp[7 : 0] = Inp_0;
        end
        
        // PASS 2 (AC <- DR)
        3'b111:
        begin
            Out_Temp = Inp_1;
        end
        
        // Defaults
        default:
        begin
            E_Out_Temp = 1'b0;
            Out_Temp   =  'b0;
        end
    endcase
end

// Assign to Outputs
assign E_Out = E_Out_Temp;
assign Out   = Out_Temp;

endmodule
