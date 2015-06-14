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

Spreadsheet::HTML::Presets::Conway - Assets for Conway.

See L<Spreadsheet::HTML::Presets>

=cut

1;
