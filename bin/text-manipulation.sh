#!/usr/bin/env bash

# Scripts takes a CSV file of hourly traded information, filters them by provided date and calculates average price
# per hour.
#
# Arguments:
# - $1 path to the input CSV file
# - $2 date in YYYY-MM-DD format

set -e

: "${1:?Path to input CSV file is missing!}"
: "${2:?Target date in YYYY-MM-DD format is missing!}"

# Get traded currency pair.
PAIR=$(< "${1}" grep "${2}" | head -n 1 | cut -d ',' -f 3)

# Steps:
# Read file and filter out lines with provided date.
# Add arbitrary : after seconds for further replacement.
# Replace the first occurrence of : with h(hour).
# Replace the next occurrence of : with m(minute).
# Replace the next occurrence of : with s(second).
# Remove unnecessary columns, based on , delimiter.
# Remove date part of the time stamp based on space delimiter.
# Calculate average price from hourly high/low and print as a nice string.
< "${1}" grep "${2}" | \
  sed "s/,${PAIR}/:,${PAIR}/g" | \
  sed "s/:/h /" | \
  sed "s/:/m /" | \
  sed "s/:/s /" | \
  cut -d ',' -f 2,5,6,8 | \
  cut -d ' ' -f 2,3,4,5 | \
  awk -F, -v PAIR="${PAIR}" '{ print "at "$1"the average price of "PAIR" was "($2 + $3) / 2" with volume of "$4 }'
