use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Spreadsheet::HTML',
    AUTHOR           => q{Jeff Anderson <jeffa@cpan.org>},
    VERSION_FROM     => 'lib/Spreadsheet/HTML.pm',
    ABSTRACT_FROM    => 'lib/Spreadsheet/HTML.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'        => 0,
    },
    PREREQ_PM => {
        'Clone'             => 0,
        'Math::Matrix'      => 0.8,
        'HTML::AutoTag'     => 0.03,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Spreadsheet-HTML-*' },
);
