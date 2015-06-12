package Spreadsheet::HTML::Presets;
use strict;
use warnings FATAL => 'all';

use Spreadsheet::HTML;

sub layout {
    Spreadsheet::HTML::generate( @_,
        encodes => '',
        matrix  => 1,
        table   => {
            role => 'presentation',
            ( map {$_ => 0} qw( border cellspacing cellpadding ) ),
        },
        _layout => 1,
    );
}

sub chessboard {
    my @black = ( '&#9820;', '&#9822;', '&#9821;', '&#9819;', '&#9818;', '&#9821;', '&#9822;', '&#9820;' );
    my @white = ( '&#9814;', '&#9816;', '&#9815;', '&#9813;', '&#9812;', '&#9815;', '&#9816;', '&#9814;' );
    Spreadsheet::HTML::generate( @_,
        tgroups  => 0,
        headless => 0,
        -row0 => sub { shift @black },
        -row1 => sub {'&#9823;'},
        -row6 => sub {'&#9817;'},
        -row7 => sub { shift @white },
        fill  => '8x8',
        table => {
            width => '65%',
            style => {
                border => 'thick outset',
            },
        },
        td => {
            height => 65,
            width  => 65,
            align  => 'center',
            style  => { 
                'font-size' => 'xx-large',
                border => 'thin inset',
                'background-color' => [ ('white', '#aaaaaa')x4, ('#aaaaaa', 'white')x4 ]
            }
        }
    );
}

=head1 NAME

Spreadsheet::HTML::Presets - Preset tables for fun and games.

See L<Spreadsheet::HTML>

=head1 METHODS

=over 4

=item * C<layout()>

Layout tables are not recommended, but if you choose to
use them you should label them as such. This adds W3C
recommended layout attributes to the table tag and features:
emiting only <td> tags, no padding or pruning of rows, forces
no HTML entity encoding in table cells.

=item * C<chessboard()>

Generates a static chess board.

=back

=cut

1;
