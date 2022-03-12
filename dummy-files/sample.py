# Authors:     FL
# Maintainers: FL
# Copyright:   YYYY, HRDAG, GPL v2 or later
# =========================================
# Project-Name/parent-task/core-task/src/script.py

# dependencies
import argparse
import logging
import pandas as pd

# support methods
def check_asserts( val ):
    assert val

# main
if __name__ == '__main__':

    # setup logging
    logname = "output/core-task.log”
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(levelname)s %(message)s',
                        handlers=[logging.FileHandler(logname),
                                  logging.StreamHandler()])

    # arg handling
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("output")
    args = parser.parse_args()

    input = args.input
    output = args.output

    # read data, initial verification
    logging.info("Loading data.")
    raw = pd.read_ext(output)
    check_asserts(raw)

    logging.info("done.")
# done.
