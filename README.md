# Simple FIFO

FIFO (First-In, First-Out) buffers are widely used in hardware design. Depending on whether the input clock and output clock are the same, FIFOs are classified as either synchronous or asynchronous. Synchronous FIFOs are simpler in structure since they do not require clock domain crossing. This makes them easier to develop and applicable to various applications.

In this project, a simple synchronous FIFO that includes a two-port synchronous RAM is implemented. The two-port synchronous RAM model is based on an existing design available on [this repository](https://github.com/shsjung/memory-model).

## File Structure

- `rtl/`
  - `ram_two_sync.sv`: Single-port RAM
  - `sf_interface.sv`: Simple FIFO interface
  - `sf_top.sv`: Top module that instantiates the memory model and FIFO interface
- `wavedrom/`: Waveform diagrams
- `obj_dir/`: Directory containing object files and executables generated during Verilator simulation
- `tb.cpp`: Testbench top-level file
- `Makefile`: Makefile script to run the testbench
- `README.md`: Project documentation
- `LICENSE`: License information

## Running the Testbench

The provided testbench is designed for simulation using Verilator. Ensure Verilator is installed before running the testbench. Refer to the [Verilator GitHub page](https://github.com/verilator/verilator) for installation instructions.

1. Clone this repository:

   ```bash
   git clone https://github.com/shsjung/simple-fifo.git
   ```

2. Navigate to the `simple-fifo` directory and run the following command:

   ```bash
   make
   ```

## Example Waveforms

![Simple FIFO Waveform](https://svg.wavedrom.com/github/shsjung/simple-fifo/main/wavedrom/sf_test_0.json)

## License

This project is distributed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a Pull Request if you'd like to contribute to this project.
