package Bot::BasicBot::Pluggable::Module::Say;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '1';

sub help {
	return "Speaks with the voice of the bot. Requires auth. Usage: !say <expression>, !do <action>";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	return unless $self->authed($message->{who});
	return unless $body =~ /^(?:!|\.)(say|do|mode|kick|topic)\s+(\#\S+)\s+(.+)$/i;

	my $type = $1;
	my $chan = $2;
	my $mess = $3;

	return $self->bot->say({channel => $chan, body => $mess}) if $type eq 'say';
	return $self->bot->emote({channel => $chan, body => $mess}) if $type eq 'do';
	return $self->bot->mode("$chan $mess") if $type eq 'mode';
	return $self->bot->topic($chan,$mess) if $type eq 'topic';
	return $self->bot->kick($chan,split(/\s+/, $mess, 2)) if $type eq 'kick';
}

1;

__END__
