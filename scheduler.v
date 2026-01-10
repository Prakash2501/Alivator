module scheduler_elevator (
    input clk,
    input rst,
    input [3:0] curr_l1, curr_l2,
    input req_valid,
    input [3:0] req_new,
    output reg wr_l1, wr_l2,
    output reg [3:0] din_l1, din_l2
);

    reg toggle;

    always @(posedge clk or posedge rst) begin
        if (rst)
            toggle <= 0;
        else if (req_valid)
            toggle <= ~toggle;
    end

    always @(*) begin
        wr_l1 = 0; wr_l2 = 0;
        din_l1 = 0; din_l2 = 0;

        if (req_valid) begin
            if ((req_new >= curr_l1) && (req_new < curr_l2)) begin
                wr_l1 = 1; din_l1 = req_new;
            end
            else if ((req_new >= curr_l2) && (req_new < curr_l1)) begin
                wr_l2 = 1; din_l2 = req_new;
            end
            else begin
                if (toggle) begin
                    wr_l1 = 1; din_l1 = req_new;
                end else begin
                    wr_l2 = 1; din_l2 = req_new;
                end
            end
        end
    end
endmodule
