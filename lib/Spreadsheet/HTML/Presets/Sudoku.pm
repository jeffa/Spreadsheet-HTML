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
            if ($('#input-' + id).attr( 'id' )) {
                rows.push( $('#input-' + id).val() );
            } else {
                rows.push( $('#td-' + id).html() );
            }
        }
        MATRIX.push( rows );
    }

    $('input.sudoku').keyup(function () { 
        this.value = this.value.replace( /[^0-9]/g, '' );

        var matches = this.id.match( /(\d+)-(\d+)/ );
        var id_r = matches[1];
        var id_c = matches[2];

        var seen_r = {};
        var seen_c = {};
        for (var i = 0; i < ROW; i++) {
            seen_r[ MATRIX[id_r][i] ] = true;
            seen_c[ MATRIX[i][id_c] ] = true;
        }

        if (seen_r[this.value] || seen_c[this.value]) {
            this.value = '';
        }

        MATRIX[matches[1]][matches[2]] = this.value;
    });

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
