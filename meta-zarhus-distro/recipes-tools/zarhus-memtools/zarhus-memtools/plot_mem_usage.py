#!/usr/bin/env python3

import csv
import sys
import matplotlib.pyplot as plt
import numpy as np

from datetime import datetime


def date_to_relative(timestamps: list[str]) -> list[int]:
    dates = [datetime.strptime(ts, "%Y-%m-%d %H:%M:%S") for ts in timestamps]
    return [int((date - dates[0]).total_seconds()) for date in dates]


def get_axes(filename: str):
    timestamps = []
    used_mem = []
    used_swap = []

    with open(f"{filename}", 'r') as csv_file:
        lines = csv.reader(csv_file)
        # Skip header
        next(lines, None)
        for row in lines:
            timestamps.append(row[0])
            used_mem.append(row[1])
            used_swap.append(row[2])
    return date_to_relative(timestamps), [int(x) for x in used_mem], [int(x) for x in used_swap]


def get_axis_ticks(ax, number):
    return [int(x) for x in np.linspace(0, max(ax), number)]


no_swap = False

if len(sys.argv) == 1:
    print("Usage: python6 plot_measurement.py measurements_directory [--no-swap]")
    exit(1)

if len(sys.argv) == 3:
    if sys.argv[2] == "--no-swap":
        no_swap = True

timestamps, used_mem, used_swap = get_axes(sys.argv[1])
plt.figure(figsize=(8, 8))
plt.plot(timestamps, used_mem, label="Used RAM")
if not no_swap:
    plt.plot(timestamps, used_swap, label="Used Swap memory")
    mem_ticks = get_axis_ticks(used_mem, 10)
    plt.yticks(mem_ticks)
plt.legend()
plt.grid()
plt.xlabel("Time [s]")
plt.ylabel("Memory [Ki]")
plt.title("Memory usage")
plt.savefig("mem-usage.png")
plt.show()
