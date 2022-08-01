using Literate
source, outdir = ARGS[1], ARGS[2]
Literate.markdown(source, outdir,
                  flavor=Literate.CommonMarkFlavor();
                  config=Dict("execute" => true))

