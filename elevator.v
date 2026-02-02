module elevator_system (
    input clk,
    input rst,
    input req_valid,
    input [3:0] req_new,
    output [3:0] floor_l1,
    output [3:0] floor_l2
);

    // Scheduler outputs
    wire wr1, wr2;
    wire [3:0] din1, din2;

    // FIFO signals
    wire empty1, empty2;
    wire [3:0] dout1, dout2;
    wire rd1, rd2;

    // Scheduler
    scheduler_elevator SCH (
        clk, rst,
        floor_l1, floor_l2,
        req_valid, req_new,
        wr1, wr2,
        din1, din2
    );

    // FIFO for Lift-1
    fifo_elevator F1 (
        clk, rst,
        wr1, rd1,
        din1,
        dout1,
        empty1
    );

    // FIFO for Lift-2
    fifo_elevator F2 (
        clk, rst,
        wr2, rd2,
        din2,
        dout2,
        empty2
    );

    // Elevator FSMs
    elevator_fsm L1 (
        clk, rst,
        empty1,
        dout1,
        rd1,
        floor_l1
    );

    elevator_fsm L2 (
        clk, rst,
        empty2,
        dout2,
        rd2,
        floor_l2
    );

endmodule

