#include "Vsf_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define CLOCK_POS \
    top->fCLK = !top->fCLK; \
    top->eval()
#define CLOCK_NEG \
    top->eval(); \
    tfp->dump(local_time++); \
    top->fCLK = !top->fCLK; \
    top->eval(); \
    tfp->dump(local_time++)
#define CLOCK_DELAY(x) \
    for (int xx=0; xx < x; xx++) { \
        top->fCLK = !top->fCLK; \
        CLOCK_NEG; \
    }

int main(int argc, char **argv) {
    int i, local_time = 0;

    Verilated::commandArgs(argc, argv);
    Vsf_top* top = new Vsf_top;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sf_top.vcd");

    CLOCK_POS;
    top->fRSTn = 0;
    top->fPUSH = 0;
    top->fPOP = 0;
    top->fD = 0;
    CLOCK_NEG;

    CLOCK_DELAY(5);

    CLOCK_POS;
    top->fRSTn = 1;
    CLOCK_NEG;

    CLOCK_DELAY(10);
    printf("Test case 1 start\n");
    int fPUSH[13] = {0, 1, 0, 1, 1, 0, 0, 0, 1, 0};
    int fPOP[13]  = {0, 0, 0, 0, 1, 1, 1, 1, 1, 1};
    int fD[13]    = {0, 0x03020100, 0, 0x07060504, 0x0b0a0908, 0, 0, 0, 0x0f0e0d0c, 0};

    for (i=0; i<13; i++) {
        CLOCK_POS;
        top->fPUSH = fPUSH[i];
        top->fPOP = fPOP[i];
        top->fD = fD[i];
        CLOCK_NEG;
    }

    CLOCK_DELAY(10);
    printf("Test case 2 start\n");

    for (i=0; i<20; i++) {
        CLOCK_POS;
        top->fPUSH = 1;
        top->fD = (i << 20) | ((i+1) << 4);
        CLOCK_NEG;
    }

    CLOCK_POS;
    top->fPUSH = 0;
    CLOCK_NEG;

    for (i=0; i<20; i++) {
        CLOCK_POS;
        top->fPOP = 1;
        CLOCK_NEG;
    }

    CLOCK_POS;
    top->fPOP = 0;
    CLOCK_NEG;

    CLOCK_DELAY(10);
    printf("Test case 3 start\n");

    /* for (i=0; i<1; i++) { */
    /*     CLOCK_POS; */
    /*     top->fPUSH = 1; */
    /*     top->fD = (i << 16) | (i+1); */
    /*     CLOCK_NEG; */
    /* } */

    for (i=1; i<30; i++) {
        CLOCK_POS;
        top->fPUSH = 1;
        top->fPOP = 1;
        top->fD = (i << 24) | ((i+1) << 8);
        CLOCK_NEG;
    }

    CLOCK_POS;
    top->fPUSH = 0;
    top->fPOP = 0;
    CLOCK_NEG;

    /* CLOCK_POS; */
    /* top->fADDR = 0x40; */
    /* top->fSTART = 1; */
    /* top->fWRITE = 0; */
    /* CLOCK_NEG; */

    /* CLOCK_POS; */
    /* top->fSTART = 0; */
    /* CLOCK_NEG; */

    /* CLOCK_POS; */
    /* top->fADDR = 0x40; */
    /* top->fSTART = 1; */
    /* top->fWRITE = 1; */
    /* CLOCK_NEG; */

    /* CLOCK_POS; */
    /* top->fSTART = 0; */
    /* top->fWRITE = 0; */
    /* CLOCK_NEG; */

    /* for (i=0; i<16; i++) { */
    /*     CLOCK_POS; */
    /*     top->fWRITE = 1; */
    /*     top->fACCESS = 1; */
    /*     top->fD = (i << 16) | (i+1); */
    /*     CLOCK_NEG; */
    /* } */

    /* CLOCK_POS; */
    /* top->fACCESS = 0; */
    /* CLOCK_NEG; */

    /* for (i=0; i<16; i++) { */
    /*     CLOCK_POS; */
    /*     top->fWRITE = 0; */
    /*     top->fACCESS = 1; */
    /*     CLOCK_NEG; */
    /* } */

    /* CLOCK_POS; */
    /* top->fACCESS = 0; */
    /* CLOCK_NEG; */

    CLOCK_DELAY(10);
    printf("Test finished\n");

    tfp->close();
    delete top;
    delete tfp;
    return 0;

}
