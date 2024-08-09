`ifndef SCOREBOARD_CLS_PKG__SV
`define SCOREBOARD_CLS_PKG__SV

package scoreboard_cls_pkg;

    import operand_item_cls_pkg::*;
    import result_item_cls_pkg::*;

    class scoreboard_cls #(parameter int DW = 4);

        mailbox #(operand_item_cls  #(.DW(DW)))     mbx_op1, mbx_op2;
        mailbox #(result_item_cls   #(.DW(DW+1)))   mbx_res;

        function new ( input mailbox #(operand_item_cls #(.DW(DW))) mbx_op1, mbx_op2, input mailbox #(result_item_cls #(.DW(DW+1))) mbx_res);
            this.mbx_op1 = mbx_op1;
            this.mbx_op2 = mbx_op2;
            this.mbx_res = mbx_res;
        endfunction : new

        task run (int count, input bit en_display = 0);
            operand_item_cls    #(.DW(DW))      operand1, operand2;
            result_item_cls     #(.DW(DW+1))    result;

            if (en_display)
                $display("[scoreboard_cls] Starting... ");

            repeat (count) begin
                fork
                    mbx_op1.get(operand1);
                    mbx_op2.get(operand2);
                join
                result = new ();
                result.m_data = operand1.m_data + operand2.m_data;
                mbx_res.put(result);
            end

        endtask : run

    endclass : scoreboard_cls

endpackage : scoreboard_cls_pkg

`endif //SCOREBOARD_CLS_PKG__SV