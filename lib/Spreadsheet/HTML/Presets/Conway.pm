package Spreadsheet::HTML::Presets::Conway;
use strict;
use warnings FATAL => 'all';

use Spreadsheet::HTML::Presets;

sub _javascript {
    my %args = @_;

    my $js = sprintf _js_tmpl(),
        $args{_max_rows},
        $args{_max_cols},
        $args{interval},
        $args{off},
        join( ',', map "'$_'", @{ $args{colors} } ),
    ;

    return Spreadsheet::HTML::Presets::_js_wrapper( code => $js, %args );
}

sub _js_tmpl {
    return <<'END_JAVASCRIPT';

/* Copyright (C) 2015 Jeff Anderson */
/* install JavaScript::Minifier to minify this code */
var MATRIX;
var ROW = %s;
var COL = %s;
var INTERVAL = %s;
var tid;

function Cell (id) {
    this.id         = id;
    this.neighbors  = 0;
    this.age        = 0;
    this.off        = '%s';
    this.on         = [ %s ];

    this.grow = function( age ) {
        this.age = age;
        if (age == 0) {
            $('#' + this.id).css( 'background-color', this.off );
        } else {
            $('#' + this.id).css( 'background-color', this.on[age - 1] );
        }
    }

    this.update = function() {
        if (this.age) {
            if ((this.neighbors <= 1) || (this.neighbors >= 4)) {
                this.grow( 0 );
            } else if (this.age < 9) {
                this.grow( ++this.age );
            }
        }
        else {
            if (this.neighbors == 3) {
                this.grow( 1 );
            }
        }
        this.neighbors = 0;
    }
}

function toggle() {
    if ($('#toggle').html() === 'Start') {
        tid = setInterval( update, INTERVAL );
        $('#toggle').html( 'Stop' );
    } else {
        clearInterval( tid );
        $('#toggle').html( 'Start' );
    }
}

$(document).ready(function(){

    $('th.conway, td.conway').click( function( data ) {
        var matches  = this.id.match( /(\d+)-(\d+)/ );
        var selected = MATRIX[matches[1]][matches[2]];
        if (selected.age) {
            selected.grow( 0 );
        } else {
            selected.grow( 1 );
        }
    });

    MATRIX = new Array( ROW );
    for (var row = 0; row < ROW; row++) {
        MATRIX[row] = new Array( COL );
        for (var col = 0; col < COL; col++) {
            MATRIX[row][col] = new Cell( row + '-' + col );
        }
    }

});

function update() {

    // count neighbors
    for (var row = 0; row < ROW; row++) {
        for (var col = 0; col < COL; col++) {

            for (var r = -1; r <= 1; r++) {
                if ( (row + r >=0) & (row + r < ROW) ) {

                    for (var c = -1; c <= 1; c++) {
                        if ( ((col+c >= 0) & (col+c < COL)) & ((row+r != row) | (col+c != col))) {
                            if (MATRIX[row + r][col + c].age) {
                                MATRIX[row][col].neighbors++;
                            }
                        }
                    }
                }
            }
        }
    }

    // update cells
    for (var row = 0; row < ROW; row++) {
        for (var col = 0; col < COL; col++) {
            MATRIX[row][col].update();    
        }
    }
}
END_JAVASCRIPT
}

=head1 NAME

Spreadsheet::HTML::Presets::Conway - Javascript implementation of Conway's Game of Life.

See L<Spreadsheet::HTML::Presets>

=head1 AUTHOR

Jeff Anderson, C<< <jeffa at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Jeff Anderson.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1;
