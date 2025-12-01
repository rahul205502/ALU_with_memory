# 💾 ALU with Synchronous Memory Trace System

## Project Description

This project implements a fundamental computing unit by integrating an **8-bit Arithmetic Logic Unit (ALU)** with a **32-word synchronous memory block**. The purpose of this integrated system is to execute ALU operations and record a complete, time-stamped trace of the inputs, operation, result, and status flags into memory.

This design serves as a foundational example for implementing instruction tracing and debugging features in compact, custom VLSI/FPGA processor architectures. The system is modeled in **Verilog HDL**.

---

## ⚙️ Top-Level Architecture (`top_module.v`)

The `top_module` serves as the system's datapath, connecting the combinational execution unit (`alu1`) to the sequential storage unit (`m1`). The ALU's results and the entire context of the operation are concatenated to form a single **29-bit trace record** written into memory.

### 29-bit Data Bus Composition

The `data_in` signal to the memory unit is a concatenation of all relevant signals, defining the format of the stored trace:

| Bit Range | Signal | Width | Description |
| :--- | :--- | :--- | :--- |
| `[28:21]` | A | 8 bits | Operand A (Input) |
| `[20:13]` | B | 8 bits | Operand B (Input) |
| `[12:10]` | `opcode` | 3 bits | ALU Operation Code |
| `[9:2]` | Y | 8 bits | ALU Result |
| `[1]` | C | 1 bit | Carry/Borrow Flag |
| `[0]` | `zero_flag` | 1 bit | Zero Flag |
| **Total** | - | **29 bits** | Full operation record |

---

## Component 1: Arithmetic Logic Unit (ALU) (`ALU.v`)

The ALU is a combinational circuit designed to perform 8 distinct 8-bit operations.

### ALU Functionality

| Opcode | Operation | Description |
| :--- | :--- | :--- |
| $3'b000$ | ADD | $Y=A+B$. Sets C to the Carry-out bit. |
| $3'b001$ | SUB | $Y=A-B$. Sets C to the Borrow-out bit. |
| $3'b010$ | AND | $Y=A$ & B (Bitwise AND). C is 0. |
| $3'b011$ | OR | $Y=A$ $\mid$ B (Bitwise OR). C is 0. |
| $3'b100$ | NOT | $Y=\sim A$ (Bitwise NOT, B is ignored). C is 0. |
| $3'b101$ | XOR | $Y=A\wedge B$ (Bitwise XOR). C is 0. |
| $3'b110$ | SLL | $Y=A<<B$ (Logical Shift Left). C is 0. |
| $3'b111$ | SRL | $Y=A>>B$ (Logical Shift Right). C is 0. |

### Status Flags

* **C (Carry/Borrow):** Captured using the concatenation $(\text{C, Y})$ for arithmetic operations.
* **zero\_flag:** Asserted if the entire 9-bit result $(\{\text{C}, \text{Y}\})$ is zero.

---

## Component 2: Synchronous Memory (`memory.v`)

The memory module implements a $32 \times 29$-bit synchronous memory, functioning as a sequential trace recorder.

### Write Logic (Sequential Access)

* **Trigger:** Writing occurs only on the positive edge of the clock (`posedge clk`) when the `write_en` signal is high.
* **Address Management:** The internal pointer, `cur_addr` (Next Write Address), automatically increments after a successful write operation.
* **Reset:** The memory contents and `cur_addr` are cleared when `rst` is low (`negedge rst`).

### Read Logic (Combinational Access)

The read operation is asynchronous (combinational):

* If `read_addr_en` is high, the output is from the specific address given by `read_addr`.
* If `read_addr_en` is low, the output is the data from the last written address (`cur_addr - 1`).
* `max
