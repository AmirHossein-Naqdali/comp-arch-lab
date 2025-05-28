# ABS Instruction Testing Guide

## Overview

This guide explains how to test the ABS (Absolute Branch) instruction implementation using the provided testbenches.

## Testbench Files

### 1. ABS_TB.v - Comprehensive Testbench

**Location**: `Mano/CPU/CPU.srcs/sim_1/imports/new/ABS_TB.v`

**Features**:

- Tests 4 different scenarios
- Includes negative number testing
- Comprehensive error checking
- Detailed output messages
- Memory model simulation

**Test Cases**:

1. **AC > memory[x]**: AC=10, memory[x]=5 → Skip 1 instruction
2. **AC < memory[x]**: AC=3, memory[x]=5 → Skip 2 instructions  
3. **AC = memory[x]**: AC=7, memory[x]=7 → Skip 2 instructions
4. **Negative numbers**: AC=-3, memory[x]=-5 → Skip 1 instruction

### 2. ABS_Simple_TB.v - Simple Testbench

**Location**: `Mano/CPU/CPU.srcs/sim_1/imports/new/ABS_Simple_TB.v`

**Features**:

- Simplified test structure
- Easy to understand and modify
- Quick verification
- Basic test cases

## How to Run the Tests

### Using Vivado Simulator

1. **Open Vivado Project**:

   ```
   Open: Mano/CPU/CPU.xpr
   ```

2. **Add Testbench to Simulation Sources**:
   - Right-click on "Simulation Sources" in Project Manager
   - Add Sources → Add or create simulation sources
   - Add the testbench files

3. **Set Top Module**:
   - Right-click on desired testbench (ABS_TB or ABS_Simple_TB)
   - Set as Top

4. **Run Simulation**:
   - Click "Run Simulation" → "Run Behavioral Simulation"
   - Or use TCL command: `launch_simulation`

### Using ModelSim/QuestaSim

1. **Compile Sources**:

   ```tcl
   vlog CPU.v Control_Unit.v ALU.v BUS.v ABS_TB.v
   ```

2. **Start Simulation**:

   ```tcl
   vsim ABS_TB
   ```

3. **Run Test**:

   ```tcl
   run -all
   ```

## Expected Output

### Successful Test Run (ABS_Simple_TB)

```
=== ABS Instruction Simple Testbench ===

Test 1: AC(10) > memory[100](5) - Should skip 1 instruction
✓ PASS: PC = 003 (skipped 1 instruction as expected)

Test 2: AC(3) <= memory[100](5) - Should skip 2 instructions
✓ PASS: PC = 004 (skipped 2 instructions as expected)

Test 3: AC(7) = memory[100](7) - Should skip 2 instructions
✓ PASS: PC = 004 (skipped 2 instructions as expected)

=== Test Complete ===
```

### Comprehensive Test Run (ABS_TB)

```
=== ABS Instruction Testbench ===

--- Test Case 1: AC > memory[x] ---
Expected: PC should increment by 1 (skip next instruction)
✓ Test Case 1 PASSED: PC = 003 (correctly skipped 1 instruction)

--- Test Case 2: AC <= memory[x] ---
Expected: PC should increment by 2 (skip next two instructions)
✓ Test Case 2 PASSED: PC = 004 (correctly skipped 2 instructions)

--- Test Case 3: AC = memory[x] ---
Expected: PC should increment by 2 (skip next two instructions)
✓ Test Case 3 PASSED: PC = 004 (correctly skipped 2 instructions)

--- Test Case 4: Negative numbers ---
Expected: AC(-3) > memory[x](-5), should skip 1 instruction
✓ Test Case 4 PASSED: PC = 003 (correctly handled negative numbers)

=== Test Results ===
✓ ALL TESTS PASSED
```

## Test Program Structure

Each test follows this pattern:

```assembly
Address | Instruction | Machine Code | Description
--------|-------------|--------------|-------------
000     | LDA 100     | 2064         | Load AC with test value
001     | ABS 101     | 8065         | Compare AC with memory[101]
002     | HLT         | 7001         | Skip if AC > memory[101]
003     | HLT         | 7001         | Skip if AC <= memory[101]
004     | (continue)  | ...          | Execution continues here
...     | ...         | ...          | ...
100     | Data        | 000A         | Test value for AC
101     | Data        | 0005         | Comparison value
```

## Debugging Failed Tests

### Common Issues

1. **PC Not Incrementing Correctly**:
   - Check D8 decoder signal activation
   - Verify AC_Greater_Than_DR comparison logic
   - Ensure sequence counter reset conditions

2. **Memory Read Issues**:
   - Verify memory model responds to Memory_Read
   - Check address generation (AR register)
   - Confirm BUS selection for memory data

3. **Timing Issues**:
   - Increase wait cycles in testbench
   - Check clock period settings
   - Verify reset timing

### Debug Signals to Monitor

```verilog
$monitor("Time=%0t | PC=%h | AC=%h | DR=%h | IR=%h | D8=%b | AC_GT_DR=%b", 
         $time, cpu_inst.PC, cpu_inst.AC, cpu_inst.DR, 
         cpu_inst.IR, cpu_inst.Decoder_D8, cpu_inst.Control_Unit_Module.AC_Greater_Than_DR);
```

## Manual Testing

### Test Case Setup

1. Load a value into AC using LDA instruction
2. Place comparison value in memory
3. Execute ABS instruction
4. Observe PC behavior

### Example Manual Test

```assembly
; Test: AC(15) > memory[200](10)
LDA 300    ; Load AC with 15
ABS 200    ; Compare with memory[200] (value 10)
HLT        ; Should be skipped (PC goes to next+1)
HLT        ; Should execute here
```

## Waveform Analysis

Key signals to observe in waveform viewer:

- **PC**: Should increment by 1 or 2 based on comparison
- **AC**: Should contain the loaded value
- **DR**: Should contain the memory comparison value
- **D8**: Should be high during ABS instruction execution
- **AC_Greater_Than_DR**: Shows comparison result
- **Memory_Read**: Should be active during T6
- **Sequence_Counter_Reset**: Should reset at appropriate time

## Troubleshooting

### If Tests Fail

1. Check that D8 decoder is properly connected
2. Verify AC_Greater_Than_DR logic uses signed comparison
3. Ensure PC increment logic includes ABS conditions
4. Confirm sequence counter reset includes ABS cases
5. Check memory model responds correctly to reads

### Simulation Issues

1. Ensure all source files are compiled
2. Check for syntax errors in modified files
3. Verify testbench includes all necessary signals
4. Confirm clock and reset timing is correct
