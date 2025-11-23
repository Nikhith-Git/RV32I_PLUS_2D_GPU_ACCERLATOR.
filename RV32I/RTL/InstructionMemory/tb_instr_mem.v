`timescale 1ns/1ps

module tb_instr_mem;

    reg         rst;
    reg  [31:0] addr;
    wire [31:0] instruction;
    
    // Instantiate instruction memory
    instr_mem uut (
        .rst(rst),
        .addr(addr),
        .instruction(instruction)
    );
    
    initial begin
        $dumpfile("instr_mem_wave.vcd");
        $dumpvars(0, tb_instr_mem);
        
        $display("\n=== Instruction Memory Test ===\n");
        
        // Test 1: Reset active
        rst = 1;
        addr = 32'h00000000;
        #10;
        $display("TEST 1 - Reset active:");
        $display("  addr=0x%08h, rst=%b → instruction=0x%08h", addr, rst, instruction);
        if (instruction == 32'h00000000)
            $display("  PASS: Output is 0 during reset\n");
        else
            $display("  FAIL: Expected 0x00000000\n");
        
        // Release reset
        rst = 0;
        
        // Test 2: Address 0x00
        addr = 32'h00000000;
        #10;
        $display("TEST 2 - Address 0x00:");
        $display("  addr=0x%08h → instruction=0x%08h", addr, instruction);
        if (instruction == 32'h00500093)
            $display("  PASS\n");
        else
            $display("  FAIL: Expected 0x00500093\n");
        
        // Test 3: Address 0x04
        addr = 32'h00000004;
        #10;
        $display("TEST 3 - Address 0x04:");
        $display("  addr=0x%08h → instruction=0x%08h", addr, instruction);
        if (instruction == 32'h00A00113)
            $display("  PASS\n");
        else
            $display("  FAIL: Expected 0x00A00113\n");
        
        // Test 4: Address 0x08
        addr = 32'h00000008;
        #10;
        $display("TEST 4 - Address 0x08:");
        $display("  addr=0x%08h → instruction=0x%08h", addr, instruction);
        if (instruction == 32'h002081B3)
            $display("  PASS\n");
        else
            $display("  FAIL: Expected 0x002081B3\n");
        
        // Test 5: Address 0x0C
        addr = 32'h0000000C;
        #10;
        $display("TEST 5 - Address 0x0C:");
        $display("  addr=0x%08h → instruction=0x%08h", addr, instruction);
        if (instruction == 32'h00000013)
            $display("  PASS\n");
        else
            $display("  FAIL: Expected 0x00000013\n");
        
        $display("=== All Tests Complete ===\n");
        $finish;
    end

endmodule
