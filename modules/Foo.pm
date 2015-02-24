package Bot::BasicBot::Pluggable::Module::Foo;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '3';

sub help {
	return "Returns an appropriate response.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body) and $body =~ /^(?:!|\.)(foo|bar)$/i;
	$1 eq "foo" ? return "Bar!" : return $self->bot->emote({ %$message, body => "hands $message->{who} a drink." });
}

1;

__END__
