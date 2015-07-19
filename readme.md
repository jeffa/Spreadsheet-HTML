Spreadsheet-HTML
================
Just another HTML table generator.

Description
-----------
Generate HTML tables with ease (HTML4, XHTML and HTML5). Can generate
landscape and other rotated views, Handsontable tables, HTML calendars,
checkboard patterns, games such as sudoku, banners and mazes, and can
create animations of cell values and backgrounds via jQuery. Can rewrap
existing tables from Excel, HTML, JSON, CSV and YAML files.

Synopsis
--------
```
mktable --param file=data.xls --param preserve=1 > out.html

# display output to browser with HTML::Display
mktable landscape --param data=[[a..d],[1..4],[5..8]] --display

mktable conway --param data=1..300 --param wrap=20 --display

mktable sudoku --display
```

Backend API
-----------
```perl
use Spreadsheet::HTML;

my $data = [
    [qw(header1 header2 header3)],
    [qw(a1 a2 a3)], [qw(b1 b2 b3)],
    [qw(c1 c2 c3)], [qw(d1 d2 d3)],
];

my $table = Spreadsheet::HTML->new( data => $data );
print $table->portrait;
print $table->landscape;

# non OO
print Spreadsheet::HTML::portrait( $data );
print Spreadsheet::HTML::landscape( $data );

# load from files
my $table = Spreadsheet::HTML->new( file => 'data.xls', cache => 1 );
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
You can also find documentation at [metaCPAN](https://metacpan.org/pod/Spreadsheet::HTML).

License and Copyright
---------------------
See [source POD](/lib/Spreadsheet/HTML.pm).
