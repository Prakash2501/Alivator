module elevator_fsm (
    input clk,
    input rst,
    input fifo_empty,
    input [3:0] fifo_dout,
    output reg fifo_rd,
    output reg [3:0] floor,
    output reg [1:0] dir,      // 00=UP,01=DOWN,11=IDLE
    output reg door
);

    reg [3:0] target;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            floor <= 0;
            dir   <= 2'b11;
            door  <= 0;
            fifo_rd <= 0;
            target <= 0;
        end else begin

            fifo_rd <= 0;
            door <= 0;

            // Fetch new target ONLY when IDLE
            if (dir == 2'b11 && !fifo_empty) begin
                fifo_rd <= 1;
                target <= fifo_dout;

                if (fifo_dout > floor)
                    dir <= 2'b00;
                else if (fifo_dout < floor)
                    dir <= 2'b01;
            end

            // MOVE UP
            else if (dir == 2'b00) begin
                if (floor < target)
                    floor <= floor + 1;
                else begin
                    door <= 1;
                    if (!fifo_empty)
                        fifo_rd <= 1;   // continue UP (LOOK)
                    else
                        dir <= 2'b11;   // reverse later
                end
            end

            // MOVE DOWN
            else if (dir == 2'b01) begin
                if (floor > target)
                    floor <= floor - 1;
                else begin
                    door <= 1;
                    if (!fifo_empty)
                        fifo_rd <= 1;
                    else
                        dir <= 2'b11;
                end
            end
        end
    end
endmodule
