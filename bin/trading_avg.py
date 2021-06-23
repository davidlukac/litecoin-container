"""
Simple scripts that takes a CSV file of hourly traded information, filters them by provided date and calculates average
price per hour.

@author: David Lukac
"""

import argparse
import csv
import datetime
from collections import namedtuple

TradeRecord = namedtuple("TradeRecord", "timestamp dateTime symbol open high low close volume")


def init_args() -> argparse.Namespace:
    """
    Initialise and parse command line arguments.
    :return: parsed arguments
    """
    parser = argparse.ArgumentParser(description='Calculate average trading prices for given day.')
    parser.add_argument('file', type=argparse.FileType('r'), help='path to CSV file')
    parser.add_argument('date', type=str, help='desired date in YYYY-MM-DD format')
    return parser.parse_args()


def main() -> None:
    """
    Main function
    :return: None
    """
    args = init_args()

    target_date = datetime.datetime.strptime(args.date, "%Y-%m-%d")

    line = 1
    reader = csv.reader(args.file, delimiter=',')
    for row in reader:
        # Skip the headers
        if line <= 2:
            line += 1
            continue

        record = TradeRecord(*row)
        record_timestamp = datetime.datetime.utcfromtimestamp(float(record.timestamp) / 1000)

        if record_timestamp.date() == target_date.date():
            average = (float(record.high) + float(record.low)) / 2.0
            formatted_time = record_timestamp.time().strftime("%Hh %Mm %Ss")
            print(f"at {formatted_time} the average price of {record.symbol} was {average:.3f} with volume of "
                  f"{record.volume}")
        elif record_timestamp < target_date:
            # We can end processing if the dates are older than target date.
            break

        line += 1


if __name__ == '__main__':
    main()
