use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

my $mm_ver = $ExtUtils::MakeMaker::VERSION;
if ($mm_ver =~ /_/) {
    # developer release
    $mm_ver = eval $mm_ver;
    die $@ if $@;
}

my @REQUIRES = (
    'strict'            => 0,
    'warnings'          => 0,
    'Data::Dumper'      => 0,
    'HTML::Entities'    => 0,
    'Math::Matrix'      => 0,
);

my @TEST_REQUIRES = (
    'Test::More'        => 0.88,
);

push(@REQUIRES, @TEST_REQUIRES) if $mm_ver < 6.64;

WriteMakefile(
    NAME             => 'Spreadsheet::HTML',
    AUTHOR           => q{Jeff Anderson <jeffa@cpan.org>},
    VERSION_FROM     => 'lib/Spreadsheet/HTML.pm',
    ABSTRACT_FROM    => 'lib/Spreadsheet/HTML.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,

    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Spreadsheet-HTML-*' },

    PREREQ_PM   => { @REQUIRES },

    ($mm_ver >= 6.52
        ? (CONFIGURE_REQUIRES => {
                'ExtUtils::MakeMaker' => 0,
          })
        : ()
    ),

    ($mm_ver >= 6.64
        ? (TEST_REQUIRES => { @TEST_REQUIRES })
        : ()
    ),

    ($mm_ver <= 6.45
        ? ()
        : (META_MERGE => {
            'meta-spec' => { version => 2 },
            resources => {
                repository  => {
                    type => 'git',
                    web  => 'https://github.com/jeffa/Spreadsheet-HTML',
                    url  => 'https://github.com/jeffa/Spreadsheet-HTML.git',
                },
            },
          })
    ),

);

# replace standard test harness with our own when 'make test' is invoked
# this is the only way i know to force 'make test' to run recursively
package MY;
sub test {
    my $inherited = shift->SUPER::test(@_);
    # replace line *after* with our script -----V
    $inherited =~ s{(test_dynamic :: pure_all\n).*\n}{$1\tprove -lrv\n}m;
    return $inherited;
}
