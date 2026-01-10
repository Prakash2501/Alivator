module tb_elevator;

    reg clk, rst;
    reg req_valid;
    reg [3:0] req_new;

    wire [3:0] floor_l1;
    wire [3:0] floor_l2;

    // DUT
    elevator_system DUT (
        .clk(clk),
        .rst(rst),
        .req_valid(req_valid),
        .req_new(req_new),
        .floor_l1(floor_l1),
        .floor_l2(floor_l2)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        req_valid = 0;
        req_new = 0;

        #20 rst = 0;

        // Request 1 → Lift 1
        #10 req_new = 4; req_valid = 1;
        #10 req_valid = 0;

        // Request 2 → Lift 2
        #20 req_new = 8; req_valid = 1;
        #10 req_valid = 0;

        // Request 3 → Lift 1
        #20 req_new = 2; req_valid = 1;
        #10 req_valid = 0;

        // Request 4 → Lift 2
        #20 req_new = 6; req_valid = 1;
        #10 req_valid = 0;

        #200 $stop;
    end

endmodule
