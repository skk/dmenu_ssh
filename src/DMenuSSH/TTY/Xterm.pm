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

package DMenuSSH::TTY::Xterm;

use strict;
use warnings 'all';
use Carp;
use Data::Dumper;

use Config::Simple;
use Mouse;

extends 'DMenuSSH::TTY::Base';

use main;

sub connect_to {
   my ($self, $host) = @_;
   my $cfg = main::get_config();
   my $terminal = $cfg->param('TTY.Terminal');
   my $terminal_arguments = $cfg->param('TTY.TerminalArguments');
   my $cmd = "$terminal $terminal_arguments ssh $host";
   print "cmd $cmd\n";
   $self->daemonize();
   system($cmd);
}

1;
