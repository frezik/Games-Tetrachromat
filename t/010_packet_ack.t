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
use v6;
use Game::Tetrachromat::PacketFactory;
use Game::Tetrachromat::Packet::Ack;
use Test;
plan 7;

my $packet_data = Buf.new(
    0x32, 0x4F, 0x67, 0x6A, # Magic number
    0x00, 0x00, # Version
    0x00, 0x01, 0x00, 0x00, # Sequence ID
    0x00, 0x02, # Packet type
    0x00, 0x08, # Payload size
    0x00, 0x00, # TODO Checksum
    0x00, 0x10, 0x01, 0x00, # Ack index
    0xFF, 0xFF, 0xFE, 0xFF, # Ack bit mask
);

my $packet = Game::Tetrachromat::PacketFactory.read_packet( $packet_data );
isa-ok $packet, Game::Tetrachromat::Packet::Ack;

todo 'Checksum not yet implemented';
ok $packet.isChecksumOK, "Checksum is OK";

cmp-ok $packet.version, '==', 0, "Version is correct";
cmp-ok $packet.type, '==', 2, "Type is correct";
cmp-ok $packet.payload_size, '==', 8, "Size is correct";
cmp-ok $packet.sequence, '==', 0x00010000, "Sequence ID is correct";

my @expected_acks = ((0x00100100 - 32) .. 0x00100100);
@expected_acks.splice( 8, 1 );
@expected_acks = @expected_acks.reverse;
is-deeply $packet.ack_ids, @expected_acks, "Got the expected acks";
