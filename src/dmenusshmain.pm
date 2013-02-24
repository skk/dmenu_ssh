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

package dmenusshmain;
use Mouse;

use strict;
use warnings 'all';
use Carp;
use Data::Dumper;
use Config::Simple;
use Class::Load qw/try_load_class/;

has cfg => (is => 'rw', isa => 'Config::Simple', required => 1);
has launcher => (is => 'rw', isa => 'DMenuSSH::Launcher::Base', required => 1);

sub execute {
    my ($self) = @_;
}

1;