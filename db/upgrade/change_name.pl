#!/usr/bin/perl

#target_name:
my $target_base = "EasyCMS2-Schema-Base-%s-%s.sql";
my $target_upgr = "EasyCMS2-Schema-Base-%s-%s-%s.sql";
my $cmd_ptrn    = "svk mv %s %s";
my @alt_cmd_ptrn = (
    "cp %1\$s %2\$s",
    "svk delete %1\$s",
    "svk add %2\$s",
);
foreach (<*.sql>) {
    my $new;
    if (/-(\d+\.\d+)-(\d+\.\d+)-([a-z]+)/i) {
        $new = sprintf($target_upgr, $1, $2, $3);
    } elsif(    /-(\d+\.\d+)-([a-z]+)/i) {
        $new = sprintf($target_base, $1, $2);
    } else {
        warn "unknown file pattern";
    }
    if ($new ne $_) {
        print "$new\n";
        if (/::/) {
            print "we need to hack this one!\n";
            foreach my $cmd_ptrn (@alt_cmd_ptrn) {
                my $cmd = sprintf($cmd_ptrn, $_, $new);
                print "$cmd\n";
                system($cmd);
                if ($? != 0) {
                    die "error doing: $cmd";
                }            
            }
        } else {
            my $cmd = sprintf($cmd_ptrn, $_, $new);
            print $cmd . "\n";
            system($cmd);
            if ($? != 0) {
                die "error doing: $cmd";
            }            
        }
    } else {
        print "already exists as new name: $new\n";
    }
}