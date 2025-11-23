`timescale 1ns/1ps

module tb_pc_unit;

    // Inputs
    reg        clk;
    reg        reset;
    reg        stall;
    reg        pc_src;
    reg [31:0] branch_target;
    
    // Outputs
    wire [31:0] pc;
    wire [31:0] pc_plus_4;
    
    // Instantiate PC Unit
    pc_unit uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .pc_src(pc_src),
        .branch_target(branch_target),
        .pc(pc),
        .pc_plus_4(pc_plus_4)
    );
    
    // Clock generation: 10ns period
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        // Setup waveform dump
        $dumpfile("pc_unit_wave.vcd");
        $dumpvars(0, tb_pc_unit);
        
        // Initialize
        clk = 0;
        reset = 0;
        stall = 0;
        pc_src = 0;
        branch_target = 32'h0;
        
        // ========== TEST 1: Reset ==========
        $display("\n=== TEST 1: Reset ===");
        reset = 1;
        #10;
        reset = 0;
        
        if (pc == 32'h0)
            $display("PASS: PC = 0x%08h after reset", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x00000000", pc);
        
        // ========== TEST 2: Normal Increment ==========
        $display("\n=== TEST 2: Normal Increment ===");
        
        #10; // One clock cycle
        if (pc == 32'h4)
            $display("PASS: PC = 0x%08h (incremented to 4)", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x00000004", pc);
            
        #10; // Another clock cycle
        if (pc == 32'h8)
            $display("PASS: PC = 0x%08h (incremented to 8)", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x00000008", pc);
            
        #10; // Another clock cycle
        if (pc == 32'hC)
            $display("PASS: PC = 0x%08h (incremented to C)", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x0000000C", pc);
        
        // ========== TEST 3: Stall ==========
        $display("\n=== TEST 3: Stall ===");
        stall = 1;
        #10;
        
        if (pc == 32'hC)
            $display("PASS: PC = 0x%08h (held during stall)", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x0000000C", pc);
        
        #10; // Still stalled
        if (pc == 32'hC)
            $display("PASS: PC = 0x%08h (still held)", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x0000000C", pc);
        
        stall = 0;
        
        // ========== TEST 4: Branch ==========
        $display("\n=== TEST 4: Branch ===");
        #10; // PC should increment first
        
        pc_src = 1;
        branch_target = 32'h00000100;
        #10;
        
        if (pc == 32'h100)
            $display("PASS: PC = 0x%08h (branched to target)", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x00000100", pc);
        
        pc_src = 0;
        
        // ========== TEST 5: Continue after branch ==========
        $display("\n=== TEST 5: Continue after branch ===");
        #10;
        
        if (pc == 32'h104)
            $display("PASS: PC = 0x%08h (incremented from branch target)", pc);
        else
            $display("FAIL: PC = 0x%08h, expected 0x00000104", pc);
        
        // ========== TEST 6: PC + 4 Output ==========
        $display("\n=== TEST 6: PC + 4 Output ===");
        
        if (pc_plus_4 == pc + 4)
            $display("PASS: pc_plus_4 = 0x%08h (correct)", pc_plus_4);
        else
            $display("FAIL: pc_plus_4 = 0x%08h, expected 0x%08h", pc_plus_4, pc + 4);
        
        // ========== SUMMARY ==========
        $display("\n=== ALL TESTS COMPLETE ===\n");
        
        #20;
        $finish;
    end
    
    // Monitor PC changes
    always @(posedge clk) begin
        $display("Time=%0t: PC=0x%08h, PC+4=0x%08h, stall=%b, pc_src=%b", 
                 $time, pc, pc_plus_4, stall, pc_src);
    end

endmodule
