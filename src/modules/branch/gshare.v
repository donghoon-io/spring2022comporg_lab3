// gshare.v

/* The Gshare predictor consists of the global branch history register (BHR)
 * and a pattern history table (PHT). Note that PC[1:0] is not used for
 * indexing.
 */

module gshare #( // LET's DO THE MATH: 32 = 22 (TAG) + 8 (BTB INDEX) + 2 (PADDING) -> 2^8=256 entries (since "Note that PC[1:0] is not used for indexing.")
  parameter DATA_WIDTH = 32,
  parameter COUNTER_WIDTH = 2,
  parameter NUM_ENTRIES = 256
) (
  input clk,
  input rstn,

  // update interface
  input update,
  input actually_taken,
  input [DATA_WIDTH-1:0] resolved_pc,

  // access interface
  input [DATA_WIDTH-1:0] pc,

  output pred
);

// DEFINITION
reg [7:0] bht;
reg [1:0] pht [255:0]; // Each entry in the PHT has a 2-bit **saturating counter**, and the number of entries in the PHT is 256 by default. Note that PC[1:0] is not used for indexing.

assign pred = (pht[bht ^ pc[9:2]] == 2'b11 || pht[bht ^ pc[9:2]] == 2'b10) ? 1'b1 : 1'b0;

// TODO: Implement gshare branch predictor
// 11 <-> 10 <-> 01 <-> 00

always @(*) begin
  if (rstn == 1'b1) begin
    if (update) begin
      // XOR into tag + pht + btb
      // BHR ^ BTB
      if (pht[bht ^ resolved_pc[9:2]] == 2'b00) begin
        pht[bht ^ resolved_pc[9:2]] = actually_taken ? 2'b01 : 2'b00;
      end
      else if (pht[bht ^ resolved_pc[9:2]] == 2'b01) begin
        pht[bht ^ resolved_pc[9:2]] = actually_taken ? 2'b10 : 2'b00;
      end
      else if (pht[bht ^ resolved_pc[9:2]] == 2'b10) begin
        pht[bht ^ resolved_pc[9:2]] = actually_taken ? 2'b11 : 2'b01;
      end
      else begin // 2'b11 -> 이러면 예외처리는 어케하누
        pht[bht ^ resolved_pc[9:2]] = actually_taken ? 2'b11 : 2'b10;
      end
      bht = {bht[6:0], actually_taken};
    end
  end
  else begin
    // Each 2-bit counter in the PHT must be initialized to  `weakly NT (01)`.
    for (integer i=0; i<256; i=i+1) begin
      pht[i] = 2'b01;
    end
    
    // All the entries in the BHR must be initialized to zero (i.e., not taken).
    bht = 8'd0;
  end
end

endmodule
