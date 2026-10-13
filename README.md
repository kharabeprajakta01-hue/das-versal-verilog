# DAS on Versal — High-Speed Data Processing in Verilog

> **DAS** — high-speed data processing, targeting **AMD/Xilinx Versal**, with the **DAS algorithm implemented in Verilog**.

## Project Overview
| Item | Description |
|------|-------------|
| **Topic** | DAS |
| **Goal** | High-speed data processing |
| **Target platform** | Versal |
| **Algorithm** | DAS algorithm (Delay-And-Sum) |
| **Approach** | Simple implementation |
| **Language** | Verilog (HDL) |
| **Learning resource** | [HDLBits](https://hdlbits.01xz.net) for Verilog practice |

## Roadmap (from project notes)
- [x] High-speed data processing core
- [ ] Targeting **Versal**: synthesis, timing closure, board bring-up
- [x] **DAS algorithm** (simple, parameterizable)
- [x] **Implementation in Verilog**
- [ ] Verilog **on Versal** (Vivado project + constraints)
- [ ] Practice/reference Verilog blocks from **HDLBits**

## Architecture
```
 in_data[N_CH] ──► [delay line ch0] ─┐
                   [delay line ch1] ─┤
                   [   ...        ] ─┼─► Σ (adder) ─► out_data
                   [delay line chN] ─┘
        in_delays[N_CH] programs each channel's delay
```

## Repository Structure
```
rtl/           das_top.v, das_channel_delay.v
tb/            das_tb.v (testbench)
constraints/   das_versal.xdc
docs/          notes
Makefile       simulation (Icarus Verilog)
```

## Run Simulation
```bash
make sim
gtkwave das.vcd   # optional
```

## Build for Versal (Vivado)
1. Create a new Vivado project and select your Versal device/board.
2. Add `rtl/*.v` as design sources and `constraints/das_versal.xdc` as constraints.
3. Set `das_top` as top, then run Synthesis → Implementation → Device Image.

## Parameters
| Parameter | Default | Meaning |
|-----------|---------|---------|
| `N_CH` | 8 | Number of input channels |
| `DATA_W` | 16 | Sample width (signed) |
| `MAX_DELAY` | 256 | Max delay in samples |

## Future Work
- Pipelined adder tree for higher Fmax
- Streaming AXI4-Stream interface
- Use Versal AI Engines / NoC for higher throughput

## License
MIT
