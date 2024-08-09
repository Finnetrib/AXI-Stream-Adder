interface AXIS_Bus #(parameter DW=8) (input clk);

    logic [DW-1:0]  tdata;
    logic           tvalid;
    logic           tready;

    modport slave (
        input tdata,
        input tvalid,
        output tready
    );

    modport master (
        output tdata,
        output tvalid,
        input tready
    );

endinterface