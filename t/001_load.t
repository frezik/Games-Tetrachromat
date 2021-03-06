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
use Test;
plan 1;

use Game::Tetrachromat;
use Game::Tetrachromat::PacketFactory;
use Game::Tetrachromat::Packet;
use Game::Tetrachromat::Packet::ConnectRequest;
use Game::Tetrachromat::Packet::ConnectResponse;
use Game::Tetrachromat::Packet::Ack;
use Game::Tetrachromat::Packet::Movement;
use Game::Tetrachromat::Packet::Sync;
use Game::Tetrachromat::Packet::Spawn;


ok( 1, "Loaded everything" );
