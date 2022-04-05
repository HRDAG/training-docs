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


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input")
    parser.add_argument("--output")
    return parser.parse_args()


def get_logging(logname):
        logging.basicConfig(level=logging.DEBUG,
                            format='%(asctime)s %(levelname)s %(message)s',
                            handlers=[logging.FileHandler(logname),
                            logging.StreamHandler()])

# main
if __name__ == '__main__':

    # setup logging
    get_logging("output/core-task.log”)

    # arg handling
    args = getargs()
    input_f = args.input
    output_f = args.output

    # read data, initial verification
    logging.info("Loading data.")
    raw_df = pd.read_ext(input_f)
    check_asserts(raw_df)
    
    logging.info('__main__ Summary:')
    logging.info('====================')    
    logging.info('{:50}{}'.format('initial shape:', raw_df.shape ))
    logging.info('{:50}{}'.format('initial info:', raw_df.info() ))
    logging.info('\n')
    
    # save data
    raw.to_parquet(output_f)
    
    logging.info("done.")
    
# done.
