
HAMMERDB_VERSION=${HAMMERDB_VERSION:-4.12}
isodate=$(date +"%Y-%m-%dT%H:%M:%S")
BENCHNAME=${BENCHNAME:-${isodate}}

./download-hammerdb.sh "$HAMMERDB_VERSION"
start_time=$(date +%s)
(cd "HammerDB-$HAMMERDB_VERSION" && time ./hammerdbcli auto ../build.tcl | tee "../results/hammerdb_build_${BENCHNAME}.log")
end_time=$(date +%s)