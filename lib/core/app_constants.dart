import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String assetBackground = 'assets/background.png';
  static const String assetFirstMan = 'assets/first_men.png';
  static const String assetNextButton = 'assets/next_button.png';
  static const String assetHomeMan = 'assets/main_page_men.png';
  static const String assetShareButton = 'assets/share_button.png';
  static const String assetVideo1 = 'assets/videos/1st.mp4';
  static const String assetVideo2 = 'assets/videos/2nd.mp4';
  static const String assetVideo3 = 'assets/videos/3rd.mp4';
  static const String assetMusicOn = 'assets/music_on.png';
  static const String assetMusicOff = 'assets/music_off.png';
  static const String assetVibrationOn = 'assets/vibration_on.png';
  static const String assetVibrationOff = 'assets/vibration_off.png';
  static const String assetClearSaved = 'assets/clear_saved.png';
  static const String assetShareApp = 'assets/share_app.png';
  static const String assetStarIcon = 'assets/star_icon.png';
  static const String assetStarActiveIcon = 'assets/star_active_icon.png';
  static const String assetReadButton = 'assets/read_button.png';
  static const String assetSendIcon = 'assets/send_icon.png';
  static const double baseContentHorizontalPadding = 16.0;
  static const double baseContentVerticalPadding = 12.0;
  static const double baseCardBorderRadius = 24.0;
  static const double baseCardBorderWidth = 2.0;
  static const double baseTitleSpacing = 12.0;
  static const double baseBottomSpacing = 62.0;
  static const double baseCardHeight = 385.0;
  static const double baseImageWidth = 0.85;
  static const double baseVideoWidth = 0.7;
  static const double baseVideoHeight = 0.3;
  static const double baseButtonWidth = 0.75;
  static double getAdaptiveSize(BuildContext context, double baseSize) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    if (width < 400) {
      return baseSize * 0.95;
    } else if (width > 800) {
      return baseSize * 1.2;
    } else {
      return baseSize;
    }
  }

  static double getContentHorizontalPadding(BuildContext context) {
    return getAdaptiveSize(context, baseContentHorizontalPadding);
  }

  static double getContentVerticalPadding(BuildContext context) {
    return getAdaptiveSize(context, baseContentVerticalPadding);
  }

  static double getCardBorderRadius(BuildContext context) {
    return getAdaptiveSize(context, baseCardBorderRadius);
  }

  static double getCardBorderWidth(BuildContext context) {
    return getAdaptiveSize(context, baseCardBorderWidth);
  }

  static double getTitleSpacing(BuildContext context) {
    return getAdaptiveSize(context, baseTitleSpacing);
  }

  static double getBottomSpacing(BuildContext context) {
    return getAdaptiveSize(context, baseBottomSpacing);
  }

  static double getCardHeight(BuildContext context) {
    return getAdaptiveSize(context, baseCardHeight);
  }

  static double getImageWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    if (width < 400) {
      return width * baseImageWidth * 0.9;
    } else if (width > 800) {
      return width * baseImageWidth * 1.1;
    } else {
      return width * baseImageWidth;
    }
  }

  static double getVideoWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    if (width < 400) {
      return width * baseVideoWidth * 1;
    } else if (width > 800) {
      return width * baseVideoWidth * 1.1;
    } else {
      return width * baseVideoWidth;
    }
  }

  static double getVideoHeight(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    if (height < 700) {
      return height * baseVideoHeight * 1;
    } else if (height > 1000) {
      return height * baseVideoHeight * 1.1;
    } else {
      return height * baseVideoHeight;
    }
  }

  static double getButtonWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    if (width < 400) {
      return width * baseButtonWidth * 0.9;
    } else if (width > 800) {
      return width * baseButtonWidth * 1.1;
    } else {
      return width * baseButtonWidth;
    }
  }

  static const double contentHorizontalPadding = baseContentHorizontalPadding;
  static const double contentVerticalPadding = baseContentVerticalPadding;
  static const double cardBorderRadius = baseCardBorderRadius;
  static const double cardBorderWidth = baseCardBorderWidth;
  static const double titleSpacing = baseTitleSpacing;
  static const double bottomSpacing = baseBottomSpacing;
  static const List<Map<String, String>> dailyFacts = [
    {
      'title': 'Armor-Plated Fish',
      'content':
          'Dunkleosteus, one of the fiercest prehistoric predators, didn\'t have teeth — it had sharp, bony plates that could slice through almost anything.',
    },
    {
      'title': 'Fossils Older Than Dinosaurs',
      'content':
          'The first known jawless fish appeared over 500 million years ago, long before dinosaurs ever walked the Earth.',
    },
    {
      'title': 'Shark Ancestors Still Swim',
      'content':
          'Modern sharks trace their lineage back to the Cladoselache, a sleek predator from 370 million years ago.',
    },
    {
      'title': 'Coelacanth — the Living Fossil',
      'content':
          'Thought extinct for 65 million years, the Coelacanth was found alive in 1938 — making it a true underwater Lazarus species.',
    },
    {
      'title': 'Fish With a Head But No Face',
      'content':
          'Some ancient fish like Arandaspis had no jaws, no teeth, and barely any face — just a flat armored front end and a tail.',
    },
    {
      'title': 'Fish That Could Bite Through Bone',
      'content':
          'The bite force of Dunkleosteus is estimated at over 6,000 N, strong enough to crush bone and rival modern crocodiles.',
    },
    {
      'title': 'The First Fish Were Filter Feeders',
      'content':
          'Early species like Haikouichthys used primitive filter-feeding techniques to survive in shallow seas.',
    },
    {
      'title': 'Herbivores Were Rare',
      'content':
          'Most early fish were carnivores — plant-eating fish like Bothriolepis were unusual and evolved much later in the Devonian period.',
    },
    {
      'title': 'Fish Invented Jaws',
      'content':
          'The Placoderms, a group of armored fish, were among the first to evolve true jaws, revolutionizing underwater predation.',
    },
    {
      'title': 'Fish with Legs?',
      'content':
          'Some prehistoric fish, like Tiktaalik, had limb-like fins, giving rise to land animals — including us!',
    },
    {
      'title': 'Ancient Fish Were Chemically Complex',
      'content':
          'Fossilized fish scales show traces of melanin and keratin, suggesting early use of biological "armor" and pigmentation.',
    },
    {
      'title': 'Ambush Hunters of the Deep',
      'content':
          'Xiphactinus, a 6-meter predator, was known for swallowing prey whole, including animals half its own size.',
    },
    {
      'title': 'Vampire Fish Ancestors',
      'content':
          'The terrifying Petromyzontida (lamprey family) existed hundreds of millions of years ago and still use their suction-mouths to feed on blood.',
    },
    {
      'title': 'Fish Survived Mass Extinctions',
      'content':
          'While many species perished in Earth\'s great die-offs, fish proved resilient, evolving into new forms each time — survivors of every extinction event.',
    },
  ];
  static const List<Map<String, dynamic>> articles = [
    {
      'id': 1,
      'title': 'Dunkleosteus',
      'subtitle': 'Armored Giant of the Devonian',
      'content':
          'Dunkleosteus was one of the most fearsome predators of the Late Devonian period, around 358–382 million years ago. This massive placoderm could grow up to 10 meters in length, with a heavily armored skull and jaw. Instead of teeth, Dunkleosteus had bony plates that formed self-sharpening "blades" — strong enough to crush bone and shell alike. Its bite force has been estimated at over 6,000 Newtons, putting it in the same league as today\'s great white sharks. Dunkleosteus could open its mouth in just 1/50 of a second, creating powerful suction to swallow prey whole — including other armored fish. Despite its fearsome design, Dunkleosteus likely had a slow metabolism, possibly relying on ambush tactics rather than high-speed chases. It ruled ancient seas as a top-tier predator, disappearing with the Devonian extinction, leaving behind only its fossilized skull — its body remains a mystery.',
      'image': 'assets/1.png',
      'isReal': true,
    },
    {
      'id': 2,
      'title': 'Xenacanthus',
      'subtitle': 'The Freshwater Shark-Eel Hybrid',
      'content':
          'Xenacanthus was a genus of primitive sharks that lived from the Late Devonian through the Triassic period (approximately 370–200 million years ago). Unlike today\'s sharks, Xenacanthus preferred freshwater environments like rivers and swamps. Its body resembled an eel more than a classic shark — long, flexible, and with a continuous dorsal fin that stretched from head to tail. One of its most distinctive features was a strange spine projecting backward from the back of its head — possibly used for defense or even injecting venom. Although not very large (around 1 meter), Xenacanthus was a stealthy predator, feeding on small amphibians, crustaceans, and other fish. Its teeth were adapted for gripping slippery prey — V-shaped and deeply rooted. Fossils of Xenacanthus have been found across Europe, North America, and even parts of South America, marking it as one of the earliest global freshwater predators.',
      'image': 'assets/2.png',
      'isReal': true,
    },
    {
      'id': 3,
      'title': 'Helicoprion',
      'subtitle': 'The Buzzsaw of the Sea',
      'content':
          'Helicoprion is one of the most bizarre prehistoric fish ever discovered. This spiral-jawed predator lived during the Permian period (290–250 million years ago) and is known almost entirely from its distinctive "tooth whorls" — tightly coiled spirals of teeth that look like a circular saw. Scientists long debated where the tooth spiral was located — early reconstructions placed it on the snout, but modern research suggests it was inside the lower jaw, unrolling forward like a tape measure. This allowed Helicoprion to slice through soft-bodied prey such as squid and other cephalopods with a scissor-like motion. Helicoprion likely grew up to 4–6 meters long and had a cartilaginous skeleton like modern sharks, which explains the scarcity of complete fossils. Despite its strange anatomy, it was a successful predator of the Paleozoic seas, and its jaw design remains one of the most iconic enigmas in paleontology.',
      'image': 'assets/3.png',
      'isReal': true,
    },
    {
      'id': 4,
      'title': 'Lepidotes',
      'subtitle': 'The Armored Grazer of Shallow Waters',
      'content':
          'Lepidotes was a genus of ray-finned fish that thrived during the Jurassic and Cretaceous periods, about 200 to 100 million years ago. It was typically under one meter in length, with a deep, laterally compressed body covered in thick, rhomboid ganoid scales — giving it a distinct armor-like appearance. This fish wasn\'t built for speed but for endurance and protection. It fed on hard-shelled prey and aquatic vegetation, using its powerful jaws and rounded, peg-like teeth to crush crustaceans, mollusks, and fibrous plant matter. Fossil evidence shows it had a relatively slow metabolism and spent much of its time foraging near the seafloor or in lagoons and estuaries. Lepidotes was an important part of the aquatic food web, serving as both grazer and prey for larger predators like marine reptiles. Its unique scale structure helped inspire early research into fish armor and hydrodynamic resistance.',
      'image': 'assets/4.png',
      'isReal': true,
    },
    {
      'id': 5,
      'title': 'Megapiranha',
      'subtitle': 'Between the Plant and the Flesh',
      'content':
          'Megapiranha is an extinct freshwater fish from the Late Miocene period (about 8–10 million years ago), discovered in South America. Despite its name and fearsome reputation, this prehistoric cousin of the modern piranha likely had a more balanced diet — omnivorous, leaning toward herbivorous. Growing up to 1 meter long, Megapiranha was much larger than its modern relatives. Its unusual zig-zag tooth pattern suggested a transitional form between the sharp, flesh-tearing teeth of piranhas and the broad, crushing teeth of pacus. This made it well-equipped to handle a variety of foods — including seeds, nuts, aquatic plants, and potentially small animals. Its jaw strength was remarkable for its size, likely helping it break tough plant material. Scientists believe Megapiranha played a unique ecological role, controlling vegetation while occasionally scavenging protein — a prehistoric example of dietary flexibility.',
      'image': 'assets/5.png',
      'isReal': true,
    },
    {
      'id': 6,
      'title': 'Dipterus',
      'subtitle': 'The Two-Finned Plant Eater',
      'content':
          'Dipterus lived during the Middle Devonian period, roughly 390 million years ago, and is considered one of the early lungfish. This ancient creature had paired lobed fins — the forerunners of the limbs of tetrapods — which helped it move slowly along the substrate of freshwater lakes and streams. Dipterus had both gills and primitive lungs, allowing it to survive in low-oxygen environments. Its diet consisted mainly of algae, soft aquatic plants, and organic debris it could scrape from rocks and sediment. It had crushing tooth plates rather than sharp teeth, perfectly suited for grinding vegetation. Although modest in size (around 35 cm), Dipterus was significant from an evolutionary standpoint. It represented a step toward land-dwelling vertebrates and demonstrated how specialized jaw and lung structures helped early fish diversify their feeding habits and habitats.',
      'image': 'assets/6.png',
      'isReal': true,
    },
    {
      'id': 7,
      'title': 'Krakenoid',
      'subtitle': 'Tentacles in the Deep',
      'content':
          'Said to dwell in the lightless trenches of the prehistoric oceans, the Krakenoid is a nightmarish hybrid of fish and cephalopod. Fossil-like imprints of this creature show a torpedo-shaped body with six soft, tentacle-like growths around its mouth, used to lure and grasp prey before it could escape. Its enormous eyes were thought to glow faintly yellow, allowing it to detect movement in pitch black waters. Krakenoid was allegedly an ambush predator — motionless for hours, then striking with its electrified barbed tongue. Ancient sailor myths describe Krakenoids swarming around shipwrecks, mistaking sinking lights for prey. While no physical fossils exist, deep-sea cave paintings from early coastal civilizations depict fish eerily similar to Krakenoid. Whether it was real or imagined, its legend still sends shivers through those who believe some corners of the deep ocean remain unexplored — and inhabited.',
      'image': 'assets/7.png',
      'isReal': false,
    },
    {
      'id': 8,
      'title': 'Grimfin',
      'subtitle': 'The Vanishing Hunter',
      'content':
          'The Grimfin is a translucent, phantom-like predator rumored to have roamed dark prehistoric waters during lunar eclipses. With elongated fins trailing like cloaks and a thin, almost invisible body, Grimfin could move in silence, undetected by prey and predator alike. Its most feared trait was temporary invisibility — blending into the water so completely it became little more than a ripple. Grimfin used high-frequency clicks to disorient fish and then struck with a scissor-shaped jaw lined with black glass-like teeth. Some cryptozoologists believe Grimfins still survive today in the hadal zones of the Pacific, occasionally caught on blurred footage from deep-sea drones. Though no concrete proof exists, their legend has earned them the title "Specters of the Sea" among myth hunters.',
      'image': 'assets/8.png',
      'isReal': false,
    },
    {
      'id': 9,
      'title': 'Furox',
      'subtitle': 'The Living Lightning Bolt',
      'content':
          'Furox was no ordinary hunter — it was electricity incarnate. With a compact, muscular body covered in glimmering bronze scales and long dorsal spines, this predator could allegedly generate explosive bursts of bioelectric energy to shock prey or ward off threats. Its most iconic feature was the curved frontal horn, believed to discharge lightning-like pulses when agitated. Some ancient reef stones show scorched coral patterns consistent with Furox attacks. It swam in zig-zags, creating static trails that attracted smaller fish — only to strike them mid-swarm. Furox stories were passed down by ancient coastal tribes who feared thunderstorms at sea, believing the rumbles were the echoes of angry Furox packs hunting just beneath the waves. Whether an exaggerated electric ray or a true prehistoric anomaly, Furox became a symbol of uncontrolled oceanic fury.',
      'image': 'assets/9.png',
      'isReal': false,
    },
    {
      'id': 10,
      'title': 'Corallos',
      'subtitle': 'The Coralback Grazer',
      'content':
          'Corallos was a peaceful reef-dwelling herbivore believed to live symbiotically with coral colonies that grew directly on its back. Measuring up to 1.5 meters long, this slow-moving fish had a broad, rounded body with thick, algae-covered skin — the perfect surface for coral polyps to take hold and thrive. Its diet consisted primarily of toxic algae and fibrous seaweed that other creatures avoided. By digesting harmful plant matter, Corallos helped regulate the balance of reef ecosystems. The coral growth on its back not only offered camouflage but also served as a natural defense: predators often avoided attacking what looked like a piece of reef. Legends from coastal island cultures speak of "swimming reefs" that appeared during tidal blooms — likely inspired by Corallos sightings. Fossilized coral rings found in strange spiral patterns are sometimes linked to these living gardens of the ancient sea.',
      'image': 'assets/10.png',
      'isReal': false,
    },
    {
      'id': 11,
      'title': 'Plumosaur',
      'subtitle': 'The Feather-Finned Drifter',
      'content':
          'With flowing fins like aquatic feathers and a calm, drifting presence, the Plumosaur is thought to have inhabited dense kelp forests during the Mesozoic era. This fish was characterized by its ultra-lightweight skeleton, transparent tail, and graceful fin extensions that rippled like silk in the water. Plumosaur\'s entire life revolved around motionless gliding. It barely moved, instead relying on underwater currents to carry it through thick patches of vegetation. It fed primarily on soft aquatic moss, tender kelp sprouts, and microalgae it collected using small comb-like teeth. Due to its delicate form and shy nature, the Plumosaur was rarely seen — even in folklore. However, ancient cave murals near prehistoric lake beds depict shimmering ghost-fish surrounded by ferns and fronds. Many believe these artworks immortalized the elusive beauty of the Plumosaur.',
      'image': 'assets/11.png',
      'isReal': false,
    },
    {
      'id': 12,
      'title': 'Glitterodus',
      'subtitle': 'The Peacekeeper of the Pond',
      'content':
          'Glitterodus was a small, brightly scaled herbivorous fish said to inhabit freshwater lakes during the early Cenozoic. Only about 20–30 cm in length, it made up for its size with dazzling, reflective scales that shimmered in golden, pink, and violet hues — visible even in murky waters. These scales weren\'t just for show — they emitted calming light pulses that helped soothe other aquatic creatures, making Glitterodus a sort of emotional regulator in the food chain. It fed on pondweed, flowering algae, and fallen blossoms from overhanging plants, swimming gently near the surface in sunlit areas. Some early shamans believed Glitterodus to be a sacred spirit of balance and healing. Its glowing scales were thought to restore harmony to disturbed ecosystems — a symbol of serenity in prehistoric mythology.',
      'image': 'assets/12.png',
      'isReal': false,
    },
  ];
}
