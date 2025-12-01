
module memory (
    input  wire        clk,
    input  wire        rst,
    // 8+8+3+8+1+1 = 29 bits of memory
    input  wire [28:0] data_in,
    input  wire        write_en,
    input  wire [04:0] read_addr,
    input  wire        read_addr_en,
    output wire [28:0] data_out,
    output wire [04:0] maxfilled_addr
);

reg [28:0] register [31:0];
reg [04:0] cur_addr;

integer i;

always @ (posedge clk or negedge rst) begin
    if (!rst) begin
        for (i=0; i<32; i=i+1) begin
            register[i] <= 0;
            cur_addr <= 0;
        end
    end
    else begin
        if (write_en) begin
            register[cur_addr] <= data_in;
            cur_addr <= cur_addr + 1;
        end
    end
end

assign data_out = (!rst)         ? 29'd0 :
                  (read_addr_en) ? register[read_addr] : register[cur_addr - 1];
                  
assign maxfilled_addr = cur_addr - 1;
endmodule