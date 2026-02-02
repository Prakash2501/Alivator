module fifo_elevator (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [3:0] din,
    output reg [3:0] dout,
    output reg empty
);

    reg [3:0] mem [0:7];
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            empty  <= 1;
            dout   <= 0;
        end else begin
            if (wr_en && count < 8) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end

            if (rd_en && count > 0) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end

            empty <= (count == 0);
        end
    end
endmodule
