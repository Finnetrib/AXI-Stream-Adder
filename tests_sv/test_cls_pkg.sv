`ifndef TEST_CLS_PKG__SV
`define TEST_CLS_PKG__SV

package test_cls_pkg;

    import environment_cls_pkg::*;

    class test_cls #(parameter int DATA_WIDTH = 4, parameter int AXIS_IN_WIDTH = 8, parameter int AXIS_OUT_WIDTH = 8);

        environment_cls #(.DATA_WIDTH(DATA_WIDTH), .AXIS_IN_WIDTH(AXIS_IN_WIDTH), .AXIS_OUT_WIDTH(AXIS_OUT_WIDTH)) env;

        function new( input virtual AXIS_Bus #(.DW(AXIS_IN_WIDTH)) operand1, operand2, input virtual AXIS_Bus #(.DW(AXIS_OUT_WIDTH)) result);
            env = new(operand1, operand2, result);
        endfunction

        task run ();
            env.gen_cfg();
            env.build();
            env.run();
        endtask

    endclass : test_cls

endpackage : test_cls_pkg

`endif //TEST_CLS_PKG__SV