`ifndef MONITOR_CLS_PKG__SV
`define MONITOR_CLS_PKG__SV

package monitor_cls_pkg ;

    import result_item_cls_pkg::*;

    class monitor_cls #(parameter int DATA_WIDTH = 5, parameter int AXIS_WIDTH = 8);

        virtual AXIS_Bus    #(.DW(AXIS_WIDTH))                      vif;
        mailbox             #(result_item_cls #(.DW(DATA_WIDTH)))   mbx;

        function new (input mailbox #(result_item_cls #(.DW(DATA_WIDTH))) mbx, input virtual AXIS_Bus #(.DW(AXIS_WIDTH)) vif);
            this.vif = vif;
            this.mbx = mbx;
        endfunction : new

        task run (input int count, input int min_delay, input int max_delay, input bit en_display = 0);
            if (en_display)
                $display("[monitor_cls] Starting...");

            vif.tready <= 1'b0;

            repeat (count) begin
                result_item_cls #(.DW(DATA_WIDTH)) item = new;

                repeat ($urandom_range(min_delay, max_delay)) begin
                    @(posedge vif.clk);
                end

                vif.tready <= 1'b1;
                @(posedge vif.clk);
                while (!vif.tvalid) begin
                    @(posedge vif.clk);
                end
                item.m_data = vif.tdata;
                vif.tready <= 1'b0;

                if (en_display)
                    item.print("monitor_cls");

                mbx.put(item);
            end
        endtask : run

    endclass : monitor_cls

endpackage : monitor_cls_pkg

`endif //MONITOR_CLS_PKG__SV