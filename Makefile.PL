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

WriteMakefile(
    NAME             => 'Spreadsheet::HTML',
    AUTHOR           => q{Jeff Anderson <jeffa@cpan.org>},
    VERSION_FROM     => 'lib/Spreadsheet/HTML.pm',
    ABSTRACT_FROM    => 'lib/Spreadsheet/HTML.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'        => 0,
        'HTML::Entities'    => 0,
        'Math::Matrix'      => 0,
    },
    PREREQ_PM => { },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Spreadsheet-HTML-*' },

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
