package Bot::BasicBot::Pluggable::Module::Kitty;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use LWP::UserAgent;
use URI;

our $VERSION = '1';

sub help {
	return "Returns an appropriate response. Usage: .kitty";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);

	return unless $command =~ /^(?:!|\.)(kitty|meow)$/;

	my $url = URI->new('http://thecatapi.com/api/images/get');
	$url->query_form(
		format           => 'src',
		results_per_page => '1',
	);

	my $ua = LWP::UserAgent->new;
	$ua->agent("LadyLuck IRC Bot/2.0");
	my $response = $ua->head($url);
	my $kitty = $response->request()->uri();

	return "Kitty! $kitty";
}

1;

__END__
