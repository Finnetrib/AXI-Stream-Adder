`ifndef CHECKER_CLS_PKG__SV
`define CHECKER_CLS_PKG__SV

package checker_cls_pkg;

    import result_item_cls_pkg::*;

    class checker_cls #(parameter int DW = 5);

        mailbox #(result_item_cls #(.DW(DW))) mbx_res_sc, mbx_res_mon;

        int count_good;
        int count_bad;

        function new ( input mailbox #(result_item_cls #(.DW(DW))) mbx_res_sc, mbx_res_mon);
            this.mbx_res_sc = mbx_res_sc;
            this.mbx_res_mon = mbx_res_mon;
            count_good = 0;
            count_bad = 0;
        endfunction : new

        task run (int count, input bit en_display = 0);
            result_item_cls     #(.DW(DW))    result_sc, result_mon;

            if (en_display)
                $display("[checker_cls] Starting... ");

            repeat (count) begin
                fork
                    mbx_res_sc.get(result_sc);
                    mbx_res_mon.get(result_mon);
                join

                if (result_sc.m_data == result_mon.m_data) begin
                    count_good++;
                end
                else begin
                    count_bad++;
                end
            end

            if (count_bad != 0) begin
                $display("[checker_cls] Fail!");
                $finish;
            end
            else if (count_good == count) begin
                $display("[checker_cls] Pass!");
                $finish;
            end

        endtask : run

    endclass : checker_cls

endpackage : checker_cls_pkg

`endif //CHECKER_CLS_PKG__SV