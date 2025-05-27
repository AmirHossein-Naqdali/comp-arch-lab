`timescale 1ns / 1ps

// ABS Instruction Testbench
module ABS_TB();

// Localparams
localparam Data_Width = 16;
localparam Address_Width = 12;

// Ports
// Clock and Reset
reg Clock;
reg Reset;
reg S_SET;

// Memory Interface
wire Memory_Write;
wire Memory_Read;
wire [(Address_Width - 1) : 0] Memory_Address;
wire [(Data_Width - 1) : 0] Memory_Data_In;
reg  [(Data_Width - 1) : 0] Memory_Data_Out;

// Input and Output Register
reg  [((Data_Width / 2) - 1) : 0] INPR_In;
wire [((Data_Width / 2) - 1) : 0] OUTR_Out;

// Time Delay
time Clock_Period = 10;

// Memory Array for simulation
reg [(Data_Width - 1) : 0] Memory [0 : (2**Address_Width - 1)];

// Test variables
integer test_case;
reg [15:0] expected_pc;
reg test_passed;

// UUT Instantiation
CPU
#
(
    .Data_Width(Data_Width),
    .Address_Width(Address_Width)
)
UUT
(
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

// Clock Generator
initial
begin
    Clock = 1'b0;
    forever #(Clock_Period / 2) Clock = ~Clock;
end

// Memory Model - responds to memory reads/writes
always @(posedge Clock)
begin
    if (Memory_Write)
        Memory[Memory_Address] <= Memory_Data_In;
end

always @(*)
begin
    if (Memory_Read)
        Memory_Data_Out = Memory[Memory_Address];
    else
        Memory_Data_Out = 16'h0000;
end

// Test Sequence
initial
begin
    // Initialize
    Reset = 1'b1;
    S_SET = 1'b0;
    INPR_In = 8'h00;
    test_case = 0;
    test_passed = 1'b1;
    
    // Initialize Memory
    for (integer i = 0; i < 2**Address_Width; i = i + 1)
        Memory[i] = 16'h0000;
    
    $display("=== ABS Instruction Testbench ===");
    $display("Time: %0t", $time);
    
    // Wait for clock edge
    @(posedge Clock);
    
    // Release reset
    Reset = 1'b0;
    S_SET = 1'b1;  // Start CPU
    
    // ========================================
    // TEST CASE 1: AC > memory[x] (should skip 1 instruction)
    // ========================================
    test_case = 1;
    $display("\n--- Test Case 1: AC > memory[x] ---");
    $display("Expected: PC should increment by 1 (skip next instruction)");
    
    // Setup memory for test case 1
    Memory[12'h000] = 16'h2064;  // LDA 100 (load AC with value at address 100)
    Memory[12'h001] = 16'h8065;  // ABS 101 (compare AC with memory[101])
    Memory[12'h002] = 16'h7001;  // HLT (should be skipped)
    Memory[12'h003] = 16'h7001;  // HLT (should execute)
    Memory[12'h064] = 16'h000A;  // Data: 10 (AC value)
    Memory[12'h065] = 16'h0005;  // Data: 5 (comparison value)
    
    // Wait for instruction execution
    repeat(50) @(posedge Clock);
    
    // Check result - PC should be at address 3 (skipped address 2)
    if (UUT.PC == 12'h003)
    begin
        $display("✓ Test Case 1 PASSED: PC = %h (correctly skipped 1 instruction)", UUT.PC);
    end
    else
    begin
        $display("✗ Test Case 1 FAILED: PC = %h (expected %h)", UUT.PC, 12'h003);
        test_passed = 1'b0;
    end
    
    // Reset for next test
    Reset = 1'b1;
    @(posedge Clock);
    Reset = 1'b0;
    
    // ========================================
    // TEST CASE 2: AC <= memory[x] (should skip 2 instructions)
    // ========================================
    test_case = 2;
    $display("\n--- Test Case 2: AC <= memory[x] ---");
    $display("Expected: PC should increment by 2 (skip next two instructions)");
    
    // Setup memory for test case 2
    Memory[12'h000] = 16'h2064;  // LDA 100 (load AC with value at address 100)
    Memory[12'h001] = 16'h8065;  // ABS 101 (compare AC with memory[101])
    Memory[12'h002] = 16'h7001;  // HLT (should be skipped)
    Memory[12'h003] = 16'h7001;  // HLT (should be skipped)
    Memory[12'h004] = 16'h7001;  // HLT (should execute)
    Memory[12'h064] = 16'h0003;  // Data: 3 (AC value)
    Memory[12'h065] = 16'h0005;  // Data: 5 (comparison value)
    
    // Wait for instruction execution
    repeat(50) @(posedge Clock);
    
    // Check result - PC should be at address 4 (skipped addresses 2 and 3)
    if (UUT.PC == 12'h004)
    begin
        $display("✓ Test Case 2 PASSED: PC = %h (correctly skipped 2 instructions)", UUT.PC);
    end
    else
    begin
        $display("✗ Test Case 2 FAILED: PC = %h (expected %h)", UUT.PC, 12'h004);
        test_passed = 1'b0;
    end
    
    // Reset for next test
    Reset = 1'b1;
    @(posedge Clock);
    Reset = 1'b0;
    
    // ========================================
    // TEST CASE 3: AC = memory[x] (should skip 2 instructions)
    // ========================================
    test_case = 3;
    $display("\n--- Test Case 3: AC = memory[x] ---");
    $display("Expected: PC should increment by 2 (skip next two instructions)");
    
    // Setup memory for test case 3
    Memory[12'h000] = 16'h2064;  // LDA 100 (load AC with value at address 100)
    Memory[12'h001] = 16'h8065;  // ABS 101 (compare AC with memory[101])
    Memory[12'h002] = 16'h7001;  // HLT (should be skipped)
    Memory[12'h003] = 16'h7001;  // HLT (should be skipped)
    Memory[12'h004] = 16'h7001;  // HLT (should execute)
    Memory[12'h064] = 16'h0007;  // Data: 7 (AC value)
    Memory[12'h065] = 16'h0007;  // Data: 7 (comparison value - equal)
    
    // Wait for instruction execution
    repeat(50) @(posedge Clock);
    
    // Check result - PC should be at address 4 (skipped addresses 2 and 3)
    if (UUT.PC == 12'h004)
    begin
        $display("✓ Test Case 3 PASSED: PC = %h (correctly skipped 2 instructions)", UUT.PC);
    end
    else
    begin
        $display("✗ Test Case 3 FAILED: PC = %h (expected %h)", UUT.PC, 12'h004);
        test_passed = 1'b0;
    end
    
    // ========================================
    // TEST CASE 4: Negative numbers test
    // ========================================
    test_case = 4;
    $display("\n--- Test Case 4: Negative numbers ---");
    $display("Expected: AC(-3) > memory[x](-5), should skip 1 instruction");
    
    // Reset for next test
    Reset = 1'b1;
    @(posedge Clock);
    Reset = 1'b0;
    
    // Setup memory for test case 4
    Memory[12'h000] = 16'h2064;  // LDA 100 (load AC with value at address 100)
    Memory[12'h001] = 16'h8065;  // ABS 101 (compare AC with memory[101])
    Memory[12'h002] = 16'h7001;  // HLT (should be skipped)
    Memory[12'h003] = 16'h7001;  // HLT (should execute)
    Memory[12'h064] = 16'hFFFD;  // Data: -3 (AC value, two's complement)
    Memory[12'h065] = 16'hFFFB;  // Data: -5 (comparison value, two's complement)
    
    // Wait for instruction execution
    repeat(50) @(posedge Clock);
    
    // Check result - PC should be at address 3 (skipped address 2)
    if (UUT.PC == 12'h003)
    begin
        $display("✓ Test Case 4 PASSED: PC = %h (correctly handled negative numbers)", UUT.PC);
    end
    else
    begin
        $display("✗ Test Case 4 FAILED: PC = %h (expected %h)", UUT.PC, 12'h003);
        test_passed = 1'b0;
    end
    
    // Final Results
    $display("\n=== Test Results ===");
    if (test_passed)
        $display("✓ ALL TESTS PASSED");
    else
        $display("✗ SOME TESTS FAILED");
    
    $display("Simulation completed at time: %0t", $time);
    $finish;
end

// Monitor important signals during simulation
initial
begin
    $monitor("Time: %0t | PC: %h | AC: %h | DR: %h | IR: %h | D8: %b | Test: %0d", 
             $time, UUT.PC, UUT.AC, UUT.DR, UUT.IR, UUT.Decoder_D8, test_case);
end

endmodule 