`ifndef CONFIG_CLS_PKG_SV
`define CONFIG_CLS_PKG_SV

package config_cls_pkg;

    class config_cls;
        rand bit [31:0] run_for_n_trans;
        rand bit [ 7:0] min_delay;
        rand bit [ 7:0] max_delay;

        constraint reasonable {
            run_for_n_trans inside {[1:1000]};
            min_delay < max_delay;
        }
    endclass : config_cls

endpackage : config_cls_pkg

`endif //CONFIG_CLS_PKG_SV