`timescale 1ns/1ps

module tb;

import test_cls_pkg::*;

localparam CLK_PERIOD = 10ns;
localparam CNT_RESET_CYCLE = 10;

logic clk;
logic rstn;

localparam integer ADDER_WIDTH      = 8;
localparam integer IN_AXIS_WIDTH    = $ceil($itor(ADDER_WIDTH) / 8) * 8;
localparam integer OUT_AXIS_WIDTH   = $ceil($itor(ADDER_WIDTH+1) / 8) * 8;

AXIS_Bus #(IN_AXIS_WIDTH)   operand1_if (clk);
AXIS_Bus #(IN_AXIS_WIDTH)   operand2_if (clk);
AXIS_Bus #(OUT_AXIS_WIDTH)  result_if   (clk);

initial begin : clk_gen
    clk <= 1'b0;
    forever begin
        #(CLK_PERIOD/2);
        clk <= ~clk;
    end
end : clk_gen

initial begin : rst_gen
    rstn <= 1'b0;
    repeat (CNT_RESET_CYCLE)
        @(posedge clk);
    rstn <= 1'b1;
end : rst_gen

test_cls #(.DATA_WIDTH(ADDER_WIDTH), .AXIS_IN_WIDTH(IN_AXIS_WIDTH), .AXIS_OUT_WIDTH(OUT_AXIS_WIDTH)) test;

initial begin : stim_gen
    if ($test$plusargs("SEED")) begin
        int seed;
        $value$plusargs("SEED=%d", seed);
        $display("Simalation run with random seed = %0d", seed);
        $urandom(seed);
    end
    else
        $display("Simulation run with default random seed");

    test = new(operand1_if, operand2_if, result_if);
    @(posedge rstn);
    test.run();
end : stim_gen

adder_axis_pipe_mp #(
    .ADDER_WIDTH    (ADDER_WIDTH)
)
u_adder_axis_pipe_mp(
    .ACLK_I             (clk),
    .ARST_N             (rstn),
    .AXIS_OPERAND1_IF   (operand1_if),
    .AXIS_OPERAND2_IF   (operand2_if),
    .AXIS_RESULT_IF     (result_if)
);

initial begin : watchdog
    @(posedge rstn);
    @(posedge clk);
    $display("Transaction quantity = %4d", test.env.cfg.run_for_n_trans);
    repeat(test.env.cfg.run_for_n_trans * test.env.cfg.max_delay) @(posedge clk);
    $display("ERROR! Watchdog error!");
    $finish;
end : watchdog

endmodule
