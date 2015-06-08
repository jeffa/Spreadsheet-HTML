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
* portrait
<table><tr><th>head1</th><th>head2</th><th>head3</th></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>

* earthquake
<table><tr><td>1</td><td>foo</td><td>one</td><th>head1</th></tr><tr><td>2</td><td>bar</td><td>two</td><th>head2</th></tr><tr><td>3</td><td>baz</td><td>three</td><th>head3</th></tr></table>

* reverse
<table><tr><td>3</td><td>2</td><td>1</td></tr><tr><td>baz</td><td>bar</td><td>foo</td></tr><tr><td>three</td><td>two</td><td>one</td></tr><tr><th>head3</th><th>head2</th><th>head1</th></tr></table>

* tornado
<table><tr><th>head3</th><td>three</td><td>baz</td><td>3</td></tr><tr><th>head2</th><td>two</td><td>bar</td><td>2</td></tr><tr><th>head1</th><td>one</td><td>foo</td><td>1</td></tr></table>

* mirror
<table><tr><th>head3</th><th>head2</th><th>head1</th></tr><tr><td>three</td><td>two</td><td>one</td></tr><tr><td>baz</td><td>bar</td><td>foo</td></tr><tr><td>3</td><td>2</td><td>1</td></tr></table>

* tsunami
<table><tr><td>3</td><td>baz</td><td>three</td><th>head3</th></tr><tr><td>2</td><td>bar</td><td>two</td><th>head2</th></tr><tr><td>1</td><td>foo</td><td>one</td><th>head1</th></tr></table>

* flip
<table><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>foo</td><td>bar</td><td>baz</td></tr><tr><td>one</td><td>two</td><td>three</td></tr><tr><th>head1</th><th>head2</th><th>head3</th></tr></table>

* landscape
<table><tr><th>head1</th><td>one</td><td>foo</td><td>1</td></tr><tr><th>head2</th><td>two</td><td>bar</td><td>2</td></tr><tr><th>head3</th><td>three</td><td>baz</td><td>3</td></tr></table>

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
