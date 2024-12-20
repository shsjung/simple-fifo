// -----------------------------------------------------------------------------
// File Name: sf_interface.sv
// Description:
//     A memory interface for FIFO. This module generates signals to interact
//     with the memory module, ensuring proper read and write operations.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 2024-12-19
// -----------------------------------------------------------------------------

`define SIM_LOG

module sf_interface #(
    parameter  int Width = 32,
    parameter  int Depth = 16,
    localparam int Aw    = $clog2(Depth)
) (
    input              fCLK,
    input              fRSTn,
    input              fPUSH,
    input              fPOP,
    input  [Width-1:0] fD,
    output [Width-1:0] fQ,
    output             fVALID,
    output             fEMPTY,
    output             fFULL,

    output             we_o,
    output [   Aw-1:0] waddr_o,
    output [Width-1:0] wdata_o,

    output             re_o,
    output [   Aw-1:0] raddr_o,
    input  [Width-1:0] rdata_i
);

    logic [Aw-1:0] raddr, waddr;
    logic qvalid;
    logic full;

    always_ff @(posedge fCLK or negedge fRSTn) begin
        if (!fRSTn) begin
            raddr <= 'h0;
        end else if (fPOP & ~fEMPTY) begin
            raddr <= raddr + 'h1;
`ifdef SIM_LOG
        end else if (fPOP & fEMPTY) begin
            $display("sf_interface: POP fail");
`endif
        end
    end

    always_ff @(posedge fCLK or negedge fRSTn) begin
        if (!fRSTn) begin
            waddr <= 'h0;
        end else if (fPUSH & ~fFULL) begin
            waddr <= waddr + 'h1;
`ifdef SIM_LOG
        end else if (fPUSH & fFULL) begin
            $display("sf_interface: PUSH fail");
`endif
        end
    end

    always_ff @(posedge fCLK or negedge fRSTn) begin
        if (!fRSTn) begin
            qvalid <= 1'b0;
        end else if (fPOP & ~fEMPTY) begin
            qvalid <= 1'b1;
        end else begin
            qvalid <= 1'b0;
        end
    end

    always_ff @(posedge fCLK or negedge fRSTn) begin
        if (!fRSTn) begin
            full <= 1'b0;
        end else if ((waddr == raddr - 'h1) && fPUSH && ~fPOP) begin
            full <= 1'b1;
        end else if (fPOP) begin
            full <= 1'b0;
        end
    end

    assign we_o = fPUSH & ~fFULL;
    assign waddr_o = waddr;
    assign wdata_o = fD;

    assign re_o = fPOP & ~fEMPTY;
    assign raddr_o = raddr;

    assign fQ = rdata_i;
    assign fVALID = qvalid;

    assign fEMPTY = (raddr == waddr) ? ~full : 1'b0;
    assign fFULL = full;

endmodule
