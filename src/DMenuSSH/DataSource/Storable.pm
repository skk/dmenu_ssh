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
use Socket;
use Storable qw/store_fd fd_retrieve retrieve store/;
use DateTime;
use DMenuSSH::DataRecord;

extends 'DMenuSSH::DataSource::Base';

has 'filename' => (is => 'ro', isa => 'Str', required => 1);

# TODO This should be removed and should be moved to super-class
has 'storable' => (is => 'rw', isa => 'DMenuSSH::DataRecord', required => 0, builder => 'build_storable');

sub build_storable {
    my $self = shift;
    my $data = ();
    eval {
        $data = retrieve $self->filename;
    };
    if ($@) {
        #print "Unable to retrieve data: $@\n.";
        $data = DMenuSSH::DataRecord->new;
    }
    $self->storable($data);
}

# ssh hosts, order by 
sub list_ssh_hosts {
    my $self = shift;
    my %hosts = %{ $self->storable->hosts };
    if (%hosts) {
        return map  { $_->[0] }
               sort { $b->[1] <=> $a->[1] }
               map  { [$_, $hosts{$_}] }
               grep { $_ ne '' }
                 keys %hosts;
    }
    else {
        return ();
    }
}

sub add_host {
    my $self = shift;
}

sub save_to_data_source {
    my $self = shift;
    my $data = $self->storable;
    store $data, $self->filename();
}

sub log_connect_to {
    my ($self, $hostname) = @_;
    my %hosts= %{ $self->storable->hosts };
    my $count = $hosts{$hostname};
    $self->storable->hosts->{$hostname} = $count + 1;
    my $data = $self->storable;
}

sub load_from_data_source {
    my $self = shift;
    my $hosts = $self->storable->hosts || \();
    if ($hosts) {
        my $last_read_ssh_known_hosts_file = $self->storable->last_read_ssh_known_hosts_file || undef;
        if ( !defined $last_read_ssh_known_hosts_file ||
             DateTime->now->ymd ne $self->storable->last_read_ssh_known_hosts_file->ymd) {
            my $data = $self->load_known_hosts;
            $self->storable->hosts($data);
            $self->storable->last_read_ssh_known_hosts_file(DateTime->now); #$last_read_ssh_known_hosts_file);
        }
    }
}

1;
