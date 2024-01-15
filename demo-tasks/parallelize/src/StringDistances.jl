# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2024, HRDAG, GPL v2 or later
# =========================================

# dependencies --- {{{
using ArgParse
using Logging: ConsoleLogger
using Parquet: read_parquet, write_parquet
using DataFrames: DataFrame
using StringDistances: Levenshtein
# }}}

# support methods --- {{{
function getargs()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--pairs"
        arg_type = String
        default = "output/linepairs.parquet"
        "--output"
        arg_type = String
        default = "output/StringDistances.parquet"
    end
    args = parse_args(s)
    @assert isfile(args["pairs"])
    return args
end


function getlogger(fname)
    io = open(fname, "w+")
    logger = ConsoleLogger(io)
    return logger
end


function main()
    args = getargs()
    logger = getlogger("output/SD-j-singl.log")

    @info "loading data"
    pairs = DataFrame(read_parquet(args["pairs"]))
    @info "nrows: $(size(pairs)[1])"
    @info "applying distance calculation to pairs"
    pairs.Levenshtein = [Levenshtein()(pairs.line_a[i], pairs.line_b[i]) for i=1:size(pairs)[1]]
    @info "writing data"
    write_parquet(args["output"], pairs)
    @info "done"
end
# }}}

# main --- {{{
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
# }}}
