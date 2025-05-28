// ABS Instruction Test Example
// This example demonstrates the ABS instruction functionality

module ABS_Test_Example();

// Test case 1: AC > memory[x] (should skip 1 instruction)
// Initial state: AC = 10, memory[100] = 5
// Expected: PC increments by 1 (skip next instruction)

// Test case 2: AC <= memory[x] (should skip 2 instructions)  
// Initial state: AC = 3, memory[100] = 5
// Expected: PC increments by 2 (skip next two instructions)

// Example assembly code:
/*
    LDA 200     ; Load AC with test value
    ABS 100     ; Compare AC with memory[100]
    HLT         ; This instruction is skipped if AC > memory[100]
    HLT         ; This instruction is skipped if AC <= memory[100]
    ; Continue execution here...
*/

// Machine code representation:
// Address | Instruction | Description
// --------|-------------|-------------
// 000     | 2200        | LDA 200 (load test value into AC)
// 001     | 8064        | ABS 100 (compare AC with memory[100])
// 002     | 7001        | HLT (halt - skipped if AC > memory[100])
// 003     | 7001        | HLT (halt - skipped if AC <= memory[100])
// 004     | ...         | Continue execution
// ...
// 100     | 0005        | Data: 5 (comparison value)
// ...
// 200     | 000A        | Data: 10 (test value for AC)

endmodule 