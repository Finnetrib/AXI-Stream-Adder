`ifndef DRIVER_CLS_PKG__SV
`define DRIVER_CLS_PKG__SV

package driver_cls_pkg;

    import operand_item_cls_pkg::*;

    class driver_cls #(parameter int DATA_WIDTH = 4, parameter int AXIS_WIDTH = 8);

        virtual AXIS_Bus    #(.DW(AXIS_WIDTH))                      vif;
        mailbox             #(operand_item_cls #(.DW(DATA_WIDTH)))  mbx;
        operand_item_cls    #(.DW(DATA_WIDTH))                      item;

        function new (input mailbox #(operand_item_cls #(.DW(DATA_WIDTH))) mbx, input virtual AXIS_Bus #(.DW(AXIS_WIDTH)) vif);
            this.mbx = mbx;
            this.vif = vif;
        endfunction : new

        task run (input int count, input int min_delay, input int max_delay, input bit en_display = 0);

            if (en_display)
                $display("[driver_cls] Starting...");

            vif.tvalid <= 1'b0;

            repeat (count) begin
                if (en_display)
                    $display("[driver_cls][ Waiting for item...");

                mbx.get(item);
                if (en_display)
                    item.print("driver_cls");

                repeat ($urandom_range(min_delay, max_delay)) begin
                    @(posedge vif.clk);
                end
                vif.tdata <= item.m_data;
                vif.tvalid <= 1'b1;
                @(posedge vif.clk);
                while (!vif.tready) begin
                    @(posedge vif.clk);
                end
                vif.tvalid <= 1'b0;

                if (en_display)
                    $display("[driver_cls] Item sended...");
            end

        endtask : run

    endclass : driver_cls

endpackage : driver_cls_pkg

`endif //DRIVER_CLS_PKG__SV