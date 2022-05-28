// immediate_generator.v

module immediate_generator #(
  parameter DATA_WIDTH = 32
)(
  input [DATA_WIDTH-1:0] instruction,

  output reg [DATA_WIDTH-1:0] sextimm
);

wire [6:0] opcode;
assign opcode = instruction[6:0];

always @(*) begin
  case (opcode)
    //////////////////////////////////////////////////////////////////////////
    // TODO : Generate sextimm using instruction
    //////////////////////////////////////////////////////////////////////////
    
    7'b0010011: sextimm = $signed(instruction[31:20]); // I-type
    7'b0000011: sextimm = $signed(instruction[31:20]); // L-type
    7'b0100011: sextimm = $signed({instruction[31:25], instruction[11:7]}); // S-type
    7'b1100011: sextimm = $signed({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}); // B-type
    7'b1100111: sextimm = $signed(instruction[31:20]); // J-type (I)
    7'b1101111: sextimm = $signed({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}); // J-type
    7'b0110111: sextimm = $signed({instruction[31:12], 12'b0}); // Lui
    7'b0010111: sextimm = $signed({instruction[31:12], 12'b0}); // Auipc

    default:    sextimm = 32'h0000_0000;
  endcase
end


endmodule
