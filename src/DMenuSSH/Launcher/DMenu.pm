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

package DMenuSSH::Launcher::DMenu;

use strict;
use warnings 'all';
use Carp;
use Data::Dumper;

use Config::Simple;
use Mouse;

extends 'DMenuSSH::Launcher::Base';

sub choose_host {
    my $self = shift;
    my $dmenu = "dmenu";
    my $dmenu_opts = "";
    my @hosts = @{ $self->ssh_hosts };
    my $cmd = "echo '" . join("\n", @hosts ) . "' | $dmenu $dmenu_opts";
    my $chosen_host = `$cmd`;
    chomp($chosen_host);
    return $chosen_host;
}

1;
