#!/bin/sh

# Create a file to store benchmark results.
out_file="./benchmark.txt"
# Create a temporary file that we will write to and read from to measure IO speeds.
tmpfile=$(mktemp /tmp/disk-benchmark.XXXXXX)

echo "Write Speed:" >> $out_file
# Get 1 GB of data from /dev/zero and write to the temporary file we created earilier.
# Since reading from /dev/zero is (bascally) free, this will measure how fast the
# our system can write to the temp file.
# dd will report the IO speed of this operation, which we will save to our log file.
( sync; dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc; sync ) 2>> $out_file

# Disable kernel caching -- if this is not disabled IO speeds will be *greatly*
# increased until the cache is exhausted, which will distorted benchmark results.
/sbin/sysctl -w vm.drop_caches=3

echo "Read Speed:" >> $out_file
# Read the data we wrote to our temp file and dump it into /dev/null
( dd if=tempfile of=/dev/null bs=1M count=1024 ) 2>> $out_file

# Clean up the temporary file of binary data.
rm "$tmpfile"
