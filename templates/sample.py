# Authors:     FL
# Maintainers: FL
# Copyright:   YYYY, HRDAG, GPL v2 or later
# =========================================
# Project-Name/parent-task/core-task/src/script.py

# dependencies
from pathlib import Path
from sys import stdout
import argparse
import logging
import pandas as pd

# support methods
def check_asserts( val ):
    assert val


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default=None)
    parser.add_argument("--output", default=None)
    args = parser.parse_args()
    assert Path(args.input).exists()
    return args


def get_logger(sname, file_name=None):
    logger = logging.getLogger(sname)
    logger.setLevel(logging.DEBUG)
    formatter = logging.Formatter("%(asctime)s - %(levelname)s " +
                                  "- %(message)s", datefmt='%Y-%m-%d %H:%M:%S')
    stream_handler = logging.StreamHandler(stdout)
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)
    if file_name:
        file_handler = logging.FileHandler(file_name)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
    return logger

# main
if __name__ == '__main__':

    # setup logging
    logger = get_logger(__name__, "output/script-name.log")

    # arg handling
    args = get_args()
    input_f = args.input
    output_f = args.output

    # read data, initial verification
    logging.info("Loading data.")
    raw_df = pd.read_ext(input_f)
    check_asserts(raw_df)
    
    # do stuff, more verification
    logging.info('__main__ Summary:')
    
    # save data, final verification
    raw.to_parquet(output_f)
    
    logging.info("done.")
    
# done.
