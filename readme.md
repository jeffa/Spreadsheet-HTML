Spreadsheet-HTML
================
Render HTML5 tables with ease.

Synopsis
--------
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

Interface
---------
* north (aka portrait)
<table><tr><th>header1</th><th>header2</th><th>header3</th></tr><tr><td>a1</td><td>a2</td><td>a3</td></tr><tr><td>b1</td><td>b2</td><td>b3</td></tr><tr><td>c1</td><td>c2</td><td>c3</td></tr><tr><td>d1</td><td>d2</td><td>d3</td></tr></table>

* west (aka landscape)
<table><tr><th>header1</th><td>a1</td><td>b1</td><td>c1</td><td>d1</td></tr><tr><th>header2</th><td>a2</td><td>b2</td><td>c2</td><td>d2</td></tr><tr><th>header3</th><td>a3</td><td>b3</td><td>c3</td><td>d3</td></tr></table>

* east
<table><tr><td>a1</td><td>b1</td><td>c1</td><td>d1</td><th>header1</th></tr><tr><td>a2</td><td>b2</td><td>c2</td><td>d2</td><th>header2</th></tr><tr><td>a3</td><td>b3</td><td>c3</td><td>d3</td><th>header3</th></tr></table>

* south
<table><tr><td>a1</td><td>a2</td><td>a3</td></tr><tr><td>b1</td><td>b2</td><td>b3</td></tr><tr><td>c1</td><td>c2</td><td>c3</td></tr><tr><td>d1</td><td>d2</td><td>d3</td></tr><tr><th>header1</th><th>header2</th><th>header3</th></tr></table>

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
