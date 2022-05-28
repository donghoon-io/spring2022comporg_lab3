// branch_target_buffer.v

/* The branch target buffer (BTB) stores the branch target address for
 * a branch PC. Our BTB is essentially a direct-mapped cache.
 */

module branch_target_buffer #( // LET's DO THE MATH: 32 = 22 (TAG) + 8 (BTB INDEX) + 2 (PADDING) -> 2^8=256 entries
  parameter DATA_WIDTH = 32,
  parameter NUM_ENTRIES = 256
) (
  input clk,
  input rstn,

  // update interface
  input update,                              // when 'update' is true, we update the BTB entry
  input [DATA_WIDTH-1:0] resolved_pc,
  input [DATA_WIDTH-1:0] resolved_pc_target,

  // access interface
  input [DATA_WIDTH-1:0] pc,

  output hit,
  output [DATA_WIDTH-1:0] target_address
);


// Each entry in the BTB consists of a `valid` bit, `tag` bits, and a 32-bit `branch target` address. The number of entries in the BTB is 256 by default. 
reg [255:0] valid;
reg [21:0] tag [255:0];
reg [31:0] branch_target_address [255:0];

// ASSIGNED HIT & TARGET_ADDRESS

assign hit = valid[pc[9:2]] && (tag[pc[9:2]] == pc[31:10]); // change
assign target_address = branch_target_address[pc[9:2]];

// TODO: Implement BTB

always @(*) begin
  // UPDATING BTB
  if (rstn == 1'b1) begin
    if (update) begin
      valid[resolved_pc[9:2]] = 1'b1;
      tag[resolved_pc[9:2]] = resolved_pc[31:10];
      branch_target_address[resolved_pc[9:2]] = resolved_pc_target;
    end
  end
  // INITIALIZATION: For an active low reset, all the entries in the BTB must be invalid (0).
  else begin
    valid = 256'b0;
  end
end

endmodule
