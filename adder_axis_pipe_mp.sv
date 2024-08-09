`default_nettype none

module adder_axis_pipe_mp #(
    parameter integer ADDER_WIDTH = 4                                        //! разрядность слагаемых
)(
    input wire logic    ACLK_I,
    input wire logic    ARST_N,

    AXIS_Bus.slave  AXIS_OPERAND1_IF,
    AXIS_Bus.slave  AXIS_OPERAND2_IF,
    AXIS_Bus.master AXIS_RESULT_IF
);

initial begin
    assert ($bits(AXIS_OPERAND1_IF) == $bits(AXIS_OPERAND2_IF)) else begin
        $display("%m AXIS WIDTH OPERAND1 and OPERAND2 not equal");
        $finish;
    end
end

adder_axis_pipe #(
  .ADDER_WIDTH  (ADDER_WIDTH),
  .IN_AXIS_WIDTH    ($bits(AXIS_OPERAND1_IF.tdata)),
  .OUT_AXIS_WIDTH   ($bits(AXIS_RESULT_IF.tdata))
)
u_adder_axis_pipe(
  .aclk (ACLK_I),
  .aresetn  (ARST_N),
  //! @virtualbus data1_i @dir in
  .data1_i_tdata    (AXIS_OPERAND1_IF.tdata),
  .data1_i_tvalid   (AXIS_OPERAND1_IF.tvalid),
  .data1_i_tready   (AXIS_OPERAND1_IF.tready),
  //! @virtualbus data2_i @dir in
  .data2_i_tdata    (AXIS_OPERAND2_IF.tdata),
  .data2_i_tvalid   (AXIS_OPERAND2_IF.tvalid),
  .data2_i_tready   (AXIS_OPERAND2_IF.tready),
  //! @virtualbus data_o @dir out
  .data_o_tdata     (AXIS_RESULT_IF.tdata),
  .data_o_tvalid    (AXIS_RESULT_IF.tvalid),
  .data_o_tready    (AXIS_RESULT_IF.tready)
);


endmodule

`resetall
