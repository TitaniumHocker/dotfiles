#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

my $stdin  = "/dev/null";
my $stdout = "/dev/null";
my $stderr = "/dev/null";

sub print_help {
    my $message = << "END";
Usage: forked.pl [-h|--help] [-i|--stdin PATH] [-o|--stdout PATH]
                 [-e|--stderr PATH] COMMAND

Simple utility for starting command in separate process.
By default STD[IN|OUT|ERR] piped to /dev/null.

Argumenrs:
    COMMAND             Command to execute in separate process.

Flags:
    -h|--help           Print this message and exit.
    -i|--stdin  PATH    Open given PATH as STDIN.
    -o|--stdout PATH    Open given PATH as STDOUT.
    -e|--stderr PATH    Open given PATH as STDERR.

The author of the program, as always, bears no responsibility.

END
    print "$message\n";
}

unless (scalar @ARGV) { print_help and exit 1 }

for (@ARGV) {
    if ($_ eq '--help' or $_ eq '-h') {
        print_help and exit 0;
    }
}

GetOptions(
    'stdin|i=s'  => \$stdin,
    'stdout|o=s' => \$stdout,
    'stderr|e=s' => \$stderr
) or print_help and exit 1;

my $pid = fork;
unless (defined $pid) {
    die "Failed to fork:\n$!\n";
}
if ($pid != 0) {
    print "Successfully forked with PID $pid, exiting parent process.\n";
    exit 0;
}

close STDIN; open STDIN, "<", $stdin
    or die "open STDIN < $stdin failed: $!\n";
close STDOUT; open STDOUT, ">", $stdout
    or die "open STDOUT > $stdout failed: $!\n";
close STDERR; open STDERR, ">", $stderr
    or die "open STDERR > $stderr failed: $!\n";

exec @ARGV;

