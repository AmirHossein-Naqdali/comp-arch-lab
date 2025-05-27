`timescale 1ns / 1ps

// Simple ABS Instruction Testbench
module ABS_Simple_TB();

// Parameters
localparam Data_Width = 16;
localparam Address_Width = 12;
localparam Clock_Period = 10;

// Signals
reg Clock, Reset, S_SET;
wire Memory_Write, Memory_Read;
wire [Address_Width-1:0] Memory_Address;
wire [Data_Width-1:0] Memory_Data_In;
reg [Data_Width-1:0] Memory_Data_Out;
reg [7:0] INPR_In;
wire [7:0] OUTR_Out;

// Simple memory model
reg [Data_Width-1:0] mem [0:4095];

// CPU Instance
CPU #(
    .Data_Width(Data_Width),
    .Address_Width(Address_Width)
) cpu_inst (
    .Clock(Clock),
    .Reset(Reset),
    .S_SET(S_SET),
    .Memory_Write(Memory_Write),
    .Memory_Read(Memory_Read),
    .Memory_Address(Memory_Address),
    .Memory_Data_In(Memory_Data_In),
    .Memory_Data_Out(Memory_Data_Out),
    .INPR_In(INPR_In),
    .OUTR_Out(OUTR_Out)
);

// Clock generation
initial begin
    Clock = 0;
    forever #(Clock_Period/2) Clock = ~Clock;
end

// Memory read logic
always @(*) begin
    if (Memory_Read)
        Memory_Data_Out = mem[Memory_Address];
    else
        Memory_Data_Out = 16'h0000;
end

// Memory write logic
always @(posedge Clock) begin
    if (Memory_Write)
        mem[Memory_Address] <= Memory_Data_In;
end

// Test procedure
initial begin
    // Initialize
    Reset = 1;
    S_SET = 0;
    INPR_In = 0;
    
    // Initialize memory
    for (integer i = 0; i < 4096; i = i + 1)
        mem[i] = 16'h0000;
    
    $display("=== ABS Instruction Simple Testbench ===");
    
    // Test Case 1: AC > memory[x] (10 > 5)
    $display("\nTest 1: AC(10) > memory[100](5) - Should skip 1 instruction");
    
    // Program memory
    mem[0] = 16'h2064;   // LDA 100  - Load AC with value from address 100
    mem[1] = 16'h8065;   // ABS 101  - Compare AC with memory[101]
    mem[2] = 16'h7001;   // HLT      - Should be skipped
    mem[3] = 16'h0000;   // NOP      - Should execute here
    
    // Data memory
    mem[100] = 16'h000A; // AC value = 10
    mem[101] = 16'h0005; // Compare value = 5
    
    // Start test
    @(posedge Clock);
    Reset = 0;
    S_SET = 1;
    
    // Wait for execution
    repeat(30) @(posedge Clock);
    
    // Check result
    if (cpu_inst.PC == 12'h003) begin
        $display("✓ PASS: PC = %h (skipped 1 instruction as expected)", cpu_inst.PC);
    end else begin
        $display("✗ FAIL: PC = %h (expected 003)", cpu_inst.PC);
    end
    
    // Reset for next test
    Reset = 1;
    @(posedge Clock);
    
    // Test Case 2: AC <= memory[x] (3 <= 5)
    $display("\nTest 2: AC(3) <= memory[100](5) - Should skip 2 instructions");
    
    // Update data memory
    mem[100] = 16'h0003; // AC value = 3
    mem[101] = 16'h0005; // Compare value = 5
    
    // Start test
    @(posedge Clock);
    Reset = 0;
    
    // Wait for execution
    repeat(30) @(posedge Clock);
    
    // Check result
    if (cpu_inst.PC == 12'h004) begin
        $display("✓ PASS: PC = %h (skipped 2 instructions as expected)", cpu_inst.PC);
    end else begin
        $display("✗ FAIL: PC = %h (expected 004)", cpu_inst.PC);
    end
    
    // Reset for next test
    Reset = 1;
    @(posedge Clock);
    
    // Test Case 3: AC = memory[x] (7 = 7)
    $display("\nTest 3: AC(7) = memory[100](7) - Should skip 2 instructions");
    
    // Update data memory
    mem[100] = 16'h0007; // AC value = 7
    mem[101] = 16'h0007; // Compare value = 7
    
    // Start test
    @(posedge Clock);
    Reset = 0;
    
    // Wait for execution
    repeat(30) @(posedge Clock);
    
    // Check result
    if (cpu_inst.PC == 12'h004) begin
        $display("✓ PASS: PC = %h (skipped 2 instructions as expected)", cpu_inst.PC);
    end else begin
        $display("✗ FAIL: PC = %h (expected 004)", cpu_inst.PC);
    end
    
    $display("\n=== Test Complete ===");
    $finish;
end

// Signal monitoring
initial begin
    $monitor("Time=%0t | PC=%h | AC=%h | DR=%h | IR=%h | D8=%b", 
             $time, cpu_inst.PC, cpu_inst.AC, cpu_inst.DR, cpu_inst.IR, cpu_inst.Decoder_D8);
end

endmodule 