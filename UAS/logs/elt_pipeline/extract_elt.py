import pandas as pd
import os
import time
from datetime import datetime

# ---------- Helper Logging ----------
def log_extract(source_name, rows, cols, file_path, start_time):
    end_time = time.time()
    log_message = (
        f"[{datetime.now()}] EXTRACT ELT | Source: {source_name} | "
        f"Rows: {rows} | Cols: {cols} | "
        f"File Size: {os.path.getsize(file_path)} bytes | "
        f"Execution Time: {round(end_time - start_time, 2)} seconds\n"
    )

    with open("logs/elt_extract.log", "a") as f:
        f.write(log_message)

# ---------- Extract Source 1 ----------
def extract_elt_source1():
    start_time = time.time()

    url = "https://github.com/KhalPrawira/Big-Data_Assignment/raw/refs/heads/main/UAS/Dataset/Pakistans%20Largest%20E-Commerce%20Dataset.csv"
    df = pd.read_csv(url)

    os.makedirs("raw/source1", exist_ok=True)
    output_path = "raw/source1/ecommerce_raw.csv"
    df.to_csv(output_path, index=False)

    log_extract(
        source_name="Pakistan E-Commerce Dataset",
        rows=df.shape[0],
        cols=df.shape[1],
        file_path=output_path,
        start_time=start_time
    )

# ---------- Extract Source 2 ----------
def extract_elt_source2():
    start_time = time.time()

    url = "https://github.com/KhalPrawira/Big-Data_Assignment/raw/refs/heads/main/UAS/Dataset/pakistan_holiday.csv"
    df = pd.read_csv(url)

    os.makedirs("raw/source2", exist_ok=True)
    output_path = "raw/source2/holiday_raw.csv"
    df.to_csv(output_path, index=False)

    log_extract(
        source_name="Pakistan Holiday Dataset",
        rows=df.shape[0],
        cols=df.shape[1],
        file_path=output_path,
        start_time=start_time
    )

# ---------- Main ----------
if __name__ == "__main__":
    extract_elt_source1()
    extract_elt_source2()
