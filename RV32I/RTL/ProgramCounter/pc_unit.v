`timescale 1ns/1ps


module pc_unit(
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,			//pc_src = 0  →  Next PC = PC + 4      (normal, go to next instruction)
                                                //pc_src = 1  →  Next PC = branch_target (jump to new address)
    input  wire        pc_src,			
    input  wire [31:0] branch_target,		// next instruction address
    output reg  [31:0] pc,			// present address
    output wire [31:0] pc_plus_4 		// just pc + 4
);
    assign pc_plus_4 = pc + 4;
    
    always @(posedge clk or posedge reset) begin
    	if(reset) begin
    		pc <= 32'h00000000;
    	end
    	
    	else if (stall) begin
    		pc <= pc;
    	end
    	
    	else if (pc_src) begin
    		pc <= branch_target;   	
    	end
    	
    	else begin
    		pc <= pc_plus_4;
    	
    	end
    end

endmodule

/*
                    ┌─────────────────────────────────────┐
                    │            PC UNIT                  │
                    │                                     │
    reset ─────────►│  ┌───────────┐                      │
                    │  │           │                      │
    clk ───────────►│  │    PC     │────────────────────► ├──── pc[31:0]
                    │  │  Register │                      │
    stall ─────────►│  │           │      ┌─────────┐     │
                    │  └─────┬─────┘      │  Adder  │     │
                    │        │            │  (+4)   │───► ├──── pc_plus_4[31:0]
                    │        │            └────┬────┘     │
                    │        │                 │          │
                    │        ▼                 │          │
                    │     ┌─────┐              │          │
    pc_src ────────►│     │ MUX │◄─────────────┘          │
                    │     └──┬──┘                         │
                    │        ▲                            │
    branch_target ─►│        │                            │
                    │        │                            │
                    └────────┴────────────────────────────┘

*/
