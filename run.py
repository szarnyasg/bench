import duckdb
import time
import sys

def benchmark(instance, out):
    con = duckdb.connect("tpch-sf100.db")
    con.load_extension("tpch")

    for query_nr in range(1, 23):
        res = con.sql(f"SELECT query FROM tpch_queries() WHERE query_nr = {query_nr}").fetchone()
        query = res[0]

        for i in range(1, 4):
            # run query
            start = time.time()
            con.sql(f"CREATE OR REPLACE TEMP TABLE res AS {query}")
            duration = time.time() - start
            out.write(f"{instance},{query_nr},{duration}\n")


if len(sys.argv) < 2:
    print("Usage: run.py instance_type")
    exit(-1)


instance = sys.argv[1]
with open("out.csv", "w") as out:
    out.write("instance,query,time\n")
    benchmark(instance, out)
