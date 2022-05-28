// hazard.v

// This module determines if pipeline stalls or flushing are required

// TODO: declare propoer input and output ports and implement the
// hazard detection unit

module hazard #(parameter DATA_WIDTH = 32)( // DISCLAIMER: 
    // stall = {(rs1_id == rd_ex && use_rs1(ir_id)) || (rs2_id == rd_ex && use_rs2(ir_id))} && memread_ex

    // inputs for stall detection as follows
    input [DATA_WIDTH-1:0] id_instruction,
    input ex_mem_read, taken,
    input [4:0] ex_rd,

    
    output flush, stall
);

reg flush;
reg stall;

always @(*) begin
    // stall = {(rs1_id == rd_ex && use_rs1(ir_id)) || (rs2_id == rd_ex && use_rs2(ir_id))} && memread_ex;
    stall = ((id_instruction[19:15] == ex_rd && id_instruction[19:15] != 5'b00000) || (id_instruction[24:20] == ex_rd && id_instruction[24:20] != 5'b00000)) && ex_mem_read;

    // flush = taken;
    flush = taken ? !stall : 0; // stall이 더 중요해?서 이렇게 해줘야하나 헷갈림
    // 찾아보니 맞는듯?
end

endmodule
