#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 16;

use Spreadsheet::HTML;

my %attrs = ( sorted_attrs => 1, month => 7, year => 1970 );

my $generator = Spreadsheet::HTML->new( %attrs );

is $generator->calendar,
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar as method";

is Spreadsheet::HTML::calendar( %attrs ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar as function";

SKIP: {
    skip "broken tests - must merge attrs first", 6;
is $generator->calendar( -4 => { class => 'today' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td class="today" style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can specify day (method)";

is Spreadsheet::HTML::calendar( %attrs, -4 => { class => 'today' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td class="today" style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can specify day (function)";

is $generator->calendar( -4 => { class => 'today' }, -12 => { class => "another" }, -20 => { class => 'yet-another' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td class="today" style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td class="another" style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td class="yet-another" style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can specify multiple days (method)";

is Spreadsheet::HTML::calendar( %attrs, -4 => { class => 'today' }, -12 => { class => "another" }, -20 => { class => 'yet-another' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td class="today" style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td class="another" style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td class="yet-another" style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can specify multiple days (function)";

is $generator->calendar( -4 => { style => { 'text-weight' => 'bold' } } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-weight: bold">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar clobbers default style (method)";

is Spreadsheet::HTML::calendar( %attrs, -4 => { style => { 'text-weight' => 'bold' } } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-weight: bold">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar clobbers default style (function)";
};

is $generator->calendar( table => { class => 'table' } ),
    '<table class="table"><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can override table (method)";

is Spreadsheet::HTML::calendar( %attrs, table => { class => 'table' } ),
    '<table class="table"><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can override table (function)";

is $generator->calendar( caption => { caption => {class => 'caption'} } ),
    '<table><caption class="caption">caption</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can override caption (method)";

is Spreadsheet::HTML::calendar( %attrs, caption => { caption => {class => 'caption'} } ),
    '<table><caption class="caption">caption</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can override caption (function)";

is $generator->calendar( -Fri => { class => 'TGIF' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th class="TGIF">Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td class="TGIF" style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td class="TGIF" style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td class="TGIF" style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td class="TGIF" style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td class="TGIF" style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can mark row by name of day (method)";

is Spreadsheet::HTML::calendar( %attrs, -Fri => { class => 'TGIF' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th class="TGIF">Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td style="text-align: right">1</td><td style="text-align: right">2</td><td class="TGIF" style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td style="text-align: right">6</td><td style="text-align: right">7</td><td style="text-align: right">8</td><td style="text-align: right">9</td><td class="TGIF" style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td style="text-align: right">13</td><td style="text-align: right">14</td><td style="text-align: right">15</td><td style="text-align: right">16</td><td class="TGIF" style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td style="text-align: right">20</td><td style="text-align: right">21</td><td style="text-align: right">22</td><td style="text-align: right">23</td><td class="TGIF" style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td style="text-align: right">27</td><td style="text-align: right">28</td><td style="text-align: right">29</td><td style="text-align: right">30</td><td class="TGIF" style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can mark row by name of day (function)";

is $generator->calendar( -Mon => { class => ':(' }, -Wed => { class => 'hump-day' }, -Fri => { class => 'TGIF' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th class=":(">Mon</th><th>Tue</th><th class="hump-day">Wed</th><th>Thu</th><th class="TGIF">Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td class=":(" style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td class="hump-day" style="text-align: right">1</td><td style="text-align: right">2</td><td class="TGIF" style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td class=":(" style="text-align: right">6</td><td style="text-align: right">7</td><td class="hump-day" style="text-align: right">8</td><td style="text-align: right">9</td><td class="TGIF" style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td class=":(" style="text-align: right">13</td><td style="text-align: right">14</td><td class="hump-day" style="text-align: right">15</td><td style="text-align: right">16</td><td class="TGIF" style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td class=":(" style="text-align: right">20</td><td style="text-align: right">21</td><td class="hump-day" style="text-align: right">22</td><td style="text-align: right">23</td><td class="TGIF" style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td class=":(" style="text-align: right">27</td><td style="text-align: right">28</td><td class="hump-day" style="text-align: right">29</td><td style="text-align: right">30</td><td class="TGIF" style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can mark rows by name of day (method)";

is Spreadsheet::HTML::calendar( %attrs, -Mon => { class => ':(' }, -Wed => { class => 'hump-day' }, -Fri => { class => 'TGIF' } ),
    '<table><caption style="font-weight: bold">July 1970</caption><tr><th>Sun</th><th class=":(">Mon</th><th>Tue</th><th class="hump-day">Wed</th><th>Thu</th><th class="TGIF">Fri</th><th>Sat</th></tr><tr><td style="text-align: right">&nbsp;</td><td class=":(" style="text-align: right">&nbsp;</td><td style="text-align: right">&nbsp;</td><td class="hump-day" style="text-align: right">1</td><td style="text-align: right">2</td><td class="TGIF" style="text-align: right">3</td><td style="text-align: right">4</td></tr><tr><td style="text-align: right">5</td><td class=":(" style="text-align: right">6</td><td style="text-align: right">7</td><td class="hump-day" style="text-align: right">8</td><td style="text-align: right">9</td><td class="TGIF" style="text-align: right">10</td><td style="text-align: right">11</td></tr><tr><td style="text-align: right">12</td><td class=":(" style="text-align: right">13</td><td style="text-align: right">14</td><td class="hump-day" style="text-align: right">15</td><td style="text-align: right">16</td><td class="TGIF" style="text-align: right">17</td><td style="text-align: right">18</td></tr><tr><td style="text-align: right">19</td><td class=":(" style="text-align: right">20</td><td style="text-align: right">21</td><td class="hump-day" style="text-align: right">22</td><td style="text-align: right">23</td><td class="TGIF" style="text-align: right">24</td><td style="text-align: right">25</td></tr><tr><td style="text-align: right">26</td><td class=":(" style="text-align: right">27</td><td style="text-align: right">28</td><td class="hump-day" style="text-align: right">29</td><td style="text-align: right">30</td><td class="TGIF" style="text-align: right">31</td><td style="text-align: right">&nbsp;</td></tr></table>',
    "calendar can mark rows by name of day (function)";
