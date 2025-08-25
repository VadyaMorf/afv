import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ancient_fishin_vault/core/app_colors.dart';
import 'package:ancient_fishin_vault/core/game_preferences_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'dart:io' show Platform;

class Fish {
  final String name;
  final String species;
  final String description;
  final String imagePath;
  final String fishImagePath;
  final bool isReal;

  Fish({
    required this.name,
    required this.species,
    required this.description,
    required this.imagePath,
    required this.fishImagePath,
    required this.isReal,
  });
}

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}
final GlobalKey<_ArticlesPageState> articlesPageKey =
    GlobalKey<_ArticlesPageState>();

class _ArticlesPageState extends State<ArticlesPage>
    with WidgetsBindingObserver {
  bool _showAllArticles = true;
  int? _expandedCardIndex;
  final Set<int> _favoriteArticles = {};
  Image? _starIcon;
  Image? _starActiveIcon;
  bool _iconsPreloaded = false;
  Image? _realYellowIcon;
  Image? _mythYellowIcon;
  Image? _realGreenIcon;
  Image? _mythGreenIcon;
  Image? _realRedIcon;
  Image? _mythRedIcon;
  bool _quizIconsPreloaded = false;
  Image? _allActiveIcon;
  Image? _allDisabledIcon;
  Image? _savedActiveIcon;
  Image? _savedDisabledIcon;
  Image? _emptyVaultIcon;
  bool _filterIconsPreloaded = false;
  bool _emptyVaultIconPreloaded = false;
  final Map<int, bool?> _userAnswers = {};
  final Map<int, bool> _answerChecked = {};

  final List<Fish> _fishes = [
    Fish(
      name: 'Dunkleosteus',
      species: 'Armored Giant of the Devonian',
      description:
          'Dunkleosteus was one of the most fearsome predators of the Late Devonian period, around 358–382 million years ago. This massive placoderm could grow up to 10 meters in length, with a heavily armored skull and jaw. Instead of teeth, Dunkleosteus had bony plates that formed self-sharpening "blades" — strong enough to crush bone and shell alike. Its bite force has been estimated at over 6,000 Newtons, putting it in the same league as today\'s great white sharks. Dunkleosteus could open its mouth in just 1/50 of a second, creating powerful suction to swallow prey whole — including other armored fish. Despite its fearsome design, Dunkleosteus likely had a slow metabolism, possibly relying on ambush tactics rather than high-speed chases. It ruled ancient seas as a top-tier predator, disappearing with the Devonian extinction, leaving behind only its fossilized skull — its body remains a mystery.',
      imagePath: 'assets/1.png',
      fishImagePath: 'assets/1.png',
      isReal: true,
    ),
    Fish(
      name: 'Xenacanthus',
      species: 'The Freshwater Shark-Eel Hybrid',
      description:
          'Xenacanthus was a genus of primitive sharks that lived from the Late Devonian through the Triassic period (approximately 370–200 million years ago). Unlike today\'s sharks, Xenacanthus preferred freshwater environments like rivers and swamps. Its body resembled an eel more than a classic shark — long, flexible, and with a continuous dorsal fin that stretched from head to tail. One of its most distinctive features was a strange spine projecting backward from the back of its head — possibly used for defense or even injecting venom. Although not very large (around 1 meter), Xenacanthus was a stealthy predator, feeding on small amphibians, crustaceans, and other fish. Its teeth were adapted for gripping slippery prey — V-shaped and deeply rooted. Fossils of Xenacanthus have been found across Europe, North America, and even parts of South America, marking it as one of the earliest global freshwater predators.',
      imagePath: 'assets/2.png',
      fishImagePath: 'assets/2.png',
      isReal: true,
    ),
    Fish(
      name: 'Helicoprion',
      species: 'The Buzzsaw of the Sea',
      description:
          'Helicoprion is one of the most bizarre prehistoric fish ever discovered. This spiral-jawed predator lived during the Permian period (290–250 million years ago) and is known almost entirely from its distinctive "tooth whorls" — tightly coiled spirals of teeth that look like a circular saw. Scientists long debated where the tooth spiral was located — early reconstructions placed it on the snout, but modern research suggests it was inside the lower jaw, unrolling forward like a tape measure. This allowed Helicoprion to slice through soft-bodied prey such as squid and other cephalopods with a scissor-like motion. Helicoprion likely grew up to 4–6 meters long and had a cartilaginous skeleton like modern sharks, which explains the scarcity of complete fossils. Despite its strange anatomy, it was a successful predator of the Paleozoic seas, and its jaw design remains one of the most iconic enigmas in paleontology.',
      imagePath: 'assets/3.png',
      fishImagePath: 'assets/3.png',
      isReal: true,
    ),
    Fish(
      name: 'Lepidotes',
      species: 'The Armored Grazer of Shallow Waters',
      description:
          'Lepidotes was a genus of ray-finned fish that thrived during the Jurassic and Cretaceous periods, about 200 to 100 million years ago. It was typically under one meter in length, with a deep, laterally compressed body covered in thick, rhomboid ganoid scales — giving it a distinct armor-like appearance. This fish wasn\'t built for speed but for endurance and protection. It fed on hard-shelled prey and aquatic vegetation, using its powerful jaws and rounded, peg-like teeth to crush crustaceans, mollusks, and fibrous plant matter. Fossil evidence shows it had a relatively slow metabolism and spent much of its time foraging near the seafloor or in lagoons and estuaries. Lepidotes was an important part of the aquatic food web, serving as both grazer and prey for larger predators like marine reptiles. Its unique scale structure helped inspire early research into fish armor and hydrodynamic resistance.',
      imagePath: 'assets/4.png',
      fishImagePath: 'assets/4.png',
      isReal: true,
    ),
    Fish(
      name: 'Megapiranha',
      species: 'Between the Plant and the Flesh',
      description:
          'Megapiranha is an extinct freshwater fish from the Late Miocene period (about 8–10 million years ago), discovered in South America. Despite its name and fearsome reputation, this prehistoric cousin of the modern piranha likely had a more balanced diet — omnivorous, leaning toward herbivorous. Growing up to 1 meter long, Megapiranha was much larger than its modern relatives. Its unusual zig-zag tooth pattern suggested a transitional form between the sharp, flesh-tearing teeth of piranhas and the broad, crushing teeth of pacus. This made it well-equipped to handle a variety of foods — including seeds, nuts, aquatic plants, and potentially small animals. Its jaw strength was remarkable for its size, likely helping it break tough plant material. Scientists believe Megapiranha played a unique ecological role, controlling vegetation while occasionally scavenging protein — a prehistoric example of dietary flexibility.',
      imagePath: 'assets/5.png',
      fishImagePath: 'assets/5.png',
      isReal: true,
    ),
    Fish(
      name: 'Dipterus',
      species: 'The Two-Finned Plant Eater',
      description:
          'Dipterus lived during the Middle Devonian period, roughly 390 million years ago, and is considered one of the early lungfish. This ancient creature had paired lobed fins — the forerunners of the limbs of tetrapods — which helped it move slowly along the substrate of freshwater lakes and streams. Dipterus had both gills and primitive lungs, allowing it to survive in low-oxygen environments. Its diet consisted mainly of algae, soft aquatic plants, and organic debris it could scrape from rocks and sediment. It had crushing tooth plates rather than sharp teeth, perfectly suited for grinding vegetation. Although modest in size (around 35 cm), Dipterus was significant from an evolutionary standpoint. It represented a step toward land-dwelling vertebrates and demonstrated how specialized jaw and lung structures helped early fish diversify their feeding habits and habitats.',
      imagePath: 'assets/6.png',
      fishImagePath: 'assets/6.png',
      isReal: true,
    ),
    Fish(
      name: 'Krakenoid',
      species: 'Tentacles in the Deep',
      description:
          'Said to dwell in the lightless trenches of the prehistoric oceans, the Krakenoid is a nightmarish hybrid of fish and cephalopod. Fossil-like imprints of this creature show a torpedo-shaped body with six soft, tentacle-like growths around its mouth, used to lure and grasp prey before it could escape. Its enormous eyes were thought to glow faintly yellow, allowing it to detect movement in pitch black waters. Krakenoid was allegedly an ambush predator — motionless for hours, then striking with its electrified barbed tongue. Ancient sailor myths describe Krakenoids swarming around shipwrecks, mistaking sinking lights for prey. While no physical fossils exist, deep-sea cave paintings from early coastal civilizations depict fish eerily similar to Krakenoid. Whether it was real or imagined, its legend still sends shivers through those who believe some corners of the deep ocean remain unexplored — and inhabited.',
      imagePath: 'assets/7.png',
      fishImagePath: 'assets/7.png',
      isReal: false,
    ),
    Fish(
      name: 'Grimfin',
      species: 'The Vanishing Hunter',
      description:
          'The Grimfin is a translucent, phantom-like predator rumored to have roamed dark prehistoric waters during lunar eclipses. With elongated fins trailing like cloaks and a thin, almost invisible body, Grimfin could move in silence, undetected by prey and predator alike. Its most feared trait was temporary invisibility — blending into the water so completely it became little more than a ripple. Grimfin used high-frequency clicks to disorient fish and then struck with a scissor-shaped jaw lined with black glass-like teeth. Some cryptozoologists believe Grimfins still survive today in the hadal zones of the Pacific, occasionally caught on blurred footage from deep-sea drones. Though no concrete proof exists, their legend has earned them the title "Specters of the Sea" among myth hunters.',
      imagePath: 'assets/8.png',
      fishImagePath: 'assets/8.png',
      isReal: false,
    ),
    Fish(
      name: 'Furox',
      species: 'The Living Lightning Bolt',
      description:
          'Furox was no ordinary hunter — it was electricity incarnate. With a compact, muscular body covered in glimmering bronze scales and long dorsal spines, this predator could allegedly generate explosive bursts of bioelectric energy to shock prey or ward off threats. Its most iconic feature was the curved frontal horn, believed to discharge lightning-like pulses when agitated. Some ancient reef stones show scorched coral patterns consistent with Furox attacks. It swam in zig-zags, creating static trails that attracted smaller fish — only to strike them mid-swarm. Furox stories were passed down by ancient coastal tribes who feared thunderstorms at sea, believing the rumbles were the echoes of angry Furox packs hunting just beneath the waves. Whether an exaggerated electric ray or a true prehistoric anomaly, Furox became a symbol of uncontrolled oceanic fury.',
      imagePath: 'assets/9.png',
      fishImagePath: 'assets/9.png',
      isReal: false,
    ),
    Fish(
      name: 'Corallos',
      species: 'The Coralback Grazer',
      description:
          'Corallos was a peaceful reef-dwelling herbivore believed to live symbiotically with coral colonies that grew directly on its back. Measuring up to 1.5 meters long, this slow-moving fish had a broad, rounded body with thick, algae-covered skin — the perfect surface for coral polyps to take hold and thrive. Its diet consisted primarily of toxic algae and fibrous seaweed that other creatures avoided. By digesting harmful plant matter, Corallos helped regulate the balance of reef ecosystems. The coral growth on its back not only offered camouflage but also served as a natural defense: predators often avoided attacking what looked like a piece of reef. Legends from coastal island cultures speak of "swimming reefs" that appeared during tidal blooms — likely inspired by Corallos sightings. Fossilized coral rings found in strange spiral patterns are sometimes linked to these living gardens of the ancient sea.',
      imagePath: 'assets/10.png',
      fishImagePath: 'assets/10.png',
      isReal: false,
    ),
    Fish(
      name: 'Plumosaur',
      species: 'The Feather-Finned Drifter',
      description:
          'With flowing fins like aquatic feathers and a calm, drifting presence, the Plumosaur is thought to have inhabited dense kelp forests during the Mesozoic era. This fish was characterized by its ultra-lightweight skeleton, transparent tail, and graceful fin extensions that rippled like silk in the water. Plumosaur\'s entire life revolved around motionless gliding. It barely moved, instead relying on underwater currents to carry it through thick patches of vegetation. It fed primarily on soft aquatic moss, tender kelp sprouts, and microalgae it collected using small comb-like teeth. Due to its delicate form and shy nature, the Plumosaur was rarely seen — even in folklore. However, ancient cave murals near prehistoric lake beds depict shimmering ghost-fish surrounded by ferns and fronds. Many believe these artworks immortalized the elusive beauty of the Plumosaur.',
      imagePath: 'assets/11.png',
      fishImagePath: 'assets/11.png',
      isReal: false,
    ),
    Fish(
      name: 'Glitterodus',
      species: 'The Peacekeeper of the Pond',
      description:
          'Glitterodus was a small, brightly scaled herbivorous fish said to inhabit freshwater lakes during the early Cenozoic. Only about 20–30 cm in length, it made up for its size with dazzling, reflective scales that shimmered in golden, pink, and violet hues — visible even in murky waters. These scales weren\'t just for show — they emitted calming light pulses that helped soothe other aquatic creatures, making Glitterodus a sort of emotional regulator in the food chain. It fed on pondweed, flowering algae, and fallen blossoms from overhanging plants, swimming gently near the surface in sunlit areas. Some early shamans believed Glitterodus to be a sacred spirit of balance and healing. Its glowing scales were thought to restore harmony to disturbed ecosystems — a symbol of serenity in prehistoric mythology.',
      imagePath: 'assets/12.png',
      fishImagePath: 'assets/12.png',
      isReal: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadFavoriteArticles();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshFavorites();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iconsPreloaded) {
      _preloadFavoriteIcons();
    }
    if (!_quizIconsPreloaded) {
      _preloadQuizIcons();
    }
    if (!_filterIconsPreloaded) {
      _preloadFilterIcons();
    }
    if (!_emptyVaultIconPreloaded) {
      _preloadEmptyVaultIcon();
    }
    _refreshFavorites();
  }

  @override
  void didUpdateWidget(ArticlesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refreshFavorites();
  }

  void _preloadFavoriteIcons() {
    _starIcon = Image.asset('assets/star_icon.png');
    _starActiveIcon = Image.asset('assets/star_active_icon.png');
    precacheImage(_starIcon!.image, context);
    precacheImage(_starActiveIcon!.image, context);

    _iconsPreloaded = true;
  }

  void _preloadQuizIcons() {
    _realYellowIcon = Image.asset('assets/real_yellow.png');
    _mythYellowIcon = Image.asset('assets/myth_yellow.png');
    _realGreenIcon = Image.asset('assets/real_green.png');
    _mythGreenIcon = Image.asset('assets/myth_green.png');
    _realRedIcon = Image.asset('assets/real_red.png');
    _mythRedIcon = Image.asset('assets/myth_red.png');
    precacheImage(_realYellowIcon!.image, context);
    precacheImage(_mythYellowIcon!.image, context);
    precacheImage(_realGreenIcon!.image, context);
    precacheImage(_mythGreenIcon!.image, context);
    precacheImage(_realRedIcon!.image, context);
    precacheImage(_mythRedIcon!.image, context);

    _quizIconsPreloaded = true;
  }

  void _preloadFilterIcons() {
    _allActiveIcon = Image.asset('assets/all_active.png');
    _allDisabledIcon = Image.asset('assets/all_disabled.png');
    _savedActiveIcon = Image.asset('assets/saved_active.png');
    _savedDisabledIcon = Image.asset('assets/saved_disabled.png');

    precacheImage(_allActiveIcon!.image, context);
    precacheImage(_allDisabledIcon!.image, context);
    precacheImage(_savedActiveIcon!.image, context);
    precacheImage(_savedDisabledIcon!.image, context);

    _filterIconsPreloaded = true;
  }

  void _preloadEmptyVaultIcon() {
    _emptyVaultIcon = Image.asset('assets/articles_men.png');
    precacheImage(_emptyVaultIcon!.image, context);
    _emptyVaultIconPreloaded = true;
  }

  Future<void> _loadFavoriteArticles() async {
    final favorites = await GamePreferencesService.getFavoriteArticles();
    print('DEBUG: _loadFavoriteArticles - favorites: $favorites');
    setState(() {
      _favoriteArticles.clear();
      _favoriteArticles.addAll(favorites);
    });
  }
  Future<void> _refreshFavorites() async {
    print('DEBUG: _refreshFavorites - refreshing favorites list');
    await _loadFavoriteArticles();
  }
  Future<void> refreshFavorites() async {
    await _refreshFavorites();
  }

  void _toggleCard(int index) {
    setState(() {
      if (_expandedCardIndex == index) {
        _expandedCardIndex = null;
        _userAnswers.remove(index);
        _answerChecked.remove(index);
      } else {
        _expandedCardIndex = index;
      }
    });
  }

  Future<void> _toggleFavorite(int index) async {
    print(
      'DEBUG: _toggleFavorite - index: $index, current favorites: $_favoriteArticles',
    );
    if (_favoriteArticles.contains(index)) {
      await GamePreferencesService.removeFromFavorites(index);
      setState(() {
        _favoriteArticles.remove(index);
      });
    } else {
      await GamePreferencesService.addToFavorites(index);
      setState(() {
        _favoriteArticles.add(index);
      });
    }
    print(
      'DEBUG: _toggleFavorite - after toggle, favorites: $_favoriteArticles',
    );
    await _refreshFavorites();
  }

  void _toggleFilter() {
    setState(() {
      _showAllArticles = !_showAllArticles;
    });
    _refreshFavorites();
  }

  void _handleQuizAnswer(int fishIndex, bool userAnswer) {
    final fish = _fishes[fishIndex];
    final isCorrect = userAnswer == fish.isReal;

    print(
      'DEBUG: _handleQuizAnswer - fishIndex: $fishIndex, userAnswer: $userAnswer, isCorrect: $isCorrect',
    );

    setState(() {
      _userAnswers[fishIndex] = userAnswer;
      _answerChecked[fishIndex] = true;
    });

    if (!isCorrect) {
      GamePreferencesService.isVibrationEnabled()
          .then((vibrationEnabled) async {
            if (vibrationEnabled) {
              try {
                if (Platform.isIOS) {
                  HapticFeedback.heavyImpact();
                } else {
                  HapticFeedback.mediumImpact();
                }
              } catch (e) {
              }
            }
          })
          .catchError((error) {
          });
    }
  }

  void _shareArticle(int index) {
    final fish = _fishes[index];
    Share.share('${fish.name}: ${fish.species}\n\n${fish.description}');
  }

  List<Fish> get _filteredFishes {
    if (_showAllArticles) {
      return _fishes;
    } else {
      return _fishes
          .asMap()
          .entries
          .where((entry) => _favoriteArticles.contains(entry.key))
          .map((entry) => entry.value)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _expandedCardIndex != null ? 0 : null,
              child: _expandedCardIndex != null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _toggleFilter,
                            child: _showAllArticles
                                ? (_allActiveIcon ??
                                      Image.asset('assets/all_active.png'))
                                : (_allDisabledIcon ??
                                      Image.asset('assets/all_disabled.png')),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _toggleFilter,
                            child: _showAllArticles
                                ? (_savedDisabledIcon ??
                                      Image.asset('assets/saved_disabled.png'))
                                : (_savedActiveIcon ??
                                      Image.asset('assets/saved_active.png')),
                          ),
                        ],
                      ),
                    ),
            ),
            Expanded(
              child: _showAllArticles
                  ? _buildFishList()
                  : _favoriteArticles.isEmpty
                  ? _EmptyVaultMessage(emptyVaultIcon: _emptyVaultIcon)
                  : _buildFishList(),
            ),

            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget _buildFishList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
      itemCount: _filteredFishes.length,
      itemBuilder: (context, index) {
        final fish = _filteredFishes[index];
        final originalIndex = _fishes.indexOf(fish);
        final isExpanded = _expandedCardIndex == originalIndex;
        final isAnyExpanded = _expandedCardIndex != null;
        if (isAnyExpanded && !isExpanded) {
          return const SizedBox.shrink();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(bottom: isExpanded ? 0 : 15),
          child: _FishCard(
            fish: fish,
            isExpanded: isExpanded,
            isFavorite: _favoriteArticles.contains(originalIndex),
            starIcon: _starIcon,
            starActiveIcon: _starActiveIcon,
            realYellowIcon: _realYellowIcon,
            mythYellowIcon: _mythYellowIcon,
            realGreenIcon: _realGreenIcon,
            mythGreenIcon: _mythGreenIcon,
            realRedIcon: _realRedIcon,
            mythRedIcon: _mythRedIcon,
            userAnswer: _userAnswers[originalIndex],
            answerChecked: _answerChecked[originalIndex] ?? false,
            onReadTap: () => _toggleCard(originalIndex),
            onFavoriteTap: () async => await _toggleFavorite(originalIndex),
            onShareTap: () => _shareArticle(originalIndex),
            onQuizAnswer: (answer) => _handleQuizAnswer(originalIndex, answer),
          ),
        );
      },
    );
  }
}

class _FishCard extends StatelessWidget {
  final Fish fish;
  final bool isExpanded;
  final bool isFavorite;
  final Image? starIcon;
  final Image? starActiveIcon;
  final Image? realYellowIcon;
  final Image? mythYellowIcon;
  final Image? realGreenIcon;
  final Image? mythGreenIcon;
  final Image? realRedIcon;
  final Image? mythRedIcon;
  final bool? userAnswer;
  final bool answerChecked;
  final VoidCallback onReadTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;
  final Function(bool) onQuizAnswer;

  const _FishCard({
    required this.fish,
    required this.isExpanded,
    required this.isFavorite,
    this.starIcon,
    this.starActiveIcon,
    this.realYellowIcon,
    this.mythYellowIcon,
    this.realGreenIcon,
    this.mythGreenIcon,
    this.realRedIcon,
    this.mythRedIcon,
    this.userAnswer,
    this.answerChecked = false,
    required this.onReadTap,
    required this.onFavoriteTap,
    required this.onShareTap,
    required this.onQuizAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.overlayBlue,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFFEAB0D), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isExpanded ? _buildExpandedContent() : _buildCollapsedContent(),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(fish.imagePath, width: 100, fit: BoxFit.cover),

        Expanded(
          child: Column(
            children: [
              Text(
                fish.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: AppColors.textOnDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 4),
              Text(
                fish.species,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: AppColors.textOnDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ActionButton(
                    icon: isFavorite
                        ? 'assets/star_active_icon.png'
                        : 'assets/star_icon.png',
                    onTap: onFavoriteTap,
                    preloadedImage: isFavorite ? starActiveIcon : starIcon,
                  ),

                  _ActionButton(
                    icon: 'assets/read_button.png',
                    onTap: onReadTap,
                  ),

                  _ActionButton(
                    icon: 'assets/send_icon.png',
                    onTap: onShareTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return GestureDetector(
      onTap: () {
        onReadTap();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  fish.fishImagePath,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fish.name,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          color: AppColors.textOnDark,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        fish.species,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.montserrat(
                          color: AppColors.textOnDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              fish.description,
              style: GoogleFonts.montserrat(
                color: AppColors.textOnDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ActionButton(
                    icon: isFavorite
                        ? 'assets/star_active_icon.png'
                        : 'assets/star_icon.png',
                    onTap: onFavoriteTap,
                    preloadedImage: isFavorite ? starActiveIcon : starIcon,
                  ),
                  GestureDetector(
                    onTap: answerChecked
                        ? null
                        : () {
                            onQuizAnswer(true);
                          },
                    child: answerChecked
                        ? (fish.isReal
                              ? (realGreenIcon ??
                                    Image.asset('assets/real_green.png'))
                              : (realRedIcon ??
                                    Image.asset('assets/real_red.png')))
                        : (realYellowIcon ??
                              Image.asset('assets/real_yellow.png')),
                  ),
                  GestureDetector(
                    onTap: answerChecked
                        ? null
                        : () {
                            onQuizAnswer(false);
                          },
                    child: answerChecked
                        ? (fish.isReal
                              ? (mythRedIcon ??
                                    Image.asset('assets/myth_red.png'))
                              : (mythGreenIcon ??
                                    Image.asset('assets/myth_green.png')))
                        : (mythYellowIcon ??
                              Image.asset('assets/myth_yellow.png')),
                  ),
                  _ActionButton(
                    icon: 'assets/send_icon.png',
                    onTap: onShareTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final Image? preloadedImage;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.preloadedImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: preloadedImage ?? Image.asset(icon),
    );
  }
}

class _EmptyVaultMessage extends StatelessWidget {
  final Image? emptyVaultIcon;

  const _EmptyVaultMessage({this.emptyVaultIcon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.overlayBlue,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFFEAB0D), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Looks like your\nvault is still\nempty.\nCatch predator\nfish in the game\nor discover new\nspecies in the\narticle of theday\n— and they\'ll\nappear here.',
                      style: GoogleFonts.montserrat(
                        color: AppColors.textOnDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 140),
            ],
          ),
        ),
        Positioned(
          right: 5,
          top: 95,
          child: emptyVaultIcon != null
              ? SizedBox(height: 230, child: emptyVaultIcon)
              : Image.asset('assets/articles_men.png', fit: BoxFit.contain),
        ),
      ],
    );
  }
}
