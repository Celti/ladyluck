package Bot::BasicBot::Pluggable::Module::GURPS::Hit;

our $VERSION = '4';

use common::sense;
use base qw(Bot::BasicBot::Pluggable::Module);
use IRC::Utils qw(NORMAL BOLD ITALIC);

sub init {
	my $self = shift;
	$self->config({user_hit_colours => 1});

	unless $self->get('user_hit_colours') {
		use constant NORMAL => '';
		use constant BOLD   => '';
		use constant ITALIC => '';
	}
}

sub help {
	return "Generates a random humanoid hit location and returns the relevant optional rules.";
}

sub told {
	my ($self,$message) = @_;
	my $body = $message->{body};
	return unless defined($body);

	my ($command,$arguments) = split(/\s+/, $body, 2);
	return unless lc($command) =~ /^(?:!|\.)hit$/;

	my $priroll = int(rand(6))+int(rand(6))+int(rand(6))+3;
	my $subroll = int(rand(6))+1;
	my $leftright = int(rand(2)) ? "Left" : "Right";
	my ($priresult, $subresult);

	my %locations = (
		skull           => BOLD."Skull:".NORMAL." 2 DR. All except ".ITALIC."tox".NORMAL.": 4× injury. Any shock requires a knockdown roll, major wounds roll at -10. Bleeding rolls every 30 seconds.",
		face            => BOLD."Face:".NORMAL." ".ITALIC."cor".NORMAL.": 1½× injury. Any shock requires a knockdown roll, major wounds roll at -5.",
		jaw             => BOLD."Jaw:".NORMAL.". Miss by 1 hits ".BOLD."chest".NORMAL.". Knockdown rolls are at a further -1.",
		nose            => BOLD."Nose:".NORMAL.ITALIC." imp, pi, beam".NORMAL.": treat as ".BOLD."skull".NORMAL.". Miss by 1 hits ".BOLD."chest".NORMAL.". Crippled by damage over ¼HP.",
		ear             => BOLD.$leftright." Ear:".NORMAL." If not ".ITALIC."cut".NORMAL.", treat as ".BOLD."face".NORMAL.". Miss by 1 hits ".BOLD."chest".NORMAL.". Crippled by damage over ¼HP. Major wound only if severed, with no penalty to knockdown rolls.",
		cheek           => BOLD.$leftright." Cheek:".NORMAL." As normal ".BOLD."face".NORMAL." hit, no special effects.",
		eye             => BOLD.$leftright." Eye:".NORMAL." ".ITALIC."imp, pi, beam".NORMAL.": treat as ".BOLD."skull".NORMAL." hit with no DR. Crippled over ⅒HP. Bleeding every 30 seconds.",
		leg             => BOLD.$leftright." Leg:".NORMAL." ".ITALIC."imp, pi".NORMAL.": maximum 1× injury. Crippled by damage over ½HP.",
		shin            => BOLD."Shin:".NORMAL." As normal ".BOLD."leg".NORMAL." hit, with no special effects.",
		knee            => BOLD."Knee:".NORMAL." If not ".ITALIC."cr, cut, pi, beam".NORMAL.", or a miss by 1: treat as normal ".BOLD."leg".NORMAL." hit. Otherwise: crippled over ⅓HP, and recovers at -2.",
		thigh           => BOLD."Thigh:".NORMAL." As normal ".BOLD."leg".NORMAL." hit, with no special effects.",
		thigh_vein      => BOLD."Thigh/Vein/Artery:".NORMAL." If not ".ITALIC."cut, imp, pi, beam".NORMAL.", or a miss by 1: treat as normal ".BOLD."leg".NORMAL." hit. Otherwise: no crippling, no injury limit; bleeding every 30 seconds at -3 penalty. ".ITALIC."cut".NORMAL.": 2.5× injury, -4 bleeding penalty.",
		arm             => BOLD.$leftright." Arm:".NORMAL." ".ITALIC."imp, pi".NORMAL.": maximum 1× injury. Crippled by damage over ½HP.",
		forearm         => BOLD."Forearm:".NORMAL." As normal ".BOLD."arm".NORMAL." hit, with no special effects.",
		elbow           => BOLD."Elbow:".NORMAL." If not ".ITALIC."cr, cut, pi, beam".NORMAL.", or a miss by 1: treat as normal ".BOLD."arm".NORMAL." hit. Otherwise: crippled over ⅓HP, and recovers at -2.",
		upper_arm       => BOLD."Upper Arm:".NORMAL." As normal ".BOLD."arm".NORMAL." hit, with no special effects.",
		shoulder_vein   => BOLD."Shoulder/Vein/Artery:".NORMAL." If not ".ITALIC."cut, imp, pi, beam".NORMAL.", or a miss by 1: treat as normal ".BOLD."arm".NORMAL." hit. Otherwise: no crippling, no injury limit; bleeding every 30 seconds at -3 penalty. ".ITALIC."cut".NORMAL.": 2.5× injury, -4 bleeding penalty.",
		chest           => BOLD."Chest:".NORMAL." Injury can't exceed 2×HP (1×HP if using bleeding rules).",
		chest_vitals    => BOLD."Vitals:".NORMAL." ".ITALIC."cr, imp, pi, beam".NORMAL." only, otherwise: treat as normal ".BOLD."chest".NORMAL." hit. ".ITALIC."imp, pi".NORMAL.": 3× injury, ".ITALIC."beam".NORMAL." 2× injury. Any shock requires a knockdown roll, major wounds roll at -5. Bleeding every 30 seconds at a -4 penalty.",
		spine           => BOLD."Spine:".NORMAL." If not ".ITALIC."cr, cut, pi, imp".NORMAL.", from behind, or if a miss by 1: treat as ".BOLD."chest".NORMAL.". Otherwise: any shock requires a knockdown roll, major wounds roll at -5. Crippled over 1×HP.",
		abdomen         => BOLD."Abdomen:".NORMAL." Injury can't exceed 2×HP (1×HP if using bleeding rules).",
		abdomen_vitals  => BOLD."Vitals:".NORMAL." ".ITALIC."cr, imp, pi, beam".NORMAL." only, otherwise: treat as normal ".BOLD."abdomen".NORMAL." hit. ".ITALIC."imp, pi".NORMAL.": 3× injury, ".ITALIC."beam".NORMAL." 2× injury. Any shock requires a knockdown roll, major wounds roll at -5. Bleeding every 30 seconds at a -4 penalty.",
		digestive_tract => BOLD."Digestive Tract:".NORMAL." On a major wound, roll HT-3 to avoid infection. Otherwise, treat as normal ".BOLD."abdomen".NORMAL." hit.",
		pelvis          => BOLD."Pelvis:".NORMAL." Crippled by damage over ½HP.",
		groin           => BOLD."Groin:".NORMAL." Shock penalties are doubled; knockdown rolls are at -5.",
		hand            => BOLD.$leftright." Hand:".NORMAL." ".ITALIC."imp, pi".NORMAL.": maximum 1× injury. Crippled by damage over ⅓HP.",
		wrist           => BOLD."Wrist:".NORMAL." If not ".ITALIC."cr, cut, pi, beam".NORMAL.", or a miss by 1: treat as normal ".BOLD."hand".NORMAL." hit. Otherwise: crippled over ¼HP, and recovers at -2.",
		foot            => BOLD.$leftright." Foot:".NORMAL." ".ITALIC."imp, pi".NORMAL.": maximum 1× injury. Crippled by damage over ⅓HP.",
		ankle           => BOLD."Ankle:".NORMAL." If not ".ITALIC."cr, cut, pi, beam".NORMAL.", or a miss by 1: treat as normal ".BOLD."foot".NORMAL." hit. Otherwise: crippled over ¼HP, and recovers at -2.",
		neck            => BOLD."Neck:".NORMAL." Miss by one hits the ".BOLD."chest".NORMAL.". ".ITALIC."cr, cor".NORMAL.": 1.5× injury; ".ITALIC."cut".NORMAL.": 2× injury. Bleeding every 30 seconds at -2 penalty. Optional: ".ITALIC."cr".NORMAL." injury over ½HP cripples the neck, causing choking.",
		neck_vein       => BOLD."Vein/Artery:".NORMAL." If not ".ITALIC."cut, imp, pi, beam".NORMAL.", or a miss by 1: treat as normal ".BOLD."neck".NORMAL." hit. Otherwise: no crippling, no injury limit; bleeding every 30 seconds at -3 penalty. ".ITALIC."cut".NORMAL.": 2.5× injury, -4 bleeding penalty.",
		none            => "No special result.",
	);

	for ($priroll) {
		when ([3, 4]) { $priresult = $locations{'skull'}; }
		when (5) { $priresult = $locations{'face'};
			for ($subroll) {
				when (1) { $subresult = $locations{'jaw'}; }
				when (2) { $subresult = $locations{'nose'}; }
				when (3) { $subresult = $locations{'ear'}; }
				when ([4, 5]) { $subresult = $locations{'cheek'}; }
				when (6) { $subresult = $locations{'eye'}; }
			}
		}
		when ([6, 7, 13, 14]) { $priresult = $locations{'leg'};
			for ($subroll) {
				when ([1, 2, 3]) { $subresult = $locations{'shin'}; }
				when (4) { $subresult = $locations{'knee'}; }
				when (5) { $subresult = $locations{'thigh'}; }
				when (6) { $subresult = $locations{'thigh_vein'}; }
			}
		}
		when ([8, 12]) { $priresult = $locations{'arm'};
			for ($subroll) {
				when ([1, 2, 3]) { $subresult = $locations{'forearm'}; }
				when (4) { $subresult = $locations{'elbow'}; }
				when (5) { $subresult = $locations{'upper_arm'}; }
				when (6) { $subresult = $locations{'shoulder_vein'}; }
			}
		}
		when ([9, 10]) { $priresult = $locations{'chest'};
			for ($subroll) {
				when (1) { $subresult = $locations{'chest_vitals'}; }
				when ([2, 3, 4, 5]) { $subresult = $locations{'none'}; }
				when (6) { $subresult = $locations{'spine'}; }
			}
		}
		when (11) { $priresult = $locations{'abdomen'};
			for ($subroll) {
				when (1) { $subresult = $locations{'abdomen_vitals'}; }
				when ([2, 3, 4]) { $subresult = $locations{'digestive_tract'}; }
				when (5) { $subresult = $locations{'pelvis'}; }
				when (6) { $subresult = $locations{'groin'}; }
			}
		}
		when (15) { $priresult = $locations{'hand'};
			for ($subroll) {
				when (1) { $subresult = $locations{'wrist'}; }
				when ([2, 3, 4, 5, 6]) { $subresult = $locations{'none'}; }
			}
		}
		when (16) { $priresult = $locations{'foot'};
			for ($subroll) {
				when (1) { $subresult = $locations{'ankle'}; }
				when ([2, 3, 4, 5, 6]) { $subresult = $locations{'none'}; }
			}
		}
		when ([17, 18]) { $priresult = $locations{'neck'};
			for ($subroll) {
				when (1) { $subresult = $locations{'neck_vein'}; }
				when ([2, 3, 4, 5, 6]) { $subresult = $locations{'none'}; }
			}
		}
	}

	$self->bot->say({%$message, body => "$message->{who}: $priroll (3d): $priresult"});
	$self->bot->say({%$message, body => "$message->{who}: $subroll (1d): $subresult"});
	return;
}

1;
