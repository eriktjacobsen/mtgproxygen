#!/usr/bin/perl
use Cwd;

my $deckfile = $ARGV[0];

# First, read the deck file

open(DECK, $deckfile) or die "Could not open $deckfile: $!";

my %cards;
while(<DECK>)
{   
    chomp;
    if (/^((\d+) +(x )?)?(\w.*)$/)
    {
        my $count = $2;
        my $card  = $4;

        $card =~ tr/ \r/_/d;
        $card = lc($card);

        $cards{$card} = $count;
        
        #print "Found $card with count $count\n";
    }
}
close DECK;

# Next determine output directory
my $cwd = cwd();
opendir(my $dh, $cwd) || die;
my @decks = grep { /^deck\d+/ && -d "$cwd/$_" } readdir($dh);
closedir $dh;

my $max = 0;
for (@decks)
{
    if (/deck(\d+)/)
    {
        #print "evaluating: $1\n";
        $max = ($1,$max)[$max > $1];
    }
}
$max++;
$max = 4;
my $dirname = "deck$max";
mkdir($dirname);

# Now, fetch the images and use thee card count 
# to generate the contents of the sheets
my @cardlist;
foreach my $card (keys %cards)
{
    for (my $i;$i<$cards{$card};$i++)
    {
        push(@cardlist, "$dirname/$card.jpg");
    }
    system("wget", "-O","$dirname/$card.jpg","http://mtgimage.com/card/$card.jpg");
}

# Use image magick to turn our source images into 8.5x11 sheets of 9 cards each
my $screen = 1;
my @arglist;
for (my $i=0;$i<=$#cardlist;$i++)
{
    my $arg = $cardlist[$i];

    $arg =~ s/'/\\'/g;
    push(@arglist,$arg);

    if ($#arglist == 8 || $i == $#cardlist)
    {
        my $param = join(" ",@arglist);
        
        system("montage $param -geometry '1x1<+0+0' $dirname/screen$screen.jpg");
        system("convert","$dirname/screen$screen.jpg",
                    "-bordercolor","White",
                    "-border","105x48",
                    "-extent","1651x2137",
                    "$dirname/screen$screen.jpg");
        $screen++;
        @arglist = ();
    }
}
