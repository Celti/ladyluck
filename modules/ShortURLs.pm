package Bot::BasicBot::Pluggable::Module::ShortURLs;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use WWW::Shorten qw(TinyURL :short);

our $VERSION = '1';

sub init {
    my $self = shift;
    $self->config({user_shorten_length => 0});
}

sub help {
	return "Shortens URLs with TinyURL. Usage: Automatic if shorten_length is set, or !shorten <URL>.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);
	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);

	return unless $body =~ m{(https?://\S+)};
	my $url = $1;

	return unless $command =~ /^(?:!|\.)shorten$/ or $self->get('user_shorten_length') and length($url) > $self->get('user_shorten_length');

	my $short_url = short_link($url);
	return "There was a problem with the shorten service." unless defined $short_url;
	return "$message->{who}'s URL is at: $short_url";
}

1;

__END__
