// control.v

// The main control module takes as input the opcode field of an instruction
// (i.e., instruction[6:0]) and generates a set of control signals.

module control(
  input [6:0] opcode,

  output [1:0] jump,
  output branch,
  output mem_read,
  output mem_to_reg,
  output [1:0] alu_op,
  output mem_write,
  output alu_src,
  output reg_write
);

reg [9:0] controls;

// combinational logic
always @(*) begin
  case (opcode)
    7'b0110011: controls = 10'b00_000_10_001; // R-type
    
    //////////////////////////////////////////////////////////////////////////
    // TODO : Implement signals for other instruction types (DONE)
    //////////////////////////////////////////////////////////////////////////
    7'b0010011: controls = 10'b00_000_11_011; // I-type
    7'b0000011: controls = 10'b00_011_00_011; // L-type
    7'b0100011: controls = 10'b00_000_00_110; // S-type
    7'b1100011: controls = 10'b00_100_01_000; // B-type
    7'b1101111: controls = 10'b10_100_01_001; // Jal
    7'b1100111: controls = 10'b01_100_01_001; // Jalr
    7'b0110111: controls = 10'b00_000_00_011; // Lui
    7'b0010111: controls = 10'b00_000_00_011; // Auipc

    default:    controls = 10'b00_000_00_000;
  endcase
end

assign {jump, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = controls;

endmodule
