# 📦 Synchronous FIFO – Verilog HDL Project
This project implements a **Synchronous FIFO (First-In-First-Out)** buffer using **Verilog HDL**, designed and tested in **Xilinx Vivado**. It is ideal for applications where data needs to be transferred between modules synchronized to the same clock.

## 🧠 Overview
A FIFO (First-In-First-Out) buffer stores data temporarily in the order it was received and outputs it in the same order. This **synchronous FIFO** uses a single clock for both write and read operations, commonly used in pipelines, UARTs, and streaming data interfaces.

## ⚙️ Features
- Single-clock synchronous FIFO architecture  
- Parameterized data width and depth  
- Read and write enable logic  
- Status flags: `full`, `empty`



