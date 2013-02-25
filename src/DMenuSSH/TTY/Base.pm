#!/usr/bin/env perl
#
# Copyright 2013 Steven Knight
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package DMenuSSH::TTY::Base;

use Mouse;

use strict;
use warnings 'all';
use Carp;
use Data::Dumper;
use Config::Simple;
use POSIX "setsid";

sub connect_to {
    confess "Abstract method - Sub-class needs to implement this method.\n"
}


sub daemonize {
    my ($self) = @_;
    chdir("/") || die "can't chdir to /: $!";
    open(STDIN,  "< /dev/null") || die "can't read /dev/null: $!";
    open(STDOUT, "> /dev/null") || die "can't write to /dev/null: $!";
    defined(my $pid = fork()) || die "can't fork: $!";
    exit if $pid; # non-zero now means I am the parent
    (setsid() != -1) || die "Can't start a new session: $!";
    open(STDERR, ">&STDOUT") || die "can't dup stdout: $!";
}

1;
