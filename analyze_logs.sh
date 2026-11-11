#!/bin/bash

LOG_FILE="app_transactions.log"
REPORT_FILE="incident_summary_$(date +%F).txt"

echo "==========================================" > $REPORT_FILE
echo " PRODUCTION INCIDENT LOG ANALYSIS REPORT  " >> $REPORT_FILE
echo " Generated At: $(date)                    " >> $REPORT_FILE
echo "==========================================" >> $REPORT_FILE

# 1. Count Total Transactions vs Errors
TOTAL_TXN=$(wc -l < $LOG_FILE)
ERROR_COUNT=$(grep -c "ERROR" $LOG_FILE)
WARN_COUNT=$(grep -c "WARN" $LOG_FILE)

echo -e "\n[1] TRAFFIC & ERROR SUMMARY" >> $REPORT_FILE
echo "Total Log Entries : $TOTAL_TXN" >> $REPORT_FILE
echo "Critical Errors   : $ERROR_COUNT" >> $REPORT_FILE
echo "Warnings          : $WARN_COUNT" >> $REPORT_FILE

# 2. Group Errors by HTTP Status Code
echo -e "\n[2] ERROR BREAKDOWN BY HTTP STATUS" >> $REPORT_FILE
grep "ERROR" $LOG_FILE | awk -F'Status: ' '{print $2}' | sort | uniq -c | awk '{print "HTTP " $2 " -> " $1 " occurrences"}' >> $REPORT_FILE

# 3. Extract Failed Transaction IDs for Engineering Escalation
echo -e "\n[3] FAILED TRANSACTION IDs (FOR REPROCESSING)" >> $REPORT_FILE
grep "ERROR" $LOG_FILE | grep -oE "TXN-[0-9]+" >> $REPORT_FILE

# 4. Identify Slow Transactions (> 2000ms)
echo -e "\n[4] HIGH LATENCY TRANSACTIONS (>2000ms)" >> $REPORT_FILE
awk -F'Latency: ' '{print $2, $0}' $LOG_FILE | awk '$1+0 > 2000 {print $0}' | cut -d' ' -f2- >> $REPORT_FILE

cat $REPORT_FILE
