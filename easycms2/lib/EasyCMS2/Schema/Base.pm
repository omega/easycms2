package EasyCMS2::Schema::Base;

use strict;
use warnings;
use POSIX 'strftime';

use base qw/DBIx::Class::Schema/;
__PACKAGE__->load_classes();
__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);

our $VERSION = '0.28';



sub upgrade {
    my ($self, $dryrun) = @_;

    $self->run_upgrade(qr//i, $dryrun);

    unless ($dryrun) {
		my $connect_info = $self->storage->connect_info();
		$self->storage->disconnect();
        my $vschema = DBIx::Class::Version->connect(@{$connect_info});
        my $vtable = $vschema->resultset('Table');
        $vtable->create({ 
            Version => $self->schema_version,
            Installed => strftime("%Y-%m-%d %H:%M:%S", gmtime())
        });
		$vschema->storage->disconnect;
		$self->storage->ensure_connected();
    }
}

sub run_upgrade {

    my ($self, $stm, $dryrun) = @_;
    my @statements = grep { $_ =~ $stm } @{$self->_filedata};
    $self->_filedata([ grep { $_ !~ /$stm/i } @{$self->_filedata} ]);

    for (@statements)
    {
        $self->storage->debugobj->query_start($_) if $self->storage->debug;
        $self->storage->dbh->do($_) or warn "SQL was:\n $_" unless $dryrun;
        $self->storage->debugobj->query_end($_) if $self->storage->debug;
    }

    return 1;
}
sub _source_exists
{   
    my ($self, $rs) = @_;

    my $c = eval {
        $rs->search({ version => 0 })->count;
    };  
    warn $@ if $@;
    return 0 if $@ || !defined $c;

    return 1;
}
sub _on_connect
{
    my ($self) = @_;
#    my $pversion = '0.09';
#=pod
    my $vschema = DBIx::Class::Version->connect(@{$self->storage->connect_info()});
    my $vtable = $vschema->resultset('Table');
    my $pversion;

    if(!$self->_source_exists($vtable))
    {
#        $vschema->storage->debug(1);
        $vschema->storage->ensure_connected();
        $vschema->deploy();
        $pversion = 0;
    }
    else
    {
        my $psearch = $vtable->search(undef, 
                                      { select => [
                                                   { 'max' => 'Installed' },
                                                   ],
                                            as => ['maxinstall'],
                                        })->first;
        $pversion = $vtable->search({ Installed => $psearch->get_column('maxinstall'),
                                  })->first;
        $pversion = $pversion->Version if($pversion);
    }
#    warn("Previous version: $pversion\n");
    if($pversion eq $self->schema_version)
    {
        warn "This version is already installed\n";
        return 1;
    }

## use IC::DT?    

    if(!$pversion)
    {
        $vtable->create({ Version => $self->schema_version,
                          Installed => strftime("%Y-%m-%d %H:%M:%S", gmtime())
                          });
        ## If we let the user do this, where does the Version table get updated?
        warn "No previous version found, calling deploy to install this version.\n";
        $self->deploy();
        return 1;
    }
#=cut
    my $file = $self->ddl_filename(
                                   $self->storage->sqlt_type,
                                   $self->upgrade_directory,
                                   $self->schema_version
                                   );
    if(!$file)
    {
        # No upgrade path between these two versions
        return 1;
    }

     $file = $self->ddl_filename(
                                 $self->storage->sqlt_type,
                                 $self->upgrade_directory,
                                 $self->schema_version,
                                 $pversion,
                                 );
#    $file =~ s/@{[ $self->schema_version ]}/"${pversion}-" . $self->schema_version/e;
    if(!-f $file)
    {
        warn "Upgrade not possible, no upgrade file found ($file)\n";
        return;
    }

    my $fh;
    open $fh, "<$file" or warn("Can't open upgrade file, $file ($!)");
    my @data = split(/;\n/, join('', grep { $_ && $_ !~ /^--/ && $_ !~ /^\s+$/ } <$fh>));
    close($fh);
    @data = grep { $_ !~ /^(BEGIN TRANACTION|COMMIT)/m } @data;

    $self->_filedata(\@data);

    ## Don't do this yet, do only on command?
    ## If we do this later, where does the Version table get updated??
    warn "Versions out of sync. This is " . $self->schema_version . 
        ", your database contains version $pversion, please call upgrade on your Schema.\n";
#    $self->upgrade($pversion, $self->schema_version);
}
1;