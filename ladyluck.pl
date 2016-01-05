#!/usr/bin/env perl
# LadyLuck v2, by Celti

use lib 'lib';
use local::lib 'extlib';

use common::sense;
use App::Bot::BasicBot::Pluggable;

$0 = 'ladyluck';
my $app = App::Bot::BasicBot::Pluggable->new_with_options(configfile => 'ladyluck.yaml');
$app->run();
