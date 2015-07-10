package Spreadsheet::HTML::Presets::Handson;
use strict;
use warnings FATAL => 'all';

use Spreadsheet::HTML::Presets;

sub handson {
    my ($self,$data,$args);
    $self = shift if ref($_[0]) =~ /^Spreadsheet::HTML/;
    ($self,$data,$args) = $self ? $self->_args( @_ ) : Spreadsheet::HTML::_args( @_ );

    my @rand = ( 0 .. 9, 'a' .. 'z', 'A' .. 'Z' );
    $args->{id} ||= 'handsontable-' . join( '', map @rand[rand@rand], 0 .. 7 );

    my @args = (
        @_,
        empty => undef,
        table => { %{ $args->{table} || {} }, class => $args->{id} },
    );

    my $table = $self ? $self->generate( @args ) : Spreadsheet::HTML::generate( @args );
    return _javascript( %$args ) . $args->{_auto}->tag( tag => 'div', cdata => $table, attr => { id => $args->{id} } );
}

sub _javascript {
    my %args = @_;

    my $js = sprintf _js_tmpl(), $args{id};

    $args{css} ||= 'http://handsontable.com/dist/handsontable.full.css';
    $args{handsonjs} ||= 'http://handsontable.com/dist/handsontable.full.js';
    $args{copyright} = 'Copyright (c) 2012-2014 Marcin Warpechowski | Copyright (c) 2015 Handsoncode sp. z o.o.';

    return Spreadsheet::HTML::Presets::_js_wrapper( code => $js, %args );
}

sub _js_tmpl {
    return <<'END_JAVASCRIPT';

/* Copyright (c) 2012-2014 Marcin Warpechowski */
/* Copyright (c) 2015 Handsoncode sp. z o.o. */
/* install JavaScript::Minifier to minify this code */

var id = '%s';

$(document).ready( function () {

    var data = new Array;
    $('.' + id + ' tr').each( function () {
        var row = new Array;
        $.each( this.cells, function () {
            row.push( $(this).html() );
        });
        data.push( row );
    });
    $('#' + id).html( '' );

    var hot = new Handsontable( document.getElementById( id ), {
        data:           data,
        rowHeaders:     true,
        colHeaders:     true,
        contextMenu:    true
        //minSpareRows:   1
    });

});

END_JAVASCRIPT
}

1;

=head1 NAME

Spreadsheet::HTML::Presets::Handson - Handsontable tables for Perl!

=head1 DESCRIPTION

This is a container for L<Spreadsheet::HTML> preset methods.
These methods are not meant to be called from this package.
Instead, use the Spreadsheet::HTML interface:

  use Spreadsheet::HTML;
  my $generator = Spreadsheet::HTML->new( data => [[1],[2]] );
  print $generator->handson( );

  # or
  use Spreadsheet::HTML qw( handson );
  print handson( data => [[1],[2]] );

=head1 METHODS

=over 4

=item * C<handson( jquery, handsonjs, css, %params )>

Styles table with Handsontable, a "data grid component with
and Excel-like appearance."

Generate an empty 100x20 data grid:

  handson( fill => '100x20' )

Uses Handsontable's JS API unless you specify another URI via
the C<handsonjs> param. Also uses their CSS unless you
override with the C<css> param.

  handson( handsonjs => '/dist/handsontable.full.js' )

Uses Google's jQuery API unless you specify another URI via
the C<jquery> param. Javascript will be minified
via L<Javascript::Minifier> if it is installed.

=back

=head1 SEE ALSO

=over 4

=item L<http://www.handsontable.com/>

=item L<Spreadsheet::HTML>

=item L<Spreadsheet::HTML::Presets>

=back

=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

The MIT License effective as of January 12, 2015.
Copyright (c) 2012-2014 Marcin Warpechowski
Copyright (c) 2015 Handsoncode sp. z o.o.
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
