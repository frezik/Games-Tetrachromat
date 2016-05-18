use v6;
# Copyright (C) 2016  Timm Murray
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
class Game::Tetrachromat::Packet 
{

has Int $.type;
has Int $.magic_number;
has Int $.version;
has Int $.sequence;
has Int $.payload_size;
has Int $.checksum;
has Buf $.payload;

method isChecksumOK() returns Bool
{
    # TODO
    return True;
}

method combine_bits( Buf $data ) returns Int
{
    my Int $total = 0;

    for 0 .. ($data.elems - 1) -> $i {
        $total = ($total +< 8) +| $data[$i];
    }

    return $total;
}

}
