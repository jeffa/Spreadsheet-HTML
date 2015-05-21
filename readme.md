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
print $table->reverse;

print Spreadsheet::HTML::generate( $data );
print Spreadsheet::HTML::transpose( $data );
print Spreadsheet::HTML::reverse( $data );
```

Installation
------------
To install this module, you should use CPAN. A good starting
place is [How to install CPAN modules](http://www.cpan.org/modules/INSTALL.html).

If you truly want to install from this github repo, then
be sure and create the manifest before you test and install:
```
perl Makefile.PL
make
make manifest
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
See [source POD](/lib/Spreadsheet/HTML.pm).
