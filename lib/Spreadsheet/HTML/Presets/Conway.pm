package Spreadsheet::HTML::Presets::Conway;
use strict;
use warnings FATAL => 'all';

sub _javascript {
    my $javascript = <<'END_JAVASCRIPT';
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script type="text/javascript">
var ROW = %s;
var COL = %s;
var off = '%s';
var on  = '%s';
var MATRIX;

function Cell (id) {
    this.id         = id;
    this.neighbors  = 0;
    this.alive      = false;

    this.update = function() {
        if (this.alive) {
            if ((this.neighbors >= 4) || (this.neighbors <= 1)) {
                this.alive = false;
                $('#' + this.id).css( 'background-color', off );
            }
        }
        else {
            if (this.neighbors == 3) {
                this.alive = true;
                $('#' + this.id).css( 'background-color', on );
            }
        }
        this.neighbors = 0;
    }
}

$(document).ready(function(){

    $('td.conway').click( function( data ) {
        var matches  = this.id.match( /(\d+)-(\d+)/ );
        var selected = MATRIX[matches[1]][matches[2]];
        if (selected.alive) {
            selected.alive = false;
            $(this).css( 'background-color', off );
        } else {
            selected.alive = true;
            $(this).css( 'background-color', on );
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

function start() {
    count();
    update_matrix();
}

function update_matrix() {
    for (var row = 0; row < ROW; row++) {
        for (var col = 0; col < COL; col++) {
            MATRIX[row][col].update();    
        }
    }
}

function count() {

    for (var row = 0; row < ROW; row++) {
    for (var col = 0; col < COL; col++) {

        for (var r = -1; r <= 1; r++) {
        if ( (row + r >=0) & (row + r < ROW) ) {

            for (var c = -1; c <= 1; c++) {
            if ( ((col+c >= 0) & (col+c < COL)) & ((row+r != row) | (col+c != col))) {
                if (MATRIX[row + r][col + c].alive) {
                    MATRIX[row][col].neighbors++;
                }
            }
            }
        }
        }
    }
    }
}
</script>
END_JAVASCRIPT
    return sprintf $javascript, @_;
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
