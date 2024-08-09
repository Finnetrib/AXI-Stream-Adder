`ifndef GENERATOR_CLS_PKG__SV
`define GENERATOR_CLS_PKG__SV

package generator_cls_pkg;

    `include "rand_check.svh"

    import operand_item_cls_pkg::*;

    class generator_cls #(parameter int DW = 4);

        operand_item_cls    #(.DW(DW))                      item;
        mailbox             #(operand_item_cls #(.DW(DW)))  mbx;

        function new (input mailbox #(operand_item_cls #(.DW(DW))) mbx);
            this.mbx = mbx;
        endfunction : new

        task run (input int count);
            repeat (count) begin
                item = new();
                `SV_RAND_CHECK(item.randomize());
                mbx.put(item);
            end
        endtask : run

    endclass : generator_cls

endpackage : generator_cls_pkg

`endif //GENERATOR_CLS_PKG__SV