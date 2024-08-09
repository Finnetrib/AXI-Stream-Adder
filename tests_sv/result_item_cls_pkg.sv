`ifndef RESULT_ITEM_CLS_PKG__SV
`define RESULT_ITEM_CLS_PKG__SV

package result_item_cls_pkg;

    class result_item_cls #(parameter int DW = 5);

        bit [DW-1:0] m_data;

        function void print(string tag = "");
            $display("[%s] Item value = 0x%0h", tag, m_data);
        endfunction : print

    endclass : result_item_cls

endpackage : result_item_cls_pkg

`endif //RESULT_ITEM_CLS_PKG__SV