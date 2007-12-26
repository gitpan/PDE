#!/usr/bin/perl

use Module::Build;
my $class = Module::Build->subclass( code => <<'EOF');
use File::stat;
use File::Basename;
use ExtUtils::Install;

sub process_elc_files {
    my $self = shift;
    # Files to ignore byte-compile
    my @ignore = qw(pde-load.el pde-loaddefs.el pde-patch.el);
    my @el = glob("lisp/*.el");
    foreach my $el ( @el ) {
        next if grep { basename($el) eq $_ } @ignore;
        my $elc = $el."c";
        unless ( -e $elc && stat($elc)->mtime > stat($el)->mtime ) {
            my $cmd = qq/emacs -q -batch --no-site-file --eval="(add-to-list 'load-path \\".\\")" -f batch-byte-compile $el/;
            print $cmd, "\n";
            system($cmd);
        }
    }
}

sub ACTION_test {
    my ($emacs_version) = `emacs --version`;
    if ( $emacs_version =~ /GNU Emacs/ ) {
        if ( $emacs_version =~ /2[23]/ ) {
            print "Seem everything is Ok\n";
        } else {
            print "Your emacs version is too low, PDE may not work. Consider upgrade it.\n"
        }
    }
    else {
        print "No emacs found in your system.\n";
    }
    return 1;
}


sub ACTION_install {
    my $self        = shift;
    $self->SUPER::ACTION_install(@_);
    my $home = $ENV{HOME};
    my $elispdir = $self->{args}{elispdir} || "$home/.emacs.d/pde";
    ExtUtils::Install::install( {lisp => $elispdir}, !$self->quiet, 0,
                                $self->{args}{uninst} || 0 );
}

EOF

my $build = $class->new(
    module_name => 'PDE',
    license => 'perl',
);
$build->add_build_element('elc');
$build->create_build_script;
