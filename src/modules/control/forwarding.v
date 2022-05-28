// forwarding.v
//이상 무
//ppt에 따르면 순서 반대라 이걸 따라주는게 좋을듯..? 너무 자의적으로 해버림..

// This module determines if the values need to be forwarded to the EX stage.

// TODO: declare propoer input and output ports and implement the
// forwarding unit

module forwarding (
  // input data_spec name
  input [4:0] ex_rs1, ex_rs2, mem_rd, wb_rd,
  input mem_reg_write, wb_reg_write,

  // output data_spec name
  output reg [1:0] forward_a, forward_b
);

// forward_a implementation
always @(*) begin
    if ((ex_rs1 != 5'b00000) && (ex_rs1 == mem_rd) && mem_reg_write) forward_a = 2'b10;
    else if ((ex_rs1 != 5'b00000) && (ex_rs1 == wb_rd) && wb_reg_write) forward_a = 2'b01;
    else forward_a = 2'b00;
end

// forward_b implementation
always @(*) begin
    if ((ex_rs2 != 5'b00000) && (ex_rs2 == mem_rd) && mem_reg_write) forward_b = 2'b10;
    else if ((ex_rs2 != 5'b00000) && (ex_rs2 == wb_rd) && wb_reg_write) forward_b = 2'b01;
    else forward_b = 2'b00;
end

endmodule