#!/usr/bin/env python3
# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2023, HRDAG, GPL v2 or later
# =========================================

# dependencies --- {{{
from pathlib import Path
from sys import stdout
import argparse
import logging
import pandas as pd
import rapidfuzz
import line_profiler

profile = line_profiler.LineProfiler()
# }}}

# support methods --- {{{
def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pairs", default="output/linepairs.parquet")
    parser.add_argument("--output", default="output/L-py-singl.parquet")
    args = parser.parse_args()
    assert Path(args.pairs).exists()
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


@profile
def getdist(a, b):
    return rapidfuzz.distance.Levenshtein.distance(a, b)
# }}}

# main --- {{{
if __name__ == '__main__':
    
    # setup logging
    logger = get_logger(__name__, "output/L-py-singl.log")

    # arg handling
    args = get_args()

    pairs = pd.read_parquet(args.pairs)
    pairs['rapidfuzz'] = pairs.apply(lambda x: getdist(x.line_a, x.line_b), axis=1).to_list()
    pairs.to_parquet(args.output)
# }}}
