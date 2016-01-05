package Bot::BasicBot::Pluggable::Module::Fnord;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use Fnorder;

our $VERSION = '1';

sub help {
	return "There is no conspiracy .fnord";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);

	return unless $command =~ /^(?:!|\.)fnord$/;

	return fnorder();
}

1;

__END__
