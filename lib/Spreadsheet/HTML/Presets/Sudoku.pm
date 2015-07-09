package Spreadsheet::HTML::Presets::Sudoku;
use strict;
use warnings FATAL => 'all';

use Spreadsheet::HTML::Presets;

sub _javascript {
    my %args = @_;

    my $js = sprintf _js_tmpl(),
        $args{size},
        $args{size},
    ;

    return Spreadsheet::HTML::Presets::_js_wrapper( code => $js, %args );
}

sub _js_tmpl {
    return <<'END_JAVASCRIPT';

/* Copyright (C) 2015 Jeff Anderson */
/* install JavaScript::Minifier to minify this code */

var ROW = %s;
var COL = %s;
var MATRIX;
var next_x = 0;
var next_y = 0;

$(document).ready( function() {

    MATRIX = new Array();
    for (var row = 0; row < ROW; row++) {
        var rows = new Array(); 
        for (var col = 0; col < ROW; col++) {
            var id = row + '-' + col;
            if ($('input-' + id).id) {
                alert( 'this is an input cell: ' + $('input-' + id).id );
            } else {
                alert( 'this is a regular cell: ' + $('td-' + id).id );
            }
        }
        MATRIX.push( rows );
    }

    $('input.sudoku').keyup(function () { 
        this.value = this.value.replace( /[^0-9]/g, '' );

        var matches = this.id.match( /(\d+)-(\d+)/ );
        MATRIX[matches[1]][matches[2]] = this.value;
    });

});


/*
$("tr.item").each(function() {
    $this = $(this)
    var value = $this.find("span.value").html();
    var quantity = $this.find("input.quantity").val();
});
*/

$(document).keydown( function(e) {

    switch(e.which) {
        case 37: // left
        next_x = -1;
        break;

        case 38: // up
        next_y = -1;
        break;

        case 39: // right
        next_x = 1;
        break;

        case 40: // down
        next_y = 1;
        break;

        default: return;
    } 
    e.preventDefault();

    if (next_x) {

        next_x = 0;
    }
    if (next_y) {

        next_y = 0;
    }

});


END_JAVASCRIPT
}

=head1 NAME

Spreadsheet::HTML::Presets::Sudoku - Javascript for sudoku board.

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
