`ifndef OPERAND_ITEM_CLS_PKG__SV
`define OPERAND_ITEM_CLS_PKG__SV

package operand_item_cls_pkg;

    class operand_item_cls #(parameter int DW = 4);

        rand bit [DW-1:0] m_data;

        function void print(string tag = "");
            $display("[%s] Item value = 0x%0h", tag, m_data);
        endfunction : print

    endclass : operand_item_cls

endpackage : operand_item_cls_pkg

`endif //OPERAND_ITEM_CLS_PKG__SV