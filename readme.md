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
* portrait (aka north)
<table><tr><th>a</th><th>b</th><th>c</th></tr><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr></table>

* landscape (aka west)
<table><tr><th>a</th><td>1</td><td>4</td></tr><tr><th>b</th><td>2</td><td>5</td></tr><tr><th>c</th><td>3</td><td>6</td></tr></table>

* east
<table><tr><td>1</td><td>4</td><th>a</th></tr><tr><td>2</td><td>5</td><th>b</th></tr><tr><td>3</td><td>6</td><th>c</th></tr></table>

* south
<table><tr><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td></tr><tr><th>a</th><th>b</th><th>c</th></tr></table>

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
