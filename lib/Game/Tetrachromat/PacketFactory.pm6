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
use Game::Tetrachromat::Packet::ConnectRequest;
use Game::Tetrachromat::Packet::ConnectResponse;
use Game::Tetrachromat::Packet::Ack;
use Game::Tetrachromat::Packet::Movement;
use Game::Tetrachromat::Packet::Sync;
use Game::Tetrachromat::Packet::Spawn;

constant $MAGIC_NUM = 0x324F676A;
constant $VERSION = 0x0000;


class Game::Tetrachromat::PacketFactory
{

method read_packet( Buf $packet_data ) returns Game::Tetrachromat::Packet
{
    my $got_magic = self.combine_bits( $packet_data.subbuf(0, 4) );
    if $got_magic != $MAGIC_NUM {
        die "Got packet with magic number $got_magic, expected $MAGIC_NUM";
        # TODO throw class (bad magic num)
    }
    my $got_version = self.combine_bits( $packet_data.subbuf(4, 2) );
    if $got_version != $VERSION {
        die "Got packet with version $got_version, expected $VERSION";
        # TODO throw class (wrong version)
    }

    my $sequence = self.combine_bits( $packet_data.subbuf( 6, 4 ) );
    my $packet_type = self.combine_bits( $packet_data.subbuf( 10, 2 ) );
    my $payload_size = self.combine_bits( $packet_data.subbuf( 12, 2 ) );
    my $checksum = self.combine_bits( $packet_data.subbuf( 14, 2 ) );
    my $payload_buf = $payload_size > 0
        ?? $packet_data.subbuf( 16, $payload_size )
        !! Buf.new();

    # TODO verify checksum

    my $packet_class;
    given $packet_type {
        when 0 { $packet_class = Game::Tetrachromat::Packet::ConnectRequest }
        when 1 { $packet_class = Game::Tetrachromat::Packet::ConnectResponse }
        when 2 { $packet_class = Game::Tetrachromat::Packet::Ack }
        when 3 { $packet_class = Game::Tetrachromat::Packet::Movement }
        when 4 { $packet_class = Game::Tetrachromat::Packet::Sync }
        when 5 { $packet_class = Game::Tetrachromat::Packet::Spawn }
        default {
            die "Don't know what to do with packet type $packet_type";
            # TODO throw object exception
        }
    }

    my $packet = $packet_class.new(
        magic_number => $got_magic,
        version => $got_version,
        type => $packet_type,
        sequence => $sequence,
        payload_size => $payload_size,
        checksum => $checksum,
        payload => $payload_buf,
    );

    return $packet;
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


