#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Time::Local;
use Time::HiRes qw(gettimeofday);

sub date2timestamp {
    my $date = shift;
    my ($year, $mon, $day, $hour, $min, $sec, $microsec) = ($date =~ /(\d{4})\-([01]\d)\-([0-3]\d) ([0-2]\d):([0-5]\d):([0-5]\d).(\d*)/);
    my $timestamp = timelocal($sec, $min, $hour, $day, $mon - 1, $year);
    $timestamp = $timestamp * 1000 * 1000 + $microsec;
    return $timestamp;
}

my($fullSec,$microsec) = gettimeofday();
my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($fullSec);
my $now = sprintf("%04d-%02d-%02d %02d:%02d:%02d.%06d",$year+1900,$mon+1,$mday,$hour,$min,$sec,$microsec);
my $timestamp = &date2timestamp($now);
print "$timestamp\n";
