#!/usr/bin/env perl
# The LadyLuck IRC bot, v4.0.0a0
#
# Copyright (c) 2016 by Patrick Burroughs <celti@celti.name>
#
# Licensed under the terms of the Artistic License, Version 2.0 <LICENSE.md or
# http://www.perlfoundation.org/artistic_license_2_0>. This distribution may
# not be copied, modified, or distributed except according to those terms.

use lib 'lib';
use local::lib 'extlib';

use common::sense;
use Bot::BasicBot::Pluggable::WithConfig;

my $config = $ARGV[0]
	// die("Please specify a config file, e.g.: $0 ladyluck.yaml");

my $bot = Bot::BasicBot::Pluggable::WithConfig -> 
	new_with_config(config => $config);

$bot->load("RD");
$bot->load("Auth");
$bot->load("Loader");

$bot->run();
