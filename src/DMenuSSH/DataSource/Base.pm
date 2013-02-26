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

package DMenuSSH::DataSource::Base;
use Mouse;

use strict;
use warnings 'all';
use Carp;
use Data::Dumper;
use Config::Simple;
use Socket;

sub execute {
    my ($self) = @_;
}

sub list_ssh_hosts {
    confess "Abstract method - Sub-class needs to implement this method.\n";
}

sub add_host {
    confess "Abstract method - Sub-class needs to implement this method.\n"
}

sub save_to_data_source {
    confess "Abstract method - Sub-class needs to implement this method.\n"
}

sub load_from_data_source {
    confess "Abstract method - Sub-class needs to implement this method.\n"
}

sub log_connect_to {
    confess "Abstract method - Sub-class needs to implement this method.\n"
}

sub load_known_hosts {
    my $self = shift;
    # TODO: Can this be any other path?
    my $ssh_known_hosts =  $ENV{HOME} . "/.ssh/known_hosts";
    my %hosts;

    my $fh_read;
    open( $fh_read, '<', $ssh_known_hosts) or confess "Can't open $ssh_known_hosts $!";
    while ( my $line = <$fh_read> ) {
        if ($line =~ m/^([.\w]*),{0,1}\s(.*)$/) {
            #my $ip = $1;
            #my $name = $1;
            my $ip = inet_aton($1);
            if ($ip) {
              my ($name,$aliases,$addrtype,$length,@addrs) = gethostbyaddr($ip, AF_INET);
              if ($name) {
                  $hosts{$name} = 1;
              }
          }
        }
    }
    return \%hosts;
}



1;
