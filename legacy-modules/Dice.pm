package Bot::BasicBot::Pluggable::Module::Dice;

use base qw(Bot::BasicBot::Pluggable::Module);
use common::sense;
use List::Util;
use IRC::Utils qw(NORMAL BOLD RED GREEN);
use Math::Random::Secure qw(irand);

our $VERSION = '7';

sub init {
	my $self = shift;
	$self->config({user_dice_colours => 1});
}

sub help {
	return "Rolls dice: .{roll|iroll|rolls} #[x][+-*/]#d#[\',=][+-*/bw]#[vs]# (for more detail, see https://celti.name/wiki/ladyluck)";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	$command = lc($command);

	return unless $command =~ /^(?:\.|\!)(i?rolls?)$/;

	my $showrolls  = $1 eq 'iroll' ? 1 : 0;
	my $showtotals = $1 eq 'rolls' ? 0 : 1;
	my $showdice   = 1;
	my $colors     = $self->get('user_dice_colours');

	my ($final, $total, @dice, @segments);

	return help() if $arguments =~ /^help$/i;
	return "♫ Never gonna give you up! / Never gonna let you down! ♫" if $arguments =~ /^rick$/i;
	return "♪ So get out there and rock / and roll the bones ♪" if $arguments =~ /^the bones$/i;

	# Ugly hack because people want to be able to do '.roll vs 10'
	$arguments = '3d ' . $arguments if $arguments =~ /^\s*vs/i;

	@segments = ( $arguments =~ / ( (?: [-+*x\/\\])?\s*
	                            (?:\d+[*x])?
	                            (?: (?>\d+)? d (?:\d+|f|%) | (?>\d+) d (?:\d+|f|%)? )
	                            (?: ['.,=] )?
	                            (?:[-+*x\/\\bw](?>\d+))?
	                            (?:\s*vs?\s*(?:.*?)[\s-](?:-?\d+))?
	                            (?!d) ) /xig
	); # Take off every xig?

	$segments[0] = '3d6' unless @segments;
	return "$message->{who} rolled too many dice and some dropped off the table." if @segments > 50;

	for my $seg (@segments) {
		$seg =~ / ( [-+*x\/\\0] )?\s*
		          (?: (\d+) [*x] )?
		          (\d+)? d (\d+|f|%)?
		          ( ['.,=] )?
		          (?: ([-+*x\/\\bw]) (\d*) )?
		          (?: \s* (?: (vs?) \s*? (.*?)? [\s-] ) (-?\d+) )? /xi;
		
		my $die = {
			segmod    => $1,
			numrolls  => $2 // 1,
			numdice   => $3 // 1,
			numsides  => $4 // 6,
			rolltype  => $5,
			diemod    => $6,
			modval    => $7,
			versus    => $8,
			tag       => $9,
			skill     => $10,
			margin    => 0,
			fudge     => 0,
			rollsmade => 0,
			output    => ''
		};
		
		$die->{numsides} = 100 if $die->{numsides} eq '%';
		
		if ( $die->{numsides} =~ /F/i ) {
			$die->{numsides} = 3;
			$die->{fudge}    = 1;
		}
		
		return "$message->{who} made a dice-rolling motion, but nothing happened." unless ( $die->{numdice} > 0 and $die->{numsides} > 0 );
		
		if (defined $die->{rolltype}) {
			return "$message->{who} flipped a coin and exploded." if ($die->{rolltype} eq '=' and $die->{numsides} == 2);
			return $self->bot->emote({%$message, body => "completed $message->{who}'s infinite loop in five seconds but won't give up the answer."}) if $die->{numsides} < 2;
			return $self->bot->emote({%$message, body => "ate $message->{who}'s fudge before it exploded."}) if $die->{fudge};
		}
		
		$die->{diemod} = undef unless defined $die->{modval};
		
		$die->{numdice}  = 1000 if $die->{numdice} > 1000;
		$die->{numsides} = 1000 if $die->{numsides} > 1000;
		$die->{numrolls} = 50 if $die->{numrolls} > 50;
		
		for ($die->{rollsmade} = 0; $die->{rollsmade} < $die->{numrolls}; $die->{rollsmade}++) {
			roll_dice($die);
			push @dice, {%{$die}};
		}
	}
	
	return "$message->{who} rolled too many dice and some dropped off the table." if ( List::Util::sum( map $_->{numdice}, @dice ) > 1000 );
	
	for my $die (@dice) {
		$die->{output} = ' ';
		
		if ($showdice) {
			$die->{output} .= $die->{segmod} if defined $die->{segmod};
			$die->{output} .= $die->{numdice} . 'd';
			$die->{output} .= $die->{fudge} ? 'F' : $die->{numsides};
			$die->{output} .= $die->{rolltype} if defined $die->{rolltype};
			$die->{output} .= $die->{diemod} . $die->{modval} if defined $die->{modval};
			$die->{output} .= ' vs ' . $die->{skill} if defined $die->{versus};
		}

		if ($showtotals) {
			$die->{output} .= BOLD if $colors == 1;
			$die->{output} .= ': ' . $die->{total};
			$die->{output} .= NORMAL if $colors == 1;
		}
		
		if ( ( $showrolls && @{ $die->{rolls} } ) or not $showtotals ) {
			$die->{output} .= ' [' . join( ", ", @{ $die->{rolls} } ) . ']';
		}
		
		if ( !defined $die->{segmod} or $die->{segmod} eq '+' ) {
			$total += $die->{total};
		}
		elsif ( $die->{segmod} eq '-' ) {
			$total -= $die->{total};
		}
		elsif ( $die->{segmod} eq '*' or $die->{segmod} eq 'x' ) {
			$total *= $die->{total};
		}
		elsif ( $die->{segmod} eq '/' or $die->{segmod} eq '\\' ) {
			$total = sprintf "%.2f", $total / $die->{total};
		}
		
		if (defined $die->{versus} and $die->{numdice} == 3 and $die->{numsides} == 6) {
			$die->{margin} = $die->{skill} - $die->{total};
			$die->{output} .= ', ';
			if (($die->{total} < 7) and (($die->{total} < 5) or ($die->{skill} > 14 and $die->{total} < 6) or ($die->{skill} > 15 and $die->{total} < 7))) {
				$die->{output} .= BOLD . GREEN if $colors == 1;
				$die->{output} .= 'CRITICAL SUCCESS: ' . ( $die->{margin} == abs($die->{margin}) ? 'Success' : 'Failure' ) . ' by ' . abs($die->{margin});
				$die->{output} .= NORMAL if $colors == 1;
			} elsif ($die->{total} > 16 or $die->{margin} < -9) {
				if ($die->{skill} > 15 and $die->{total} == 17) {
					$die->{output} .= RED if $colors == 1;
					$die->{output} .= 'AUTOMATIC FAILURE: ' . ( $die->{margin} == abs($die->{margin}) ? 'Success' : 'Failure' ) . ' by ' . abs($die->{margin});
					$die->{output} .= NORMAL if $colors == 1;
				} else {
					$die->{output} .= BOLD . RED if $colors == 1;
					$die->{output} .= 'CRITICAL FAILURE: ' . ( $die->{margin} == abs($die->{margin}) ? 'Success' : 'Failure' ) . ' by ' . abs($die->{margin});
					$die->{output} .= NORMAL if $colors == 1;
				}
			} elsif ($die->{margin} >= 0) {
				$die->{output} .= GREEN if $colors == 1;
				$die->{output} .= 'Success by ' . abs($die->{margin});
				$die->{output} .= NORMAL if $colors == 1;
			} else {
				$die->{output} .= RED if $colors == 1;
				$die->{output} .= 'Failure by ' . abs($die->{margin});
				$die->{output} .= NORMAL if $colors == 1;
			}
		}

		if (defined $die->{versus} and $die->{numdice} == 1 and $die->{numsides} == 20) {
			$die->{margin} = $die->{total} - $die->{skill};
			$die->{output} .= ', ';
			if ($die->{skill} <= $die->{total}) {
				$die->{output} .= GREEN if $colors == 1;
				$die->{output} .= 'Success by ' . abs($die->{margin});
				$die->{output} .= NORMAL if $colors == 1;
			} else { 
				$die->{output} .= RED if $colors == 1;
				$die->{output} .= 'Failure by ' . abs($die->{margin});
				$die->{output} .= NORMAL if $colors == 1;
			}
		}

		if (defined $die->{versus} and $die->{numdice} == 1 and $die->{numsides} == 100) {
			$die->{margin} = $die->{total} - $die->{skill};
			$die->{output} .= ', ';
			if ($die->{total} <= $die->{skill}) {
				$die->{output} .= GREEN if $colors == 1;
				$die->{output} .= 'Success by ' . abs($die->{margin});
				$die->{output} .= NORMAL if $colors == 1;
			} else { 
				$die->{output} .= RED if $colors == 1;
				$die->{output} .= 'Failure by ' . abs($die->{margin});
				$die->{output} .= NORMAL if $colors == 1;
			}
		}
	}
	
	$final = $message->{who} . ':';
	$final .= join( ';', map( $_->{output}, @dice ) );
	
	if (List::Util::first { defined($_->{segmod}) } @dice) {
		$final .= '; Total: ';
		$final .= BOLD if $colors == 1;
		$final .= $total;
		$final .= NORMAL if $colors == 1;
	}
	
	return "$message->{who} rolled too many dice and some dropped off the table." if (length($final) > 400);
	
	return $final;
}

sub roll_dice {
	my $die = shift;
	
	$die->{rolls} = ();
	$die->{total} = 0;
	
	for ( my $i = 0 ; $i < $die->{numdice} ; $i++ ) {
		push @{ $die->{rolls} }, 1 + irand $die->{numsides};
	}
	
	if ( defined $die->{rolltype} ) {
		if ( $die->{rolltype} eq '\'' ) { # Explode high
			foreach ( @{ $die->{rolls} } ) {
				push( @{ $die->{rolls} }, 1 + irand $die->{numsides} ) if $_ == $die->{numsides};
			}
		} elsif ( $die->{rolltype} eq ',' || $die->{rolltype} eq '.' ) { # Explode low
			foreach ( @{ $die->{rolls} } ) {
				push( @{ $die->{rolls} }, 1 + irand $die->{numsides} ) if ( $_ eq 1 );
				$_ = 0 - $die->{numsides} if ( $_ eq 1 );
			}
		} elsif ( $die->{rolltype} eq '=' ) { # Explode
			foreach ( @{ $die->{rolls} } ) {
				push( @{ $die->{rolls} }, 1 + irand $die->{numsides} ) if ( $_ eq $die->{numsides} || $_ eq 1 );
				$_ = 0 - $die->{numsides} if ( $_ eq 1 );
			}
		}
	}
	
	@{ $die->{rolls} } = map $_ - 2, @{ $die->{rolls} } if $die->{fudge};
	
	$die->{diemod} = '' unless defined $die->{diemod};
	
	if ( lc( $die->{diemod} ) eq 'b' ) {
		@{ $die->{rolls} } = sort { $b <=> $a } @{ $die->{rolls} };
		$die->{modval} = @{ $die->{rolls} } if $die->{modval} > @{ $die->{rolls} };
		$die->{total} = List::Util::sum( @{ $die->{rolls} }[ 0 .. $die->{modval} - 1 ] );
	} elsif ( lc( $die->{diemod} ) eq 'w' ) {
		@{ $die->{rolls} } = sort { $a <=> $b } @{ $die->{rolls} };
		$die->{modval} = @{ $die->{rolls} } if $die->{modval} > @{ $die->{rolls} };
		$die->{total} = List::Util::sum( @{ $die->{rolls} }[ 0 .. $die->{modval} - 1 ] );
	} else {    # Regular case
		$die->{total} = List::Util::sum( @{ $die->{rolls} } );
	}
	
	if ( $die->{diemod} eq '+' ) {
		$die->{total} += $die->{modval};
	} elsif ( $die->{diemod} eq '-' ) {
		$die->{total} -= $die->{modval};
	} elsif ( $die->{diemod} eq '*' or lc( $die->{diemod} ) eq 'x' ) {
		$die->{total} *= $die->{modval};
	} elsif ( $die->{diemod} eq '/' or $die->{diemod} eq '\\' ) {
		$die->{total} = sprintf "%.2f", $die->{total} / $die->{modval};
	}
}

1;

__END__
