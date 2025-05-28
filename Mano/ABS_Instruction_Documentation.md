# ABS Instruction Implementation for Mano Machine

## Overview

The ABS (Absolute Branch) instruction has been added to the Mano machine CPU. This instruction performs a conditional branch based on the comparison between the accumulator (AC) and a memory location.

## Instruction Format

```
Opcode: 1000 (4-bit opcode)
Format: 1000 xxxxxxxxxxxx
Where: xxxxxxxxxxxx is the 12-bit memory address
```

## Operation

```
ABS x: if (AC - memory[x]) > 0 then:
           PC <- PC + 1 (skip next instruction)
       else:
           PC <- PC + 2 (skip next two instructions)
```

## Implementation Details

### Instruction Encoding

- The ABS instruction uses a 4-bit opcode `1000` (binary) = `8` (hex)
- This extends beyond the traditional 3-bit Mano instruction set
- The remaining 12 bits specify the memory address

### Execution Sequence

1. **T0-T5**: Standard instruction fetch and decode
2. **T6**: Read memory[x] (Memory_Read = 1, BUS selects memory)
3. **T7**: Load memory[x] into DR (DR_LD = 1)
4. **T8**: Compare AC with DR, increment PC once
5. **T9**: If AC <= DR, increment PC again (total increment = 2)

### Control Signals Modified

- **Memory_Read**: Added `(D8 & T6)` for reading memory[x]
- **DR_LD**: Added `(D8 & T7)` for loading memory data
- **PC_INR**: Added `(D8 & T8)` and `((~AC_Greater_Than_DR) & D8 & T9)`
- **Sequence_Counter_Reset**: Added reset conditions for ABS instruction
- **BUS_Select**: Added `(D8 & T6)` for memory data access

### New Hardware Added

- **Decoder_D8**: New decoder output for ABS instruction
- **AC_Greater_Than_DR**: Signed comparison wire `($signed(AC) > $signed(DR))`

## Usage Example

```assembly
; Example: Skip instructions based on AC vs memory[100]
ABS 100     ; Compare AC with memory[100]
; Next instruction (skipped if AC > memory[100])
; Next instruction (skipped if AC <= memory[100])
; Continue here if AC > memory[100]
; Continue here if AC <= memory[100]
```

## Files Modified

1. **CPU.v**: Added D8 decoder output and instruction decoding logic
2. **Control_Unit.v**: Added D8 input and ABS instruction control logic

## Testing

The ABS instruction can be tested by:

1. Loading a value into AC
2. Storing a comparison value in memory
3. Executing ABS instruction
4. Observing PC increment behavior

## Machine Code Example

```
Instruction: ABS 100 (decimal)
Binary: 1000 000001100100
Hex: 8064
```

This instruction will compare AC with the value stored at memory address 100 and branch accordingly.
