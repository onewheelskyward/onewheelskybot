require 'json'
require 'httparty'

# class PedalpaloozaEvent
#   include DataMapper::Resource
#
#   property :id, Serial
#   property :sequence, Integer
#   property :dtstart, String, length: 255
#   property :dtstamp, String, length: 255
#   property :summary, String, length: 2000
#   property :uid, String, length: 255
#   property :description, String, length: 4000
#   property :organizer, String, length: 500
#   property :location, String, length: 2000
#   property :attach, String, length: 2048
# end
#
class PedalPalooza
  include Cinch::Plugin

  # match /(pedalpalooza|pp)\s*$/i,                                                      method: :next_ride
  # match /(pedalpalooza|pp)\s+next/i,                                                   method: :next_ride
  # match /(pedalpalooza|pp)\s+(\d{5}|\d{5}-\d{4})\s+next/i,                             method: :zip_code_next
  # match /(pedalpalooza|pp)\s+(\d{5}|\d{5}-\d{4})\s+(\d+\/\d+\s+\d+:\d+)/i,            method: :zip_code_date_time
  # match /(pedalpalooza|pp)\s+(\d{5}|\d{5}-\d{4})\s+(.*)$/i,                            method: :zip_code_search
  # match /pp reload$/i,                        method: :load_ical

  # set :help, <<-EOF
  # Pedalpalooza search bot!  Find the nearest, or next, or nearest next ride.  Or find something you missed.
  # !pedalpalooza [search]            [search] rides
  # !pedalpalooza [zip] [search]      [search] rides nearest to zip
  # !pedalpalooza next                Next ride, anywhere.
  # !pedalpalooza [zip] next          Next ride nearest to [zip]
  # !pedalpalooza [time/date]         Next ride after specified time/date.  e.g. 6/10 16:45
  # !pedalpalooza [zip] [time/date]   Rides near [zip] after [time/date]
  # !pedalpalooza past [search]       Past rides, optionally specifying [search]
  # EOF

  # def execute (msg, query)
  #   msg.reply(['nice try.', 'Nuh-uh', 'Not yet', 'workin\' on it', 'under construction'].sample)
  # end

  # def load_ical
  #   in_event = false
  #   last_key = nil
  #
  #   todo: get ical from web
    # PedalpaloozaEvent.delete
    # @ical.split("\n").each do |line|
    #   if line.scan /^BEGIN:VEVENT$/
    #     event = PedalpaloozaEvent.new()
    #     in_event = true
    #   end
    #   if line.scan /^END:VEVENT$/
    #     in_event = false
    #     puts event.inspect
    #     puts event.valid?
    #     puts event.save
    #   end
    #
    #   if in_event
    #     if matches = line.match(/^([A-Za-z;\/=]+):(.*)/)
    #       todo: named regex
          # key = matches[0].downcase
          # data = matches[1]

          # if key.match /^DTSTART/ # Little hack for the DTSTART;TZID=US/Pacific key.
          #   key = 'dtstart'
          # end
  # match /pp reload$/i,                        method: :load_ical

  # set :help, <<-EOF
  # Pedalpalooza search bot!  Find the nearest, or next, or nearest next ride.  Or find something you missed.
  # !pedalpalooza [search]            [search] rides
  # !pedalpalooza [zip] [search]      [search] rides nearest to zip
  # !pedalpalooza next                Next ride, anywhere.
  # !pedalpalooza [zip] next          Next ride nearest to [zip]
  # !pedalpalooza [time/date]         Next ride after specified time/date.  e.g. 6/10 16:45
  # !pedalpalooza [zip] [time/date]   Rides near [zip] after [time/date]
  # !pedalpalooza past [search]       Past rides, optionally specifying [search]
  # EOF

  # def execute (msg, query)
  #   msg.reply(['nice try.', 'Nuh-uh', 'Not yet', 'workin\' on it', 'under construction'].sample)
  # end
  #
  # def load_ical
  #   in_event = false
  #   last_key = nil
  #
  #   todo: get ical from web
    # PedalpaloozaEvent.delete
    # @ical.split("\n").each do |line|
    #   if line.scan /^BEGIN:VEVENT$/
    #     event = PedalpaloozaEvent.new()
    #     in_event = true
    #   end
    #   if line.scan /^END:VEVENT$/
    #     in_event = false
    #     puts event.inspect
    #     puts event.valid?
    #     puts event.save
    #   end
    #
    #   if in_event
    #     if matches = line.match(/^([A-Za-z;\/=]+):(.*)/)
    #       todo: named regex
          # key = matches[0].downcase
          # data = matches[1]
          #
          # if key.match /^DTSTART/ # Little hack for the DTSTART;TZID=US/Pacific key.
          #   key = 'dtstart'
          # end
          #
          # event[key] = data
          # last_key = key
        # elsif matches = line.match(/\s{2}(.*)/)    # line continuations.
        #   event[last_key] += " #{matches[0]}"
        #  end
      #
      # end
    # end
  # end
  @ical =<<END
BEGIN:VCALENDAR
CALSCALE:GREGORIAN
X-WR-TIMEZONE;VALUE=TEXT:US/Pacific
METHOD:PUBLISH
PRODID:-//Shift Calendar//Pedalpalooza//EN
X-WR-CALNAME;VALUE=TEXT:PedalpaloozaVERSION:2.0
BEGIN:VEVENT
SEQUENCE:1
DTSTART;TZID=US/Pacific:20140605T150000
DTSTAMP:20140602T000000
SUMMARY:Summer of Patrick!
UID:20140605.4271@shift2bikes.org
DESCRIPTION:Hi, I'm Patrick. Help me kick off the Summer of Patrick with
  some day drinking on a Thursday.
ORGANIZER:Patrick, duh, ploftus12@gmail.com
LOCATION:Vera Katz Statue, SE Eastbank Esplanade and Main St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4271
END:VEVENT
BEGIN:VEVENT
SEQUENCE:2
DTSTART;TZID=US/Pacific:20140605T173000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:feminism n bikes r 4 everybody
UID:20140605.4257@shift2bikes.org
DESCRIPTION:Spread some feminist joy by bike. Meet new friends. This ride
  will join the kickoff ride.
ORGANIZER:Dede Desperate, dededesperate@yahoo.com
LOCATION:PSU PARK BLOCKS, Sw Market & Mill St.  (LOOK FOR BIKES)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4257
END:VEVENT
BEGIN:VEVENT
SEQUENCE:3
DTSTART;TZID=US/Pacific:20140605T173000
DTSTAMP:20140602T000000
SUMMARY:Cycling Sojourner Washington Book Launch
UID:20140605.4259@shift2bikes.org
DESCRIPTION:Come on out to celebrate the launch of Cycling Sojourner
  Washington, the latest title from Into Action Publications!
ORGANIZER:Ellee Thalheimer, http://www.cyclingsojourner.com/
LOCATION:Velocult, 1969 NE 42nd Avenue
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4259
END:VEVENT
BEGIN:VEVENT
SEQUENCE:4
DTSTART;TZID=US/Pacific:20140605T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:B4HPDX Free Volunteer Mechanics Class
UID:20140605.4125@shift2bikes.org
DESCRIPTION:Those willing to volunteer 10 hours for Bikes for Humanity may
  attend this 24-hour bike mechanics class.
ORGANIZER:Steven, b4hpdx@gmail.com, http://www.b4hpdx.org/
LOCATION:Bikes For Humanity PDX, 4038 SE Brooklyn Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4125
END:VEVENT
BEGIN:VEVENT
SEQUENCE:5
DTSTART;TZID=US/Pacific:20140605T180000
DTSTAMP:20140602T000000
SUMMARY: Pedalpalooza Kickoff Ride
UID:20140605.4294@shift2bikes.org
DESCRIPTION:It's the opening ceremony, the inaugural calamity, the first
  fiasco of Pedalpalooza 2014. Dress up. Bring friends.
ORGANIZER:Matheas Michaels
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4294
END:VEVENT
BEGIN:VEVENT
SEQUENCE:6
DTSTART;TZID=US/Pacific:20140605T190000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Portland Zine Symposium Bike-In Movie
UID:20140605.4233@shift2bikes.org
DESCRIPTION:The Portland Zine Symposium's annual bike-in movie will be the
  1983 Australian classic "BMX Bandits." 80s attire encouraged.
ORGANIZER:Portland Zine Symposium, pdxzines@gmail.com,
  http://www.portlandzinesymposium.org/
LOCATION:Independent Publishing Resource Center, 1001 SE Division St.,
  Portland OR
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4233
END:VEVENT
BEGIN:VEVENT
SEQUENCE:7
DTSTART;TZID=US/Pacific:20140605T190000
DTSTAMP:20140602T000000
SUMMARY:Unicycle Polo
UID:20140605.4302@shift2bikes.org
DESCRIPTION:Do you ride a unicycle? Would you like the chance to attack
  people with a stick, while unicycling? Just want to watch?
ORGANIZER:Hamilton H. Orr, ubtumblr@gmail.com,
  http://www.unicyclebastards.com/
LOCATION:Alberta Park Bike Polo Court, NE 22nd Ave and Killingsworth St.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4302
END:VEVENT
BEGIN:VEVENT
SEQUENCE:8
DTSTART;TZID=US/Pacific:20140605T230000
DTSTAMP:20140602T000000
SUMMARY:backdoor ride
UID:20140605.4326@shift2bikes.org
DESCRIPTION:Urban exploration! Private land is illegitimate, the backdoor
  is open. Hidden spaces beckon, begging us to come play.
ORGANIZER:jaya, jaya.jeptha@gmail.com, 503-380-2573
LOCATION:washington high school, SE 14th & SE Stark
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#05-4326
END:VEVENT
BEGIN:VEVENT
SEQUENCE:9
DTSTART;TZID=US/Pacific:20140606T070000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Breakfast on the Bridges
UID:20140606.4477@shift2bikes.org
DESCRIPTION:Stop for some coffee, treats, and camaraderie. Running late?
  We've got tardy slips! A Portland tradition since 2002.
ORGANIZER:Shift,
  http://www.shift2bikes.org/wikiwiki/bikefun:breakfast_on_the_bridges
LOCATION:Hawthorne, Burnside, and Lower Steel Bridges
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4477
END:VEVENT
BEGIN:VEVENT
SEQUENCE:10
DTSTART;TZID=US/Pacific:20140606T130000
DTSTAMP:20140602T000000
SUMMARY:Ride the Burnt Bridge
UID:20140606.4174@shift2bikes.org
DESCRIPTION:A 30.5 mile loop ride of the Burnt Bridge Creek Trail and the
  Marine Drive path going over both Columbia River bridges.
ORGANIZER:Tom, nagitpo@gmail.com
LOCATION:Cascades MAX Station, Stop ID 10574, NE Mt St Helens Ave,
  Portland, OR 97220 (Meet by the South benches at the MAX station)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4174
END:VEVENT
BEGIN:VEVENT
SEQUENCE:11
DTSTART;TZID=US/Pacific:20140606T170000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Hop(s) on an EBike
UID:20140606.4404@shift2bikes.org
DESCRIPTION:Welcome to our new ebike store! Try an electric bike today and
  receive a token for a complimentary beer at Hopworks.
ORGANIZER:Cynergy E-Bikes, 503-719-7678
LOCATION:3822 SE Powell Blvd
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4404
END:VEVENT
BEGIN:VEVENT
SEQUENCE:12
DTSTART;TZID=US/Pacific:20140606T173000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Beer, Bikes & Blood: LIZZIE the musical
UID:20140606.4325@shift2bikes.org
DESCRIPTION:Discount ($20) tickets to a musical about 1890s ax murder
  preceded by a free bikey preparty with snacks and beer? Deal.
ORGANIZER:Portland Center Stage, aliceh@pcs.org,
  http://www.pcs.org/blog/item/beer-bikes-blood/
LOCATION:The Gerding Theater at the Armory, 128 NW 11th Ave, Portland, OR
  97209
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4325
END:VEVENT
BEGIN:VEVENT
SEQUENCE:13
DTSTART;TZID=US/Pacific:20140606T173000
DTSTAMP:20140602T000000
SUMMARY:Skate Skavenger Hunt
UID:20140606.4415@shift2bikes.org
DESCRIPTION:Skate the town in search of anything n' everything. Bring a
  digital camera, friends, and your skateboard or rollerskates
ORGANIZER:Billy Bones
LOCATION:Naito Legacy Fountain, SW Ankeny and SW Naito Parkway
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4415
END:VEVENT
BEGIN:VEVENT
SEQUENCE:14
DTSTART;TZID=US/Pacific:20140606T180000
DURATION:PT8H0M0S
DTSTAMP:20140602T000000
SUMMARY:Morrissey Mobile Disco
UID:20140606.4200@shift2bikes.org
DESCRIPTION:4th annual latenight music-lovin' roving dance party!
  Costumery, tomfoolery, booze. All hail The Moz!
ORGANIZER:Rhienna, Twitter: @djrhienna
LOCATION:Salmon Street Springs Fountain, SW Naito Pkwy & Salmon St (Ring
  around the fountain...)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4200
END:VEVENT
BEGIN:VEVENT
SEQUENCE:15
DTSTART;TZID=US/Pacific:20140606T180000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Pop Til' You Puke 3
UID:20140606.4225@shift2bikes.org
DESCRIPTION:80s pop, dancing, multiple stops with food and drink... need we
  say more?
ORGANIZER:Lance Poehler, lancepoehler@gmail.com
LOCATION:Bottom West Side of the Steel Bridge, Bottom West Steel Bridge
  (Bottom West Side of the Steel Bridge)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4225
END:VEVENT
BEGIN:VEVENT
SEQUENCE:16
DTSTART;TZID=US/Pacific:20140606T184500
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Yoga Ride
UID:20140606.4460@shift2bikes.org
DESCRIPTION:Meet at 6:50pm, NE entrance to Laurelhurst Park, ride to 7831
  SE Stark for FREE Yoga for Cyclists class at 7:30
ORGANIZER:Joel Holly, info@yogarefugepdx.com, 702-907-7831
LOCATION:Laurelhurst Park, 3700 SE Ankeny St (NE entrance)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4460
END:VEVENT
BEGIN:VEVENT
SEQUENCE:17
DTSTART;TZID=US/Pacific:20140606T190000
DTSTAMP:20140602T000000
SUMMARY:Dirty Diablo's Wild Ride!
UID:20140606.4446@shift2bikes.org
DESCRIPTION:Bicycle Dance Party! Wild Devilish Delights! Come Run with the
  Devil! FREAK OUT!
ORGANIZER:Diablo, http://bit.ly/DirtyDiabloRide2014
LOCATION:Devil's Point, 5305 SE Foster Rd (Show up early, relax, grab a
  beverage . . .)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4446
END:VEVENT
BEGIN:VEVENT
SEQUENCE:18
DTSTART;TZID=US/Pacific:20140606T190000
DTSTAMP:20140602T000000
SUMMARY:Bike Swarm Kick-Off Keg Ride
UID:20140606.4486@shift2bikes.org
DESCRIPTION:PDX Bike Swarm's Pedalpalooza Kick-Off Keg Ride, featuring a
  mobile keg of Cascadian Dark Ale!
ORGANIZER:PDX Bike Swarm, http://facebook.com/pdxbikeswarm/
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4486
END:VEVENT
BEGIN:VEVENT
SEQUENCE:19
DTSTART;TZID=US/Pacific:20140606T200000
DTSTAMP:20140602T000000
SUMMARY:Superhero(ine) Ride!
UID:20140606.4341@shift2bikes.org
DESCRIPTION:Grab your favorite sidekick, cape and steed-- join us in the
  fight for Truth, Justice and the Dream of the 90's!
ORGANIZER:Captain Fiasco, camelsauce@hotmail.com
LOCATION:Col. Summers Park, SE 20th and Belmont (On the asphalt in the
  middle of the park.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4341
END:VEVENT
BEGIN:VEVENT
SEQUENCE:20
DTSTART;TZID=US/Pacific:20140606T200000
DTSTAMP:20140602T000000
SUMMARY:#IWokeUpLikeThis
UID:20140606.4389@shift2bikes.org
DESCRIPTION:Let's celebrate us. Dress to impress // wear whatever you want
  because you’re flawless. Surfbort.
ORGANIZER:Andrew Sasquatch, andrewpmerriam@gmail.com, 505-238-9166
LOCATION:Irving Park, NE 7th Ave and Fargo St, Portland (You'll see us.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4389
END:VEVENT
BEGIN:VEVENT
SEQUENCE:21
DTSTART;TZID=US/Pacific:20140606T210000
DTSTAMP:20140602T000000
SUMMARY:Dead Baby Bikes Club Ride
UID:20140606.3478@shift2bikes.org
DESCRIPTION:We wanna be free...free to ride our machines without being
  hassled by the man. And we want to get loaded.
ORGANIZER:Dead Baby Bikes
LOCATION:APEX, 1216 SE Division
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-3478
END:VEVENT
BEGIN:VEVENT
SEQUENCE:22
DTSTART;TZID=US/Pacific:20140606T220000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:The Guthrie Ride
UID:20140606.4213@shift2bikes.org
DESCRIPTION:An enjoyable, mild paced, adventurous ride. Technically,
  helmets are legally required for one part (hint hint!).
ORGANIZER:Guthrie
LOCATION:1101 NE Alberta St Portland, OR 97211 (Across from Radio Room in
  the Parking Lot)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#06-4213
END:VEVENT
BEGIN:VEVENT
SEQUENCE:23
DTSTART;TZID=US/Pacific:20140607T100000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Bikes for Humanity Volunteer Repair Clinics
UID:20140607.2528@shift2bikes.org
DESCRIPTION:Learn bike repair skills FREE by helping refurbish bikes for a
  non-profit project. Details at www.b4hpdx.org
ORGANIZER:Steven
LOCATION:B4HPDX Store, 3354 SE Powell Blvd. Portland Oregon
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-2528
END:VEVENT
BEGIN:VEVENT
SEQUENCE:24
DTSTART;TZID=US/Pacific:20140607T100000
DURATION:PT6H0M0S
DTSTAMP:20140602T000000
SUMMARY:Sweat for Sweets II
UID:20140607.4337@shift2bikes.org
DESCRIPTION:If you like sugar, North Clackamas County, soda fountains, and
  B-17 Bombers you'll LOVE this ride. Bring $.
ORGANIZER:Jason Johnson, 503-334-9022
LOCATION:JaCiva , 4733 SE Hawthorne Blvd
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4337
END:VEVENT
BEGIN:VEVENT
SEQUENCE:25
DTSTART;TZID=US/Pacific:20140607T103000
DURATION:PT6H0M0S
DTSTAMP:20140602T000000
SUMMARY:Rough Stuff/Country Bike (in the city) Ramble
UID:20140607.4267@shift2bikes.org
DESCRIPTION:20-30mi not-a-loop ramble exploring dirt roads and unknown
  places on comfortable bikes. Some climbs, moderate pace.
ORGANIZER:adventure!, http://urbanadventureleague.wordpress.com/
LOCATION:Woodlawn Park (under the bridge), NE Dekum St and Bellevue Ave
  (Meet under the bridge)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4267
END:VEVENT
BEGIN:VEVENT
SEQUENCE:26
DTSTART;TZID=US/Pacific:20140607T103000
DTSTAMP:20140602T000000
SUMMARY:Food Carts 4 Charity! - Food Carts & Markets!
UID:20140607.4379@shift2bikes.org
DESCRIPTION:Join us as we discover the connections between Farmers Markets
  & Food Carts, Bring $ for Purchases
ORGANIZER:Scott Batchelar , http://www.fc4c.org/, Follow our twitters
  @fc4charity @FC4CPDX
LOCATION:Holladay Park, NE Multnomah betw NE 11th & 13th
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4379
END:VEVENT
BEGIN:VEVENT
SEQUENCE:27
DTSTART;TZID=US/Pacific:20140607T110000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Morning Naked Ride
UID:20140607.4430@shift2bikes.org
DESCRIPTION:Start the World Naked Bike Ride day right with a morning naked
  ride. Bare as you dare. Cameras discouraged.
ORGANIZER:Ker Nal and Pas't Tire
LOCATION:Irving Park, NE 7th Ave and Fargo St, Portland (Near Basketball
  Pavillion)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4430
END:VEVENT
BEGIN:VEVENT
SEQUENCE:28
DTSTART;TZID=US/Pacific:20140607T110000
DURATION:PT12H0M0S
DTSTAMP:20140602T000000
SUMMARY:Naked Metric Century
UID:20140607.4481@shift2bikes.org
DESCRIPTION:Ride 100 km naked.
ORGANIZER:Ker Nal and Past Tire
LOCATION:Irving Park, NE 7th Ave and Fargo St, Portland (Meet near
  Basketball Pavillion)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4481
END:VEVENT
BEGIN:VEVENT
SEQUENCE:29
DTSTART;TZID=US/Pacific:20140607T140000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Single Speed / Fixed-Friendly Ride
UID:20140607.4188@shift2bikes.org
DESCRIPTION:Finally, a flat ride where you can ride any bike you want,
  especially a cruiser, fixed gear, or single speed.
ORGANIZER:Maria Schur, bicyclekitty@gmail.com,
  http://bicyclekitty.blogspot.com/
LOCATION:Western Bikeworks, 1015 NW 17th Ave (meet inside)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4188
END:VEVENT
BEGIN:VEVENT
SEQUENCE:30
DTSTART;TZID=US/Pacific:20140607T140000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Pedalcar Karaoke III: Ride of Epic Ballads
UID:20140607.4414@shift2bikes.org
DESCRIPTION:We've got the mobile music. You've got the vocal chords.
  Serenade the neighborhood with us! Ends at Hott Sock Ride.
ORGANIZER:Damon Eckhoff & Greg Raisman, pedalcarkaraoke@gmail.com ,
  503-334-8735
LOCATION:Col. Summers Park, SE 20th and Belmont (Near the Pedalcar with
  music.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4414
END:VEVENT
BEGIN:VEVENT
SEQUENCE:31
DTSTART;TZID=US/Pacific:20140607T140000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Sunny Nekkid Ride
UID:20140607.4429@shift2bikes.org
DESCRIPTION:Ride in the sun and celebrate body freedom. Bring paint for art
  and messages. Ends at Fig Leif Ride. Cameras discouraged
ORGANIZER:Past Tire and Ker Nal
LOCATION:Coe Circle, 3900 NE Glisan St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4429
END:VEVENT
BEGIN:VEVENT
SEQUENCE:32
DTSTART;TZID=US/Pacific:20140607T141500
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Heritage Trees of NoPo
UID:20140607.4176@shift2bikes.org
DESCRIPTION:This 10 mile meander will visit and pay tribute to some of
  North Portland's most spectacular and interesting trees.
ORGANIZER:Gregg & Patty, gregg@vitalwellnesscoaching.com, 503-410-1891
LOCATION:Patton Square Park, corner of N. Interstate and N. Emerson
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4176
END:VEVENT
BEGIN:VEVENT
SEQUENCE:33
DTSTART;TZID=US/Pacific:20140607T160000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Gladys Bikes Grand (re)Opening Party
UID:20140607.4310@shift2bikes.org
DESCRIPTION:Celebrate our new space with food from neighboring businesses,
  a keg, prizes, and a photo booth.
ORGANIZER:Gladys Bikes, hello@gladysbikes.com, http://www.gladysbikes.com/
LOCATION:Gladys Bikes, 29th and Alberta
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4310
END:VEVENT
BEGIN:VEVENT
SEQUENCE:34
DTSTART;TZID=US/Pacific:20140607T170000
DTSTAMP:20140602T000000
SUMMARY:LAST Hott Sock Ride
UID:20140607.4161@shift2bikes.org
DESCRIPTION:Join the well-heeled calve-ry for one last fun ride w/ great
  fashion + games @ Sock Dreams+Sock It To Me.
ORGANIZER:Ladies of the Sock, famouspotato@gmail.com
LOCATION:SE Salmon St + Eastbank Esplanade
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4161
END:VEVENT
BEGIN:VEVENT
SEQUENCE:35
DTSTART;TZID=US/Pacific:20140607T170000
DTSTAMP:20140602T000000
SUMMARY:Portlandfixed - Lifeblood Of Bike Culture Ride
UID:20140607.4368@shift2bikes.org
DESCRIPTION:PortlandFixed.com gets together to sacrifice an OG 4Loko in
  honor of their new forum before going on a "ride."
ORGANIZER:Bicycle Illuminati, http://portlandfixed.com
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4368
END:VEVENT
BEGIN:VEVENT
SEQUENCE:36
DTSTART;TZID=US/Pacific:20140607T170000
DTSTAMP:20140602T000000
SUMMARY:Bikini Bike Ride
UID:20140607.4405@shift2bikes.org
DESCRIPTION:Training for the WNBR? Join us for a 2-mile swimsuit-clad ride,
  a free pint of Kona Beer, and 15% OFF a swimsuit!
ORGANIZER:Popina and VeloCult, Poppiswim@gmail.com
LOCATION:Popina Swimwear Hollywood, 2030 NE 42nd Ave.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4405
END:VEVENT
BEGIN:VEVENT
SEQUENCE:37
DTSTART;TZID=US/Pacific:20140607T170000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Fig Leif Naked Bike Ride
UID:20140607.4435@shift2bikes.org
DESCRIPTION:Naked gravel bike ride up car-free NW Leif Erikson Drive in
  Forest Park. Bare as you dare. Concludes in time for WNBR.
ORGANIZER:Henry, Henry5Km@gmail.com
LOCATION:Forest park, top of NW Thurman St. (500 yards beyond the entry
  gate by the Port-a-Potties)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4435
END:VEVENT
BEGIN:VEVENT
SEQUENCE:38
DTSTART;TZID=US/Pacific:20140607T184500
DURATION:PT1H0M0S
DTSTAMP:20140602T000000
SUMMARY:St. Johns Naked Ride
UID:20140607.4409@shift2bikes.org
DESCRIPTION:Going to the Naked Bike Ride? We are too! We'll take
  side-streets for the 10 mi. ride and wear as few clothes as we want
ORGANIZER:Block Bikes
LOCATION:Block Bikes PDX LLC, 7238 N Burlington Ave (We'll move over to the
  plaza across the street if we run out of sidewalk.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4409
END:VEVENT
BEGIN:VEVENT
SEQUENCE:39
DTSTART;TZID=US/Pacific:20140607T200000
DTSTAMP:20140602T000000
SUMMARY:World Naked Bike Ride
UID:20140607.4129@shift2bikes.org
DESCRIPTION:A fun protest against oil dependance, traffic violence, and
  body shaming. Ride as bare as you dare. 7 miles. Not a loop.
ORGANIZER:WNBR Team, http://pdxwnbr.org
LOCATION:Normandale Park, NE 56th Ave and NE Halsey (DO NOT BLOCK HALSEY)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4129
END:VEVENT
BEGIN:VEVENT
SEQUENCE:40
DTSTART;TZID=US/Pacific:20140607T233000
DTSTAMP:20140602T000000
SUMMARY:WNBR After Ride - Late Night Food Carts
UID:20140607.4375@shift2bikes.org
DESCRIPTION:Hungry after all that naked riding? You're in luck! Some of
  Portland's food carts are open late. Bring $.
ORGANIZER:Scott Batchelar, http://www.fc4c.org/, Make sure to follow us on
  Twitter @fc4charity @FC4CPDX
LOCATION:Lillis Albina City Park, N Russell and Flint Ave. (Meet 15 Minutes
  after the end of the World Naked Bike Ride)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#07-4375
END:VEVENT
BEGIN:VEVENT
SEQUENCE:41
DTSTART;TZID=US/Pacific:20140608T100000
DTSTAMP:20140602T000000
SUMMARY:Zoobomb Century
UID:20140608.4236@shift2bikes.org
DESCRIPTION:100 miles of downhill on a 16" kid's bike. Only minibikes
  qualify, everyone welcome. Bring a helmet and MAX fare.
ORGANIZER:Johnnie O., rejuicedbikes@gmail.com
LOCATION:Logs of Indecision, SW Knights Blvd and Wildwood trail
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4236
END:VEVENT
BEGIN:VEVENT
SEQUENCE:42
DTSTART;TZID=US/Pacific:20140608T103000
DTSTAMP:20140602T000000
SUMMARY:Lake Oswego Heritage Tree Bike Ride
UID:20140608.4365@shift2bikes.org
DESCRIPTION:Go on a 13-mile bike ride through Lake Oswego’s neighborhoods
  to visit some of the City’s grandest trees!
ORGANIZER:Shannan Stoll, sstoll@ci.oswego.or.us, 503-675-3737
LOCATION:Lower Millennium Plaza park, 200 1st St, Lake Oswego, OR 97034
  (meet in the SE end of the park, down the stairs, by the fountain)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4365
END:VEVENT
BEGIN:VEVENT
SEQUENCE:43
DTSTART;TZID=US/Pacific:20140608T110000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Port-tucky Derby
UID:20140608.4396@shift2bikes.org
DESCRIPTION:Saddle up, Portland. Join us for costumes, contests, races, and
  brunchy beverages along the way.
ORGANIZER:Val & Lindsay, portuckyderby@gmail.com
LOCATION:Peninsula Park, 700 N Rosa Parks Way
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4396
END:VEVENT
BEGIN:VEVENT
SEQUENCE:44
DTSTART;TZID=US/Pacific:20140608T110000
DTSTAMP:20140602T000000
SUMMARY: VBC 2014 - Portland YAHTZEE Ride
UID:20140608.4423@shift2bikes.org
DESCRIPTION:Roll the dice and visit some sustainable, community-built
  Village Building Convergence 2014 projects.
ORGANIZER:City Repair Project, http://cityrepair.org/
LOCATION:Sunnyside Centenary United Methodist Churc,  3520 SE Yamhill St,
  Portland, Oregon 97214
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4423
END:VEVENT
BEGIN:VEVENT
SEQUENCE:45
DTSTART;TZID=US/Pacific:20140608T110000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:The Joy of Sects
UID:20140608.4432@shift2bikes.org
DESCRIPTION:The Bike Temple takes you on a "speed dating" style tour of
  religion in Portland.
ORGANIZER:Bike Temple Templars
LOCATION:Xhurch, 4550 NE 20th Ave (@ Going)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4432
END:VEVENT
BEGIN:VEVENT
SEQUENCE:46
DTSTART;TZID=US/Pacific:20140608T120000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Zumba Ride (Pedalpazumba!)
UID:20140608.4216@shift2bikes.org
DESCRIPTION:Join us for two of our favorites... riding & dancing, as we
  tour through inner SE.
ORGANIZER:Tom
LOCATION:Col. Summers Park, SE 20th and Belmont (on the basketball court)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4216
END:VEVENT
BEGIN:VEVENT
SEQUENCE:47
DTSTART;TZID=US/Pacific:20140608T130000
DTSTAMP:20140602T000000
SUMMARY:2BWell Health and Fitness Ride (Cross Fit)
UID:20140608.4265@shift2bikes.org
DESCRIPTION:Warm up, crossfit, ride, get a tour of Whole Foods from their
  Nutritional Therapy Practitioner, ride, crossfit, repeat!
ORGANIZER:2BWell Natural Medicine, http://2bwell.net/
LOCATION:CrossFit Stumptown, 535 NE 28th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4265
END:VEVENT
BEGIN:VEVENT
SEQUENCE:48
DTSTART;TZID=US/Pacific:20140608T133000
DTSTAMP:20140602T000000
SUMMARY:Ellie's Ride
UID:20140608.4444@shift2bikes.org
DESCRIPTION:Fun, slow-paced family ride with rockin' music & BIG BUBBLES!
ORGANIZER:Tim, 503-847-5564
LOCATION:OMSI, 1945 SE Water Ave, Portland (Near submarine on Esplanade)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4444
END:VEVENT
BEGIN:VEVENT
SEQUENCE:49
DTSTART;TZID=US/Pacific:20140608T140000
DTSTAMP:20140602T000000
SUMMARY:Kindergarten Games
UID:20140608.4278@shift2bikes.org
DESCRIPTION:How's that whole "grown up" thing working for you? Come play
  the games you miss!
ORGANIZER:Karl, klangen@gmail.com
LOCATION:Peninsula Park, 700 N Rosa Parks Way (In front of the Community
  Center)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4278
END:VEVENT
BEGIN:VEVENT
SEQUENCE:50
DTSTART;TZID=US/Pacific:20140608T140000
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Blessing of the Bikes
UID:20140608.4350@shift2bikes.org
DESCRIPTION:No matter your faith or bike preference, bring your bike and
  join us for the 7th Annual Blessing of the Bikes.
ORGANIZER:Thomas W. Gornick, http://www.archdpdx.org/
LOCATION:Cathedral of St. Mary's, 1716 NW Couch St. (NW 18th and Couch St.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4350
END:VEVENT
BEGIN:VEVENT
SEQUENCE:51
DTSTART;TZID=US/Pacific:20140608T150000
DTSTAMP:20140602T000000
SUMMARY:PDX Cargo Bike Gang: Longest way across the street
UID:20140608.4238@shift2bikes.org
DESCRIPTION:Love cargo bikes? So do we! Come ride with us from one of our
  favorite shops, Clever Cycles, to the Lucky Lab.
ORGANIZER:KYouell
LOCATION:Clever Cycles, 908 SE Hawthorne Blvd (Meet up on SE 9th, between
  SE Hawthorne & SE Clay)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4238
END:VEVENT
BEGIN:VEVENT
SEQUENCE:52
DTSTART;TZID=US/Pacific:20140608T160000
DTSTAMP:20140602T000000
SUMMARY:Intro urban features riding
UID:20140608.4372@shift2bikes.org
DESCRIPTION:Ever want to ride walls? banks? Learn some new skills, tricks,
  and spots! Bring helmet, gloves, and at least 28c tires.
ORGANIZER:Shiny Sideup
LOCATION:St Stephen Catholic Church, 1112 SE 41st Ave.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4372
END:VEVENT
BEGIN:VEVENT
SEQUENCE:53
DTSTART;TZID=US/Pacific:20140608T160000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Bizarro 122nd Ave
UID:20140608.4431@shift2bikes.org
DESCRIPTION:East Portland's most important north-south artery has bike
  lanes. Find out where they go and imagine what 122nd could be
ORGANIZER:Michael Andersen, http://bikeportland.org
LOCATION:Jody's Bar & Grill, 12035 NE Glisan St (one block north of 122nd
  Ave MAX)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-4431
END:VEVENT
BEGIN:VEVENT
SEQUENCE:54
DTSTART;TZID=US/Pacific:20140608T203000
DTSTAMP:20140602T000000
SUMMARY:Zoobomb
UID:20140608.3959@shift2bikes.org
DESCRIPTION:Since '02, the most fun you can have on two wheels. Go fast or
  slow but definitely bring a helmet, lights, and MAX fare.
ORGANIZER:Zoobomb, zoobomb@zoobomb.net, http://zoobomb.net
LOCATION:Zoobomb Pyle, SW 13th Ave & W Burnside
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#08-3959
END:VEVENT
BEGIN:VEVENT
SEQUENCE:55
DTSTART;TZID=US/Pacific:20140609T050000
DTSTAMP:20140602T000000
SUMMARY:Sunrise Coffee
UID:20140609.4217@shift2bikes.org
DESCRIPTION:Ride to someplace pretty, brew coffee, watch the sunrise, talk
  smart, ride home.
ORGANIZER:Andy Schmidt
LOCATION:Terwilliger Boulevard Parkway, SW Terwiilger Blvd & SW Hamilton St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#09-4217
END:VEVENT
BEGIN:VEVENT
SEQUENCE:56
DTSTART;TZID=US/Pacific:20140609T173000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Traffic Signals Wonkery
UID:20140609.4323@shift2bikes.org
DESCRIPTION:Join the Manager of PBOT's Traffic Signal Division for a 10-12
  mile tour of innovative intersections. Bring questions!
ORGANIZER:Peter Koonce, peter.koonce@portlandoregon.gov, 503-823-8686
LOCATION:Portland Building, 1120 SW 5th Ave (Under Portlandia)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#09-4323
END:VEVENT
BEGIN:VEVENT
SEQUENCE:57
DTSTART;TZID=US/Pacific:20140609T173000
DTSTAMP:20140602T000000
SUMMARY:Le Tour de Gentrification
UID:20140609.4366@shift2bikes.org
DESCRIPTION:Portland is being ravaged by displacing capital development.
  Let's tour the scenes of the crime.
ORGANIZER:Rebel Metropolis, nyxfilm@gmail.com,
  https://www.facebook.com/events/1495061874042959/
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#09-4366
END:VEVENT
BEGIN:VEVENT
SEQUENCE:58
DTSTART;TZID=US/Pacific:20140609T174500
DTSTAMP:20140602T000000
SUMMARY:ALLEYS of N & NE Portland
UID:20140609.4280@shift2bikes.org
DESCRIPTION:Casually ride through the alleys of N and NE Portland! Why stay
  on the beaten path when you can explore new routes?
ORGANIZER:Kirk & Erinne, kirk.paulsen@gmail.com, 503-858-2042
LOCATION:StormBreaker Brewing, 832 North Beech Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#09-4280
END:VEVENT
BEGIN:VEVENT
SEQUENCE:59
DTSTART;TZID=US/Pacific:20140609T180000
DTSTAMP:20140602T000000
SUMMARY:Canadian Pride Roller Hockey Ride
UID:20140609.4474@shift2bikes.org
DESCRIPTION:Join us for some good ol' street hockey. Skates, shoes,
  whatever! All are welcome. We've got sticks.
ORGANIZER:Saul T. Scrapper
LOCATION:Alberta Park, NE Ainsworth + NE 22nd Avenue
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#09-4474
END:VEVENT
BEGIN:VEVENT
SEQUENCE:60
DTSTART;TZID=US/Pacific:20140610T120000
DTSTAMP:20140602T000000
SUMMARY:Tater Tot Campout
UID:20140610.4264@shift2bikes.org
DESCRIPTION:An easy overnight bike camping trip, 33mi each way. Bring $20
  for the MAX, camping fees, and amazing tater tots!
ORGANIZER:Kai, kaionabike@gmail.com, 503-388-0304
LOCATION:Hatfield Government Center MAX Station in Hillsboro, 100 SW Adams
  Ave, Hillsboro (Email me, or check out the blog for more ride info!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4264
END:VEVENT
BEGIN:VEVENT
SEQUENCE:61
DTSTART;TZID=US/Pacific:20140610T120000
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Tuesday Teddy Ride
UID:20140610.4417@shift2bikes.org
DESCRIPTION:Tallbike-riding clowns want to cruise around the Brooklyn
  Neighborhood with your family and your stuffed animals!
ORGANIZER:Olive Rootbeer & Dingo, iloverootbeer.dingo@gmail.com,
  971-221-6715
LOCATION:Johnson Creek City Park, SE 21st Ave & SE Clatsop St Portland, OR
  97202 (We'll be near the kids play area & restrooms)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4417
END:VEVENT
BEGIN:VEVENT
SEQUENCE:62
DTSTART;TZID=US/Pacific:20140610T173000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:SE Ponds Ride
UID:20140610.4173@shift2bikes.org
DESCRIPTION:Join me for a casual 11.5 mile ride by some of the most
  beautiful ponds, lakes, rivers, and creeks in the Portland area.
ORGANIZER:Richard Powell, rpowell@hostpond.com
LOCATION:Reed College, North Parking Lot, SE 33rd Ave and Steele St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4173
END:VEVENT
BEGIN:VEVENT
SEQUENCE:63
DTSTART;TZID=US/Pacific:20140610T173000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Food Carts 4 Charity - Ultimate Ramble!
UID:20140610.4413@shift2bikes.org
DESCRIPTION:Wanna learn about the History of Food Carts in Portland? Well,
  then this Ramble Ride is for you! Bring $ for eats!
ORGANIZER:Scott Batchelar , 971-207-5523
LOCATION:SW 10th and Alder Street (Meet in the parking lot in the center)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4413
END:VEVENT
BEGIN:VEVENT
SEQUENCE:64
DTSTART;TZID=US/Pacific:20140610T180000
DTSTAMP:20140602T000000
SUMMARY:Emo Ride
UID:20140610.4263@shift2bikes.org
DESCRIPTION:"Well I got a bad feeling about this." Emo attire encouraged.
  Song requests welcome.
ORGANIZER:Erin and Alex, apbrey@gmail.com
LOCATION:Col. Summers Park, SE 20th and Belmont (NE Corner)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4263
END:VEVENT
BEGIN:VEVENT
SEQUENCE:65
DTSTART;TZID=US/Pacific:20140610T183000
DTSTAMP:20140602T000000
SUMMARY:Bike touring for women
UID:20140610.4351@shift2bikes.org
DESCRIPTION:Free workshop about bike touring/camping led by Cycle Wild.
  Women and trans folks only, please.
ORGANIZER:Erinne & Stasia, erinne.larissa@gmail.com, stasiah@gmail.com
LOCATION:Velo Cult, 1969 NE 42nd (In the basement theater)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4351
END:VEVENT
BEGIN:VEVENT
SEQUENCE:66
DTSTART;TZID=US/Pacific:20140610T190000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Grilled By Bike
UID:20140610.4306@shift2bikes.org
DESCRIPTION:Wieners, sliders, and vegan delights; cooked on our rolling
  grill! Bring grillables, drinks, and friends.
ORGANIZER:Eric JP Eilif Krista Aaron,
  https://www.facebook.com/events/1484160371818643/
LOCATION:Ladd's Circle, SE 16th Ave & Harrison St  (Follow the smells)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4306
END:VEVENT
BEGIN:VEVENT
SEQUENCE:67
DTSTART;TZID=US/Pacific:20140610T194500
DTSTAMP:20140602T000000
SUMMARY:Silent Disco Ride-KBOO 90.7 FM
UID:20140610.4451@shift2bikes.org
DESCRIPTION:What are those folks silently rockin' out to? Find out! Bring a
  portable FM Radio with Headphones. Stops for dancing!
ORGANIZER:Diablo, http://bit.ly/KBOORide
LOCATION:KBOO, 20 SE 8th Ave, Portland (Meet across the street in the
  parking lots)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#10-4451
END:VEVENT
BEGIN:VEVENT
SEQUENCE:68
DTSTART;TZID=US/Pacific:20140611T140000
DTSTAMP:20140602T000000
SUMMARY:Foster Road goes to City Council
UID:20140611.4465@shift2bikes.org
DESCRIPTION:Come Support the Foster Streetscape Plan at City Council, and
  ride to the Foster neighborhood to celebrate.
ORGANIZER:Nick Falbo, nick@fosterunited.org, 503-421-8327
LOCATION:City Hall, 1221 SW 4th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4465
END:VEVENT
BEGIN:VEVENT
SEQUENCE:69
DTSTART;TZID=US/Pacific:20140611T163000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:BTA Commuter Station in Ladd's Addition
UID:20140611.4330@shift2bikes.org
DESCRIPTION:FREE SNACKS! Bike Registration! Just stop by and say hello,
  because BTA <3s bike riders!
ORGANIZER:Bicycle Transportation Alliance, nicole@btaoregon.org,
  503-226-0676
LOCATION:SE Ladd Ave & SE Division (On the sidewalk where SE Ladd meets
  Division)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4330
END:VEVENT
BEGIN:VEVENT
SEQUENCE:70
DTSTART;TZID=US/Pacific:20140611T164500
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Yes I CAN fit it on my bike!
UID:20140611.4467@shift2bikes.org
DESCRIPTION:Duct tape? Bungees? Inner tubes? Where there's a free pile or a
  thrift store, there's a way.
ORGANIZER:Sarah Gilbert, sarahgilbert@gmail.com, 503-889-6410
LOCATION:Sewallcrest Park, SE 31st Ave and Stephens St (near Market Street
  entrance)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4467
END:VEVENT
BEGIN:VEVENT
SEQUENCE:71
DTSTART;TZID=US/Pacific:20140611T173000
DTSTAMP:20140602T000000
SUMMARY:Bike to the Future: Facility Ride
UID:20140611.4242@shift2bikes.org
DESCRIPTION:GREAT SCOTT! Travel with OHSU & Go By Bike to 2015! See what
  bike facilities the future holds! B2F costumes encouraged!
ORGANIZER:John Landolfe, http://www.ohsu.edu/bike/
LOCATION:Tom McCall Park at Naito & Columbia, SW Naito Pkwy & SW Columbia
  St.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4242
END:VEVENT
BEGIN:VEVENT
SEQUENCE:72
DTSTART;TZID=US/Pacific:20140611T173000
DTSTAMP:20140602T000000
SUMMARY:Tim's Mystery Taco Ride
UID:20140611.4356@shift2bikes.org
DESCRIPTION:Back again with all new stops. This ride will be about 15 miles
  at a casual pace through SE and NE only. Bring $
ORGANIZER:Tim K, thkieltyka@gmail.com
LOCATION:SE Portland
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4356
END:VEVENT
BEGIN:VEVENT
SEQUENCE:73
DTSTART;TZID=US/Pacific:20140611T173000
DTSTAMP:20140602T000000
SUMMARY:Kamehameha Day
UID:20140611.4388@shift2bikes.org
DESCRIPTION:Join Pedal PT for a leisurely ride to Green Dragon. In the
  spirt of King Kamehameha Day Hawaiian attire is recommended!
ORGANIZER:Pedal PT, info@pedalpt.com, 503-894-9038
LOCATION:Pedal PT, 2622 SE 25th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4388
END:VEVENT
BEGIN:VEVENT
SEQUENCE:74
DTSTART;TZID=US/Pacific:20140611T180000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Plaid to Plaid
UID:20140611.4207@shift2bikes.org
DESCRIPTION:Wear plaid! See plaid! Make plaid! We will celebrate all things
  plaid.
ORGANIZER:Erin, 971-212-6212
LOCATION:Plaid Pantry, 2983 SE Belmont St, Portland, OR
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4207
END:VEVENT
BEGIN:VEVENT
SEQUENCE:75
DTSTART;TZID=US/Pacific:20140611T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Going Around in Circles
UID:20140611.4328@shift2bikes.org
DESCRIPTION:Ride in circles and learn all about the many circle parks,
  memorials, fountains. Circle games. bring potluck to share.
ORGANIZER:Carye Bye, hiddenportland@gmail.com, 503-248-4454
LOCATION:The Fields Park, 1099 NW Overton Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4328
END:VEVENT
BEGIN:VEVENT
SEQUENCE:76
DTSTART;TZID=US/Pacific:20140611T183000
DTSTAMP:20140602T000000
SUMMARY:Portlandia Ride
UID:20140611.4412@shift2bikes.org
DESCRIPTION:Come celebrate the funniest show about Portland that is still
  on T.V!
ORGANIZER:Kielnotkyle, kielij@gmail.com, 206-850-8084
LOCATION:Portland City Hall, 1221 SW 4th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#11-4412
END:VEVENT
BEGIN:VEVENT
SEQUENCE:77
DTSTART;TZID=US/Pacific:20140612T063000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Bikepool to Lake O
UID:20140612.4482@shift2bikes.org
DESCRIPTION:Working in Lake O. is the pits. But commuting there doesn't
  have to be.
ORGANIZER:Lori
LOCATION:Vera Katz Eastbank Esplanade, SE Madison & Eastbank Esplanade
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4482
END:VEVENT
BEGIN:VEVENT
SEQUENCE:78
DTSTART;TZID=US/Pacific:20140612T093000
DURATION:PT8H0M0S
DTSTAMP:20140602T000000
SUMMARY:Midweek Ride to the Columbia Gorge
UID:20140612.4268@shift2bikes.org
DESCRIPTION:30 miles, intermediate level, mod pace, great views.
  Register/info: ualgorgeride2014.eventbrite.com
ORGANIZER:Ian and Shawn, http://urbanadventureleague.wordpress.com/
LOCATION:TBA, TBA (At a MAX stop in Gresham. Full details given to those
  who register.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4268
END:VEVENT
BEGIN:VEVENT
SEQUENCE:79
DTSTART;TZID=US/Pacific:20140612T144500
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Beverly Cleary School Bike Train!
UID:20140612.4299@shift2bikes.org
DESCRIPTION:Kid-paced ride to all 3 sites of Beverly Cleary school, from
  Hollyrood to Fernwood to Rose City
ORGANIZER:Joseph E
LOCATION:Beverly Cleary School Hollyrood Campus, 3560 NE Hollyrood Ct,
  Portland, OR (Bike parking area: at front door (Hollyrood), in back
  (Fernwood)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4299
END:VEVENT
BEGIN:VEVENT
SEQUENCE:80
DTSTART;TZID=US/Pacific:20140612T163000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:PDX Tandems Social Ride
UID:20140612.4261@shift2bikes.org
DESCRIPTION:Tandemonium! Same as last year but more mileage! Drinks en
  route to Irving park for the Rocky Butte Sunset Ride
ORGANIZER:Eric Ivy, https://www.facebook.com/events/512845192172091/
LOCATION:Ladd's Circle, SE 16th Ave & Harrison St  (Near the other tandems)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4261
END:VEVENT
BEGIN:VEVENT
SEQUENCE:81
DTSTART;TZID=US/Pacific:20140612T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:B4HPDX Free Volunteer Mechanics Class
UID:20140612.4125@shift2bikes.org
DESCRIPTION:Those willing to volunteer 10 hours for Bikes for Humanity may
  attend this 24-hour bike mechanics class.
ORGANIZER:Steven, b4hpdx@gmail.com, http://www.b4hpdx.org/
LOCATION:Bikes For Humanity PDX, 4038 SE Brooklyn Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4125
END:VEVENT
BEGIN:VEVENT
SEQUENCE:82
DTSTART;TZID=US/Pacific:20140612T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Free Bike Repair w/ Repair PDX
UID:20140612.4249@shift2bikes.org
DESCRIPTION:In partnership with Mercy Corps we'll be offering FREE bike
  repair, sewing/mending, small appliance repair and more.
ORGANIZER:Repair PDX, http://repairpdx.org/
LOCATION:Mercy Corps, 45 SW Ankeny St, Portland, OR 97204
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4249
END:VEVENT
BEGIN:VEVENT
SEQUENCE:83
DTSTART;TZID=US/Pacific:20140612T183000
DTSTAMP:20140602T000000
SUMMARY:PDX Valkyries
UID:20140612.4308@shift2bikes.org
DESCRIPTION:Ladies-only Valkyries ride. Bring your winged-Viking helmet and
  spear! Keep an eye out for mauraders. BYOB.
ORGANIZER:PDX Valkyries, http://facebook.com/pdxvalkyries/
LOCATION:Piccolo Park, SE 28th between SE Division & Clinton
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4308
END:VEVENT
BEGIN:VEVENT
SEQUENCE:84
DTSTART;TZID=US/Pacific:20140612T183000
DTSTAMP:20140602T000000
SUMMARY:Marauder ride 2014
UID:20140612.4289@shift2bikes.org
DESCRIPTION:Sport yer best marauder gear ride meet 6:30, we ride at 7 to
  attack stuff and roll around like we own the place.
ORGANIZER:Dingo Dizmal, http://oliveanddingo.com/
LOCATION:top of the hill, 5511 se Hawthorne (55th and Hawthorne)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4289
END:VEVENT
BEGIN:VEVENT
SEQUENCE:85
DTSTART;TZID=US/Pacific:20140612T190000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Rocky Butte Sunset Dance Party Picnic
UID:20140612.4223@shift2bikes.org
DESCRIPTION:Follow the tunes from Irving Park (NE 11th & Klickitat) to
  Rocky Butte for a potluck, sunset picnic and dance party.
ORGANIZER:Rocky Butte Sunset, rockybuttesunset@gmail.com
LOCATION:Irving Park, NE 11th Ave. and NE Klickitat St. (E. side of the
  park)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4223
END:VEVENT
BEGIN:VEVENT
SEQUENCE:86
DTSTART;TZID=US/Pacific:20140612T190000
DTSTAMP:20140602T000000
SUMMARY:Unicycle Polo
UID:20140612.4401@shift2bikes.org
DESCRIPTION:Do you ride a unicycle? Want the chance to attack people with a
  stick, while unicycling? Just want to watch?
ORGANIZER:Hamilton, ubtumblr@gmail.com, http://www.unicyclebastards.com/
LOCATION:Alberta Park Bike Polo Court, NE 22nd Ave and Killingsworth St.
  (The southeast corner of Alberta Park.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4401
END:VEVENT
BEGIN:VEVENT
SEQUENCE:87
DTSTART;TZID=US/Pacific:20140612T200000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Full Moon Nekkid
UID:20140612.4461@shift2bikes.org
DESCRIPTION:Ride naked under the full moon.
ORGANIZER:Ker Nal and Past Tire
LOCATION:Coe Circle, 3900 NE Glisan St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#12-4461
END:VEVENT
BEGIN:VEVENT
SEQUENCE:88
DTSTART;TZID=US/Pacific:20140613T070000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Breakfast on the Bridges
UID:20140613.4478@shift2bikes.org
DESCRIPTION:Stop for some coffee, treats, and camaraderie. Running late?
  We've got tardy slips! A Portland tradition since 2002.
ORGANIZER:Shift, bonb@lists.riseup.net,
  http://shift2bikes.org/wiki/bikefun:breakfast_on_the_bridges
LOCATION:Hawthorne, Burnside, and Lower Steel Bridges
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4478
END:VEVENT
BEGIN:VEVENT
SEQUENCE:89
DTSTART;TZID=US/Pacific:20140613T140000
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Pie Time
UID:20140613.4425@shift2bikes.org
DESCRIPTION:Do you love Pie? Bring kids, chalk, & at least $8. We will ride
  & stop and draw. End at Pie spot for pie and kids show.
ORGANIZER:Olive Rootbeer & Dingo, iloverootbeer.dingo@gmail.com,
  971-221-6715
LOCATION:Laurelhurst City Park, SE Cesar E Chavez and Stark Street (We'll
  be near the kids play area; look for tall bikes)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4425
END:VEVENT
BEGIN:VEVENT
SEQUENCE:90
DTSTART;TZID=US/Pacific:20140613T180000
DTSTAMP:20140602T000000
SUMMARY:Capoeira Rolling Roda Ride
UID:20140613.4307@shift2bikes.org
DESCRIPTION:Capoeira movements, music and roda around town. Curious about
  capoeira or Afro-Brazilian culture? Join us!
ORGANIZER:Rainha
LOCATION:Powell Park, SE 26th Ave and Powell Blvd
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4307
END:VEVENT
BEGIN:VEVENT
SEQUENCE:91
DTSTART;TZID=US/Pacific:20140613T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Santa Ride
UID:20140613.4248@shift2bikes.org
DESCRIPTION:Ride around with Santa and visit some of his favorite hangouts!
ORGANIZER:Pantsless Santa, zacharys@gmail.com
LOCATION:Couch Park, NW Glisan St & Path
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4248
END:VEVENT
BEGIN:VEVENT
SEQUENCE:92
DTSTART;TZID=US/Pacific:20140613T183000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Parade Float Ride
UID:20140613.4352@shift2bikes.org
DESCRIPTION:Turn your bicycle contraption into a parade float and go for a
  stroll in inner SE. Bring some candy!
ORGANIZER:Nature Boy, natureboy444@yahoo.com, 503-501-1256
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4352
END:VEVENT
BEGIN:VEVENT
SEQUENCE:93
DTSTART;TZID=US/Pacific:20140613T190000
DTSTAMP:20140602T000000
SUMMARY:Bachelorette Party Lap Dance Ride
UID:20140613.4476@shift2bikes.org
DESCRIPTION:Ladies: dress raunchy and bring your bills. Men: wear your best
  stripper attire and be prepared to give lap dances.
ORGANIZER:Victoria Mattingly
LOCATION:Col. Summers Park, SE 20th and Belmont (next to the tennis courts)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4476
END:VEVENT
BEGIN:VEVENT
SEQUENCE:94
DTSTART;TZID=US/Pacific:20140613T190000
DTSTAMP:20140602T000000
SUMMARY:Bowie (vs. Prince) Ride
UID:20140613.4133@shift2bikes.org
DESCRIPTION:Okay, Team Bowie. Get ready for a battle of 80's hair
  proportions. Frequent stops for dance/battle with Team Prince.
ORGANIZER:Lilymonster, http://www.anomalily.net, tweet @anomalily or
  @DirtyDiabloRide for live ride details
LOCATION:The Fields Neighborhood Park, NW 10th & NW Overton
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4133
END:VEVENT
BEGIN:VEVENT
SEQUENCE:95
DTSTART;TZID=US/Pacific:20140613T191500
DTSTAMP:20140602T000000
SUMMARY:Prince (vs. Bowie) Ride
UID:20140613.4449@shift2bikes.org
DESCRIPTION:Put yer purple armor on, Team Prince, 'cause it's time to
  battle dance Team Bowie in the streets!
ORGANIZER:Diablo, http://bit.ly/PRINCE2014
LOCATION:Sewallcrest Park, SE 31st Ave and Stephens St (Meet by the
  playground)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4449
END:VEVENT
BEGIN:VEVENT
SEQUENCE:96
DTSTART;TZID=US/Pacific:20140613T193000
DTSTAMP:20140602T000000
SUMMARY:Lomography Cycle
UID:20140613.4345@shift2bikes.org
DESCRIPTION:Learn how to take psychedelic 35mm photos! Bring a disposable
  camera and your creativity.
ORGANIZER:Eddie B., http://www.bearandshark.com/
LOCATION:Sewall Crest Park, SE 32nd and SE Lincoln St, portland, OR (In the
  cul-de-sac on the S. side of the park)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4345
END:VEVENT
BEGIN:VEVENT
SEQUENCE:97
DTSTART;TZID=US/Pacific:20140613T235900
DTSTAMP:20140602T000000
SUMMARY:Midnight Mystery Ride
UID:20140613.4361@shift2bikes.org
DESCRIPTION:Meet at the bar for a few cheap drinks and be ready to follow
  your leader at midnight to a mystery outdoor location.
ORGANIZER:Team Midnight, midnightmysteryridePDX@gmail.com,
  http://midnightmysteryride.wordpress.com/
LOCATION:East Portland Eagles Lodge, 740 SE 106th Ave (Come inside before
  the ride!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#13-4361
END:VEVENT
BEGIN:VEVENT
SEQUENCE:98
DTSTART;TZID=US/Pacific:20140614T090000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:Bike Church Bike Swap
UID:20140614.4336@shift2bikes.org
DESCRIPTION:3 speeds! Frankenbikes! Playa-caked wrecks. Got some tradeable
  beaters? Bring 'em to our first annual Bike Swap.
ORGANIZER:Johnnie O., rejuicedbikes@gmail.com,
  https://www.facebook.com/events/1450820745157623/
LOCATION:Bike Barn, 328 NE Mason St. (The Big Red Bike Barn)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4336
END:VEVENT
BEGIN:VEVENT
SEQUENCE:99
DTSTART;TZID=US/Pacific:20140614T100000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Bikes for Humanity Volunteer Repair Clinics
UID:20140614.2528@shift2bikes.org
DESCRIPTION:Learn bike repair skills FREE by helping refurbish bikes for a
  non-profit project. Details at www.b4hpdx.org
ORGANIZER:Steven
LOCATION:B4HPDX Store, 3354 SE Powell Blvd. Portland Oregon
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-2528
END:VEVENT
BEGIN:VEVENT
SEQUENCE:100
DTSTART;TZID=US/Pacific:20140614T100000
DTSTAMP:20140602T000000
SUMMARY:Stub Stewart bike camping with Cycle Wild
UID:20140614.4300@shift2bikes.org
DESCRIPTION:Cycle Wild's bike camping trip to Stub Stewart State Park!
  Registration Required. $10 + fees
ORGANIZER:Cycle Wild, info@cyclewild.org, http://www.cyclewild.org/
LOCATION:Stub Stewart State Park, Banks-Vernonia Trail (meet up location
  will be e-mailed to registrants)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4300
END:VEVENT
BEGIN:VEVENT
SEQUENCE:101
DTSTART;TZID=US/Pacific:20140614T100000
DTSTAMP:20140602T000000
SUMMARY:Deutsche Radfahrt IV
UID:20140614.4319@shift2bikes.org
DESCRIPTION:Themen: Transport, Geschichte, Architektur, Kunst,
  Raumzeitverbindungen. Bringt dafür etwas Taschengeld mit.
ORGANIZER:Der Phasmide, soundofharmony@hotmail.com,
  http://www.zeitgeistnorthwest.org/
LOCATION:Portland Aerial Tram, 3303 SW Bond Avenue
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4319
END:VEVENT
BEGIN:VEVENT
SEQUENCE:102
DTSTART;TZID=US/Pacific:20140614T100000
DURATION:PT6H0M0S
DTSTAMP:20140602T000000
SUMMARY:Group Acupuncture Charity Event
UID:20140614.4462@shift2bikes.org
DESCRIPTION:Community style acupuncture to support the Community Cycling
  Center. Suggested donation $15.00
ORGANIZER:Abraham Hawkins, shiftwellnesspdx@gmail.com, 503-841-6079
LOCATION:Shift Wellness PDX, 8040 NE Sandy Blvd, Portland, OR
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4462
END:VEVENT
BEGIN:VEVENT
SEQUENCE:103
DTSTART;TZID=US/Pacific:20140614T103000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Pocket Library Ride
UID:20140614.4226@shift2bikes.org
DESCRIPTION:I love all of Portland's pocket libraries! Give a book, take a
  book. You may even see a life size Dr Who Tardis!
ORGANIZER:Lance Poehler, lancepoehler@gmail.com,
  https://www.facebook.com/32ndAveTardisLibrary
LOCATION:Laurelhurst Park, 3700 SE Ankeny St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4226
END:VEVENT
BEGIN:VEVENT
SEQUENCE:104
DTSTART;TZID=US/Pacific:20140614T113000
DTSTAMP:20140602T000000
SUMMARY:Star Wars Vs. Star Trek Ride
UID:20140614.4198@shift2bikes.org
DESCRIPTION:Dress yourself and/or your bike up in Starfleet or Imperial
  gear and join us for Year 5: The Empire Bikes Back!
ORGANIZER:Luke Kirk, Twitter @starwarstartrek
LOCATION:OMSI, 1945 SE Water Ave, Portland (parking lot)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4198
END:VEVENT
BEGIN:VEVENT
SEQUENCE:105
DTSTART;TZID=US/Pacific:20140614T120000
DTSTAMP:20140602T000000
SUMMARY:The Sound of Music Sing-a-long Ride
UID:20140614.4185@shift2bikes.org
DESCRIPTION:The hills are alive! Ride from park to park singing songs from
  the movie with film/lyrics on a mobile A/V system.
ORGANIZER:Tom
LOCATION:Overlook Park, N Interstate Ave and Fremont St (Meet on the grassy
  hill overlooking the park near the intersection of N Melrose Dr and N
  Overlook Blvd)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4185
END:VEVENT
BEGIN:VEVENT
SEQUENCE:106
DTSTART;TZID=US/Pacific:20140614T120000
DTSTAMP:20140602T000000
SUMMARY:Alternative Library Ride
UID:20140614.4450@shift2bikes.org
DESCRIPTION:Libraries aren't just for books! Meet the libraries that lend
  tools, kitchen appliances, and more!
ORGANIZER:Robin, Info@kitchenshare.org, 503-964-3362
LOCATION:TBA
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4450
END:VEVENT
BEGIN:VEVENT
SEQUENCE:107
DTSTART;TZID=US/Pacific:20140614T123000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Tryon Creek Watershed Stream Restoration Tour
UID:20140614.4354@shift2bikes.org
DESCRIPTION:Ecology, SW community, hidden gems, hills, stream restoration
  projects! Learn about ecological restoration. 9 miles.
ORGANIZER:Tryon Creek Watershed Council, TryonCreekWC@gmail.com,
  541-921-7394
LOCATION:Riverdale Highschool, 9727 SW Terwilliger Blvd
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4354
END:VEVENT
BEGIN:VEVENT
SEQUENCE:108
DTSTART;TZID=US/Pacific:20140614T130000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Secret Society Ride: Freemason Lodges and Symbols
UID:20140614.4214@shift2bikes.org
DESCRIPTION:tour of Freemason architecture and history in four quadrants of
  Portland. Velvet cloaks are optional.
ORGANIZER:Emily Hall
LOCATION:Wilhelm's Memorial Mausoleum, 6705 SE 14th Ave, Portland, OR
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4214
END:VEVENT
BEGIN:VEVENT
SEQUENCE:109
DTSTART;TZID=US/Pacific:20140614T130000
DTSTAMP:20140602T000000
SUMMARY:Belligerante History ride
UID:20140614.4301@shift2bikes.org
DESCRIPTION:Celebrate Flag Day with patriotic paraphernalia, partying, and
  Portland's all-Schwinn Bike Club!
ORGANIZER:Ted Shred
LOCATION:Skidmore fountain, SW 1st Ave and Ankeny St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4301
END:VEVENT
BEGIN:VEVENT
SEQUENCE:110
DTSTART;TZID=US/Pacific:20140614T130000
DTSTAMP:20140602T000000
SUMMARY:East Vancouver Suburban Outcast Ride
UID:20140614.4469@shift2bikes.org
DESCRIPTION:Suburban misfits unite and ride!!! 15ish miles of yarn bombing,
  t shirt modification, wine drinking, and hot tubbing!
ORGANIZER:Rich and Tina
LOCATION:Vancouver New Seasons, 2100 SE 164th Ave, Vancouver
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4469
END:VEVENT
BEGIN:VEVENT
SEQUENCE:111
DTSTART;TZID=US/Pacific:20140614T140000
DTSTAMP:20140602T000000
SUMMARY:Southeast Small Manufacturing Tour
UID:20140614.4241@shift2bikes.org
DESCRIPTION:A <5 mi. guided tour of 4+ small manufacturing studios in SE,
  each using different materials, with food/drink at the end
ORGANIZER:Walnut Studiolo, walnutstudiolo@gmail.com
LOCATION:Mudshark Studios/Eutectic Gallery, 1930 NE Oregon St.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4241
END:VEVENT
BEGIN:VEVENT
SEQUENCE:112
DTSTART;TZID=US/Pacific:20140614T140000
DTSTAMP:20140602T000000
SUMMARY:Mid-Day Mystery Ride
UID:20140614.4464@shift2bikes.org
DESCRIPTION:Ten-plus miles of fun, unusual roads, including mildly rough
  terrain. Ends at a great outdoor spot. Maybe bring snacks?
ORGANIZER:jaya, jaya.jeptha@gmail.com, 503-380-2573
LOCATION:Grant High School, 2245 NE 36th Ave (by the tennis courts!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4464
END:VEVENT
BEGIN:VEVENT
SEQUENCE:113
DTSTART;TZID=US/Pacific:20140614T150000
DTSTAMP:20140602T000000
SUMMARY:Startup Swag Ride
UID:20140614.4321@shift2bikes.org
DESCRIPTION:Close your MacBook, throw on your favorite swag and join us for
  a leisurely ride around PDX's hot startup scene.
ORGANIZER:Aaron Kaffen, aaron@cloudability.com,
  https://www.facebook.com/events/732670913451667/
LOCATION:Vera Katz statue on the East Bank Espanade, SE Eastbank Esplanade
  and Main St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4321
END:VEVENT
BEGIN:VEVENT
SEQUENCE:114
DTSTART;TZID=US/Pacific:20140614T150000
DTSTAMP:20140602T000000
SUMMARY:Scale of the Universe
UID:20140614.4427@shift2bikes.org
DESCRIPTION:if the sun is as big as our bike wheel, how far is Neptune? Fun
  fact filled ride all along the waterfront.
ORGANIZER:FLUX, a.q.frankenstein@gmail.com
LOCATION:Japanese American Historical Plaza, Waterfront at NW Couch
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4427
END:VEVENT
BEGIN:VEVENT
SEQUENCE:115
DTSTART;TZID=US/Pacific:20140614T150000
DTSTAMP:20140602T000000
SUMMARY:Little Bikes go to Gigantic Brewing
UID:20140614.4454@shift2bikes.org
DESCRIPTION:Tiny bikes (Tern, Brompton, Bike Friday, Dahon, Strida...) and
  those who love them...assemble for a casual ride!
ORGANIZER:Will Vanlue
LOCATION:Holladay Park, NE Multnomah betw NE 11th & 13th (You'll be able to
  find us pretty easily. We'll be the ones with folding bikes.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4454
END:VEVENT
BEGIN:VEVENT
SEQUENCE:116
DTSTART;TZID=US/Pacific:20140614T150000
DTSTAMP:20140602T000000
SUMMARY:Sunny Nekkid II
UID:20140614.4456@shift2bikes.org
DESCRIPTION:Ride naked or mostly naked. Work on that tan, those quads, and
  enjoy body-acceptance. Cameras discouraged
ORGANIZER:Past Tire and Ker Nal
LOCATION:Coe Circle, 3900 NE Glisan St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4456
END:VEVENT
BEGIN:VEVENT
SEQUENCE:117
DTSTART;TZID=US/Pacific:20140614T180000
DTSTAMP:20140602T000000
SUMMARY:Flake Ride
UID:20140614.3946@shift2bikes.org
DESCRIPTION:So uh, yeah, this ride'll be great. Until we don't show up,
  'cause you know, life gets busy, man.
ORGANIZER:Cornelius and Tony, eporter123@hotmail.com
LOCATION:Somewhere in the SE, maybe NE? (Don't worry, I'll TOTALLY be
  there!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-3946
END:VEVENT
BEGIN:VEVENT
SEQUENCE:118
DTSTART;TZID=US/Pacific:20140614T183000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Bike Mechanic Challenge
UID:20140614.4284@shift2bikes.org
DESCRIPTION:Professional mechanics compete in front of a live audience.
  Food! Beer! Raffle! Heckling! $10 suggested donation.
ORGANIZER:Community Cycling Center, http://is.gd/BMC2014
LOCATION:VeloCult, 1969 NE 42nd Avenue
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4284
END:VEVENT
BEGIN:VEVENT
SEQUENCE:119
DTSTART;TZID=US/Pacific:20140614T183000
DTSTAMP:20140602T000000
SUMMARY:Sunset Mystery Ride
UID:20140614.4370@shift2bikes.org
DESCRIPTION:Meet up and ride to a mystery destination to watch the sunset.
  Be prepared to relax and hang out at our destination.
ORGANIZER:Sekhmet
LOCATION:Mt. Scott Park, SE 72nd & Harold, Portland, OR 97206
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4370
END:VEVENT
BEGIN:VEVENT
SEQUENCE:120
DTSTART;TZID=US/Pacific:20140614T200000
DTSTAMP:20140602T000000
SUMMARY:The Little Lebowski Urban Achievers Ride
UID:20140614.4232@shift2bikes.org
DESCRIPTION:Put on your best Lebowski character outfit and take 'er easy
  with us. We'll wind up at the lanes. No funny stuff.
ORGANIZER:J. Quintana, epr_111@yahoo.com
LOCATION:Col. Summers Park, SE 20th and Belmont (near the tennis courts)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4232
END:VEVENT
BEGIN:VEVENT
SEQUENCE:121
DTSTART;TZID=US/Pacific:20140614T210000
DTSTAMP:20140602T000000
SUMMARY:Gender*Bender
UID:20140614.4397@shift2bikes.org
DESCRIPTION:Ride to BlowPony ($10) with gender*benders in support of the
  LGBTQ community. Drag welcome!
ORGANIZER:Jessie Queerious, jessiequeerious@gmail.com,
  http://www.rotture.com/event/163802
LOCATION:Crush Bar, 1400 SE Morrison Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4397
END:VEVENT
BEGIN:VEVENT
SEQUENCE:122
DTSTART;TZID=US/Pacific:20140614T230000
DTSTAMP:20140602T000000
SUMMARY:The Warriors Ride
UID:20140614.4154@shift2bikes.org
DESCRIPTION:An epic ride of courage, comradery, and endurance. Rally your
  Krew, gear up, and try to survive. Come out and play!
ORGANIZER:J Ryde, Jacob@SaintFurniture.com
LOCATION:Expo Center MAX Station, 2060 N Marine Dr
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#14-4154
END:VEVENT
BEGIN:VEVENT
SEQUENCE:123
DTSTART;TZID=US/Pacific:20140615T103000
DTSTAMP:20140602T000000
SUMMARY:Classic & Vintage Road Bike Ogle & Ride
UID:20140615.4394@shift2bikes.org
DESCRIPTION:Celebrate lugs, downtube shifters, sew-ups, high-flange hubs,
  drillium, corncobs, Bennoto tape, and the era of Merckx.
ORGANIZER:John Liu, johnliu@earthlink.net, 510-847-0070
LOCATION:VeloCult, 1969 NE 42nd Avenue
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4394
END:VEVENT
BEGIN:VEVENT
SEQUENCE:124
DTSTART;TZID=US/Pacific:20140615T110000
DTSTAMP:20140602T000000
SUMMARY:Shrine Ride
UID:20140615.4434@shift2bikes.org
DESCRIPTION:Face our fragility as we visit harrowing streets and shrines to
  riders who have crossed the great finish line in the sky
ORGANIZER:Jimmy Tardy, jvt2b@yahoo.com
LOCATION:Zoobomb Pile, SW 13th Ave & W Burnside
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4434
END:VEVENT
BEGIN:VEVENT
SEQUENCE:125
DTSTART;TZID=US/Pacific:20140615T120000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Rang Barse ride of colors!
UID:20140615.4180@shift2bikes.org
DESCRIPTION:Inspired by the Indian "Festival of Colors," we will pelt each
  other with colored powders, and get pelted in return!
ORGANIZER:browse
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4180
END:VEVENT
BEGIN:VEVENT
SEQUENCE:126
DTSTART;TZID=US/Pacific:20140615T120000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Vanvouver Vintage
UID:20140615.4387@shift2bikes.org
DESCRIPTION:Meet at Esther Short Park, WA's oldest public square, with your
  vintage bike and join in a short loop through town!
ORGANIZER:Matthew
LOCATION:Esther Short Park, W 6th and Columbia (near the clock tower)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4387
END:VEVENT
BEGIN:VEVENT
SEQUENCE:127
DTSTART;TZID=US/Pacific:20140615T130000
DTSTAMP:20140602T000000
SUMMARY:A Riding Tour of Ankh-Morportland
UID:20140615.4208@shift2bikes.org
DESCRIPTION:Discworld-themed ride. Costumes strongly encouraged. Make sure
  your will is updated in case of angry trolls.
ORGANIZER:Twoflower
LOCATION:Eastbank Esplanade, just north of Hawthorne Bridge, 5 SE Madison
  St, Portland
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4208
END:VEVENT
BEGIN:VEVENT
SEQUENCE:128
DTSTART;TZID=US/Pacific:20140615T130000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:City Repair Intersection Mural Tour
UID:20140615.4463@shift2bikes.org
DESCRIPTION:Join City Repair in a pedal friendly tour of this years VBC 14
ORGANIZER:City Repair , ted@cityrepair.org , http://vbc.cityrepair.org /
LOCATION:N Overlook Blvd & N Concord
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4463
END:VEVENT
BEGIN:VEVENT
SEQUENCE:129
DTSTART;TZID=US/Pacific:20140615T133000
DTSTAMP:20140602T000000
SUMMARY:Twins & Multiples Ride
UID:20140615.4443@shift2bikes.org
DESCRIPTION:Twin babies in a cargo bike? Triplet teens on tall bikes?
  Senior quads on recumbents? Bring your womb mate(s) for a ride
ORGANIZER:Gregg, woodlawntrees@gmail.com
LOCATION:Holladay Park (In front of the Double Tree), NE Multnomah betw NE
  11th & 13th
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4443
END:VEVENT
BEGIN:VEVENT
SEQUENCE:130
DTSTART;TZID=US/Pacific:20140615T144500
DTSTAMP:20140602T000000
SUMMARY:Robot Uprising!
UID:20140615.4262@shift2bikes.org
DESCRIPTION:Help deliver robo-propoganda to the soft, fleshy citizens of
  Portland, and then enjoy a robot picnic.
ORGANIZER:Myklebot, mykle-robot@mykle.com
LOCATION:Robo Taco, 607 SE Morrison (Please do not vaporize customers
  before the uprising begins.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4262
END:VEVENT
BEGIN:VEVENT
SEQUENCE:131
DTSTART;TZID=US/Pacific:20140615T150000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Back down the alley
UID:20140615.4373@shift2bikes.org
DESCRIPTION:Let's explore the back alleys of SE Portland. So many
  interesting dirt sections right here in the city.
ORGANIZER:Bike Fun
LOCATION:Creston Pool, 4454 SE Powell Blvd Portland, OR 97206
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4373
END:VEVENT
BEGIN:VEVENT
SEQUENCE:132
DTSTART;TZID=US/Pacific:20140615T160000
DTSTAMP:20140602T000000
SUMMARY:Presidential Fitness Challenge Ride
UID:20140615.4290@shift2bikes.org
DESCRIPTION:Are you fit and nimble as a 17-year-old boy/girl? Come prove
  yourself at the 4th Presidential Fitness Challenge!
ORGANIZER:Alex Bigazzi, 503-265-9429
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4290
END:VEVENT
BEGIN:VEVENT
SEQUENCE:133
DTSTART;TZID=US/Pacific:20140615T160000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:Homebrews and Community Gardens
UID:20140615.4406@shift2bikes.org
DESCRIPTION:Bring homebrews as we bike around to varoius community gardens,
  exchanging brewing and gardening techniques. BBQ at end!
ORGANIZER:Bobby & Rachel
LOCATION:Two Plum Park, NE 7th ave (Between Shaver and Mason)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4406
END:VEVENT
BEGIN:VEVENT
SEQUENCE:134
DTSTART;TZID=US/Pacific:20140615T163000
DTSTAMP:20140602T000000
SUMMARY:Dead Head Ride
UID:20140615.4360@shift2bikes.org
DESCRIPTION:Put on your tie dye. Sport your Steelie. Wear rings on your
  fingers and bells your shoes.
ORGANIZER:Fannie, McConnell.Fannie@gmail.com
LOCATION:Saint Stephen Catholic Church, 1112 SE 41st Avenue, Portland OR
  97214
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4360
END:VEVENT
BEGIN:VEVENT
SEQUENCE:135
DTSTART;TZID=US/Pacific:20140615T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Open Shop Night at Citybikes
UID:20140615.4148@shift2bikes.org
DESCRIPTION:Citybikes Wrench nights are located at the Annex at SE 8th and
  Ankeny. Where you can learn to fix your bike issues.
ORGANIZER:John Rutman, John.bicycleway@gmail.com,
  http://www.CityBikes.coop/
LOCATION:Citybikes Annex, SE 8th Ave and Ankeny St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-4148
END:VEVENT
BEGIN:VEVENT
SEQUENCE:136
DTSTART;TZID=US/Pacific:20140615T203000
DTSTAMP:20140602T000000
SUMMARY:Zoobomb
UID:20140615.3959@shift2bikes.org
DESCRIPTION:Since '02, the most fun you can have on two wheels. Go fast or
  slow but definitely bring a helmet, lights, and MAX fare.
ORGANIZER:Zoobomb, zoobomb@zoobomb.net, http://zoobomb.net
LOCATION:Zoobomb Pyle, SW 13th Ave & W Burnside
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#15-3959
END:VEVENT
BEGIN:VEVENT
SEQUENCE:137
DTSTART;TZID=US/Pacific:20140616T163000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:That 70's Show
UID:20140616.4277@shift2bikes.org
DESCRIPTION:Learn the interesting parts of Portland culture that had root
  in the 70s. 15 miles, slow paced.
ORGANIZER:Michael Wade
LOCATION:City Hall, 1221 SW 4th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4277
END:VEVENT
BEGIN:VEVENT
SEQUENCE:138
DTSTART;TZID=US/Pacific:20140616T173000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Swing Bike Ride
UID:20140616.4342@shift2bikes.org
DESCRIPTION:Have a Swing Bike? Let's ride! Calling all swing bikes, custom
  or manufactured, dangerous, or less dangerous.
ORGANIZER:EricIvy, https://www.facebook.com/events/1563154980577530/
LOCATION:Apex, 1216 SE Division
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4342
END:VEVENT
BEGIN:VEVENT
SEQUENCE:139
DTSTART;TZID=US/Pacific:20140616T180000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Cargo bikes to Cakes
UID:20140616.4398@shift2bikes.org
DESCRIPTION:Let's see all the ingenious cargo solutions Portlanders can
  come up with. Longest 2-wheel trackstand wins slice of cake.
ORGANIZER:The Beebe Company, silasbeebe@hotmail.com, 503-734-7561
LOCATION:FINISH AT: Piece of Cake Bakery, 8306 SE 17th Avenue Portland, OR
  97202
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4398
END:VEVENT
BEGIN:VEVENT
SEQUENCE:140
DTSTART;TZID=US/Pacific:20140616T180000
DTSTAMP:20140602T000000
SUMMARY:Canadian Pride Roller Hockey Ride
UID:20140616.4475@shift2bikes.org
DESCRIPTION:Pedal to (Princess) Alberta Park and play some Roller Hockey!
ORGANIZER:Saul T. Scrapper,
  https://www.facebook.com/pages/Portland-Roller-Hockey/186538884697065
LOCATION:Alberta Park, NE Ainsworth + NE 22nd Avenue
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4475
END:VEVENT
BEGIN:VEVENT
SEQUENCE:141
DTSTART;TZID=US/Pacific:20140616T183000
DTSTAMP:20140602T000000
SUMMARY:Cully Bar Crawl
UID:20140616.4191@shift2bikes.org
DESCRIPTION:We'll be hitting dive bars and ending at karaoke so pace
  yerself. What happens in Cully stays in Cully.
ORGANIZER:Sara Sparkle
LOCATION:Bottles, 5015 N.E. Fremont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4191
END:VEVENT
BEGIN:VEVENT
SEQUENCE:142
DTSTART;TZID=US/Pacific:20140616T190000
DTSTAMP:20140602T000000
SUMMARY:Foster Road Bike Bar Crawl
UID:20140616.4353@shift2bikes.org
DESCRIPTION:Reach the depths of SE Portland pub culture: Foster Road. 6-10
  bars, 3 miles.
ORGANIZER:Nick, nick@fosterunited.org, 503-421-8327
LOCATION:Eagle Eye Tavern, 5836 SE 92nd Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4353
END:VEVENT
BEGIN:VEVENT
SEQUENCE:143
DTSTART;TZID=US/Pacific:20140616T190000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:The Magical History Tour
UID:20140616.4392@shift2bikes.org
DESCRIPTION:Join Pedal Bike Tours for a night of Beatles-themed Portland
  History.
ORGANIZER:Scott Klees, scott@pedalbiketours.com, 503-243-2453
LOCATION:Below the Portlandia Statue, 1120 SW 5th Ave.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4392
END:VEVENT
BEGIN:VEVENT
SEQUENCE:144
DTSTART;TZID=US/Pacific:20140616T190000
DTSTAMP:20140602T000000
SUMMARY:ET Ride
UID:20140616.4411@shift2bikes.org
DESCRIPTION:Come dressed as the feds or E.T. & Elliot. Bring water pistols.
  Feel free to bring E.T., too.
ORGANIZER:Kate, kate.laudermilk@gmail.com, 503-545-2665
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#16-4411
END:VEVENT
BEGIN:VEVENT
SEQUENCE:145
DTSTART;TZID=US/Pacific:20140617T110000
DTSTAMP:20140602T000000
SUMMARY:A Nice Long Ride 3
UID:20140617.4221@shift2bikes.org
DESCRIPTION:Easy pace, ~40 miles, speedsterism discouraged, loop-esque
ORGANIZER:Rachel, 503-422-6171
LOCATION:Metropolis Cycles, 2249 N Williams Ave (Meeting on Page St - the
  little side street)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4221
END:VEVENT
BEGIN:VEVENT
SEQUENCE:146
DTSTART;TZID=US/Pacific:20140617T140000
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Super Hero Adventure
UID:20140617.4419@shift2bikes.org
DESCRIPTION:This Ride has everything. Costumes. Music. Flying through the
  city with the wind in our capes! Bring $ for entertainment
ORGANIZER:Olive Rootbeer & Dingo, iloverootbeer.dingo@gmail.com,
  971-221-6715
LOCATION:Woodstock City Park, SE 47th Ave and Harold Street (We'll be near
  the kids play area; look for tall bikes)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4419
END:VEVENT
BEGIN:VEVENT
SEQUENCE:147
DTSTART;TZID=US/Pacific:20140617T163000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:BTA Open House
UID:20140617.4287@shift2bikes.org
DESCRIPTION:We're betting you could use a drink amidst all this bike fun.
  Stop by our office for one and chat with some BTA staff.
ORGANIZER:Bicycle Transportation Alliance, http://www.btaoregon.org
LOCATION:BTA HQ, 618 NW Glisan, Suite 401, Portland.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4287
END:VEVENT
BEGIN:VEVENT
SEQUENCE:148
DTSTART;TZID=US/Pacific:20140617T170000
DTSTAMP:20140602T000000
SUMMARY:Midweek Bike Camping to Oxbow
UID:20140617.4440@shift2bikes.org
DESCRIPTION:Overnight camping at Oxbow, 10 mi, sites $22/night. Grocery
  stop. Limit 15. Register: oxbowjune2014s24o.eventbrite.com
ORGANIZER:Shawn, http://urbanadventureleague.wordpress.com/
LOCATION:TBA, TBA (Register to get full meet up details.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4440
END:VEVENT
BEGIN:VEVENT
SEQUENCE:149
DTSTART;TZID=US/Pacific:20140617T173000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Our toxiCITY
UID:20140617.4286@shift2bikes.org
DESCRIPTION:Short tour (~7 miles) of some of Portland's toxic sites, past &
  present. Not a loop!
ORGANIZER:Jamaal Green, jamaal.green@gmail.com
LOCATION:Wallace Park, NW 25th Ave and Raleigh St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4286
END:VEVENT
BEGIN:VEVENT
SEQUENCE:150
DTSTART;TZID=US/Pacific:20140617T180000
DTSTAMP:20140602T000000
SUMMARY:Melodic Pop Ride
UID:20140617.4251@shift2bikes.org
DESCRIPTION:"Sweet dreams till sunbeams find you. Sweet dreams that leave
  all worries behind you" A cheery, poppy ride.
ORGANIZER:Erin and Alex
LOCATION:Powell City Park, SE 26th Ave and Powell Blvd (NW Corner on the
  Field)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4251
END:VEVENT
BEGIN:VEVENT
SEQUENCE:151
DTSTART;TZID=US/Pacific:20140617T180000
DTSTAMP:20140602T000000
SUMMARY:Frisbee --> Bike Ride --> Disc Golf
UID:20140617.4282@shift2bikes.org
DESCRIPTION:Frisbee @ Peninsula Park - Bike to Pier Park - Disc Golf @ Pier
  Park
ORGANIZER:Kirk & Erinne, kirk.paulsen@gmail.com, 503-858-2042
LOCATION:Peninsula City Park, N Ainsworth St & N Albina Ave (We'll be
  *near* the Rose Garden)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4282
END:VEVENT
BEGIN:VEVENT
SEQUENCE:152
DTSTART;TZID=US/Pacific:20140617T180000
DTSTAMP:20140602T000000
SUMMARY:Hot for Teacher Ride
UID:20140617.4386@shift2bikes.org
DESCRIPTION:School's out for summer! Celebrate by drinking ice cold beer
  with those most excited about the year's end: teachers!
ORGANIZER:Kate , kate.laudermilk@gmail.com, 503-545-2665
LOCATION:Apex, 1216 SE Division
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4386
END:VEVENT
BEGIN:VEVENT
SEQUENCE:153
DTSTART;TZID=US/Pacific:20140617T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Portland or Hollywood; The Moviegoers
UID:20140617.4452@shift2bikes.org
DESCRIPTION:Come see some of the places where movies (both well-known and
  obscure) were filmed.
ORGANIZER:Scott Lieuellen, scott.el.09@gmail.com, 503-238-8613
LOCATION:USS Oregon Memorial, SW Oak and Naito
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4452
END:VEVENT
BEGIN:VEVENT
SEQUENCE:154
DTSTART;TZID=US/Pacific:20140617T203000
DTSTAMP:20140602T000000
SUMMARY:Friends of the Friendless
UID:20140617.4403@shift2bikes.org
DESCRIPTION:A Marcus Mckenzie Classic: mystery adventure and new
  friendships as we group behind lone riders to their destinations.
ORGANIZER:Claire, clairealyea@gmail.com
LOCATION:Two Plum Park, 4040 NE 7th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#17-4403
END:VEVENT
BEGIN:VEVENT
SEQUENCE:155
DTSTART;TZID=US/Pacific:20140618T103000
DTSTAMP:20140602T000000
SUMMARY:Wet n Wild West Side Ride
UID:20140618.4297@shift2bikes.org
DESCRIPTION:Howdy y'all. This 2-3 mile western-themed ride is for families
  who love playgrounds and play fountains!
ORGANIZER:Ellen and Cecily, ovgardenclub@gmail.com
LOCATION:Orenco MAX Station, Orenco/NW 231st Ave MAX Station, NE Orenco
  Station Pkwy, Hillsboro, OR 97124 (Start location is just south of the
  Orenco MAX Station in the courtyard with wisteria all around.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#18-4297
END:VEVENT
BEGIN:VEVENT
SEQUENCE:156
DTSTART;TZID=US/Pacific:20140618T163000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:BTA Commuter Station on SE Ankeny
UID:20140618.4331@shift2bikes.org
DESCRIPTION:FREE SNACKS! Bike Registration! Just stop by and say hello,
  because BTA <3s bike riders!
ORGANIZER:Bicycle Transportation Alliance, nicole@btaoregon.org,
  503-226-0676
LOCATION:1914 SE Ankeny St (At City Bikes Repair Shop)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#18-4331
END:VEVENT
BEGIN:VEVENT
SEQUENCE:157
DTSTART;TZID=US/Pacific:20140618T170000
DURATION:PT1H0M0S
DTSTAMP:20140602T000000
SUMMARY:Metal Ride
UID:20140618.4487@shift2bikes.org
DESCRIPTION:Come ride around the city listening to
ORGANIZER:kiel, kielij@gmail.com
LOCATION:APEX, 1216 SE Division
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#18-4487
END:VEVENT
BEGIN:VEVENT
SEQUENCE:158
DTSTART;TZID=US/Pacific:20140618T180000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Monkey Puzzle Tree Ride
UID:20140618.4253@shift2bikes.org
DESCRIPTION:Maybe you've never noticed them, or you have and they've
  baffled you, or you know everything about 'em! Join us!
ORGANIZER:Amanda Lee Harrison
LOCATION:Nacho Cheese Manor, 416 N Beech St. Portland OR 97227 (This is my
  house, we just put in a one year monkey puzzle in the yard :)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#18-4253
END:VEVENT
BEGIN:VEVENT
SEQUENCE:159
DTSTART;TZID=US/Pacific:20140618T180000
DTSTAMP:20140602T000000
SUMMARY:Doctor Who Ride (4th annual)
UID:20140618.4364@shift2bikes.org
DESCRIPTION:Grow yourself a TARDIS to ride around the Space-Time Vortex of
  Portland with other Timelords and Timeladies.
ORGANIZER:Lady Evelyn and Alexander Smith, who@sneaksneak.org, 503-987-0660
LOCATION:Skidmore Bluffs, 2299 N Skidmore Ct, Portland
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#18-4364
END:VEVENT
BEGIN:VEVENT
SEQUENCE:160
DTSTART;TZID=US/Pacific:20140618T183000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Bike Camping Cookout
UID:20140618.4441@shift2bikes.org
DESCRIPTION:Ride 5 mi to mystery park to make dinner. Camp stove required.
  No grills or instant meals.
ORGANIZER:Shawn, http://urbanadventureleague.wordpress.com/
LOCATION:Green Zebra Grocery,  8621 N Lombard St (This will be the grocery
  stop)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#18-4441
END:VEVENT
BEGIN:VEVENT
SEQUENCE:161
DTSTART;TZID=US/Pacific:20140618T190000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:Mobile Metamorphic Effigy Eradication Ride
UID:20140618.4218@shift2bikes.org
DESCRIPTION:Make an effigy of the old you, strap it to your bike and say
  goodbye to your past and the winter and hello to Summer2014
ORGANIZER:Lil' Mama Bone Crusher
LOCATION:Peninsula Park, 700 N Rosa Parks Way (South End of the park on
  Ainsworth, near the rose garden)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#18-4218
END:VEVENT
BEGIN:VEVENT
SEQUENCE:162
DTSTART;TZID=US/Pacific:20140619T093000
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Dr. Theo Seuss Geisel Ride
UID:20140619.4424@shift2bikes.org
DESCRIPTION:Dress as your fav Dr. Seuss character & do a slow kid ride to a
  Suess themed Story Time @ Cafe au Play. Bring @ least $8
ORGANIZER:Olive Rootbeer & Dingo, iloverootbeer.dingo@gmail.com,
  971-221-6715
LOCATION:Clinton City Park , SE 57th Ave. and Woodward Street (We'll be
  waiting in the kids play area on tall-bikes.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4424
END:VEVENT
BEGIN:VEVENT
SEQUENCE:163
DTSTART;TZID=US/Pacific:20140619T120000
DURATION:PT1H0M0S
DTSTAMP:20140602T000000
SUMMARY:Bike Lunch & Learn
UID:20140619.4489@shift2bikes.org
DESCRIPTION:Prioritize Portland!
ORGANIZER:Scott Cohen, 503-823-5345
LOCATION:City Hall, 1221 SW 4th Ave (Lovejoy Room, 2nd floor)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4489
END:VEVENT
BEGIN:VEVENT
SEQUENCE:164
DTSTART;TZID=US/Pacific:20140619T173000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Portland's Bike History Scavenger Hunt
UID:20140619.4329@shift2bikes.org
DESCRIPTION:A scavenger hunt to find some of the great places in Portland's
  bike history. Bring a smartphone.
ORGANIZER:YPT Portland, amoore08@gmail.com
LOCATION:Portland Building, 1120 SW 5th Ave (Under the Portlandia statue)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4329
END:VEVENT
BEGIN:VEVENT
SEQUENCE:165
DTSTART;TZID=US/Pacific:20140619T174500
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Follow that Trike! A B-line Delivery Ride
UID:20140619.4393@shift2bikes.org
DESCRIPTION:Learn the mysteries behind giant cargo tricycles, receive
  giveaways, and beer! Rain or shine, B-line delivers.
ORGANIZER:Donna, donna.avallone@b-linepdx.com, 520-678-6221
LOCATION:B-Line Sustainable Urban Delivery warehouse, 735 SE Alder St.
  Portland OR, 97214
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4393
END:VEVENT
BEGIN:VEVENT
SEQUENCE:166
DTSTART;TZID=US/Pacific:20140619T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:B4HPDX Free Volunteer Mechanics Class
UID:20140619.4125@shift2bikes.org
DESCRIPTION:Those willing to volunteer 10 hours for Bikes for Humanity may
  attend this 24-hour bike mechanics class.
ORGANIZER:Steven, b4hpdx@gmail.com, http://www.b4hpdx.org/
LOCATION:Bikes For Humanity PDX, 4038 SE Brooklyn Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4125
END:VEVENT
BEGIN:VEVENT
SEQUENCE:167
DTSTART;TZID=US/Pacific:20140619T180000
DTSTAMP:20140602T000000
SUMMARY:Bikey Trivia- by Bike!
UID:20140619.4390@shift2bikes.org
DESCRIPTION:Do you like bikes? (hint: yes) Do you like trivia? (hint:
  maybe) If so, then this is the ride for you! Maybe!
ORGANIZER:Ryan Good, goodsterman@yahoo.com, 503-970-9915
LOCATION:Hopworks Bike Bar, 3947 North Williams  (We'll be in the outdoor
  seating area out back)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4390
END:VEVENT
BEGIN:VEVENT
SEQUENCE:168
DTSTART;TZID=US/Pacific:20140619T183000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Espanol Hoy!
UID:20140619.4224@shift2bikes.org
DESCRIPTION:We will be riding and listening to spanish music and ending at
  a free Spanish conversation pot luck at Portlandia
ORGANIZER:Lance Poehler
LOCATION:North Park Blocks Basketball Court, NW Park Ave and NW Flanders
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4224
END:VEVENT
BEGIN:VEVENT
SEQUENCE:169
DTSTART;TZID=US/Pacific:20140619T183000
DTSTAMP:20140602T000000
SUMMARY:Bike Play 6: Bike Play's Big Adventure
UID:20140619.4315@shift2bikes.org
DESCRIPTION:Ride from scene to scene with WTC's 6th annual Bike Play. This
  year's inspiration: Pee-Wee's Big Adventure
ORGANIZER:The Working Theatre Collective
LOCATION:Peninsula Park , 700 N Rosa Parks Way
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4315
END:VEVENT
BEGIN:VEVENT
SEQUENCE:170
DTSTART;TZID=US/Pacific:20140619T190000
DTSTAMP:20140602T000000
SUMMARY:It's (another) Arrested Development Ride!
UID:20140619.4202@shift2bikes.org
DESCRIPTION:The Arrested Development ride! Wear a costume, bring your best
  chicken impression, watch out for bridges & hop-ons.
ORGANIZER:Lucille 3, blisslikethis@gmail.com,
  https://www.facebook.com/events/503498239754025/
LOCATION:The Banana Stand, SE 12th and SE Elliot (1 block north of
  Division. Actually, it's just a mural. There is probably no money in it.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4202
END:VEVENT
BEGIN:VEVENT
SEQUENCE:171
DTSTART;TZID=US/Pacific:20140619T190000
DTSTAMP:20140602T000000
SUMMARY:Unicycle Polo
UID:20140619.4402@shift2bikes.org
DESCRIPTION:Do you ride a unicycle? Want the chance to attack people with a
  stick, while unicycling? Just want to watch?
ORGANIZER:Mr. Orr, ubtumblr@gmail.com, http://www.unicyclebastards.com/
LOCATION:Alberta Park Bike Polo Court, NE 22nd Ave and Killingsworth St.
  (southeast corner of alberta park)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4402
END:VEVENT
BEGIN:VEVENT
SEQUENCE:172
DTSTART;TZID=US/Pacific:20140619T200000
DTSTAMP:20140602T000000
SUMMARY:Music Box River Ride
UID:20140619.4291@shift2bikes.org
DESCRIPTION:Sunset party ride to a dance party/bonfire on the beach. No
  beer stop. BYO.
ORGANIZER:Look Good Feel Good
LOCATION:Irving Park, NE 7th Ave and Fargo St, Portland (top of the knob)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4291
END:VEVENT
BEGIN:VEVENT
SEQUENCE:173
DTSTART;TZID=US/Pacific:20140619T210000
DTSTAMP:20140602T000000
SUMMARY:pdX Files
UID:20140619.4418@shift2bikes.org
DESCRIPTION:Light up you and your bike as we illuminate the strange and
  mysterious.
ORGANIZER:Foxxxy Mulder
LOCATION:Velocult, 1969 NE 42nd Avenue
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#19-4418
END:VEVENT
BEGIN:VEVENT
SEQUENCE:174
DTSTART;TZID=US/Pacific:20140620T060000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Early morning coffee and carousing
UID:20140620.4275@shift2bikes.org
DESCRIPTION:Early brew at 6, ride at 6:30. Hills included. End near
  downtown by 9am.
ORGANIZER:Erinne , erinne.larissa@gmail.com
LOCATION:Extracto Coffee, 2921 NE Killingsworth St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4275
END:VEVENT
BEGIN:VEVENT
SEQUENCE:175
DTSTART;TZID=US/Pacific:20140620T070000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Breakfast on the Bridges
UID:20140620.4479@shift2bikes.org
DESCRIPTION:Stop for some coffee, treats, and camaraderie. Running late?
  We've got tardy slips! A Portland tradition since 2002.
ORGANIZER:Shift,
  http://shift2bikes.org/wiki/bikefun:breakfast_on_the_bridges
LOCATION:Hawthorne, Burnside, and Lower Steel Bridges
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4479
END:VEVENT
BEGIN:VEVENT
SEQUENCE:176
DTSTART;TZID=US/Pacific:20140620T140000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Business on a Bike
UID:20140620.4395@shift2bikes.org
DESCRIPTION:Exercise! Network! Repeat!
ORGANIZER:Evan Elken, eelken@phillipsandco.com, 503-416-4665
LOCATION:Salmon Street Fountain, SW Salmon St and Naito Pkwy
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4395
END:VEVENT
BEGIN:VEVENT
SEQUENCE:177
DTSTART;TZID=US/Pacific:20140620T160000
DTSTAMP:20140602T000000
SUMMARY:OMSI Pedals Science: Engineering Explosion
UID:20140620.4293@shift2bikes.org
DESCRIPTION:It's OMSI's 5th annual science ride! Become an OMSI engineer on
  this ride full of hands-on group challenges.
ORGANIZER:Amanda Fisher, afisher@omsi.edu, 503-797-4635
LOCATION:OMSI, 1945 SE Water Ave, Portland (North end of the North parking
  lot next to the river)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4293
END:VEVENT
BEGIN:VEVENT
SEQUENCE:178
DTSTART;TZID=US/Pacific:20140620T160000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Kilted Happy Hour Ride
UID:20140620.4369@shift2bikes.org
DESCRIPTION:StumpTown Kilts' 3rd Annual Kilted Ride to kid friendly bars in
  the SE Portland for happy hour.
ORGANIZER:Todd Michael Altstadt, todd.michael.altstadt@stumptownkilts.com,
  503-926-0287
LOCATION:StumpTown Kilts' HQ Showroom, 2020 SE Bush ST. (Where SE 21ST AVE
  dead-ends South of Powell)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4369
END:VEVENT
BEGIN:VEVENT
SEQUENCE:179
DTSTART;TZID=US/Pacific:20140620T173000
DTSTAMP:20140602T000000
SUMMARY:IPRC Love Ride
UID:20140620.4363@shift2bikes.org
DESCRIPTION:Join us for an easy ride from the IPRC's old home to its new
  one on 10th & SE Division, where there shall be happy hour
ORGANIZER:Steph Routh
LOCATION:1005 W. Burnside St., Portland
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4363
END:VEVENT
BEGIN:VEVENT
SEQUENCE:180
DTSTART;TZID=US/Pacific:20140620T173000
DTSTAMP:20140602T000000
SUMMARY:Ride Together... Stand Together
UID:20140620.4445@shift2bikes.org
DESCRIPTION:Timbers Army & the Community Cycling Center will ride together!
  Bring scarves, vocal chords, and excitement. RCTID!
ORGANIZER:Lillian, lillian.karabaic@communitycyclingcenter.org,
  http://www.communitycyclingcenter.org
LOCATION:Community Cycling Center, 1700 NE Alberta St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4445
END:VEVENT
BEGIN:VEVENT
SEQUENCE:181
DTSTART;TZID=US/Pacific:20140620T181500
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Pastafarian Pirate Ride
UID:20140620.4422@shift2bikes.org
DESCRIPTION:Wear your finest Pirate garb or pasta strainer headgear!
  Relaxed ride: grog, buried treasure, pasta feed.
ORGANIZER:Irreverend Extra Medium, IrreverendExtraMedium@gmail.com
LOCATION:Powell City Park, SE 22nd & Powell (West side of the park, on 22nd
  Avenue south of Powell)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4422
END:VEVENT
BEGIN:VEVENT
SEQUENCE:182
DTSTART;TZID=US/Pacific:20140620T183000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Champagne Ride
UID:20140620.4247@shift2bikes.org
DESCRIPTION:Dress up. Bring Champagne. Bring cash. Pants, as always, are
  optional.
ORGANIZER:Dom Perignon (Zach Spier)
LOCATION:Ladd Circle, 1600 SE Harrison St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4247
END:VEVENT
BEGIN:VEVENT
SEQUENCE:183
DTSTART;TZID=US/Pacific:20140620T183000
DTSTAMP:20140602T000000
SUMMARY:Bike Play 6: Bike Play's Big Adventure
UID:20140620.4316@shift2bikes.org
DESCRIPTION:Ride from scene to scene with WTC's 6th annual Bike Play. This
  year's inspiration: Pee-Wee's Big Adventure
ORGANIZER:The Working Theatre Collective,
  http://theworkingtheatrecollective.wordpress.com/
LOCATION:Peninsula Park , 700 N Rosa Parks Way
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4316
END:VEVENT
BEGIN:VEVENT
SEQUENCE:184
DTSTART;TZID=US/Pacific:20140620T183000
DTSTAMP:20140602T000000
SUMMARY:Flying,fishing,foosing,frisbeeball & Franzia ride
UID:20140620.4408@shift2bikes.org
DESCRIPTION:4th annual alphabetical tournament ride. Ride to parks/bars &
  compete as 2-person team in frivolous mini-games. Prizes!
ORGANIZER:Mister F, 6FRide2014@gmail.com
LOCATION:Col. Summers Park, SE 20th and Belmont (Near the softball field)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4408
END:VEVENT
BEGIN:VEVENT
SEQUENCE:185
DTSTART;TZID=US/Pacific:20140620T190000
DTSTAMP:20140602T000000
SUMMARY:Heavy Bike Hill Climb Challenge
UID:20140620.4220@shift2bikes.org
DESCRIPTION:Ride your HEAVY ASS bike up a STEEP ASS hill. 40+ lb bikes to
  Pittock Mansion. Add beverage weight to reach 40 lbs
ORGANIZER:Patrick, ploftus12@gmail.com
LOCATION:Unthank Park, N Kerby Ave and Failing St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4220
END:VEVENT
BEGIN:VEVENT
SEQUENCE:186
DTSTART;TZID=US/Pacific:20140620T210000
DURATION:PT6H0M0S
DTSTAMP:20140602T000000
SUMMARY:Dropout BC Pedalpalooza Prom ride
UID:20140620.4155@shift2bikes.org
DESCRIPTION:Dropout Bike Bicycle's Annual Prom ride, social ride to a big
  bike party, all bikes welcomed.
ORGANIZER:Dropout Bicycle Club, DOBCPDX@gmail.com,
  http://dropoutbikeclub.blogspot.com/
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#20-4155
END:VEVENT
BEGIN:VEVENT
SEQUENCE:187
DTSTART;TZID=US/Pacific:20140621T100000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Bikes for Humanity Volunteer Repair Clinics
UID:20140621.2528@shift2bikes.org
DESCRIPTION:Learn bike repair skills FREE by helping refurbish bikes for a
  non-profit project. Details at www.b4hpdx.org
ORGANIZER:Steven
LOCATION:B4HPDX Store, 3354 SE Powell Blvd. Portland Oregon
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-2528
END:VEVENT
BEGIN:VEVENT
SEQUENCE:188
DTSTART;TZID=US/Pacific:20140621T100000
DTSTAMP:20140602T000000
SUMMARY:Sprockettes Girls 2-day Summer Camp!
UID:20140621.4355@shift2bikes.org
DESCRIPTION:2-Day summer bike-dance camp for girls ages 5-12 with The
  Sprockettes. $40-100 sliding scale. more info sprockettes.org
ORGANIZER:The Sprockettes!, sprockettescamp@gmail.com,
  http://www.sprockettes.org/
LOCATION:Irving Park, NE 7th Ave and Fargo St, Portland (Saturday Irving
  Park, Sunday Peninsula Park)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4355
END:VEVENT
BEGIN:VEVENT
SEQUENCE:189
DTSTART;TZID=US/Pacific:20140621T100000
DURATION:PT12H0M0S
DTSTAMP:20140602T000000
SUMMARY:Lumberyard 2nd Anniversary Party
UID:20140621.4488@shift2bikes.org
DESCRIPTION:The Lumberyard Bike Park 2nd Anniversary Party! $10 day pass.
ORGANIZER:Lumberyard Bike Park
LOCATION:Lumberyard Indoor Bike Park, 2700 NE 82nd Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4488
END:VEVENT
BEGIN:VEVENT
SEQUENCE:190
DTSTART;TZID=US/Pacific:20140621T100000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Food Cart Revolution-by bike!
UID:20140621.4483@shift2bikes.org
DESCRIPTION:Food Cart Revolution – by bike! Saturday, June 21st 10:00 am
  -12:00 pm RSVP required through EventBrite.
ORGANIZER:Know Your City, ask@knowyourcity.org, 971-717-7307
LOCATION:SW 10th & Alder, Portland, OR
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4483
END:VEVENT
BEGIN:VEVENT
SEQUENCE:191
DTSTART;TZID=US/Pacific:20140621T103000
DTSTAMP:20140602T000000
SUMMARY:Food Carts 4 Charity! - Summer Food Cart Festival.
UID:20140621.4380@shift2bikes.org
DESCRIPTION:Join us on a ride to the Summer Food Cart Festival a benefit
  for ALSO a leisurely ride to MHCC.
ORGANIZER:Scott Batchelar , http://www.alsoweb.org/food-cart.htm, Follow
  our twitters @fc4charity @FC4CPDX
LOCATION:Gateway Transit Center, NE 99th Ave and Multnomah St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4380
END:VEVENT
BEGIN:VEVENT
SEQUENCE:192
DTSTART;TZID=US/Pacific:20140621T104500
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:80's/90's Cycling fashion themed jerseys...
UID:20140621.4279@shift2bikes.org
DESCRIPTION:Don that 80s and 90s cycling garb and hit the streets for a
  stylin' 20-40 mile scenic jaunt ending with a BBQ.
ORGANIZER:RyRy, ryhererynow@gmail.com, 503-542-4556
LOCATION:Citybikes Cooperative, 734 SE Ankeny St (Parking lot)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4279
END:VEVENT
BEGIN:VEVENT
SEQUENCE:193
DTSTART;TZID=US/Pacific:20140621T113000
DTSTAMP:20140602T000000
SUMMARY:Swim Across Portland
UID:20140621.4156@shift2bikes.org
DESCRIPTION:Join us for the third annual outdoor pool tour. Bring (or
  wear!) your swimsuit, towel, lock and $12 for pool entry fees.
ORGANIZER:Maria Schur, bicyclekitty@gmail.com
LOCATION:Water Avenue Coffee, 1028 SE Water
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4156
END:VEVENT
BEGIN:VEVENT
SEQUENCE:194
DTSTART;TZID=US/Pacific:20140621T120000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Free Box Scavenger Hunt!
UID:20140621.4269@shift2bikes.org
DESCRIPTION:Get ready to search high and low for specific free box items.
  Make teams of 2-3 or just show up and join a team.
ORGANIZER:Pink Princess, Free Box Mavin Meghan, dropout74@gmail.com
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4269
END:VEVENT
BEGIN:VEVENT
SEQUENCE:195
DTSTART;TZID=US/Pacific:20140621T120000
DTSTAMP:20140602T000000
SUMMARY:Tater Tot Tour
UID:20140621.4357@shift2bikes.org
DESCRIPTION:An easy overnight bike camping trip, 33mi each way. Bring $20
  for the MAX & camping fees.
ORGANIZER:Kai, kaionabike@gmail.com, 503-388-0304
LOCATION:Hatfield Government Center MAX Station in Hillsboro, 100 SW Adams
  Ave, Hillsboro (Email me, or check out the blog for more ride info!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4357
END:VEVENT
BEGIN:VEVENT
SEQUENCE:196
DTSTART;TZID=US/Pacific:20140621T120000
DTSTAMP:20140602T000000
SUMMARY:Paddlepalooza!
UID:20140621.4473@shift2bikes.org
DESCRIPTION:4th annual Pedalpalooza Flotilla! kayaks, canoes, rowboats,
  sailboats...bring your boat down to the river BY BIKE!
ORGANIZER:Saul T. Scrapper
LOCATION:Steel Bridge West End, nw naito and nw glisan
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4473
END:VEVENT
BEGIN:VEVENT
SEQUENCE:197
DTSTART;TZID=US/Pacific:20140621T130000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Pedalpakidicalmassalooza Ice Cream
UID:20140621.4359@shift2bikes.org
DESCRIPTION:Ride a loop with Kidical Mass. Lots of ice cream stops! Bring
  money for treats. Kids must have helmets. We ride slowly!
ORGANIZER:Katie Proctor, katie.proctor@gmail.com,
  http://kidicalmasspdx.org/
LOCATION:Laurelhurst City Park, 2419 SE 16th Ave (By the duck pond.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4359
END:VEVENT
BEGIN:VEVENT
SEQUENCE:198
DTSTART;TZID=US/Pacific:20140621T140000
DTSTAMP:20140602T000000
SUMMARY:Trail Ride
UID:20140621.4270@shift2bikes.org
DESCRIPTION:No need to drive to this trail ride! Bring: MTB, lights, water,
  lock, and cash. All ages and abilities welcome.
ORGANIZER:Northwest Trail Alliance, http://nw-trail.org
LOCATION:Jamison Square, NW 10th and Johnson
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4270
END:VEVENT
BEGIN:VEVENT
SEQUENCE:199
DTSTART;TZID=US/Pacific:20140621T143000
DTSTAMP:20140602T000000
SUMMARY:Harry Potter Vs. Lord of the Rings!
UID:20140621.4199@shift2bikes.org
DESCRIPTION:Are you shire folk or Gryffindor? Are you an elf or a house
  elf? Rock your house colors or your hottest Orc gear!!
ORGANIZER:The Leapers!
LOCATION:Sabin Hydropark, 1907 NE Skidmore St (Near the water towers on the
  playground side!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4199
END:VEVENT
BEGIN:VEVENT
SEQUENCE:200
DTSTART;TZID=US/Pacific:20140621T150000
DTSTAMP:20140602T000000
SUMMARY:Wet T-Shirt Ride
UID:20140621.4320@shift2bikes.org
DESCRIPTION:Feel free to bring any spritzing, soaking, or spraying device,
  but please no water balloons-they give the squirrels gas.
ORGANIZER:Alex Steinberger
LOCATION:Da Vinci Middle School, NE 27th Ave and Everett St (on the
  blacktop next to the school)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4320
END:VEVENT
BEGIN:VEVENT
SEQUENCE:201
DTSTART;TZID=US/Pacific:20140621T150000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Sunny Nekid III
UID:20140621.4457@shift2bikes.org
DESCRIPTION:Yet another naked ride through Portland. Bare as you dare.
  Cameras discouraged.
ORGANIZER:Ker Nal and Past Tire
LOCATION:Coe Circle, 3900 NE Glisan St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4457
END:VEVENT
BEGIN:VEVENT
SEQUENCE:202
DTSTART;TZID=US/Pacific:20140621T163000
DTSTAMP:20140602T000000
SUMMARY:Get Lost!
UID:20140621.4305@shift2bikes.org
DESCRIPTION:A ride led entirely by chance. Dice will determine our route
  and, although the route will be legal, it might be...dicey.
ORGANIZER:Amos, happyamosfun@gmail.com
LOCATION:Velo Cult, 1969 NE 42nd
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4305
END:VEVENT
BEGIN:VEVENT
SEQUENCE:203
DTSTART;TZID=US/Pacific:20140621T180000
DTSTAMP:20140602T000000
SUMMARY:Skate Critical Mass
UID:20140621.4472@shift2bikes.org
DESCRIPTION:Skate in the street! Bring your roller skates, blades,
  scooters, and skateboards for a skate around town!
ORGANIZER:Saul T. Scrapper
LOCATION:Saturday Market Fountain , SW Ankeny & Naito
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4472
END:VEVENT
BEGIN:VEVENT
SEQUENCE:204
DTSTART;TZID=US/Pacific:20140621T183000
DTSTAMP:20140602T000000
SUMMARY:Bike Play 6: Bike Play's Big Adventure
UID:20140621.4316@shift2bikes.org
DESCRIPTION:Ride from scene to scene with WTC's 6th annual Bike Play. This
  year's inspiration: Pee-Wee's Big Adventure
ORGANIZER:The Working Theatre Collective,
  http://theworkingtheatrecollective.wordpress.com/
LOCATION:Peninsula Park , 700 N Rosa Parks Way
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4316
END:VEVENT
BEGIN:VEVENT
SEQUENCE:205
DTSTART;TZID=US/Pacific:20140621T190000
DURATION:PT1H0M0S
DTSTAMP:20140602T000000
SUMMARY:Monsteride
UID:20140621.4447@shift2bikes.org
DESCRIPTION:The evening air cools and it's time to put your fur (and horns
  and claws) on. Prizes for best monsterisms.
ORGANIZER:James DeRosso
LOCATION:County Bldg Parking Lot, 921 SE 47th Ave.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4447
END:VEVENT
BEGIN:VEVENT
SEQUENCE:206
DTSTART;TZID=US/Pacific:20140621T203000
DTSTAMP:20140602T000000
SUMMARY:Solstice Ride
UID:20140621.4169@shift2bikes.org
DESCRIPTION:Ride all night on the first day of summer. Bring warm clothes,
  food, water, and a comfortable bike. There will be hills.
ORGANIZER:Nate, yourheartmaystop@gmail.com
LOCATION:Alberta Cooperative Grocery, 1500 NE Alberta St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4169
END:VEVENT
BEGIN:VEVENT
SEQUENCE:207
DTSTART;TZID=US/Pacific:20140621T223000
DTSTAMP:20140602T000000
SUMMARY:rooftop ride
UID:20140621.4327@shift2bikes.org
DESCRIPTION:Urban summits, year five. Come adventure with us! Good shoes,
  sharp wits and dark clothes recommended.
ORGANIZER:jaya, jaya.jeptha@gmail.com, 503-380-2573
LOCATION:39th & NE Glisan (in the center circle!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#21-4327
END:VEVENT
BEGIN:VEVENT
SEQUENCE:208
DTSTART;TZID=US/Pacific:20140622T090000
DTSTAMP:20140602T000000
SUMMARY:Mmm, forbidden donut ride
UID:20140622.4371@shift2bikes.org
DESCRIPTION:A cruise around Portland to sample the city's finest fried
  dough delights.
ORGANIZER:Patrick Caldwell, patrick.m.caldwell@gmail.com
LOCATION:Holladay Park, NE Multnomah betw NE 11th & 13th
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4371
END:VEVENT
BEGIN:VEVENT
SEQUENCE:209
DTSTART;TZID=US/Pacific:20140622T110000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:Sunday Parkways - North
UID:20140622.4250@shift2bikes.org
DESCRIPTION:Enjoy food, music, vendors and bike fun on over 9 miles of
  car-free streets in North Portland.
ORGANIZER:FYI, https://www.portlandoregon.gov/transportation/58929
LOCATION:penninsula park, 700 N Rosa Parks Way
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4250
END:VEVENT
BEGIN:VEVENT
SEQUENCE:210
DTSTART;TZID=US/Pacific:20140622T123000
DTSTAMP:20140602T000000
SUMMARY:Community Orchards Ride
UID:20140622.4399@shift2bikes.org
DESCRIPTION:Ride to orchards that are growing fruit free for anyone to
  harvest. We'll end with a picnic near Sunday Parkways.
ORGANIZER:Emily, http://portlandfruit.org/
LOCATION:Sabin Community Orchard, NE Mason between 18th and 19th
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4399
END:VEVENT
BEGIN:VEVENT
SEQUENCE:211
DTSTART;TZID=US/Pacific:20140622T140000
DTSTAMP:20140602T000000
SUMMARY:Vintage MTB Ride
UID:20140622.4420@shift2bikes.org
DESCRIPTION:Saddle up your grungy old 80s or 90s MTB for some unimproved
  roadway and single track fun.
ORGANIZER:Jeff Ong, info@chowswap.org
LOCATION:Woodstock City Park, SE 47th and Steele
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4420
END:VEVENT
BEGIN:VEVENT
SEQUENCE:212
DTSTART;TZID=US/Pacific:20140622T143000
DTSTAMP:20140602T000000
SUMMARY:Bike Play 6: Bike Play's Big Adventure
UID:20140622.4317@shift2bikes.org
DESCRIPTION:Ride from scene to scene with WTC's 6th annual Bike Play. This
  year's inspiration: Pee-Wee's Big Adventure
ORGANIZER:The Working Theatre Collective
LOCATION:Peninsula Park , 700 N Rosa Parks Way
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4317
END:VEVENT
BEGIN:VEVENT
SEQUENCE:213
DTSTART;TZID=US/Pacific:20140622T150000
DTSTAMP:20140602T000000
SUMMARY:Rose City Pinball Ride
UID:20140622.4410@shift2bikes.org
DESCRIPTION:Bring your quarters. We're hitting up the best pinball in
  Portland!
ORGANIZER:Isaac Ruiz, isaac@rosecitypinball.com
LOCATION:Project 529, 2240 N Interstate Ave (Across from the
  Missippi/Albina MAX Station)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4410
END:VEVENT
BEGIN:VEVENT
SEQUENCE:214
DTSTART;TZID=US/Pacific:20140622T153000
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Performance: The Sprockettes' Summer Camp for Girl
UID:20140622.4381@shift2bikes.org
DESCRIPTION:Join Portland's premiere bike dance troupe at the concluding
  performance of our camp for girls!
ORGANIZER:The Sprockettes, sprockettescamp@gmail.com,
  http://www.sprockettes.org/
LOCATION:Peninsula Park, 700 N Rosa Parks Way (Look for the big crowd in
  Pink and Black!)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4381
END:VEVENT
BEGIN:VEVENT
SEQUENCE:215
DTSTART;TZID=US/Pacific:20140622T160000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Three Speed Ride
UID:20140622.4157@shift2bikes.org
DESCRIPTION:Casual ramble after Sun Pkwys, 8-10mi, mostly flat with some
  dirt roads. Picnic/tea brew up towards end.
ORGANIZER:El Presidente, http://societyofthreespeeds.wordpress.com/
LOCATION:Omaha Parkway, N Omaha Ave and N Ainsworth St (meet on the south
  side of Ainsworth, in the parkway)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4157
END:VEVENT
BEGIN:VEVENT
SEQUENCE:216
DTSTART;TZID=US/Pacific:20140622T163000
DTSTAMP:20140602T000000
SUMMARY:Food Carts 4 Charity! - Bites & Bliss
UID:20140622.4378@shift2bikes.org
DESCRIPTION:Eat tidbits from Food Carts and get Blissed out with Massage
  and Acupuncture, Bring $$
ORGANIZER:Scott Batchelar , http://www.fc4c.org/, Follow our twitters
  @fc4charity @FC4CPDX
LOCATION:SE 12th Ave and SE Hawthorne Blvd
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4378
END:VEVENT
BEGIN:VEVENT
SEQUENCE:217
DTSTART;TZID=US/Pacific:20140622T183000
DTSTAMP:20140602T000000
SUMMARY:Let's Make a Movie!
UID:20140622.4348@shift2bikes.org
DESCRIPTION:Ride with us to scenic spots around town and we'll film a fun,
  non-narrative movie together celebrating the bicycle!
ORGANIZER:Becky & Paul
LOCATION:Pioneer Courthouse Square, SW Broadway and Morrison St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4348
END:VEVENT
BEGIN:VEVENT
SEQUENCE:218
DTSTART;TZID=US/Pacific:20140622T190000
DTSTAMP:20140602T000000
SUMMARY:No Hands Olympics
UID:20140622.4358@shift2bikes.org
DESCRIPTION:Think you're hot shit? Prove it! Spectators encouraged.
  There'll be beer, prizes, and music. BYO band aids.
ORGANIZER:Karl Dawson, karlcd@yahoo.com
LOCATION:Overlook Park, N Interstate Ave and Fremont St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4358
END:VEVENT
BEGIN:VEVENT
SEQUENCE:219
DTSTART;TZID=US/Pacific:20140622T201500
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Bride Ride
UID:20140622.4194@shift2bikes.org
DESCRIPTION:We're getting married. Show up in your wedding finery and go
  for a ride. Wheeee!!!! Lots of white dresses welcome.
ORGANIZER:Ellen, Feyonce
LOCATION:Northeast-ish side of Laurelhurst Park, SE  (Look for the fancy
  clothes)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-4194
END:VEVENT
BEGIN:VEVENT
SEQUENCE:220
DTSTART;TZID=US/Pacific:20140622T203000
DTSTAMP:20140602T000000
SUMMARY:Zoobomb
UID:20140622.3959@shift2bikes.org
DESCRIPTION:Since '02, the most fun you can have on two wheels. Go fast or
  slow but definitely bring a helmet, lights, and MAX fare.
ORGANIZER:Zoobomb, zoobomb@zoobomb.net, http://zoobomb.net
LOCATION:Zoobomb Pyle, SW 13th Ave & W Burnside
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#22-3959
END:VEVENT
BEGIN:VEVENT
SEQUENCE:221
DTSTART;TZID=US/Pacific:20140623T170000
DTSTAMP:20140602T000000
SUMMARY:Billys Birthday Ride
UID:20140623.4455@shift2bikes.org
DESCRIPTION:Bust out your 20" bikes and come ride. All bikes welcome.
  Airplanes and helicopters discouraged.
ORGANIZER:william gump, metalmaker2@yahoo.com
LOCATION:brooklyn park, 3400 SE Milwaukie Ave, Portland, OR 97202
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#23-4455
END:VEVENT
BEGIN:VEVENT
SEQUENCE:222
DTSTART;TZID=US/Pacific:20140623T173000
DURATION:PT6H0M0S
DTSTAMP:20140602T000000
SUMMARY:Showgirls: The Ride
UID:20140623.4211@shift2bikes.org
DESCRIPTION:Wear your best Versace or glittery unitard & join us on a ride
  devoted to the worst/best movie of the 90s: SHOWGIRLS!
ORGANIZER:rhienna, Twitter: @djrhienna
LOCATION:Director Park, SW Yamhill St and 6th Ave, Portland
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#23-4211
END:VEVENT
BEGIN:VEVENT
SEQUENCE:223
DTSTART;TZID=US/Pacific:20140623T174500
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Introducing the Inner Loop
UID:20140623.4428@shift2bikes.org
DESCRIPTION:Central Portland's waterfront jewel needs a single name. Let's
  give it one.
ORGANIZER:Joshua Force, joshua.force@gmail.com, 971-340-8842
LOCATION:Vera Katz statue, SE Eastbank Esplanade and Main St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#23-4428
END:VEVENT
BEGIN:VEVENT
SEQUENCE:224
DTSTART;TZID=US/Pacific:20140623T183000
DTSTAMP:20140602T000000
SUMMARY:Puppy-palooza!
UID:20140623.4324@shift2bikes.org
DESCRIPTION:DOGS ON BIKES! Bring your bike and your four-pawed, furry
  friends. There will be romping, riding and treats.
ORGANIZER:Pooch Pedalers, erinne.larissa@gmail.com
LOCATION:Meat for Cats and Dogs, 2205 E Burnside St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#23-4324
END:VEVENT
BEGIN:VEVENT
SEQUENCE:225
DTSTART;TZID=US/Pacific:20140623T190000
DTSTAMP:20140602T000000
SUMMARY:The Patina Ride
UID:20140623.4314@shift2bikes.org
DESCRIPTION:Bring out your favorite old ride. Faded paint? Cracked and or
  grazed finish? Structural rust? Let's ride!
ORGANIZER:Spencer
LOCATION:Paradox cafe, 3439 SE Belmont St (We will assemble around the west
  side of the building)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#23-4314
END:VEVENT
BEGIN:VEVENT
SEQUENCE:226
DTSTART;TZID=US/Pacific:20140623T190000
DTSTAMP:20140602T000000
SUMMARY:Danzig's BDAY 20" RALLYCAT
UID:20140623.4334@shift2bikes.org
DESCRIPTION:ALLEY CAT RACE FOR GLENN DANZIG'S BIRTHDAY. GRAB A 20" BMX.
  MEET @ WASHINGTON HIGH, 7PM. RALLY AFTER. RIDE JACKIE RIDE!
ORGANIZER:SEANZIG, SBRADY89@GMAIL.COM,
  https://www.facebook.com/events/1453481918225431/
LOCATION:TBA
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#23-4334
END:VEVENT
BEGIN:VEVENT
SEQUENCE:227
DTSTART;TZID=US/Pacific:20140624T160000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Rush Hour Ride
UID:20140624.4459@shift2bikes.org
DESCRIPTION:We're going to ride the arterial highways of Portland, like
  Sandy and MLK. Ends at Barbur Ride
ORGANIZER:Robert Moses and Tom McCall
LOCATION:Morrison Bridge, in the middle at the "bus stop"
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4459
END:VEVENT
BEGIN:VEVENT
SEQUENCE:228
DTSTART;TZID=US/Pacific:20140624T171500
DTSTAMP:20140602T000000
SUMMARY:Reverse Commute: Beaverton to Portland
UID:20140624.4471@shift2bikes.org
DESCRIPTION:Ride the reverse commute from Beaverton to Portland, checking
  out trails, bikes and transit, and Washington Park.
ORGANIZER:Lisa Frank, lisa@btaoregon.org, 503-758-0712
LOCATION:Beaverton Round, 12725 SW Millikan Way, Beaverton (By the
  Beaverton Central MAX station)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4471
END:VEVENT
BEGIN:VEVENT
SEQUENCE:229
DTSTART;TZID=US/Pacific:20140624T173000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:BARBUR HIGH CRASH CORRIDOR Version 3.0
UID:20140624.4453@shift2bikes.org
DESCRIPTION:Learn why Barbur is a High Crash Corridor with SW Portland
  advocates. A commute outside your comfort zone!
ORGANIZER:Roger Averbeck, roger.averbeck@gmail.com
LOCATION:Barbur High Crash Corridor Version 3.0, 1120 SW 5th Ave, Portland,
  OR 97204  (Meet at the Portland Bldg main entrance on SW 5th Ave)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4453
END:VEVENT
BEGIN:VEVENT
SEQUENCE:230
DTSTART;TZID=US/Pacific:20140624T174500
DTSTAMP:20140602T000000
SUMMARY:The Dream of the 1890s is Alive in NW Portland
UID:20140624.4349@shift2bikes.org
DESCRIPTION:Learn about Portland's lumberjacks, business tycoons, dock
  workers, and even a good old-fashioned hangin'.
ORGANIZER:PDX_Becs, kiwimunki@hotmail.com
LOCATION:NW Cultural Center, 1819 NW Everett Street, Portland OR (Meet on
  the NW Cultural Center's front steps)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4349
END:VEVENT
BEGIN:VEVENT
SEQUENCE:231
DTSTART;TZID=US/Pacific:20140624T180000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Heritage Tree Bike Ride
UID:20140624.4239@shift2bikes.org
DESCRIPTION:Join this leisurely 4-mile tour of Vancouver's finest Heritage
  Trees, the oldest and most storied trees in our region.
ORGANIZER:VUF, urbanforestry@cityofvancouver.us, 360-487-8308
LOCATION:meet at Esther Short Park, W 6th & Columbia St Vancouver, WA 98668
  (meet near the clock tower)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4239
END:VEVENT
BEGIN:VEVENT
SEQUENCE:232
DTSTART;TZID=US/Pacific:20140624T180000
DTSTAMP:20140602T000000
SUMMARY:The Benson Ride
UID:20140624.4254@shift2bikes.org
DESCRIPTION:A tour of Portland's 'Bensons' in celebration of the release of
  Brian Benson's bike trip memoir, "Going Somewhere." Ends at reading.
ORGANIZER:Simon Benson IV, leah.benson@gmail.com,
  http://www.powells.com/biblio/9780142180648
LOCATION:Gladys Bikes, 2905 NE Alberta Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4254
END:VEVENT
BEGIN:VEVENT
SEQUENCE:233
DTSTART;TZID=US/Pacific:20140624T183000
DTSTAMP:20140602T000000
SUMMARY:Volunteer at Bike Farm
UID:20140624.4098@shift2bikes.org
DESCRIPTION:Attend our monthly volunteer orientation to find out more about
  Bike Farm and how you can help.
ORGANIZER:the holla, volunteer@bikefarm.org, http://bikefarm.org/
LOCATION:Bike Farm, 1810 NE First Avenue (NE First and NE Schuyler, one
  block north of Broadway)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4098
END:VEVENT
BEGIN:VEVENT
SEQUENCE:234
DTSTART;TZID=US/Pacific:20140624T190000
DTSTAMP:20140602T000000
SUMMARY:Chutes And Ladders Ride
UID:20140624.4292@shift2bikes.org
DESCRIPTION:We recreate the classic game of Chutes & Ladders life-size on
  the east-side street grid.
ORGANIZER:Look Good Feel Good
LOCATION:Irving Park, NE 7th Ave and Fargo St, Portland (top of the knob)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#24-4292
END:VEVENT
BEGIN:VEVENT
SEQUENCE:235
DTSTART;TZID=US/Pacific:20140625T163000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:BTA Commuter Station on SW Barbur
UID:20140625.4332@shift2bikes.org
DESCRIPTION:FREE SNACKS! Bike Registration! Just stop by and say hello,
  because BTA <3s bike riders!
ORGANIZER:Bicycle Transportation Alliance, nicole@btaoregon.org,
  503-226-0676
LOCATION:4999 SW Barbur Blvd (0.1 miles south on SW Barbur from Hamilton on
  the right side)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4332
END:VEVENT
BEGIN:VEVENT
SEQUENCE:236
DTSTART;TZID=US/Pacific:20140625T163000
DURATION:PT0H30M0S
DTSTAMP:20140602T000000
SUMMARY:Clown Parade!!
UID:20140625.4421@shift2bikes.org
DESCRIPTION:What makes a clown?? Dress up, bring your gadgets/gizmoz & come
  parade with us! Pace is slow for half hour to a park!
ORGANIZER:Olive Rootbeer & Dingo, iloverootbeer.dingo@gmail.com,
  971-221-6715
LOCATION:Pieper Cafe, 6504 SE Foster Rd.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4421
END:VEVENT
BEGIN:VEVENT
SEQUENCE:237
DTSTART;TZID=US/Pacific:20140625T173000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Demystifying Bike Signals, Buttons, and Loops
UID:20140625.4426@shift2bikes.org
DESCRIPTION:An 8-10 mile tour of the good and the bad of bike signals and
  intersection treatments. Sponsored by WTS.
ORGANIZER:Lidwien Rahman and Pam Johnson, pcj@pdx.edu
LOCATION:PSU Urban Plaza, between SW 5th and 6th Ave's, and Mill and
  Montgomery Streets (Near the bike racks)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4426
END:VEVENT
BEGIN:VEVENT
SEQUENCE:238
DTSTART;TZID=US/Pacific:20140625T180000
DURATION:PT1H0M0S
DTSTAMP:20140602T000000
SUMMARY:Free Legal Clinic For Bicyclists
UID:20140625.4114@shift2bikes.org
DESCRIPTION:Attorney Ray Thomas covers Oregon bike and pedestrian laws,
  insurance policies, and what to do if you're in a crash.
ORGANIZER:Bicycle Transportation Alliance, cgee@stc-law.com, 503-228-5222
LOCATION:BTA, 618 NW Glisan, Suite 401, Portland.   (Use Buzzer #41)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4114
END:VEVENT
BEGIN:VEVENT
SEQUENCE:239
DTSTART;TZID=US/Pacific:20140625T183000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Bikes+Books
UID:20140625.4240@shift2bikes.org
DESCRIPTION:A literary event with a bar. 10 authors will read from their
  bike-related books, book signings + sales, food cart.
ORGANIZER:Ayleen Crotty, AyleenCrotty@Gmail.com, 971-221-7228
LOCATION:Disjecta Courtyard, 1848 North McClellen (On McClellen between
  Denver and Fenwick, in the courtyard)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4240
END:VEVENT
BEGIN:VEVENT
SEQUENCE:240
DTSTART;TZID=US/Pacific:20140625T184500
DTSTAMP:20140602T000000
SUMMARY:Bike Band Ride
UID:20140625.4433@shift2bikes.org
DESCRIPTION:Sounds from our souls on an acoustically scenic ride!
ORGANIZER:BubbleStar, gvpope@gmail.com
LOCATION:Holladay Park, NE Multnomah betw NE 11th & 13th
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4433
END:VEVENT
BEGIN:VEVENT
SEQUENCE:241
DTSTART;TZID=US/Pacific:20140625T190000
DTSTAMP:20140602T000000
SUMMARY:Photobooth Ride
UID:20140625.4222@shift2bikes.org
DESCRIPTION:A fun casual ride to some of Portland's photo booths. Bring
  cash and props. Take a picture! It'll last longer!
ORGANIZER:Vanessa, vforro79@gmail.com
LOCATION:The Standard, 14 NE 22nd Ave (The Standard, Beulahland, Alleyway,
  Florida Room, Disjecta)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4222
END:VEVENT
BEGIN:VEVENT
SEQUENCE:242
DTSTART;TZID=US/Pacific:20140625T190000
DURATION:PT1H30M0S
DTSTAMP:20140602T000000
SUMMARY:Tour de Franzia
UID:20140625.4466@shift2bikes.org
DESCRIPTION:Bring any color you like: red, pink, or white!
ORGANIZER:Ernest & Julio
LOCATION:Sabin HydroPark , NE 19th and Skidmore (Under the large towers
  full of liquids. No, seriously.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4466
END:VEVENT
BEGIN:VEVENT
SEQUENCE:243
DTSTART;TZID=US/Pacific:20140625T220000
DTSTAMP:20140602T000000
SUMMARY:Silent Ride
UID:20140625.4367@shift2bikes.org
DESCRIPTION:The chilliest ride of Pedalpalooza. Stealth through the night
  on a mystery tour of Portland's less-known areas. Shhh!
ORGANIZER:Claire, clairealyea@gmail.com
LOCATION:Sewallcrest Park, SE 31st Ave and Stephens St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#25-4367
END:VEVENT
BEGIN:VEVENT
SEQUENCE:244
DTSTART;TZID=US/Pacific:20140626T104500
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Volunteer For Beer!
UID:20140626.4303@shift2bikes.org
DESCRIPTION:Volunteer for a 2-hour bike parking shift at the North American
  Organic Brewers Festival, get a mug and 12 tokens!
ORGANIZER:North American Organic Brewers Festival,
  http://www.signupgenius.com/go/30E0C4DA4A723AB9-bike
LOCATION:Overlook Park, N Interstate Ave and Fremont St (Softball diamond
  infield SW corner of the park.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4303
END:VEVENT
BEGIN:VEVENT
SEQUENCE:245
DTSTART;TZID=US/Pacific:20140626T130000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Explore the Green Bike Loop
UID:20140626.4298@shift2bikes.org
DESCRIPTION:Explore the future "Green Loop" from Tillikum Crossing, thru
  the Park Blocks, Lloyd District to OMSI.
ORGANIZER:Joseph & Sean, http://greenbikeloop.weebly.com/
LOCATION:Go by Bike, 3303 SW Bond (Valet bike parking at the base of the
  Aerial Tram)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4298
END:VEVENT
BEGIN:VEVENT
SEQUENCE:246
DTSTART;TZID=US/Pacific:20140626T140000
DTSTAMP:20140602T000000
SUMMARY:Joy of Sects 2: Jaunty Hat Edition
UID:20140626.4439@shift2bikes.org
DESCRIPTION:Silly religious parodies. Beer. Slow pace. No helmets. Check
  website for more details.
ORGANIZER:Halleylujah, http://tinyurl.com/o3wx3nd
LOCATION:24th and Meatballs, 2329 NE Glisan St, Portland, OR 97232
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4439
END:VEVENT
BEGIN:VEVENT
SEQUENCE:247
DTSTART;TZID=US/Pacific:20140626T170000
DTSTAMP:20140602T000000
SUMMARY:Food Carts 4 Charity -Steven & Tiffany!
UID:20140626.4377@shift2bikes.org
DESCRIPTION:Let's hit up a few food carts on the way to Steven Shomler and
  Tiffany Harelik's "Portland Food Cart Stories" signing!
ORGANIZER:Scott Batchelar , http://www.fc4c.org/, Follow our twitters
  @fc4charity @FC4CPDX
LOCATION:Holladay Park, NE Multnomah betw NE 11th & 13th
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4377
END:VEVENT
BEGIN:VEVENT
SEQUENCE:248
DTSTART;TZID=US/Pacific:20140626T180000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:B4HPDX Free Volunteer Mechanics Class
UID:20140626.4125@shift2bikes.org
DESCRIPTION:Those willing to volunteer 10 hours for Bikes for Humanity may
  attend this 24-hour bike mechanics class.
ORGANIZER:Steven, b4hpdx@gmail.com, http://www.b4hpdx.org/
LOCATION:Bikes For Humanity PDX, 4038 SE Brooklyn Street
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4125
END:VEVENT
BEGIN:VEVENT
SEQUENCE:249
DTSTART;TZID=US/Pacific:20140626T180000
DURATION:PT6H0M0S
DTSTAMP:20140602T000000
SUMMARY:Broken Bicycles Tom Waits Ride
UID:20140626.4362@shift2bikes.org
DESCRIPTION:A slow boozy ride through Portland's dives and strip clubs,
  celebrating Tom Waits
ORGANIZER:The Human Skeleton, thehumanskeleton@yahoo.com,
  http://tiny.cc/twaits/
LOCATION:Billy Ray's Dive Bar, 2216 NE Martin Luther King Jr Blvd (2216 NE
  Martin Luther King Jr Blvd)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4362
END:VEVENT
BEGIN:VEVENT
SEQUENCE:250
DTSTART;TZID=US/Pacific:20140626T180000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Transport Your Activism
UID:20140626.4458@shift2bikes.org
DESCRIPTION:Ride Portland's bikeways to see what we want to change! Bring
  tape measures, graph paper, radar guns, and ideas!
ORGANIZER:Ted Buehler, ted101@gmail.com,
  http://bikeportland.org/2010/06/23/ride-provides-info-and-inspiration-for-t
  ransportation-activism-35561 /
LOCATION:Organics To You, 606 SE Madison
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4458
END:VEVENT
BEGIN:VEVENT
SEQUENCE:251
DTSTART;TZID=US/Pacific:20140626T183000
DTSTAMP:20140602T000000
SUMMARY:The Ginger Ride (6th Annual!)
UID:20140626.4197@shift2bikes.org
DESCRIPTION:Bring your bike, your red hairs, your red wig (if you're not a
  natural), and let us ride red! PS it's free!
ORGANIZER:The Ginger Rider
LOCATION:White Owl Social Club, 1305 SE 8th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4197
END:VEVENT
BEGIN:VEVENT
SEQUENCE:252
DTSTART;TZID=US/Pacific:20140626T184500
DTSTAMP:20140602T000000
SUMMARY:Young Meditators Ride!
UID:20140626.4374@shift2bikes.org
DESCRIPTION:Come ride, meditate, and potluck with folks from the Shambala
  Young Meditators Group!
ORGANIZER:Kelly Aldinger, kelly.aldinger@gmail.com
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4374
END:VEVENT
BEGIN:VEVENT
SEQUENCE:253
DTSTART;TZID=US/Pacific:20140626T190000
DTSTAMP:20140602T000000
SUMMARY:Unicycles for Noobs
UID:20140626.4296@shift2bikes.org
DESCRIPTION:Are you one wheel curious? Don't want to deal with TWO wheels,
  a chain, derailleur, gears and handlebars?
ORGANIZER:Hamilton H. Orr, ubtumblr@gmail.com
LOCATION:Alberta Park Bike Polo Court, NE 22nd Ave and Killingsworth St.
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4296
END:VEVENT
BEGIN:VEVENT
SEQUENCE:254
DTSTART;TZID=US/Pacific:20140626T190000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:That 70's ride
UID:20140626.4346@shift2bikes.org
DESCRIPTION:It's the 70's again! Hip huggers, bell bottoms, and gumby
  shoes. We will be cruising the waterfront. Diggit man!
ORGANIZER:Keith & Danny Partridge
LOCATION:Salmon Street Fountain, SW Salmon St and Naito Pkwy
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4346
END:VEVENT
BEGIN:VEVENT
SEQUENCE:255
DTSTART;TZID=US/Pacific:20140626T213000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Tour of Portland Part Too...MMR Version
UID:20140626.4344@shift2bikes.org
DESCRIPTION:A life-size replica of an "infamous and contested" Midnight
  Mystery Ride. 12 Miles. Bring beer, firewood, yadda yadda...
ORGANIZER:Steven Michael
LOCATION:Suki's Bar and Grill, 2401 SW 4th Ave (In the parking lot.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#26-4344
END:VEVENT
BEGIN:VEVENT
SEQUENCE:256
DTSTART;TZID=US/Pacific:20140627T060000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Early morning coffee & ride
UID:20140627.4276@shift2bikes.org
DESCRIPTION:Meet at 6 for coffee and nibbles, ride at 6:30. End at BonB
  around 8:30am.
ORGANIZER:Erinne, erinne.larissa@gmail.com
LOCATION:Extracto Coffee, 2921 NE Killingsworth St
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4276
END:VEVENT
BEGIN:VEVENT
SEQUENCE:257
DTSTART;TZID=US/Pacific:20140627T070000
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Breakfast on the Bridges
UID:20140627.4480@shift2bikes.org
DESCRIPTION:Stop for some coffee, treats, and camaraderie. Running late?
  We've got tardy slips! A Portland tradition since 2002.
ORGANIZER:Shift, bonb@lists.riseup.net,
  http://shift2bikes.org/wiki/bikefun:breakfast_on_the_bridges
LOCATION:Hawthorne, Burnside, and Lower Steel Bridges
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4480
END:VEVENT
BEGIN:VEVENT
SEQUENCE:258
DTSTART;TZID=US/Pacific:20140627T104500
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Volunteer For Beer!
UID:20140627.4303@shift2bikes.org
DESCRIPTION:Volunteer for a 2-hour bike parking shift at the North American
  Organic Brewers Festival, get a mug and 12 tokens!
ORGANIZER:North American Organic Brewers Festival,
  http://www.signupgenius.com/go/30E0C4DA4A723AB9-bike
LOCATION:Overlook Park, N Interstate Ave and Fremont St (Softball diamond
  infield SW corner of the park.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4303
END:VEVENT
BEGIN:VEVENT
SEQUENCE:259
DTSTART;TZID=US/Pacific:20140627T110000
DTSTAMP:20140602T000000
SUMMARY:Sauvie Island Adventure Ride
UID:20140627.4416@shift2bikes.org
DESCRIPTION:25 mile trip out to the sunny, clothing-optional sands of
  Collins Beach. Don't forget your towel!
ORGANIZER:Scott Batchelar , sbphotos@mac.com, 971-207-5523
LOCATION:The Fields Neighborhood Park, 1099 NW Overton St, Portland, OR
  97209
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4416
END:VEVENT
BEGIN:VEVENT
SEQUENCE:260
DTSTART;TZID=US/Pacific:20140627T113000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:Tank of Doom Tour of PDX Oil Profiteers
UID:20140627.4288@shift2bikes.org
DESCRIPTION:The Tank of Doom tours the NW PDX facilities of the firms
  profiting from Bakken shale and tar sands oil extraction.
ORGANIZER:Portland Rising Tide, http://portlandrisingtide.com
LOCATION:North Park Blocks, NW Park Ave and Couch St (We'll be close to the
  elephant--the one in the room.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4288
END:VEVENT
BEGIN:VEVENT
SEQUENCE:261
DTSTART;TZID=US/Pacific:20140627T173000
DTSTAMP:20140602T000000
SUMMARY:Critical Mass: People, Planet, Peace over Profit
UID:20140627.4281@shift2bikes.org
DESCRIPTION:What if there were FAR more bikes at rush hour? Not following
  leaders, of course... Mass up for People, Planet and Peace
ORGANIZER:PDX Bike Swarm and PDX Valkyries
LOCATION:North Park Blocks, NW Park Ave and Couch St (Bronze Elephant)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4281
END:VEVENT
BEGIN:VEVENT
SEQUENCE:262
DTSTART;TZID=US/Pacific:20140627T184500
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Grant Petersen Ride
UID:20140627.4255@shift2bikes.org
DESCRIPTION:Just Ride.
ORGANIZER:Andy Schmidt
LOCATION:3000 N Willamette Blvd (Meet at the dead madrona tree)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4255
END:VEVENT
BEGIN:VEVENT
SEQUENCE:263
DTSTART;TZID=US/Pacific:20140627T190000
DTSTAMP:20140602T000000
SUMMARY:The Sprockettes Ride
UID:20140627.4260@shift2bikes.org
DESCRIPTION:The Sprockettes are turning 10 and they want to ride and dance
  with YOU!
ORGANIZER:The Sprockettes, sprockettes@gmail.com
LOCATION:Peninsula Park (700 N Rosa Parks Way)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4260
END:VEVENT
BEGIN:VEVENT
SEQUENCE:264
DTSTART;TZID=US/Pacific:20140627T200000
DTSTAMP:20140602T000000
SUMMARY:Run-D.M.C. Vs. Beastie Boys
UID:20140627.4448@shift2bikes.org
DESCRIPTION:Calling all B-Boys & Fly-Girls! Yes, yes y'all and we don't
  stop! Break Dancers: BYO Cardboard
ORGANIZER:Diablo, http://bit.ly/RUNDMC2014
LOCATION:North Bar, 5008 SE Division St (Meet across the street in one of
  the parking lots)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#27-4448
END:VEVENT
BEGIN:VEVENT
SEQUENCE:265
DTSTART;TZID=US/Pacific:20140628T090000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:History of Housing Discrimination Ride
UID:20140628.4407@shift2bikes.org
DESCRIPTION:Learn about Portland and Oregon's history of discrimination and
  segregation, led by 4 local community organizations.RSVP
ORGANIZER:Justin Buri, Mychal Tettah, Diane Hess, Chiquita Rollins and
  Vivian Satterfield
LOCATION:Community Cycling Center Offices, 1805 NE 2nd Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4407
END:VEVENT
BEGIN:VEVENT
SEQUENCE:266
DTSTART;TZID=US/Pacific:20140628T100000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:Bikes for Humanity Volunteer Repair Clinics
UID:20140628.2528@shift2bikes.org
DESCRIPTION:Learn bike repair skills FREE by helping refurbish bikes for a
  non-profit project. Details at www.b4hpdx.org
ORGANIZER:Steven
LOCATION:B4HPDX Store, 3354 SE Powell Blvd. Portland Oregon
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-2528
END:VEVENT
BEGIN:VEVENT
SEQUENCE:267
DTSTART;TZID=US/Pacific:20140628T100000
DTSTAMP:20140602T000000
SUMMARY:Ebike Ride with Martina
UID:20140628.4391@shift2bikes.org
DESCRIPTION:Let's explore Smith and Bybee Lakes by electric-assist bike.
  Don't have one? Rent one at our start point!
ORGANIZER:Martina Fahrner, Martina@pobox.com, 971-263-0475
LOCATION:Ebike store, N 809 Rosa Parks Way (Parking Lot)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4391
END:VEVENT
BEGIN:VEVENT
SEQUENCE:268
DTSTART;TZID=US/Pacific:20140628T103000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Parklandia! A bike tour of Portland Parks
UID:20140628.4485@shift2bikes.org
DESCRIPTION:Parklandia: A Portland Bike Tour Saturday, June 28,
  10:30AM-12:30PM Ride Departs from The Portland Art Museum Members: $
ORGANIZER:Know Your City, ask@knowyourcity.org, 971-717-7307
LOCATION:Portland Art Museum, 1219 SW Park Ave (Out in front)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4485
END:VEVENT
BEGIN:VEVENT
SEQUENCE:269
DTSTART;TZID=US/Pacific:20140628T104500
DURATION:PT2H0M0S
DTSTAMP:20140602T000000
SUMMARY:Volunteer For Beer!
UID:20140628.4303@shift2bikes.org
DESCRIPTION:Volunteer for a 2-hour bike parking shift at the North American
  Organic Brewers Festival, get a mug and 12 tokens!
ORGANIZER:North American Organic Brewers Festival,
  http://www.signupgenius.com/go/30E0C4DA4A723AB9-bike
LOCATION:Overlook Park, N Interstate Ave and Fremont St (Softball diamond
  infield SW corner of the park.)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4303
END:VEVENT
BEGIN:VEVENT
SEQUENCE:270
DTSTART;TZID=US/Pacific:20140628T113000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:Loving Oregon Summer: Helvetia Bike Ride
UID:20140628.4283@shift2bikes.org
DESCRIPTION:Hailed for irreplaceable high-value farming areas, Helvetia is
  also mighty scenic. Explore the Urban Growth Boundary!
ORGANIZER:1000 Friends of Oregon & Amanda Caffall, amanda@friends.org
LOCATION:Orenco MAX Station, NW 231st Ave and NE Alder St, Hillsboro
  (Orenco MAX Station)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4283
END:VEVENT
BEGIN:VEVENT
SEQUENCE:271
DTSTART;TZID=US/Pacific:20140628T130000
DURATION:PT2H30M0S
DTSTAMP:20140602T000000
SUMMARY:Sunny Day Nekkid Ride
UID:20140628.4309@shift2bikes.org
DESCRIPTION:Daytime. No clothes. Unannounced. 5 quadrants. Legal. Way more
  fun than the nighttime WNBR.
ORGANIZER:fluxgeo, fluxgeo@yahoo.com, 971-207-5804
LOCATION:Coe Circle, Joan of Arc Statue, 3900 NE Glisan St (Coe Circle,
  Joan of Arc Statue, 3900 NE Glisan @ Cesar Chavez)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4309
END:VEVENT
BEGIN:VEVENT
SEQUENCE:272
DTSTART;TZID=US/Pacific:20140628T130000
DURATION:PT3H0M0S
DTSTAMP:20140602T000000
SUMMARY:The Pink Parade
UID:20140628.4400@shift2bikes.org
DESCRIPTION:A celebration of bicycles, the color pink, and rosé wines from
  Oregon & beyond.
ORGANIZER:Brian Davis
LOCATION:Big Pink, SW Oak St and 6th Ave
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4400
END:VEVENT
BEGIN:VEVENT
SEQUENCE:273
DTSTART;TZID=US/Pacific:20140628T140000
DURATION:PT5H0M0S
DTSTAMP:20140602T000000
SUMMARY:The Bike Fair
UID:20140628.4150@shift2bikes.org
DESCRIPTION:Annual Multnomah County Bike Fair
ORGANIZER:Agent Scout, thirtysevenart@hotmail.com
LOCATION:Col. Summers Park, SE 20th and Belmont
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4150
END:VEVENT
BEGIN:VEVENT
SEQUENCE:274
DTSTART;TZID=US/Pacific:20140628T140000
DTSTAMP:20140602T000000
SUMMARY:NWTA - Ride to your ride
UID:20140628.4338@shift2bikes.org
DESCRIPTION:No need to drive to this trail ride! Bring: MTB, lights, water,
  lock, and cash. All ages and abilities welcome.
ORGANIZER:Northwest Trail Alliance, http://nw-trail.org/
LOCATION:Cartlandia, 8145 SE 82nd St., Portland, OR
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4338
END:VEVENT
BEGIN:VEVENT
SEQUENCE:275
DTSTART;TZID=US/Pacific:20140628T180000
DURATION:PT4H0M0S
DTSTAMP:20140602T000000
SUMMARY:NWTA Family Mtn Bike Night Ride, Bonfire, And Camp
UID:20140628.4343@shift2bikes.org
DESCRIPTION:A family moutainbike campout at Cascade Locks. Campfire, kids
  skills course, beginner-friendly trails...
ORGANIZER:Northwest Trail Alliance, http://www.dimwitswithbritelites.org/
LOCATION:EasyCLIMB Trail Cascade Locks,
  https://www.google.com/maps/@45.6852998,-121.853669,17z (Through Town, Left
  of Forest Lane, Left on Industrial Way to the End)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4343
END:VEVENT
BEGIN:VEVENT
SEQUENCE:276
DTSTART;TZID=US/Pacific:20140628T200000
DURATION:PT8H0M0S
DTSTAMP:20140602T000000
SUMMARY:Loud'n'Lit ride
UID:20140628.4295@shift2bikes.org
DESCRIPTION:Closing out Pedalpalooza with a bang. Flaming tall bike
  jousting tourney and DJ's till the sun comes up.
ORGANIZER:Tall Tour Crew
LOCATION:Col. Summers Park, SE 20th and Belmont (post-bike fair party)
ATTACH:http://www.shift2bikes.org/cal/viewpp2014.php#28-4295
END:VEVENT
END:VCALENDAR

END
end
