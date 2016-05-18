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
use Game::Tetrachromat::Packet;

class Game::Tetrachromat::Packet::Ack
    is Game::Tetrachromat::Packet
{

has @.ack_ids;

submethod BUILD()
{
    my $main_ack = self.combine_bits( self.payload.subbuf( 0, 4 ) );
    my $ack_index = self.combine_bits( self.payload.subbuf( 4, 4 ) );
    @!ack_ids.push( $main_ack );

    for 1 .. 32 -> $i {
        my $shift_count = 32 - $i;
        my $is_acked = ($ack_index +> $shift_count) +& 1;
        if $is_acked {
            my $new_ack_id = $main_ack - $i;
            @!ack_ids.push( $new_ack_id );
        }
    }
}

}
