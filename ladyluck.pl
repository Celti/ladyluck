#!/usr/bin/env perl
# LadyLuck v2, by Celti

use common::sense;
use local::lib 'extlib';
use App::Bot::BasicBot::Pluggable;

my $app = App::Bot::BasicBot::Pluggable->new_with_options(configfile => 'ladyluck.yaml');
$app->run();
