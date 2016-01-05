package Fnorder;

use Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(fnorder);
@EXPORT_OK = qw();

use strict;

our(@adjectives) = 
  ("23rd ", "acceptable ", "acrobatic ", "alien ", "amiable ",
   "amoeboid ", "ancient ", "arbitrary ", "atomic ", "avenging ",
   "awesome ", "balanced ", "besotted ", "best ", "black ", "blue ",
   "calculating ", "cast iron ", "cat-like ", "cautious ", "Chinese ",
   "cold ", "communist ", "corrupt ", "dead ", "deadly ", "dehydrated ",
   "disguised ", "dizzy ", "drug-crazed ", "drunken ", "easy ",
   "electric ", "embossed ", "enormous ", "expensive ", "explosive ",
   "extraterrestrial ", "ferocious ", "frozen ", "furry ", "gelatinous ",
   "glowing ", "gnarly ", "gold ", "granular ", "greedy ", "green ",
   "high ", "highest ", "hot ", "humming ", "illuminated ", "imitation ",
   "impotent ", "impudent ", "impulsive ", "indictable ", "innocent ",
   "insane ", "Japanese ", "lecherous ", "lizard-like ", "lovely ",
   "maniacal ", "mauve ", "medium-sized ", "morbid ", "most influential ",
   "mutant ", "naughty ", "nuclear ", "oily ", "oozing ", "opaque ",
   "opulent ", "orbital ", "persuasive ", "pickled ", "poor ",
   "pregnant ", "protozoan ", "puce ", "pulsating ", "purple ",
   "putrid ", "radical ", "radioactive ", "red ", "reformed ",
   "reincarnated ", "rubber ", "Russian ", "screaming ", "sexy ",
   "shiftless ", "shifty ", "Siamese ", "silver ", "sin-ridden ",
   "sinister ", "sizzling ", "skeptical ", "slack-producing ",
   "sleeping ", "slick ", "slime-dripping ", "slimy ", "slippery ",
   "sluggish ", "smoking ", "solid gold ", "splendid ", "squamous ",
   "stoned ", "sweet ", "temporary ", "throbbing ", "tin-plated ",
   "tiny ", "transient ", "treacherous ", "tubular ", "ugly ",
   "untouchable ", "user-friendly ", "user-serviceable ", "vacant ",
   "vacillating ", "vampiric ", "vibrant ", "virginal ", "vivid ",
   "wealthy ", "well-dressed ", "white ", "wimpy ", "worthless ",
   "young ","illegal ", "tax-free ", "drugged ", "polluted ",
   "flaming ", "diseased ", "agnostic ","anorexic ", "conquering ",
   "cosmic ", "dancing ", "dyslexic ", "frenzied ", "lumpy ", "musical ",
   "plump ", "perfectly ordinary ", "French ", "Martian ",
   "beautiful ", "broken ", "corruscating ", "enhanced ", "frightening ", 
   "horrific ", "mythical ", "rugose ", "upgraded ");

our(@names) = 
  ("007 ", "a dead relative ", "a long-lost uncle ","a dead rock star ",
   "Abdul Al-Azrad ", "Abraham Lincoln ", "Bill Gates ",
   "Albert Einstein ", "Ali Baba ", "Aladdin ",
   "Batman ", "Buck Rogers ",
   "Bullwinkle ", "Captain Ahab ", "Captain America ", "Captain Kirk ",
   "Captain Nemo ", "Charlie Brown ", "Cthulhu ", "Dilbert ",
   "Darth Vader ", "Dave Letterman ", "Uncle Bob ",
   "Dracula ", "Elvis ",
   "Erik Bloodaxe ", "Evil Stevie ", "Fearless Leader ",
   "Flaming Carrot ",
   "George Lucas ", "Gerald Ford ",
   "Gandhi ", "Grandmother ", "Gumby ", "Hamlet ",
   "Han Solo ", "Hitler ", "Hulk Hogan ",
   "Hunter S. Thompson ", "Internal Security ", 
   "Isaac Asimov ", "Jack the Ripper ",
   "Jimmy Carter ", "Johnny-B-Gud ",
   "Joseph Stalin ", "King Arthur ", "King Tut ",
   "Lex Luthor ", "Luke Skywalker ", 
   "Michael Jordan ", "Mick Jagger ",
   "Mr. Bill ", "Mr. Ed ", "Mr. Science ",
   "Mr. Spock ", "Nelson Mandela ", "Nixon ",
   "Norman Bates ", "Obi-Wan Kenobi ", "Oliver North ", 
   "Paul Newman ", "Perry Mason ", "Princess Leia ",
   "Rambo ", "Ringo ", "Robby the Robot ",
   "Robert Heinlein ", "Rocky ", "Roger Rabbit ", "Ronald Reagan ",
   "Scrooge ", "Sir Lancelot ", "Snoopy ", 
   "Spiderman ", "Squad 23 ", "Steve ", "Steven Spielberg ", "Superman ",
   "the A.C.L.U. ", "The Computer ", "the Discordian ", "Sir Paul ",
   "the Hand ", "The Illuminati ", "the Joker ", "the Legion of Doom ",
   "the ninja ", 
   "the Secret Master ",
   "the Secret Service ", "the vice squad ", "Thor ", 
   "Tiny Tim ", "Tweety-Bird ", "Uncle Duke ", "Weird Al ",
   "Winston Churchill ", "yo' mama ", "your brother ",
   "your evil twin ", "your father ", "your mother ", "your sister ",
   "Zaphod Beeblebrox ", "Zeus ", "Zonker ","Donovan's Brain ",
   "Jimmy Hoffa ","Tristero ","the Archdean ","Asmodeus ",
   "Archangel Gabriel ", "Al-Qaeda ", "Angel ", "Arnold Schwarzenegger ", 
   "Barry Bonds ", "Bill Clinton ", "Bill O'Reilly ", "Britney Spears ", 
   "Bud Selig ", "Buffy ", "Captain Archer ", "Condoleeza Rice ", 
   "Dick Cheney ", "Harry Potter ", "Harvey Birdman ", "Hillary Clinton ", 
   "Jacques Chirac ", "Jay Leno ", "Joe Montana ", "John Ashcroft ", 
   "Jon Stewart ", "Karl Rove ", "LeBron James ", "Neo ", 
   "Osama bin-Laden ", "Peter Jackson ", "President Bartlett ", 
   "President Bush ", "Saddam Hussein ", "Sponge Bob Square Pants ", 
   "T'Pol ", "Tony Blair ", "the American Idol ", "the Bachelor ", 
   "the Bachelorette ", "the Crocodile Hunter ", "the Dixie Chicks ", 
   "the Powerpuff Girls "
);

our(@places) = ("(not available at your clearance) ", "Afghanistan ", 
   "Alpha Centauri ",
   "Alpha Complex ", "Atlantis ", "Austin ", "Baghdad ", "Berkeley ", "Berlin ",
   "Buckingham Palace ", "Callahan's Place ", "Cheyenne Mountain ",
   "Chicago ", "Cyberworld ", "Dallas ", "Death Valley ", "Dime Box ",
   "Endsville ", "Gasoline Alley ", "Gotham City ", "headquarters ", "Hell ",
   "Hollywood ", "Hong Kong ", "Iran ", "Iraq ", "Israel ",
   "Joe's Bar and Grill ", "Kabul ", "Katmandu ", "Lake Geneva ", "Las Vegas ",
   "left field ", "Lithuania ", "London ", "Los Angeles ", "Main Street ",
   "Mars ", "Middle-earth ", "Mission Control ", "Mordor ", "Moscow ",
   "Munich ", "my back yard ", "Peking ", "Poland ",
   "San Francisco ", "Siberia ", "Sixth Street ", "SJ Games ",
   "Switzerland ", "Tel Aviv ", "the back forty ", "the Bastille ",
   "the bathroom ", "the best place possible ", "the brewery ",
   "the Bat Cave ", "the corner bar ", "the dentists' convention ",
   "the doghouse ", "the dumpster ", "the editorial department ",
   "the Empire State Building ", "the hackers' convention ",
   "the home of a trusted friend ", "the Hotel California ", 
   "the Last National Bank ", "the North Pole ", "the ocean ", 
   "the outback ", "the Phoenix Project ", "the river ", 
   "the same place as before ", "the service station ", "the South Pole ", 
   "the Super Bowl ", "the tavern ", "the toxic waste dump ", 
   "the U.S. Attorney's Office ", "the Vatican ", "the Watergate Hotel ", 
   "the White House ", "Toledo ", "Topeka ", "Uranus ", "Wall Street ", 
   "you-know-where ", "your place ", "Yrth ","the Death Star ",
   "beautiful downtown Burbank ", "Smallville ", "the Shire ");

our(@prepositions) = 
  ("assumes responsibility for ", "avoids servants of ", 
   "deals with ", "elopes with ", "evades agents of ", "flees from ", 
   "flees to ", "flies to ", "flies toward ", "goes for ", "goes to ",
   "has finished in ", "has left with ", "hides in ", "is attacked by ",
   "is commanded by ", "is concerned about ", "is contaminated by ",
   "is destroyed by ", "is distressed by ", "is financed by ",
   "is fondled by ", "is found by ", "is imitated by ", "is infiltrated by ",
   "is joined by ", "is like a god to ", "is removed by ", 
   "is the patron of ", "is threatened by ", "listens to ", "makes fun of ",
   "may not visit ", "moves to ", "originates from ", "reports to ",
   "retreats from ", "returns to ", "shoots henchmen of ",
   "should watch for ", "steals from ", "takes blame for ",
   "takes control of ", "takes no notice of ", "takes refuge in ",
   "travels to ", "walks to ", "was eliminated by ", "was seen in ",
   "will go to ", "withdraws from ", "assumed responsibility for ", 
   "avoided servants of ","has dealt with ", "eloped with ", 
   "evaded agents of ", "fled from ", "fled to ", "flew to ", 
   "flew toward ", "has gone for ", "went to ", "hides in ",
   "was attacked by ", "was commanded by ", "was concerned about ", 
   "was contaminated by ", "was destroyed by ", "was distressed by ", 
   "was financed by ", "was fondled by ", "was found by ", 
   "was imitated by ", "was infiltrated by ", "was joined by ", 
   "was removed by ", "was the patron of ", "was threatened by ", 
   "listened to ", "made fun of ", "moved to ", "originated from ", 
   "reported to ", "retreated from ", "returned to ", "shot henchmen of ",
   "watched for ", "stole from ", "took blame for ", "took control of ", 
   "took no notice of ", "took refuge in ", "traveled to ", 
   "walked to ","withdrew from ", "plays with ", "played with ", 
   "is assassinated by ", "was assassinated by ", "is boggled by ",
   "was boggled by ", "performs surgical alternations on ");


our(@actions) = 
  ("amuses ", "avoids ", "berates ", "boggles ", "bothers ",
   "buries ", "catches ", "commands ", "contaminates ", "controls ",
   "converts ", "delivers ", "destroys ", "disfigures ", "eats ", "enters ",
   "fondles ", "handles ", "harasses ", "hassles ", "helps ",
   "imitates ", "infiltrates ", "inherits ", "joins ", "kills ", "leaves ",
   "massages ", "molests ", "persuades ", "perverts ", "pitches ",
   "rebuilds ", "reinforces ", "removes ", "replaces ", "resurrects ",
   "saves ", "serves ", "spanks ", "squeezes ", "strokes ", "subverts ",
   "swallows ", "swats ", "torments ", "tortures ", "transforms ", 
   "whips ","teases ", "stomps ", "mates with ", "tickles ", "audits ",
   "beats ", "defeats ", "outwits ","manipulates ", "defects to ", 
   "titillates ", "perverts ", "defenestrates ", "discards ",
   "abandons ", "talks to ", "talks back to ", "allies with ",
   "discovers ", "betrays ", "assassinates ", "promotes ", 
   "pretends to be ", "disguises ", "disobeys ", "alters ",
   "intimidates ");

our(@pronouns) = ("his ", "my ", "our ", "the ", "your ");

our(@intros) = 
  ("4 out of 5 dentists recommend that ","Abort immediately unless ",
   "Abort previous sequence. ","Advance code sequence. ",
   "Alert all stations! ","Confirmed report: ",
   "Contrary to popular belief, ","Delete all evidence that ",
   "Determine whether ","E.F. Hutton says ","Effective immediately, ",
   "Enemy agents now know that ","Fnord! ","Follow plan x if ",
   "Ignore previous message. ","Ignore this message. ","Imperative that ",
   "It appears that ","It is not true that ",
   "Most people surveyed believe that ","Observe and report if ",
   "Oral Roberts dreamed that ","Our foes believe that ",
   "Our reporters claim that ","Pentagon officials deny that ",
   "Please investigate report that ","Step up operation. ",
   "Terminate operation if ", "The surgeon general warns that ",
   "Unsubstantiated rumor: ","Urgent! ","Usual sources confirm that ",
   "Warning! ","We suspect that ");

our(@nouns) = 
  ("911 file ", "(censored) ", "amethyst ", 
   "amulet ", "ash tray ", "baby ", "BBS ", "beer bottle ", "blueprint ",
   "boat ", "book ", "bowling ball ", "business card ", "button ", "cable ",
   "cactus ", "cannibal ", "capsule ", "carnation ", "cash ", "cat ",
   "cauliflower ", "chainsaw ", "chair ", "chicken ", "club ", "cockroach ",
   "code wheel ", "coke can ", "compact disc ", "computer ", "cork ",
   "couch ", "cow ", "crystal ", "cummerbund ",
   "cyberdeck ", "demon ", "devil ", "diamond ", "dictaphone ", "dictator ",
   "dinosaur ", "disk drive ", "document ", "dragon ", "drug ", "duck ",
   "elephant ", "engine ", "eye ", "file ", "flag ", "floppy disk ",
   "fly ", "football ", "frame ", "frog ", "geographer ", "goldfish ",
   "grasshopper ", "grimoire ", "gyroslugger ", "hammer ", "hat ",
   "hat-rack ", "helmet ", "hemisphere ", "hot tub ", "hypodermic ",
   "ice cream ", "ID card ", "iguana ", "implement ", "infant ", "insect ",
   "jellybean ", "jet ", "jet ski ", "jukebox ", "kitten ", "Klingon ",
   "krugerrand ", "kumquat ", "lamp ", "light bulb ", "machine gun ",
   "mallet ", "manuscript ", "mason jar ", "message ", "mosquito ",
   "motorcycle ", "mouse ", "oar ", "octopus ", "olive ", "ostrich ",
   "paddle ", "paintbrush ", "paper clip ", "passport ", "password file ",
   "password ", "pendant ", "penguin ", "petunia ", "phased plasma rifle ",
   "phone ", "photocopy ", "piranha ", "pistol ", "pit viper ", "plant ",
   "playtester ", "pop tart ", "power drill ", "ptarmigan ", "pterodactyl ",
   "puppy ", "pyramid ", "racquetball ", "radio ", "railroad ", "razor ",
   "rescuer ", "ring ", "rom chip ", "saber ", "saxophone ", "scenario ",
   "scraper ", "screwdriver ", "scuba mask ", "sculpture ", "sex toy ",
   "shark ", "shoggoth ", "skateboard ", "ski lift ", "skillet ",
   "spark plug ", "spider ", "submarine ", "surfboard ", "sword ", 
   "teddy bear ", "telegram ", "television ", "tennis ball ", "termite ", 
   "textbook ", "toast ", "tornado ", "traitor ", "transmitter ", 
   "treasure chest ", "tree ", "trolley ", "trumpet ", "typewriter ", 
   "user's manual ", "Uzi ", "van ", "virus ", "volleyball ", "wand ", 
   "wheel ", "whip ", "yak ", "Zulu ","INWO deck ", "ukelele ", "icon ",
   "amphibian ", "toad ", "terminal ", "additive ", "piccolo ", "tuba ", 
   "angel ", "demon ", "CD-ROM ", "DVD ", "Deep One ", "Handheld ", "MP3 ", "Segway ", "dog ", "iMac ", "laptop ", "nanite ");

sub p_intro {
    return $intros[int(rand($#intros+1))];
}
sub p_noun {
    return $nouns[int(rand($#nouns+1))];
}
sub p_name {
    return $names[int(rand($#names+1))];
}
sub p_place {
    return $places[int(rand($#places+1))];
}
sub p_prs {
    return $prepositions[int(rand($#prepositions+1))];
}
sub p_act {
    return $actions[int(rand($#actions+1))];
}
sub p_pronoun {
    return $pronouns[int(rand($#pronouns+1))];
}
sub p_adj {
    return $adjectives[int(rand($#adjectives+1))];
}

sub fnorder {
   my($syntax) = int(rand(14));
   my($msg) = "";
				# GRAMMAR RULES:
				# -----------------------------------
if ($syntax == 0) {
    $msg .= "The ";		# The
    if (int(rand(2)) > 0) {     # <adjective>  (50% chance)
	$msg .= &p_adj();
    }
    $msg .= &p_noun();		# <noun>
    if (int(rand(5))==0) {	# in <someplace>   (20% chance)
	$msg .= "in ";
	$msg .= &p_place();
    }
    $msg .= "is ";		# is
    $msg .= &p_adj();		# <adjective>
}
elsif ($syntax == 1) {
    $msg .= &p_name();		# <name>
    $msg .= &p_act();		# <action>
    $msg .= "the ";		# the
    $msg .= &p_adj();		# <adjective>
    $msg .= &p_noun();		# <noun>
    $msg .= "and the ";		# and the
    $msg .= &p_adj();		# <adjective>
    $msg .= &p_noun();		# <noun>
}
elsif ($syntax == 2) {
    $msg .= "The ";		# The
    $msg .= &p_noun();		# <noun>
    $msg .= "from ";		# from
    $msg .= &p_place();		# <place>
    $msg .= "will go to ";	# will go to 
    $msg .= &p_place();		# <place>
}
elsif ($syntax == 3) {
    $msg .= &p_name();		# <name>
    $msg .= "must take the ";	# must take the
    $msg .= &p_adj();		# <adjective>
    $msg .= &p_noun();		# <noun>
    $msg .= "from ";		# from
    $msg .= &p_place();		# <place>
}
elsif ($syntax == 4) {
    $msg .= &p_place();		# <place>
    $msg .= "is ";		# is
    $msg .= &p_adj();		# <adjective>
    $msg .= "and the ";		# and the
    $msg .= &p_noun();		# <noun>
    $msg .= "is ";		# is
    $msg .= &p_adj();		# <adjective>
}
elsif ($syntax == 5) {
    $msg .= &p_name();		# <name>
    $msg .= &p_prs();		# <preposition>
    $msg .= &p_place();		# <place>
    $msg .= "for the ";		# for the
    $msg .= &p_adj();		# <adjective>
    $msg .= &p_noun();		# <noun>
}
elsif ($syntax == 6) {
    $msg .= "The ";		# The
    if (int(rand(2)) > 0) {
	$msg .= &p_adj();	# <adjective> (50% chance)
    }
    $msg .= &p_noun();		# <noun>
    $msg .= &p_act();		# <action>
    $msg .= "the ";		# the
    $msg .= &p_adj();		# <adjective>
    $msg .= &p_noun();		# <noun>
    if (int(rand(5))==0) {		# in <place>  (20% chance)
	$msg .= "in ";
	$msg .= &p_place();
    }
}
elsif ($syntax == 7) {
    $msg .= &p_name();		# <name>
    $msg .= &p_prs();		# <preposition>
    $msg .= &p_place();		# <place>
    $msg .= "and ";		# and
    $msg .= &p_act();		# <action>
    $msg .= "the ";		# the
    $msg .= &p_noun();		# <noun>
}
elsif ($syntax == 8) {
    $msg .= &p_name();		# <name>
    $msg .= "takes ";		# takes
    $msg .= &p_pronoun();	# <pronoun>
    if (int(rand(2)) > 0) {	      
	$msg .= &p_adj();	# <adjective> (50% chance)
    }
    $msg .= &p_noun();		# <noun>
    $msg .= "and ";		# and
    $msg .= &p_prs();		# <preposition>
    $msg .= &p_place();		# <place>
}
elsif ($syntax == 9) {
    $msg .= &p_name();		# <name>
    $msg .= &p_act();		# <action>
    $msg .= "the ";		# the
    if (int(rand(2)) > 0) {
	$msg .= &p_adj();	# <adjective> (50% chance)
    }
    $msg .= &p_noun();		# <noun>
}
elsif ($syntax == 10) {
    $msg .= &p_name();		# <name>
    $msg .= &p_act();		# <action>
    $msg .= &p_name();		# <name>
    $msg .= "and ";		# and
    $msg .= &p_pronoun();	# <pronoun>
    if (int(rand(2)) > 0) {
	$msg .= &p_adj();	# <adjective> (50% chance)
    }
    $msg .= &p_noun();		# <noun>
}
elsif ($syntax == 11) {
    $msg .= &p_name();		# <name>
    $msg .= "is the ";		# is the
    if (int(rand(2)) > 0) {	   
	$msg .= &p_adj();	# <adjective) (50% chance)
    }			 
    $msg .= &p_noun();		# <noun>
    chop($msg);
    $msg .= "; ";		# ;
    $msg .= &p_name();		# <name>
    $msg .= &p_prs();		# <preposition>
    $msg .= &p_place();		# <place>
}
elsif ($syntax == 12) {
    $msg .= "You must meet ";	# You must meet
    $msg .= &p_name();		# <name>
    $msg .= "at ";		# at
    $msg .= &p_place();		# <place>
    $msg .= "and get the ";	# and get the
    if (int(rand(2)) > 0) {
	$msg .= &p_adj();	# <adjective> (50% chance)
    }
    $msg .= &p_noun();		# <noun>
}
else {
    $msg .= "A ";		# A
    $msg .= &p_noun();		# <noun>
    $msg .= "from ";		# from
    $msg .= &p_place();		# <place>
    $msg .= &p_act();		# <action>
    $msg .= "the ";		# the
    if (int(rand(2)) > 0) {
	$msg .= &p_adj();	# <adjective> (50% chance)
    }
    if (int(rand(5)) == 0) {
	$msg .= &p_adj();	# <adjective> (20% chance)
    }
    $msg .= &p_noun();		# <noun>
}

   chop($msg);			# delete the blank at the end
   $msg .= ".";			# add a period
   return ucfirst($msg);
}


1;
