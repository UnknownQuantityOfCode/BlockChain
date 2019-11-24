use v5.10;
$|++;

use Data::Dumper;
use BlockChain;

use Digest::SHA qw(sha256_base64);
use Math::Round qw(nearest);

my $first_names = ["Saundra", "Shelba", "Napoleon", "Page", "Brooks", "Robert", "Evyn", "Barry", "Farr", "Den", "Glendon", "Willdon", "Howard", "Tatiana", "Elijah", "Pebrook", "Calvin", "Celinda", "Sue", "Charley", "Windy", "Emery", "Clementia", "Darbee", "Phoebe", "Marijo", "Rhoda", "Iago", "Jack", "Tawnya", "Giorgi", "Boone", "Meghann", "Bill", "Clayborne", "Blake", "Viva", "Rosalynd", "Christabel", "Isacco", "Frannie", "Marylinda", "Matthus", "Boone", "Viviene", "Aldric", "Esra", "Hercules", "Dedra", "Danica", "Meggie", "Nola", "Fionnula", "Kial", "Meta", "Brade", "Marthe", "Samantha", "Durant", "Imojean", "Kyle", "Morgan", "Caritta", "Kayne", "Hyacinthie", "Wat", "Conni", "Gilberto", "Brittni", "Adi", "Humfried", "Enrica", "Sanders", "Yvon", "Jo ann", "Travis", "Casandra", "Raychel", "Kamillah", "Thor", "Gaspard", "Lorrin", "Fernandina", "Delores", "Richardo", "Walther", "Kayla", "Franni", "Faye", "Pauly", "Mandel", "Kelly", "Trev", "Lexie", "Moe", "Isidore", "Thom", "Francine", "Tammy", "Dalton"];
my $last_names = ["Swayte", "Foulis", "Greatbach", "Baldick", "Sainsbury", "Lardeux", "Sandbrook", "Ever", "Yukhnov", "Garahan", "Hewlings", "Climar", "Jarville", "Stares", "Greggor", "Itzkovwitch", "Graser", "Penvarden", "St Louis", "Kunzler", "Ralling", "Fonquernie", "Beecraft", "Bohden", "Guerrero", "Meran", "Bickerstaffe", "Dentith", "Gilardi", "Mattingson", "Giampietro", "Medgewick", "Tschursch", "Stillmann", "Torrecilla", "Powys", "Iwanczyk", "Welman", "Burnsyde", "Stuchbery", "Hinckesman", "Varian", "Simmonite", "Jolly", "Claque", "Howroyd", "Dellenbach", "Hounsham", "Dooher", "Wrangle", "Alejandro", "Gadney", "Gillio", "Duetschens", "Christoforou", "Fittes", "Ruddom", "Wootton", "Marfield", "Tyrwhitt", "Aughton", "Handman", "Cannon", "Ebbetts", "Le Floch", "Ivashkov", "Silly", "Gee", "Bottomer", "Absolon", "Sygroves", "Scoles", "Cawtheray", "Chotty", "Challens", "Smythe", "Sherman", "Fleischmann", "Nutting", "Folca", "Bennetts", "MacCracken", "Heinschke", "Stuffins", "Kleuer", "Tunnoch", "Lyster", "Jochen", "Bernardoni", "Gillani", "Olkowicz", "Castanos", "Chitty", "Bowmaker", "Petrecz", "Shufflebotham", "Leighfield", "Learmont", "Sears", "Bartke"];

my $coins = BlockChain->new(difficulty => 3);
my $to = 10;
foreach my $tran_number (1..$to){
	warn "Block #".$tran_number." of $to (".( nearest( 0.01, ( ( $tran_number / $to ) * 100 ) ) )."%)";
	$coins->addBlock(
		"Transaction" => transactionNumber($tran_number),
		"Seller" => getName(),
		"Buyer" => getName()
	);
}
sleep(2);
$coins->displayChain();
print Dumper $coins;

sub transactionNumber {
	my $number = shift;
	return "#".padLeft($number,6);
}

sub padLeft {
	my ($text, $amount, $char) = @_;
	return ((($char || '0') x ($amount-length($text))) . $text);
}

sub getName {
	return $first_names->[int(rand($#$first_names))].' '.$last_names->[int(rand($#$last_names))].( ( rand(1) > 0.89 ) ? '-'.$last_names->[int(rand($#$last_names))] : '' );
}