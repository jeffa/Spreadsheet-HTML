Spreadsheet-HTML
================
HTML tables from arrays (with transpositions).

ALPHA RELEASE
-------------
While most functionality for this module has been completed,
that final 10% takes 90% of the time ... there is still much
todo:

* emit col, colgroup, thead, tbody and caption tags
* map client functions to cells
* assign attrs to td tags by row
* do that nifty rotating attr value trick

See [DBIx::XHTML_Table](http://search.cpan.org/dist/DBIx-XHTML_Table/)
if you need a production ready solution and check back soon.

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

my $table = Spreadsheet::HTML->new( data => $data, cache => 1 );
print $table->generate;
print $table->transpose;
print $table->flip;
print $table->mirror;
print $table->reverse;

print Spreadsheet::HTML::generate( $data );
print Spreadsheet::HTML::transpose( $data );
print Spreadsheet::HTML::flip( $data );
print Spreadsheet::HTML::mirror( $data );
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
You can also find documentation at [metaCPAN](https://metacpan.org/pod/Spreadsheet::HTML).

License and Copyright
---------------------
See [source POD](/lib/Spreadsheet/HTML.pm).
