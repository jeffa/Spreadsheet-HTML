Spreadsheet-HTML
================
HTML tables from arrays (with transpositions).

Synopsis
--------
```perl
use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3)],
    [qw(foo bar baz)],
    [qw(one two three)],
    [qw(col1 col2 col3)],
];

my $table = Spreadsheet::HTML->new( data => $data );
print $table->generate;
print $table->transpose;

print Spreadsheet::HTML::generate( $data );
print Spreadsheet::HTML::transpose( $data );
```

Installation
------------
To install this module, you may run the
[classic CPAN process](http://perldoc.perl.org/ExtUtils/MakeMaker.html#Default-Makefile-Behaviour):
```
perl Makefile.PL
make
make test
make install
```

Support and Documentation
-------------------------
After installing, you can find documentation for this module with the
perldoc command.
```
perldoc Spreadsheet::HTML
```
You can also look for information at
[cpan.org](http://search.cpan.org/dist/Spreadsheet-HTML/)

License and Copyright
---------------------
See (/lib/Spreadsheet/HTML.pm).
