package Bot::BasicBot::Pluggable::Module::Decide;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use Text::ParseWords;

our $VERSION = '2';

sub help {
	return "Chooses between multiple options. Usage: .decide <option 1> <option 2> [option 3]...";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless $command =~ /^(!|\.)(decide|choose)$/i;

	my @tokens = parse_line('(\s+or\s+|\s*,\s*|\s+)', 0, $arguments);
	return "Figure it out yourself!" if @tokens <= 1;
	return "I choose: " . $tokens[int rand @tokens];
}

1;

__END__
