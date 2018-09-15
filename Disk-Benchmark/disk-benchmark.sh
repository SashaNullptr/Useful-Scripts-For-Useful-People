#!/bin/sh

show_help() {
  echo "Benchmark disk read and write speeds."
  echo "Command line arguments:"
  echo "  f: Path to file that will contain the benchmark results. Results are appended by default. If this variable is not specified results will be saved to ./io_benchmark.txt"
  echo "  h: Show this help text and exit."
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize file path to store benchmark results.
out_file="./io_benchmark.txt"

while getopts "h?vf:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    f)  out_file=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

# Create a temporary file that we will write to and read from to measure IO speeds.
tempfile=$(mktemp /tmp/disk-benchmark.XXXXXX)

echo "Saving benchmark results to '$out_file', Leftovers: $@"
echo "Temp file location: '$tempfile'"

echo "Write Speed:" >> $out_file
# Get 1 GB of data from /dev/zero and write to the temporary file we created earilier.
# Since reading from /dev/zero is (bascally) free, this will measure how fast the
# our system can write to the temp file.
# dd will report the IO speed of this operation, which we will save to our log file.
( sync; dd if=/dev/zero of="$tempfile" bs=1M count=1024 conv=fdatasync,notrunc; sync ) 2>> $out_file

# Disable kernel caching -- if this is not disabled IO speeds will be *greatly*
# increased until the cache is exhausted, which will distorted benchmark results.
/sbin/sysctl -w vm.drop_caches=3

echo "Read Speed:" >> $out_file
# Read the data we wrote to our temp file and dump it into /dev/null
( dd if="$tempfile" of=/dev/null bs=1M count=1024 ) 2>> $out_file

# Clean up the temporary file of binary data.
rm "$tempfile"
