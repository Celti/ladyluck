package Bot::BasicBot::Pluggable::Module::NickServ;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;

our $VERSION = '5';

sub init {
	my $self = shift;
	$self->config({user_nickserv_password => 'iamnotabot'});
	#$self->config({user_nickserv_nick => 'LadyLuck'});
}

sub help {
	return "Authenticates to NickServ and automatically maintains bot nick. Usage: Automatic, or manually with !identify and !renick";
}

sub admin {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	#my $nick = $self->get('user_nickserv_nick');
	my $nick = $self->bot->nick();
	my $password = $self->get('user_nickserv_password');

	return "IDENTIFY $password" if $message->{who} eq 'NickServ' and $body =~ /nickname is registered/;
	return $self->bot->pocoirc->yield(nick => "$nick") if $message->{who} eq 'NickServ' and $body =~ /nickname is now being changed/;
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	#my $nick = $self->get('user_nickserv_nick');
	my $nick = $self->bot->nick();
	my $password = $self->get('user_nickserv_password');

	return $self->bot->nick() if $body =~ /^!whoami$/;
	return $self->bot->pocoirc->yield(nick => "$nick") if $body =~ /^!renick$/;
	return $self->bot->say({who => 'NickServ', body => "IDENTIFY $password", channel => 'msg' }) if $body =~ /^!identify$/;
}

sub nick_change {
	my ($self,$old_nick,$new_nick) = @_;
	#my $nick = $self->get('user_nickserv_nick');
	my $nick = $self->bot->nick();
	return $self->bot->pocoirc->yield(nick => "$nick") if $old_nick eq $nick;
}

1;

__END__
