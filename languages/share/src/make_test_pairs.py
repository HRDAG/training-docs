# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2022, HRDAG, GPL v2 or later
# =========================================
# 

# ---- dependencies {{{
from pathlib import Path
from sys import stdout
import argparse
import logging
import yaml
import pandas as pd
#}}}

# ---- support methods {{{
def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="input/string_tests.yaml")
    parser.add_argument("--output", default="output/test_pairs.parquet")
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


def read_yaml(fname):
    with open(fname, 'r') as f_handle:
        out = yaml.safe_load(f_handle)
    return out


def make_pairs(tests):
    pairs  = [(a, b) for a in tests for b in tests]
    assert len(pairs) == (len(tests)**2)
    return pairs
#}}}

# ---- main {{{
if __name__ == '__main__':
    # setup logging
    logger = get_logger(__name__, "output/make_test_pairs.log")

    # arg handling
    args = get_args()

    # read data, initial verification
    logger.info("Loading data.")
    tests = read_yaml(args.input)
    
    # do stuff, more verification
    test_pairs = make_pairs(tests)
    out = pd.DataFrame(test_pairs, columns=["string_1", "string_2"])

    # save data, final verification
    out.to_parquet(args.output)
    
    logger.info("done.")
    
#}}}
# done.
