Spreadsheet-HTML
================
Render HTML5 tables with ease.

ALPHA RELEASE
-------------
While most functionality for this module has been completed,
that final 10% takes 90% of the time ... there is still some
left todo:

* emit col, colgroup
* map client attrs and functions to cells/rows

See [DBIx::XHTML_Table](http://search.cpan.org/dist/DBIx-XHTML_Table/)
if you need a production ready solution and check back soon.

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
* portrait
<table><tr><th>Header1</th><th>Header2</th><th>Header3</th></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>

* landscape
<table><tr><th>Header1</th><td>foo</td><td>one</td><td>1</td></tr><tr><th>Header2</th><td>bar</td><td>two</td><td>2</td></tr><tr><th>Header3</th><td>baz</td><td>three</td><td>3</td></tr></table>

* flip
<table><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><th>Header1</th><th>Header2</th><th>Header3</th></tr></table>

* mirror
<table><tr><th>Header3</th><th>Header2</th><th>Header1</th></tr><tr><td>baz</td><td>bar</td><td>foo</td></tr><tr><td>three</td><td>two</td><td>one</td></tr><tr><td>3</td><td>2</td><td>1</td></tr></table>

* reverse
<table><tr><td>3</td><td>2</td><td>1</td></tr><tr><td>three</td><td>two</td><td>one</td></tr><tr><td>baz</td><td>bar</td><td>foo</td></tr><tr><th>Header3</th><th>Header2</th><th>Header1</th></tr></table>

* earthquake
<table><tr><td>1</td><td>one</td><td>foo</td><th>Header1</th></tr><tr><td>2</td><td>two</td><td>bar</td><th>Header2</th></tr><tr><td>3</td><td>three</td><td>baz</td><th>Header3</th></tr></table>

* tsunami
<table><tr><td>3</td><td>three</td><td>baz</td><th>Header3</th></tr><tr><td>2</td><td>two</td><td>bar</td><th>Header2</th></tr><tr><td>1</td><td>one</td><td>foo</td><th>Header1</th></tr></table>

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
