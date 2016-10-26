package Bot::BasicBot::Pluggable::Module::Quit;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '1';

sub help {
	return "Gracefully shuts down the bot. Requires auth. Usage: !quit";
}

sub admin {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless $body =~ /^!quit$/;

	$self->bot->shutdown($self->bot->quit_message()) if $self->authed($message->{who});
}

1;

__END__
