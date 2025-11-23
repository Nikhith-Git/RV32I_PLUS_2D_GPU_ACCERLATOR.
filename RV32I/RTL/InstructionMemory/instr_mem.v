`timescale 1ns/1ps

module instr_mem (
    input  	       rst,
    input  wire [31:0] addr,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:255];
    
    initial begin
        $readmemh("program1.hex", memory); // Load instructions from hex file
    end 

    assign instruction = (rst) ? 32'h00000000 : memory[addr[31:2]];

endmodule

/*
┌───────────────────────────────────────────┐
│         INSTRUCTION MEMORY                │
│                                           │
│   Address        Content (Instruction)    │
│   ───────        ────────────────────     │
│   0x00           00500093  (addi x1,x0,5) │
│   0x04           00A00113  (addi x2,x0,10)│
│   0x08           002081B3  (add x3,x1,x2) │
│   0x0C           00000013  (nop)          │
│   0x10           00000013  (nop)          │
│   ...            ...                      │
│                                           │
│   PC ─────►┌───────────┐                  │
│            │  Address  │                  │
│            │  Decoder  │                  │
│            └─────┬─────┘                  │
│                  │                        │
│                  ▼                        │
│            ┌───────────┐                  │
│            │instruction│─────────────►    │
│            └───────────┘     Output       │
└───────────────────────────────────────────┘

## Module Interface
```
                ┌──────────────────────┐
                │   INSTRUCTION MEM    │
                │                      │
  addr[31:0] ──►│                      │
   (from PC)    │    Read Only         │──► instruction[31:0]
                │    Memory            │
                │                      │
                └──────────────────────┘
```

## Important Characteristics

| Feature | Value | Why |
|---------|-------|-----|
| Read type | Combinational | Instruction available immediately |
| Write | Not needed | Program loaded at start, never changes |
| Size | 256 words (1KB) | Enough for testing |
| Width | 32 bits | RISC-V instruction size |
| Clock | None | Read-only, instant access |

---

## Example Execution
```
Program loaded:
  memory[0] = 00500093  (addi x1, x0, 5)
  memory[1] = 00A00113  (addi x2, x0, 10)
  memory[2] = 002081B3  (add x3, x1, x2)

Cycle 1:
  PC = 0x00000000
  addr[31:2] = 0
  instruction = memory[0] = 00500093 ✓

Cycle 2:
  PC = 0x00000004
  addr[31:2] = 1
  instruction = memory[1] = 00A00113 ✓

Cycle 3:
  PC = 0x00000008
  addr[31:2] = 2
  instruction = memory[2] = 002081B3 ✓


*/
