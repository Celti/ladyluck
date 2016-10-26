package Bot::BasicBot::Pluggable::Module::Memory;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '1';

sub help {
	return "Remembers and returns facts about keywords.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);

	return unless $command =~ /^(?:!|\.)(remember|recall|details|match|try_recall|$/;

	return "Bar!"
}

1;

__END__
