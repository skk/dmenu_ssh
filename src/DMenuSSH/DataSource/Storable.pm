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

package DMenuSSH::DataSource::Storable;

use Mouse;

use strict;
use warnings 'all';
use Carp;
use Data::Dumper;
use Config::Simple;
use FileHandle;
use Storable qw/store_fd fd_retrieve retrieve store/;

extends 'DMenuSSH::DataSource::Base';

has 'filename' => (is => 'ro', isa => 'Str', required => 1);
#has 'filehandle' => (is => 'ro', isa => 'FileHandle', required => 0, builder => 'build_filehandle');
has 'storable' => (is => 'rw', isa => 'Ref', required => 0, builder => 'build_storable');

#sub build_filehandle {
#    my $self = shift;
#    return FileHandle->new($self->filename, "w");
#}

sub build_storable {
    my $self = shift;
    my $data = ();
    eval {
        $data = retrieve $self->filename;
    };
    if ($@) {
        #print "Unable to retrieve data: $@\n.";
        $data = \{};
    }
    $self->storable($data);
}

sub load_know_hosts {
    my $self = shift;
    # TODO: Can this be any other path?
    my $ssh_known_hosts =  $ENV{HOME} . "/.ssh/known_hosts";
    #print "filename $ssh_known_hosts\n";
    my %hosts;

    my $fh_read;
    open( $fh_read, '<', $ssh_known_hosts) or confess "Can't open $ssh_known_hosts $!";
    while ( my $line = <$fh_read> ) {if ($line =~ m/^(.*),(\d*.\d*.\d*.\d*) (.*)$/) {
            #print "1 $1, 2 $2\n";
            $hosts{$1} = 1;
        }
    }
    return \%hosts;
}

sub list_ssh_hosts {
    my $self = shift;
    if (ref $self->storable eq 'HASH') {
        return keys $self->storable;
    }
    else {
        return [];
    }
}

sub add_host {
    my $self = shift;
}

sub save_to_data_source {
    my $self = shift;
}

sub load_from_data_source {
    my $self = shift;
    my $rv = (ref $self->storable() eq '') ? 1 : 0;
    if (!$rv) {
        my $data = $self->load_know_hosts;
        $self->storable($data);
    }
}

1;
