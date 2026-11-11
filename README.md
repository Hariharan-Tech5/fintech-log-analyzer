# FinTech Payment Log Analyzer & Incident Triage Tool

## Business Problem
During high-severity (Sev-1/Sev-2) payment outages, Production Support Engineers must rapidly analyze massive server log files to identify failing microservices, quantify customer impact, and extract stuck transaction IDs for reprocessing.

## Solution
This Bash utility automates log parsing using `grep`, `awk`, and regular expressions to:
1. Summarize total traffic vs. critical `ERROR` and `WARN` counts.
2. Group failures by HTTP status codes (`500`, `504`, `401`) to pinpoint root causes.
3. Extract failed `TXN-ID`s into a clean list for batch reprocessing.
4. Flag high-latency transactions (`>2000ms`) before they trigger full timeouts.

## How to Run
```bash
chmod +x analyze_logs.sh
./analyze_logs.sh
```
