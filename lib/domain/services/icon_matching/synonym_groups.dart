import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Semantic synonym groups.
/// Each group maps a large set of related real-world words to a single icon.
/// This is what makes "parents" → family icon work, even though "parents"
/// is never a brand or a spending keyword.
class SynonymGroups {
  /// Each entry: icon → list of synonyms that all resolve to that icon.
  static final List<_SynonymGroup> groups = [
    // ── Family & People ─────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.peopleGroup, [
      'family', 'parent', 'parents', 'mom', 'mum', 'mama', 'mommy', 'mummy',
      'dad', 'papa', 'daddy', 'father', 'mother', 'son', 'daughter',
      'brother', 'sister', 'bro', 'sis', 'sibling', 'siblings',
      'uncle', 'aunt', 'aunty', 'auntie', 'nephew', 'niece',
      'cousin', 'cousins', 'relatives', 'relation', 'relations',
      'grandma', 'grandpa', 'grandmother', 'grandfather', 'granny', 'nana', 'nani',
      'dada', 'dadi', 'nanu', 'chacha', 'chachi', 'mama', 'mami',
      'bua', 'fufa', 'mausa', 'mausi', 'jija', 'bhabhi',
      'sasur', 'saas', 'devrani', 'jethani',
      'inlaws', 'inlaw', 'fatherinlaw', 'motherinlaw',
      'kids', 'children', 'child', 'kiddo', 'toddler',
      'stepfather', 'stepmother', 'stepdad', 'stepmom',
      'godfather', 'godmother', 'guardian',
      'household', 'familytime', 'relatives',
    ]),

    // ── Friends & Social ────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.userGroup, [
      'friend', 'friends', 'bestfriend', 'bff', 'buddy', 'pal',
      'mate', 'mates', 'bro', 'dude', 'homie', 'gang', 'squad',
      'colleague', 'colleagues', 'coworker', 'coworkers', 'workmate',
      'boss', 'manager', 'supervisor', 'team', 'teammates',
      'roommate', 'roommates', 'flatmate', 'housemate',
      'neighbor', 'neighbour', 'neighbors', 'neighbours',
      'classmate', 'classmates', 'batchmate', 'senior', 'junior',
      'hangout', 'hangouts', 'outing', 'gettogether',
      'reunion', 'meetup', 'gathering', 'potluck',
      'groupdinner', 'teamlunch', 'teamdinner', 'farewell',
      'housewarming', 'kittyparty',
    ]),

    // ── Romance & Dating ────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.heart, [
      'girlfriend', 'boyfriend', 'gf', 'bf', 'partner', 'bae',
      'husband', 'wife', 'hubby', 'wifey', 'spouse', 'soulmate',
      'fiance', 'fiancee', 'lover', 'sweetheart', 'darling',
      'date', 'dating', 'datenight', 'romantic', 'romance',
      'love', 'anniversary', 'honeymoon', 'couple',
      'proposal', 'engagement', 'ring',
    ]),

    // ── Food & Dining (broad) ───────────────────────────────
    _SynonymGroup(FontAwesomeIcons.utensils, [
      'foodie', 'buffet', 'feast', 'banquet', 'catering', 'caterer',
      'tiffin', 'dabba', 'lunchbox', 'canteen', 'cafeteria', 'messroom',
      'mess', 'foodcourt', 'streetfood', 'chaatcorner', 'chaat',
      'dhaba', 'bhojanalaya', 'hotel', 'eatery', 'bistro', 'diner',
      'barbeque', 'bbq', 'grill', 'roast', 'kebab', 'tikka',
      'tandoori', 'momos', 'chowmein', 'manchurian', 'friedrice',
      'idli', 'vada', 'sambar', 'uttapam', 'appam', 'puttu',
      'samosa', 'pakora', 'bhaji', 'kachori', 'jalebi', 'gulabjamun',
      'rasgulla', 'barfi', 'laddu', 'halwa', 'kheer', 'payasam',
      'mithai', 'paan', 'supari',
    ]),

    // ── Beverages (broad) ───────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.mugHot, [
      'beverage', 'beverages', 'hotchocolate', 'matcha', 'mocha',
      'frappuccino', 'macchiato', 'americano', 'flatwhite',
      'coldcoffee', 'icedtea', 'icedcoffee', 'boba', 'bubbletea',
      'lassi', 'chaas', 'buttermilk', 'nimbu', 'nimbupaani',
      'lemonade', 'sharbat', 'thandai', 'milkshake', 'shake',
      'kombucha', 'greenteabreak', 'coffeebreak', 'teatime',
    ]),

    // ── Transport (broad) ───────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.car, [
      'commuting', 'carpool', 'carpooling', 'rideshare', 'ridesharing',
      'carwash', 'carservice', 'carrepair', 'mechanic', 'garage',
      'tyre', 'tire', 'tires', 'tyres', 'alignment', 'servicing',
      'tuneup', 'oilchange', 'brakes', 'clutch', 'engine',
      'emission', 'puc', 'registration', 'rto', 'challan',
      'trafficfine', 'speeding', 'towing', 'breakdown',
      'roadside', 'assistance', 'fastag', 'etoll',
      'driving', 'drivingschool', 'drivingtest', 'license',
    ]),

    // ── Travel (broad) ──────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.earthAmericas, [
      'overseas', 'abroad', 'backpacking', 'backpacker', 'wanderlust',
      'pilgrimage', 'yatra', 'tirth', 'hajj', 'umrah',
      'roadtrip', 'longdrive', 'adventure', 'safari', 'expedition',
      'cruise', 'excursion', 'sightseeing', 'exploration', 'explore',
      'souvenir', 'souvenirs', 'memento', 'postcard',
      'currency', 'forex', 'exchange', 'moneyexchange',
      'travelinsurance', 'travelbag', 'travelkit',
    ]),

    // ── Home & Domestic ─────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.house, [
      'housing', 'housetax', 'propertytax', 'society', 'societyfees',
      'association', 'hoa', 'commonarea', 'liftmaintenance',
      'interiordesign', 'interior', 'curtains', 'blinds', 'carpet',
      'rug', 'tiles', 'flooring', 'wallpaper', 'partition',
      'shifting', 'moving', 'relocation', 'packers', 'movers',
      'packersandmovers', 'deposit', 'securitydeposit', 'brokerage',
      'broker', 'agent', 'realtor', 'realestate', 'property',
      'stamp', 'stampduty', 'registration',
    ]),

    // ── Utilities (broad) ───────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.bolt, [
      'utility', 'utilities', 'ebill', 'powerbill', 'electricbill',
      'waterbill', 'gasbill', 'phonebill', 'internetbill',
      'sewer', 'sewage', 'drainage', 'municipal', 'corporation',
      'prepaid', 'postpaid', 'datapack', 'topup',
      'inverter', 'generator', 'solar', 'solarpanel',
      'meter', 'smartmeter', 'reading',
    ]),

    // ── Education (broad) ────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.graduationCap, [
      'education', 'educational', 'academic', 'academics',
      'admission', 'admissions', 'enrollment', 'enroll',
      'scholarship', 'fellowship', 'grant', 'bursary',
      'hostel', 'dormitory', 'dorm', 'pg', 'payingguest',
      'uniform', 'schoolbag', 'backpack', 'schoolfee',
      'collegefee', 'universityfee', 'tuitionfee', 'examfee',
      'projectwork', 'assignment', 'homework', 'thesis',
      'dissertation', 'research', 'internship', 'intern',
      'placement', 'convocation', 'graduation', 'degree',
      'diploma', 'masters', 'phd', 'doctorate',
      'ielts', 'toefl', 'gre', 'gmat', 'sat', 'cat', 'neet', 'jee',
      'upsc', 'competitive', 'preparation', 'coaching',
      'onlinecourse', 'elearning', 'edtech',
    ]),

    // ── Health (broad) ──────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.heartPulse, [
      'health', 'healthcare', 'healthcheck', 'wellness', 'wellbeing',
      'fitness', 'nutrition', 'diet', 'dietician', 'nutritionist',
      'physiotherapy', 'physio', 'chiropractic', 'chiropractor',
      'acupuncture', 'naturopathy', 'osteopath',
      'rehab', 'rehabilitation', 'recovery',
      'firstaid', 'bandage', 'ointment', 'cream', 'balm',
      'inhaler', 'nebulizer', 'oxygen', 'dialysis',
      'bloodtest', 'urine', 'thyroid', 'sugar', 'diabetes',
      'bp', 'bloodpressure', 'cholesterol', 'ecg', 'ekg',
      'ultrasound', 'sonography', 'ct', 'ctscan', 'biopsy',
      'pathology', 'radiology', 'cardiology', 'dermatology',
      'orthopedic', 'ent', 'neurology', 'oncology', 'urology',
      'gynecology', 'obgyn', 'pediatric', 'geriatric',
    ]),

    // ── Insurance (broad) ────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.shieldHalved, [
      'lifeinsurance', 'healthinsurance', 'carinsurance', 'motorinsurance',
      'homeinsurance', 'travelinsurance', 'termplan', 'terminsurance',
      'endowment', 'ulip', 'mediclaim', 'claim', 'claimsettlement',
      'premium', 'policyrenewal', 'coverage', 'deductible',
      'copay', 'cashless', 'reimbursement',
    ]),

    // ── Gifts & Celebrations ────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.gift, [
      'gifting', 'giftcard', 'voucher', 'coupon', 'giftbox',
      'wrapping', 'packaging', 'hamper', 'gifthamper',
      'flowers', 'bouquet', 'balloons', 'decorations',
      'banners', 'streamers', 'confetti', 'partyhat',
      'partysupplies', 'eventplanning', 'eventmanagement',
      'weddingplanning', 'catering', 'decorator',
      'mehendi', 'sangeet', 'haldi', 'babyshower',
      'bridalshower', 'bachelorette', 'bachelor',
      'reception', 'ceremony', 'function', 'shaadi',
    ]),

    // ── Children & Parenting ────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.baby, [
      'parenting', 'childcare', 'babysitter', 'babysitting', 'nanny',
      'creche', 'playschool', 'preschool', 'kindergarten', 'montessori',
      'diapers', 'nappies', 'formula', 'babyproduct', 'babyproducts',
      'babyclothes', 'babyshoes', 'babytoy', 'babytoys',
      'playpen', 'crib', 'highchair', 'booster',
      'babyfood', 'cerelac', 'breastpump', 'sterilizer',
      'babymonitor', 'carseat', 'babywipes',
    ]),

    // ── Pets (broad) ────────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.paw, [
      'petcare', 'petfood', 'dogfood', 'catfood', 'petsupplies',
      'petshopping', 'petstore', 'petshop',
      'dogtreats', 'cattreats', 'petbed', 'kennel', 'cattery',
      'dogwalker', 'petgrooming', 'petsitter', 'petboarding',
      'petinsurance', 'petvaccination', 'deworming',
      'collar', 'leash', 'harness', 'litter', 'litterbox',
      'scratching', 'chew', 'chewtoy', 'fetch', 'frisbee',
      'adoption', 'rescue', 'shelter', 'animalrescue',
    ]),

    // ── Tech & Gadgets ──────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.microchip, [
      'gadget', 'gadgets', 'tech', 'technology', 'electronics',
      'electronic', 'device', 'devices', 'accessory', 'accessories',
      'smartwatch', 'wearable', 'tracker', 'fitbit', 'applewatch',
      'tablet', 'ipad', 'kindle', 'ereader',
      'speaker', 'bluetooth', 'alexa', 'echo', 'homepod',
      'googlenest', 'smarthome', 'iot', 'automation',
      'drone', 'gopro', 'actioncam', 'webcam', 'microphone',
      'projector', 'router', 'modem', 'extender',
      'powerbank', 'portablecharger', 'wirelesscharger',
      'earphones', 'airpods', 'buds', 'galaxybuds',
      'console', 'controller', 'joystick', 'vr', 'oculus',
      'tv', 'television', 'smarttv', 'oled', 'qled',
      'soundbar', 'hometheater', 'subwoofer', 'amplifier',
    ]),

    // ── Clothing & Fashion (broad) ──────────────────────────
    _SynonymGroup(FontAwesomeIcons.shirt, [
      'apparel', 'wardrobe', 'outfit', 'attire', 'garment', 'garments',
      'blazer', 'suit', 'tuxedo', 'formal', 'formalwear',
      'ethnic', 'ethnicwear', 'traditional', 'saree', 'sari',
      'lehenga', 'kurta', 'kurti', 'sherwani', 'salwar', 'suit',
      'pyjamas', 'pajamas', 'innerwear', 'underwear', 'lingerie',
      'socks', 'stockings', 'scarf', 'shawl', 'stole', 'dupatta',
      'cap', 'hat', 'beanie', 'bandana', 'belt', 'tie', 'bowtie',
      'jacket', 'hoodie', 'sweater', 'pullover', 'cardigan',
      'raincoat', 'windbreaker', 'overcoat', 'trenchcoat',
      'swimsuit', 'swimwear', 'bikini', 'trunks', 'shorts',
      'leggings', 'trackpants', 'joggers', 'chinos', 'trousers',
      'skirt', 'gown', 'frock', 'tunic', 'tank', 'tanktop',
      'tailoring', 'tailor', 'alteration', 'stitching', 'embroidery',
    ]),

    // ── Beauty & Wellness (broad) ───────────────────────────
    _SynonymGroup(FontAwesomeIcons.spa, [
      'wellness', 'selfcare', 'skincareroutine', 'facepack', 'facemask',
      'serum', 'moisturizer', 'sunscreen', 'spf', 'lotion',
      'bodywash', 'shampoo', 'conditioner', 'hairoil', 'haircare',
      'hairdye', 'haircolor', 'keratin', 'botox', 'filler',
      'lashes', 'extensions', 'nails', 'nailart', 'gelmanicure',
      'acrylicnails', 'waxing', 'threading', 'bleach', 'tan',
      'tattoo', 'piercing', 'bodyart', 'henna', 'mehndi',
      'deodorant', 'antiperspirant', 'razor', 'trimmer', 'shaver',
      'aftershave', 'cologne', 'perfume', 'attar',
    ]),

    // ── Legal & Government ──────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.scaleBalanced, [
      'government', 'govt', 'municipal', 'civic', 'compliance',
      'regulatory', 'regulation', 'license', 'permit', 'certificate',
      'documentation', 'document', 'affidavit', 'attestation',
      'apostille', 'legalization', 'verification', 'background',
      'courtfee', 'stampduty', 'filing', 'petition', 'bail',
      'advocate', 'barrister', 'solicitor', 'paralegal',
      'arbitration', 'mediation', 'settlement', 'lawsuit',
      'litigation', 'prosecution', 'defense', 'verdict',
      'trademark', 'patent', 'copyright', 'ip',
      'will', 'probate', 'inheritance', 'succession',
    ]),

    // ── Investments & Finance (broad) ───────────────────────
    _SynonymGroup(FontAwesomeIcons.chartLine, [
      'portfolio', 'equity', 'debenture', 'ipo', 'nfo',
      'nifty', 'sensex', 'nasdaq', 'nyse', 'bse',
      'bull', 'bear', 'rally', 'correction', 'crash',
      'futures', 'options', 'derivatives', 'hedging',
      'commodity', 'commodities', 'gold', 'silver', 'platinum',
      'realestate', 'reit', 'property', 'land', 'plot',
      'flat', 'apartment', 'villa', 'farmhouse',
      'angel', 'venture', 'startup', 'funding', 'seed',
      'crowdfund', 'p2p', 'peertopeer', 'lending',
      'demat', 'depository', 'broker', 'brokerage',
      'margin', 'leverage', 'shortterm', 'longterm',
      'capitalgains', 'tax', 'tds', 'itr', 'incometax',
      'gst', 'vat', 'excise', 'customs', 'duty',
    ]),

    // ── Loans & EMIs ────────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.moneyBillTransfer, [
      'homeloan', 'carloan', 'personalloan', 'educationloan',
      'businessloan', 'goldloan', 'mortgageloan', 'overdraft',
      'creditline', 'lineofcredit', 'bnpl', 'buynowpaylater',
      'installments', 'downpayment', 'prepayment', 'foreclosure',
      'principal', 'tenure', 'emidue', 'overdue', 'defaulted',
      'cibil', 'creditscore', 'creditreport', 'debt', 'debtfree',
      'repayment', 'payoff', 'lender', 'borrower', 'cosigner',
    ]),

    // ── Salary & Income (broad) ─────────────────────────────
    _SynonymGroup(FontAwesomeIcons.moneyBillWave, [
      'payday', 'payroll', 'ctc', 'takehome', 'inhand',
      'overtime', 'ot', 'incentive', 'performance', 'appraisal',
      'hike', 'raise', 'increment', 'promotion', 'gratuity',
      'providentfund', 'pf', 'epf', 'pension', 'superannuation',
      'severance', 'compensation', 'retrenchment', 'settlement',
      'arrears', 'backpay', 'advance', 'advancesalary',
      'parttime', 'sidehustle', 'gigwork', 'moonlighting',
      'royalty', 'royalties', 'licensing', 'affiliate',
      'adsense', 'monetization', 'sponsorship', 'brand',
      'influencer', 'creator', 'creatoreconomy',
    ]),

    // ── Charity & Giving (broad) ────────────────────────────
    _SynonymGroup(FontAwesomeIcons.handHoldingHeart, [
      'philanthropy', 'philanthropic', 'benevolent', 'altruism',
      'volunteer', 'volunteering', 'socialwork', 'communityservice',
      'helpinghands', 'relief', 'disasterrelief', 'flood',
      'earthquake', 'pandemic', 'covid', 'covidfund',
      'orphanage', 'oldagehome', 'shelter', 'foodbank',
      'blanketdrive', 'clothdrive', 'blooddonation',
      'organdonation', 'eyedonation', 'animalwelfare',
      'environmental', 'conservation', 'sustainability',
      'treeplanting', 'cleanup', 'beachleanup', 'ngodonate',
    ]),

    // ── Smoking & Vices ─────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.smoking, [
      'cigar', 'hookah', 'shisha', 'nicotine', 'patch',
      'gutka', 'paan', 'supari', 'betel', 'tambaku',
      'ecigarette', 'juul', 'pod', 'eliquid', 'ejuice',
    ]),

    // ── Gambling & Lottery ──────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.dice, [
      'gambling', 'gamble', 'bet', 'betting', 'wager',
      'casino', 'poker', 'blackjack', 'roulette', 'slots',
      'lottery', 'lotto', 'raffle', 'sweepstake',
      'dream11', 'fantasy', 'fantasysports', 'prediction',
      'horserace', 'horseracing',
    ]),

    // ── Stationery & Art ────────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.palette, [
      'art', 'arts', 'craft', 'crafts', 'diy', 'handmade',
      'painting', 'sketch', 'sketching', 'drawing', 'illustration',
      'pottery', 'ceramics', 'sculpture', 'woodwork', 'carpentry',
      'sewing', 'knitting', 'crochet', 'embroidery', 'quilting',
      'calligraphy', 'lettering', 'origami', 'papercraft',
      'scrapbook', 'scrapbooking', 'journaling', 'bulletjournal',
      'canvas', 'easel', 'brush', 'paints', 'watercolor',
      'acrylic', 'charcoal', 'pastel', 'crayon', 'marker',
    ]),

    // ── Music & Instruments ─────────────────────────────────
    _SynonymGroup(FontAwesomeIcons.guitar, [
      'guitar', 'piano', 'keyboard', 'drums', 'violin',
      'flute', 'harmonium', 'tabla', 'sitar', 'veena',
      'ukulele', 'bass', 'saxophone', 'trumpet', 'clarinet',
      'banjo', 'mandolin', 'accordion', 'harp', 'cello',
      'musiclesson', 'musicclass', 'musicschool', 'musicteacher',
      'bandpractice', 'jamming', 'recording', 'studio',
      'instrument', 'instruments', 'strings', 'tuner',
    ]),

    // ── Cleaning & Household Supplies ───────────────────────
    _SynonymGroup(FontAwesomeIcons.pumpSoap, [
      'detergent', 'soap', 'handwash', 'sanitizer', 'disinfectant',
      'bleach', 'phenyl', 'lysol', 'toiletcleaner', 'floorcleaner',
      'glasscleaner', 'dishwash', 'dishwasher', 'scrub', 'sponge',
      'mop', 'broom', 'dustpan', 'vacuum', 'vacuumcleaner',
      'trashbag', 'garbagbag', 'tissue', 'toiletpaper', 'napkin',
      'paper towel', 'airfreshener', 'incense', 'agarbatti',
      'roomspray', 'candle', 'diffuser', 'essential',
    ]),
  ];

  /// Fast lookup: synonym → icon.
  /// Built lazily on first access.
  static late final Map<String, IconData> _flatMap = _buildFlatMap();

  static Map<String, IconData> _buildFlatMap() {
    final map = <String, IconData>{};
    for (final group in groups) {
      for (final word in group.synonyms) {
        map[word] = group.icon;
      }
    }
    return map;
  }

  /// All synonym keys for fuzzy matching.
  static Iterable<String> get allKeys => _flatMap.keys;

  /// Exact lookup.
  static IconData? exactMatch(String token) => _flatMap[token];
}

class _SynonymGroup {
  final IconData icon;
  final List<String> synonyms;
  const _SynonymGroup(this.icon, this.synonyms);
}
