package Bot::BasicBot::Pluggable::Module::Faker;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use LWP::JSON::Tiny;
use URI;

our $VERSION = '1';

sub help {
	return "Generates a fake identity. Usage: .fake [male|female] [rare|common|any]";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	return unless $body =~ /^(?:!|\.)fake\s*(m(?:ale)?|f(?:emale)?)?\s*(rare|common|any)?$/i;

	my $gender = $1;
	my $rarity = $2;
	my $type;
	my $min;
	my $max;

	for ($gender) {
		when (/f|female/) { $type = 'female'; }
		when (/m|male/) { $type = 'male'; }
		default    { $type = 'both'; }
	}

	for ($rarity) {
		when (/rare/)   { $min = 50; $max = 100; }
		when (/common/) { $min = 1;  $max = 25;  }
		when (/any/)    { $min = 1;  $max = 100; }
		default         { $min = 1;  $max = 50;  }
	}


	my $url = URI->new('http://namey.muffinlabs.com/name.json');
	$url->query_form(
		with_surname => 'true',
		type         => $type,
		min_freq     => $min,
		max_freq     => $max,
	);

	my $ua = LWP::UserAgent::JSON->new;
	$ua->agent("LadyLuck IRC Bot/2.0");
	my $response = $ua->get($url);

	return "Error fetching names:" . $response->status_line unless $response->is_success;
	return $response->json_content->[0];
}

1;

__END__
