// -----------------------------------------------------------------------------
// File Name: sf_top.sv
// Description:
//     Top module integrating two-port synchronous memory model and the FIFO
//     interface block.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 2024-12-19
// -----------------------------------------------------------------------------

module sf_top #(
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
    output             fFULL
);

    logic             we;
    logic [   Aw-1:0] waddr;
    logic [Width-1:0] wdata;
    logic             re;
    logic [   Aw-1:0] raddr;
    logic [Width-1:0] rdata;

    sf_interface #(
        .Width (Width),
        .Depth (Depth)
    ) inst_sf_interface (
        .fCLK    (fCLK),
        .fRSTn   (fRSTn),
        .fPUSH   (fPUSH),
        .fPOP    (fPOP),
        .fD      (fD),
        .fQ      (fQ),
        .fVALID  (fVALID),
        .fEMPTY  (fEMPTY),
        .fFULL   (fFULL),

        .we_o    (we),
        .waddr_o (waddr),
        .wdata_o (wdata),

        .re_o    (re),
        .raddr_o (raddr),
        .rdata_i (rdata)
    );

    ram_two_sync #(
        .Width (Width),
        .Depth (Depth)
    ) inst_mem (
        .clk_i   (fCLK),

        .we_i    (we),
        .waddr_i (waddr),
        .wdata_i (wdata),

        .re_i    (re),
        .raddr_i (raddr),
        .rdata_o (rdata)
    );

endmodule
