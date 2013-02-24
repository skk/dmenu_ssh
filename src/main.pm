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


use Exporter 'import'; # gives you Exporter's import() method directly
our @EXPORT_OK;
@EXPORT_OK = qw(main);

use strict;
use warnings 'all';
use Carp;
use Data::Dumper;
use Config::Simple;
use File::Path;
use Config::Simple;
use Class::Load qw/try_load_class/;

use dmenusshmain;

sub get_config {
    my $xdg_config_home = ($ENV{"XDG_CONFIG_HOME"} || $ENV{"HOME"} ). ".config" || 
        croak "Neither \$HOME nor \$XDG_CONFIG_HOME are set.";
    my $config_dir = $xdg_config_home . "/dmenussh/";

    File::Path::make_path($config_dir);

    my $config_file = $config_dir . "dmenussh.conf";

    if (! -f $config_file ) {
        my $default = Config::Simple->new("dmenussh_default.conf");
        $default->write($config_file);
    }
    return Config::Simple->new($config_file);
}

sub get_class {
    my ($classname, $class_options) = @_;
    if (!$class_options) {
        $class_options = {};
    }
    try_load_class($classname) || confess "Unable to load class $classname";
    my $launcher = $classname->new($class_options);
}

sub main {
    my $cfg = get_config();

    my $launcher = get_class($cfg->param("General.Launcher"));
    my $dmenusshmain = dmenusshmain->new(cfg => $cfg,
                                         launcher => $launcher);
    $dmenusshmain->execute();
}

1;
