`ifndef ENVIRONMENT_CLS_PKG__SV
`define ENVIRONMENT_CLS_PKG__SV

package environment_cls_pkg;

    import operand_item_cls_pkg::*;
    import result_item_cls_pkg::*;
    import generator_cls_pkg::*;
    import agent_cls_pkg::*;
    import driver_cls_pkg::*;
    import monitor_cls_pkg::*;
    import scoreboard_cls_pkg::*;
    import checker_cls_pkg::*;
    import config_cls_pkg::*;

    `include "rand_check.svh"

    parameter OPERAND_QTY = 2;

    class environment_cls #(parameter int DATA_WIDTH = 4, parameter int AXIS_IN_WIDTH = 8, parameter int AXIS_OUT_WIDTH = 8);

        generator_cls   #(.DW(DATA_WIDTH))                                              gen[OPERAND_QTY-1:0];
        agent_cls       #(.DW(DATA_WIDTH))                                              agt[OPERAND_QTY-1:0];
        driver_cls      #(.DATA_WIDTH(DATA_WIDTH),      .AXIS_WIDTH(AXIS_IN_WIDTH))     drv[OPERAND_QTY-1:0];
        monitor_cls     #(.DATA_WIDTH(DATA_WIDTH+1),    .AXIS_WIDTH(AXIS_OUT_WIDTH))    mon;
        scoreboard_cls  #(.DW(DATA_WIDTH))                                              scb;
        checker_cls     #(.DW(DATA_WIDTH+1))                                            chk;
        config_cls                                                                      cfg;

        mailbox #(operand_item_cls  #(.DW(DATA_WIDTH)))     mbx_gen2agt [OPERAND_QTY-1:0];
        mailbox #(operand_item_cls  #(.DW(DATA_WIDTH)))     mbx_agt2scb [OPERAND_QTY-1:0];
        mailbox #(operand_item_cls  #(.DW(DATA_WIDTH)))     mbx_agt2drv [OPERAND_QTY-1:0];
        mailbox #(result_item_cls   #(.DW(DATA_WIDTH+1)))   mbx_scb2chk;
        mailbox #(result_item_cls   #(.DW(DATA_WIDTH+1)))   mbx_mon2chk;

        virtual AXIS_Bus #(.DW(AXIS_IN_WIDTH))  operand1;
        virtual AXIS_Bus #(.DW(AXIS_IN_WIDTH))  operand2;
        virtual AXIS_Bus #(.DW(AXIS_OUT_WIDTH)) result;

        function new( input virtual AXIS_Bus #(.DW(AXIS_IN_WIDTH)) operand1, operand2, input virtual AXIS_Bus #(.DW(AXIS_OUT_WIDTH)) result);
            cfg             = new();
            this.operand1   = operand1;
            this.operand2   = operand2;
            this.result     = result;
        endfunction

        function void gen_cfg();
             `SV_RAND_CHECK(cfg.randomize());
        endfunction : gen_cfg

        function void build();
            for (int i = 0; i < OPERAND_QTY; i++) begin
                mbx_gen2agt[i] = new(1);
                mbx_agt2scb[i] = new(1);
                mbx_agt2drv[i] = new(1);
            end
            mbx_scb2chk = new(1);
            mbx_mon2chk = new(1);

            for (int i = 0; i < OPERAND_QTY; i++) begin
                gen[i] = new(.mbx(mbx_gen2agt[i]));
                agt[i] = new(.gen2agt(mbx_gen2agt[i]), .agt2drv(mbx_agt2drv[i]), .agt2scb(mbx_agt2scb[i]));
            end

            drv[0] = new(.mbx(mbx_agt2drv[0]), .vif(operand1));
            drv[1] = new(.mbx(mbx_agt2drv[1]), .vif(operand2));

            mon = new(.mbx(mbx_mon2chk), .vif(result));

            scb = new(.mbx_op1(mbx_agt2scb[0]), .mbx_op2(mbx_agt2scb[1]), .mbx_res(mbx_scb2chk));
            chk = new(.mbx_res_sc(mbx_scb2chk), .mbx_res_mon(mbx_mon2chk));
        endfunction : build

        task run();
            fork
                gen[0].run(cfg.run_for_n_trans);
                gen[1].run(cfg.run_for_n_trans);
                agt[0].run();
                agt[1].run();
                drv[0].run(cfg.run_for_n_trans, cfg.min_delay, cfg.max_delay);
                drv[1].run(cfg.run_for_n_trans, cfg.min_delay, cfg.max_delay);
                mon.run(cfg.run_for_n_trans, cfg.min_delay, cfg.max_delay);
                scb.run(cfg.run_for_n_trans);
                chk.run(cfg.run_for_n_trans);
            join
        endtask : run

    endclass : environment_cls

endpackage : environment_cls_pkg

`endif //ENVIRONMENT_CLS_PKG__SV