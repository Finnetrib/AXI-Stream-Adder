`ifndef AGENT_CLS_PKG__SV
`define AGENT_CLS_PKG__SV

package agent_cls_pkg;

    import operand_item_cls_pkg::*;

    class agent_cls #(parameter int DW = 4);

        mailbox             #(operand_item_cls #(.DW(DW)))  gen2agt, agt2drv, agt2scb;
        operand_item_cls    #(.DW(DW))                      item;

        function new(input mailbox #(operand_item_cls #(.DW(DW))) gen2agt, agt2drv, agt2scb);
            this.gen2agt = gen2agt;
            this.agt2drv = agt2drv;
            this.agt2scb = agt2scb;
        endfunction : new

        task run();
            forever begin
                gen2agt.get(item);
                agt2scb.put(item);
                agt2drv.put(item);
            end
        endtask : run

    endclass : agent_cls

endpackage : agent_cls_pkg

`endif //AGENT_CLS_PKG__SV