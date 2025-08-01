/obj/item/organ/tongue/copy_traits_from(obj/item/organ/tongue/old_tongue, mob/living/carbon/organ_receiver, copy_actions = FALSE)
	. = ..()
	// make sure we get food preferences too, because those are now tied to tongues for some reason
	liked_foodtypes = old_tongue.liked_foodtypes
	disliked_foodtypes = old_tongue.disliked_foodtypes
	toxic_foodtypes = old_tongue.toxic_foodtypes
	if (!organ_receiver || !organ_receiver.get_quirk(/datum/quirk/custom_tongue))
		return
	set_say_modifiers(organ_receiver)

/// Used to set the say modifiers on organ_receiver (ideally a player.) Early returns if the target has a signal listening (runs /datum/quirk/custom_tongue/proc/tongue_setup())
/obj/item/organ/tongue/proc/set_say_modifiers(mob/living/carbon/organ_receiver, ask, exclaim, whisper, yell, say)
	var/obj/item/organ/tongue/tongue = organ_receiver.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(SEND_SIGNAL(organ_receiver, COMSIG_SET_SAY_MODIFIERS))
		return // Early return so other quirks don't overwrite custom tongue.
	if(ask)
		organ_receiver.verb_ask = ask
	if(exclaim)
		organ_receiver.verb_exclaim = exclaim
	if(whisper)
		organ_receiver.verb_whisper = whisper
	if(yell)
		organ_receiver.verb_yell = yell
	if(say)
		tongue.say_mod = say

/obj/item/organ/tongue/dog
	name = "long tongue"
	desc = "A long and wet tongue. It seems to jump when it's called good, oddly enough."
	say_mod = "woofs"
	icon_state = "tongue"
	modifies_speech = TRUE

/obj/item/organ/tongue/dog/on_mob_insert(mob/living/carbon/signer, special = FALSE, movement_flags = DELETE_IF_REPLACED)
	. = ..()
	set_say_modifiers(signer, "arfs", "wans", "whimpers", "barks")

/obj/item/organ/tongue/dog/on_mob_remove(mob/living/carbon/speaker, special = FALSE)
	. = ..()
	speaker.verb_ask = initial(verb_ask)
	speaker.verb_exclaim = initial(verb_exclaim)
	speaker.verb_whisper = initial(verb_whisper)
	speaker.verb_yell = initial(verb_yell)

/obj/item/organ/tongue/cat/on_mob_insert(mob/living/carbon/signer, special = FALSE, movement_flags = DELETE_IF_REPLACED)
	. = ..()
	set_say_modifiers(signer, "mrrps", "mrrowls", "purrs", "yowls")

/obj/item/organ/tongue/cat/on_mob_remove(mob/living/carbon/speaker, special = FALSE)
	. = ..()
	speaker.verb_ask = initial(verb_ask)
	speaker.verb_exclaim = initial(verb_exclaim)
	speaker.verb_whisper = initial(verb_whisper)
	speaker.verb_yell = initial(verb_yell)

/obj/item/organ/tongue/avian
	name = "avian tongue"
	desc = "A short and stubby tongue that craves seeds."
	say_mod = "chirps"
	icon_state = "tongue"
	modifies_speech = TRUE

/obj/item/organ/tongue/avian/on_mob_insert(mob/living/carbon/signer, special = FALSE, movement_flags = DELETE_IF_REPLACED)
	. = ..()
	set_say_modifiers(signer, "peeps", "squawks", "murmurs", "shrieks")

/obj/item/organ/tongue/avian/on_mob_remove(mob/living/carbon/speaker, special = FALSE)
	. = ..()
	speaker.verb_ask = initial(verb_ask)
	speaker.verb_exclaim = initial(verb_exclaim)
	speaker.verb_whisper = initial(verb_whisper)
	speaker.verb_yell = initial(verb_yell)

/// This "human" tongue is only used in Character Preferences / Augmentation menu.
/// The base tongue class lacked a say_mod. With say_mod included it makes a non-Human user sound like a Human.
/obj/item/organ/tongue/human
	say_mod = "says"

/obj/item/organ/tongue/lizard/robot
	name = "robotic lizard voicebox"
	desc = "A lizard-like voice synthesizer that can interface with organic lifeforms."
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES
	icon_state = "tonguerobot"
	say_mod = "hizzes"
	attack_verb_continuous = list("beeps", "boops")
	attack_verb_simple = list("beep", "boop")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue
	liked_foodtypes = NONE
	disliked_foodtypes = NONE
	organ_traits = list(TRAIT_SILICON_EMOTES_ALLOWED)
	voice_filter = "alimiter=0.9,acompressor=threshold=0.2:ratio=20:attack=10:release=50:makeup=2,highpass=f=1000"

/obj/item/organ/tongue/lizard/robot/can_speak_language(language)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/tongue/lizard/robot/modify_speech(datum/source, list/speech_args)
	. = ..()
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/lizard/cybernetic
	name = "forked cybernetic tongue"
	icon = 'modular_nova/modules/organs/icons/cyber_tongue.dmi'
	icon_state = "cybertongue-lizard"
	desc =  "A fully-functional forked synthetic tongue, encased in soft silicone. Features include high-resolution vocals and taste receptors."
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES
	// Not as good as organic tongues, not as bad as the robotic voicebox.
	taste_sensitivity = 20
	liked_foodtypes = NONE
	disliked_foodtypes = NONE
	modifies_speech = TRUE

/obj/item/organ/tongue/cybernetic
	name = "cybernetic tongue"
	icon = 'modular_nova/modules/organs/icons/cyber_tongue.dmi'
	icon_state = "cybertongue"
	desc =  "A fully-functional synthetic tongue, encased in soft silicone. Features include high-resolution vocals and taste receptors."
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES
	say_mod = "says"
	// Not as good as organic tongues, not as bad as the robotic voicebox.
	taste_sensitivity = 20
	liked_foodtypes = NONE
	disliked_foodtypes = NONE
	toxic_foodtypes = NONE

/obj/item/organ/tongue/vox
	name = "vox tongue"
	desc = "A fleshy muscle mostly used for skreeing."
	say_mod = "skrees"
	liked_foodtypes = MEAT | FRIED

/obj/item/organ/tongue/dwarven
	name = "dwarven tongue"
	desc = "A fleshy muscle mostly used for bellowing."
	say_mod = "bellows"
	liked_foodtypes = ALCOHOL | MEAT | DAIRY //Dwarves like alcohol, meat, and dairy products.
	disliked_foodtypes = JUNKFOOD | FRIED | CLOTH //Dwarves hate foods that have no nutrition other than alcohol.

/obj/item/organ/tongue/ghoul
	name = "ghoulish tongue"
	desc = "A fleshy muscle mostly used for rasping."
	say_mod = "rasps"
	liked_foodtypes = RAW | MEAT
	disliked_foodtypes = VEGETABLES | FRUIT | CLOTH
	toxic_foodtypes = DAIRY | PINEAPPLE

/obj/item/organ/tongue/insect
	name = "insect tongue"
	desc = "A fleshy muscle mostly used for chittering."
	say_mod = "chitters"
	liked_foodtypes = GROSS | RAW | TOXIC | GORE
	disliked_foodtypes = CLOTH | GRAIN | FRIED
	toxic_foodtypes = DAIRY

/obj/item/organ/tongue/xeno_hybrid
	name = "alien tongue"
	desc = "According to leading xenobiologists the evolutionary benefit of having a second mouth in your mouth is \"that it looks badass\"."
	icon_state = "tonguexeno"
	say_mod = "hisses"
	taste_sensitivity = 10
	liked_foodtypes = MEAT

/obj/item/organ/tongue/xeno_hybrid/Initialize(mapload)
	. = ..()
	voice_filter = /obj/item/organ/tongue/alien::voice_filter

/obj/item/organ/tongue/skrell
	name = "skrell tongue"
	desc = "A fleshy muscle mostly used for warbling."
	say_mod = "warbles"

/obj/item/organ/tongue/lizard/filterless
	name = "smooth forked tongue"

	voice_filter = null

/obj/item/organ/tongue/lizard/filterless/Initialize(mapload)
	. = ..()

	desc += " This one is noticeably smooth, and would lack any non-hissing lisps if used."
