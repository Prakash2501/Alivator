module scheduler_elevator (
    input clk,
    input rst,
    input [3:0] curr_l1, curr_l2,
    input [1:0] dir_l1, dir_l2,
    input req_valid,
    input [3:0] req_new,
    output reg wr_l1, wr_l2,
    output reg [3:0] din_l1, din_l2
);

    reg toggle;
    reg [3:0] dist_l1, dist_l2;
    reg ok_l1, ok_l2;

    // fairness toggle
    always @(posedge clk or posedge rst) begin
        if (rst)
            toggle <= 0;
        else if (req_valid)
            toggle <= ~toggle;
    end

    always @(*) begin
        wr_l1 = 0; wr_l2 = 0;
        din_l1 = 0; din_l2 = 0;

        // distance
        dist_l1 = (curr_l1 > req_new) ? (curr_l1 - req_new) : (req_new - curr_l1);
        dist_l2 = (curr_l2 > req_new) ? (curr_l2 - req_new) : (req_new - curr_l2);

        // direction compatibility
        ok_l1 = (dir_l1 == 2'b11) ||
                (dir_l1 == 2'b00 && req_new >= curr_l1) ||
                (dir_l1 == 2'b01 && req_new <= curr_l1);

        ok_l2 = (dir_l2 == 2'b11) ||
                (dir_l2 == 2'b00 && req_new >= curr_l2) ||
                (dir_l2 == 2'b01 && req_new <= curr_l2);

        if (req_valid) begin
            // both compatible → choose nearest
            if (ok_l1 && ok_l2) begin
                if (dist_l1 < dist_l2) begin
                    wr_l1 = 1; din_l1 = req_new;
                end else if (dist_l2 < dist_l1) begin
                    wr_l2 = 1; din_l2 = req_new;
                end else begin
                    if (toggle) begin
                        wr_l1 = 1; din_l1 = req_new;
                    end else begin
                        wr_l2 = 1; din_l2 = req_new;
                    end
                end
            end
            // only lift-1 compatible
            else if (ok_l1) begin
                wr_l1 = 1; din_l1 = req_new;
            end
            // only lift-2 compatible
            else if (ok_l2) begin
                wr_l2 = 1; din_l2 = req_new;
            end
            // none compatible → IDLE first
            else begin
                if (dir_l1 == 2'b11) begin
                    wr_l1 = 1; din_l1 = req_new;
                end else begin
                    wr_l2 = 1; din_l2 = req_new;
                end
            end
        end
    end
endmodule
