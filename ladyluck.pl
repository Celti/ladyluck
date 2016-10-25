#!/usr/bin/env perl
# LadyLuck v3, by Celti

use lib 'lib';
use local::lib 'extlib';

use common::sense;
use Bot::BasicBot::Pluggable::WithConfig;

my $config = $ARGV[0]
	// die("Please specify a config file, e.g.: $0 ladyluck.yaml");

my $bot = Bot::BasicBot::Pluggable->new_with_config(config => $config);

$bot->load("Loader");
$bot->run();
