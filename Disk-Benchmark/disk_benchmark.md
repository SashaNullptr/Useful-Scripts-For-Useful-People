# Benchmark Disk I/O Speed

## What is this script for?

This script will run a rough benchmark of disk read and write speeds.

## How is this script used?

Run I/O benchmarks and save results to default location of `./io_benchmark.txt`.
```shell
sudo ./disk-benchmark.sh
```

Run the I/O benchmarks and save results to a particular file using the `-f` flag.
```shell
sudo ./disk-benchmark.sh -f "./IO_test.txt"
```

Display the built-in help and exit.

```shell
./disk-benchmark.sh -h
```

## Usage notes

By default this script will attempt to disable kernel-caching. Caching will
*greatly* effect read speeds and needs to be disabled in order to get precise results.
However disabling it requires root privileges, and so it is recommended to run the
benchmark script with `sudo` or as root. If the script as run as a non-root user
it will still run, but with kernel caching enabled.

## How does this script work?
