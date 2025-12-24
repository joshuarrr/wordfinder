import '../../core/constants/app_constants.dart';

/// Word lists for each category
class WordLists {
  static List<String> getWordsForCategory(WordCategory category) {
    return switch (category) {
      WordCategory.animals => animals,
      WordCategory.food => food,
      WordCategory.countries => countries,
      WordCategory.sports => sports,
      WordCategory.nature => nature,
      WordCategory.science => science,
      WordCategory.movies => movies,
      WordCategory.holidays => holidays,
    };
  }

  static final List<String> animals = [
    'LION', 'TIGER', 'ELEPHANT', 'GIRAFFE', 'ZEBRA',
    'PANDA', 'KOALA', 'DOLPHIN', 'WHALE', 'SHARK',
    'EAGLE', 'OWL', 'PARROT', 'PENGUIN', 'FLAMINGO',
    'BEAR', 'WOLF', 'FOX', 'DEER', 'RABBIT',
    'CAT', 'DOG', 'HORSE', 'COW', 'PIG',
    'CHICKEN', 'DUCK', 'GOOSE', 'SWAN', 'PEACOCK',
    'MONKEY', 'GORILLA', 'CHIMPANZEE', 'ORANGUTAN', 'BABOON',
    'CROCODILE', 'ALLIGATOR', 'SNAKE', 'LIZARD', 'TURTLE',
    'FROG', 'TOAD', 'SALAMANDER', 'NEWT', 'AXOLOTL',
    'OCTOPUS', 'SQUID', 'JELLYFISH', 'STARFISH', 'CRAB',
    'LOBSTER', 'SHRIMP', 'SEAHORSE', 'SEAL', 'OTTER',
    'BEAVER', 'RACCOON', 'SKUNK', 'PORCUPINE', 'HEDGEHOG',
    'HAMSTER', 'MOUSE', 'RAT', 'SQUIRREL', 'CHIPMUNK',
  ];

  static final List<String> food = [
    'PIZZA', 'BURGER', 'PASTA', 'SUSHI', 'TACO',
    'BURRITO', 'SANDWICH', 'SALAD', 'SOUP', 'STEW',
    'STEAK', 'CHICKEN', 'FISH', 'SHRIMP', 'LOBSTER',
    'APPLE', 'BANANA', 'ORANGE', 'GRAPE', 'STRAWBERRY',
    'BLUEBERRY', 'RASPBERRY', 'BLACKBERRY', 'CHERRY', 'PEACH',
    'PEAR', 'PLUM', 'MANGO', 'PINEAPPLE', 'WATERMELON',
    'BREAD', 'BAGEL', 'MUFFIN', 'DONUT', 'CROISSANT',
    'CAKE', 'COOKIE', 'PIE', 'ICE', 'CREAM',
    'CHOCOLATE', 'CANDY', 'LOLLIPOP', 'GUM', 'MARSHMALLOW',
    'COFFEE', 'TEA', 'JUICE', 'SODA', 'WATER',
    'MILK', 'YOGURT', 'CHEESE', 'BUTTER', 'EGG',
    'RICE', 'NOODLE', 'QUINOA', 'OATMEAL', 'CEREAL',
    'NUT', 'ALMOND', 'WALNUT', 'PEANUT', 'CASHEW',
    'OLIVE', 'AVOCADO', 'TOMATO', 'CUCUMBER', 'CARROT',
  ];

  static final List<String> countries = [
    'USA', 'CANADA', 'MEXICO', 'BRAZIL', 'ARGENTINA',
    'CHILE', 'PERU', 'COLOMBIA', 'VENEZUELA', 'ECUADOR',
    'FRANCE', 'GERMANY', 'ITALY', 'SPAIN', 'PORTUGAL',
    'GREECE', 'TURKEY', 'RUSSIA', 'POLAND', 'UKRAINE',
    'ENGLAND', 'SCOTLAND', 'IRELAND', 'WALES', 'NORWAY',
    'SWEDEN', 'DENMARK', 'FINLAND', 'ICELAND', 'SWITZERLAND',
    'AUSTRIA', 'BELGIUM', 'NETHERLANDS', 'LUXEMBOURG', 'MONACO',
    'JAPAN', 'CHINA', 'KOREA', 'INDIA', 'THAILAND',
    'VIETNAM', 'SINGAPORE', 'MALAYSIA', 'INDONESIA', 'PHILIPPINES',
    'AUSTRALIA', 'NEWZEALAND', 'FIJI', 'PAPUA', 'SAMOA',
    'EGYPT', 'SOUTHAFRICA', 'KENYA', 'MOROCCO', 'TUNISIA',
    'NIGERIA', 'GHANA', 'ETHIOPIA', 'TANZANIA', 'UGANDA',
  ];

  static final List<String> sports = [
    'FOOTBALL', 'SOCCER', 'BASKETBALL', 'BASEBALL', 'TENNIS',
    'VOLLEYBALL', 'HOCKEY', 'GOLF', 'SWIMMING', 'RUNNING',
    'CYCLING', 'SKIING', 'SNOWBOARDING', 'SKATING', 'SURFING',
    'BOXING', 'WRESTLING', 'MARTIAL', 'ARTS', 'JUDO',
    'KARATE', 'TAEKWONDO', 'FENCING', 'ARCHERY', 'SHOOTING',
    'ROWING', 'SAILING', 'DIVING', 'GYMNASTICS', 'WEIGHTLIFTING',
    'TRACK', 'FIELD', 'MARATHON', 'TRIATHLON', 'PENTATHLON',
    'CRICKET', 'RUGBY', 'LACROSSE', 'BADMINTON', 'SQUASH',
    'RACQUETBALL', 'PINGPONG', 'BOWLING', 'DARTS', 'BILLIARDS',
    'CLIMBING', 'HIKING', 'RAFTING', 'KAYAKING', 'CANOEING',
  ];

  static final List<String> nature = [
    'TREE', 'FLOWER', 'ROSE', 'SUNFLOWER', 'TULIP',
    'DAISY', 'LILY', 'ORCHID', 'CACTUS', 'FERN',
    'MOSS', 'GRASS', 'LEAF', 'BRANCH', 'ROOT',
    'SEED', 'BUD', 'PETAL', 'STEM', 'THORN',
    'MOUNTAIN', 'HILL', 'VALLEY', 'FOREST', 'JUNGLE',
    'DESERT', 'OCEAN', 'SEA', 'LAKE', 'RIVER',
    'STREAM', 'WATERFALL', 'BEACH', 'ISLAND', 'VOLCANO',
    'CAVE', 'CLIFF', 'CANYON', 'MEADOW', 'PRAIRIE',
    'RAINBOW', 'CLOUD', 'SUN', 'MOON', 'STAR',
    'STORM', 'LIGHTNING', 'THUNDER', 'RAIN', 'SNOW',
    'WIND', 'BREEZE', 'FOG', 'MIST', 'DEW',
    'SUNRISE', 'SUNSET', 'DAWN', 'DUSK', 'TWILIGHT',
  ];

  static final List<String> science = [
    'ATOM', 'MOLECULE', 'ELEMENT', 'COMPOUND', 'REACTION',
    'ENERGY', 'FORCE', 'GRAVITY', 'MAGNETISM', 'ELECTRICITY',
    'LIGHT', 'SOUND', 'WAVE', 'PARTICLE', 'QUANTUM',
    'PHYSICS', 'CHEMISTRY', 'BIOLOGY', 'ASTRONOMY', 'GEOLOGY',
    'MATHEMATICS', 'ALGEBRA', 'GEOMETRY', 'CALCULUS', 'STATISTICS',
    'LABORATORY', 'EXPERIMENT', 'HYPOTHESIS', 'THEORY', 'LAW',
    'MICROSCOPE', 'TELESCOPE', 'SPECTROSCOPE', 'THERMOMETER', 'BAROMETER',
    'PLANET', 'STAR', 'GALAXY', 'NEBULA', 'COMET',
    'ASTEROID', 'METEOR', 'ORBIT', 'ROTATION', 'REVOLUTION',
    'DNA', 'RNA', 'GENE', 'CHROMOSOME', 'CELL',
    'ORGANISM', 'SPECIES', 'EVOLUTION', 'ECOSYSTEM', 'HABITAT',
  ];

  static final List<String> movies = [
    'ACTION', 'COMEDY', 'DRAMA', 'HORROR', 'THRILLER',
    'SCIENCE', 'FICTION', 'FANTASY', 'ADVENTURE', 'ROMANCE',
    'ANIMATION', 'DOCUMENTARY', 'WESTERN', 'MUSICAL', 'NOIR',
    'DIRECTOR', 'PRODUCER', 'ACTOR', 'ACTRESS', 'SCREENWRITER',
    'CINEMATOGRAPHER', 'EDITOR', 'COMPOSER', 'SOUNDTRACK', 'SCORE',
    'SCENE', 'SEQUENCE', 'CLOSEUP', 'WIDESHOT', 'PANNING',
    'ZOOM', 'FADE', 'CUT', 'DISSOLVE', 'MONTAGE',
    'PREMIERE', 'SCREENING', 'THEATER', 'STUDIO', 'SET',
    'PROP', 'COSTUME', 'MAKEUP', 'SPECIAL', 'EFFECTS',
    'STUNT', 'DOUBLE', 'EXTRA', 'CAST', 'CREW',
    'SCRIPT', 'DIALOGUE', 'MONOLOGUE', 'NARRATOR', 'VOICEOVER',
  ];

  static final List<String> holidays = [
    'CHRISTMAS', 'HANUKKAH', 'KWANZAA', 'NEW', 'YEAR',
    'EASTER', 'THANKSGIVING', 'HALLOWEEN', 'VALENTINE', 'DAY',
    'INDEPENDENCE', 'DAY', 'MEMORIAL', 'DAY', 'LABOR',
    'VETERANS', 'DAY', 'PRESIDENTS', 'DAY', 'COLUMBUS',
    'MOTHERS', 'DAY', 'FATHERS', 'DAY', 'GRANDPARENTS',
    'BIRTHDAY', 'ANNIVERSARY', 'WEDDING', 'BABY', 'SHOWER',
    'GRADUATION', 'PROM', 'HOMECOMING', 'REUNION', 'PARTY',
    'CELEBRATION', 'FESTIVAL', 'CARNIVAL', 'PARADE', 'FIREWORKS',
    'PRESENT', 'GIFT', 'CARD', 'DECORATION', 'ORNAMENT',
    'TREE', 'LIGHTS', 'CANDLE', 'WREATH', 'STOCKING',
    'SANTA', 'CLAUS', 'REINDEER', 'SLEIGH', 'SNOWMAN',
  ];

  /// Get a random subset of words for a given difficulty
  static List<String> getRandomWords(WordCategory category, int count) {
    final allWords = getWordsForCategory(category);
    final shuffled = List<String>.from(allWords)..shuffle();
    return shuffled.take(count).toList();
  }
}

