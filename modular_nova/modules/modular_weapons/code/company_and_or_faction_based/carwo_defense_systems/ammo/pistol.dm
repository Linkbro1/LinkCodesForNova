// .35 Sol Short
// Pistol caliber caseless round used almost exclusively by SolFed weapons

/obj/item/ammo_casing/c35sol
	name = ".35 Sol Short lethal bullet casing"
	desc = "A SolFed standard caseless lethal pistol round."

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/ammo.dmi'
	icon_state = "35sol"

	caliber = CALIBER_SOL35SHORT
	projectile_type = /obj/projectile/bullet/c35sol


/obj/item/ammo_casing/c35sol/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/caseless)


/obj/projectile/bullet/c35sol
	name = ".35 Sol Short bullet"
	damage = 20

	wound_bonus = 5 // Normal bullets are 20
	exposed_wound_bonus = 10


/obj/item/ammo_box/c35sol
	name = "ammo box (.35 Sol Short lethal)"
	desc = "A box of .35 Sol Short pistol rounds, holds twenty-four rounds."

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/ammo.dmi'
	icon_state = "35box"

	multiple_sprites = AMMO_BOX_FULL_EMPTY

	w_class = WEIGHT_CLASS_NORMAL

	caliber = CALIBER_SOL35SHORT
	ammo_type = /obj/item/ammo_casing/c35sol
	max_ammo = 24


// .35 Sol's equivalent to a rubber bullet

/obj/item/ammo_casing/c35sol/incapacitator
	name = ".35 Sol Short incapacitator bullet casing"
	desc = "A SolFed standard caseless less-lethal pistol round. Exhausts targets on hit, has a tendency to bounce off walls at shallow angles."

	icon_state = "35sol_disabler"

	projectile_type = /obj/projectile/bullet/c35sol/incapacitator
	harmful = FALSE
	print_cost = 0
	ammo_categories = AMMO_CLASS_NONE


/obj/projectile/bullet/c35sol/incapacitator
	name = ".35 Sol Short incapacitator bullet"
	damage = 5
	stamina = 30

	wound_bonus = -40
	exposed_wound_bonus = -20

	weak_against_armour = TRUE

	// The stats of the ricochet are a nerfed version of detective revolver rubber ammo
	// This is due to the fact that there's a lot more rounds fired quickly from weapons that use this, over a revolver
	ricochet_auto_aim_angle = 30
	ricochet_auto_aim_range = 5
	ricochets_max = 4
	ricochet_incidence_leeway = 50
	ricochet_chance = 130
	ricochet_decay_damage = 0.8

	shrapnel_type = null
	sharpness = NONE
	embed_data = null


/obj/item/ammo_box/c35sol/incapacitator
	name = "ammo box (.35 Sol Short incapacitator)"
	desc = "A box of .35 Sol Short pistol rounds, holds twenty-four rounds. The blue stripe indicates this should hold less-lethal ammunition."

	icon_state = "35box_disabler"

	ammo_type = /obj/item/ammo_casing/c35sol/incapacitator


// .35 Sol ripper, similar to the detective revolver's dumdum rounds, causes slash wounds and is weak to armor

/obj/item/ammo_casing/c35sol/ripper
	name = ".35 Sol Short ripper bullet casing"
	desc = "A SolFed standard caseless ripper pistol round. Causes slashing wounds on targets, but is weak to armor."

	icon_state = "35sol_shrapnel"
	projectile_type = /obj/projectile/bullet/c35sol/ripper

	custom_materials = AMMO_MATS_RIPPER
	ammo_categories = AMMO_CLASS_PLUS
	print_cost = 2

/obj/projectile/bullet/c35sol/ripper
	name = ".35 Sol ripper bullet"
	damage = 15

	weak_against_armour = TRUE

	sharpness = SHARP_EDGED

	wound_bonus = 20
	exposed_wound_bonus = 20

	embed_type = /datum/embedding/c35sol_ripper

	embed_falloff_tile = -15

/datum/embedding/c35sol_ripper
	embed_chance = 75
	fall_chance = 3
	jostle_chance = 4
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.4
	pain_mult = 5
	jostle_pain_mult = 6
	rip_time = 1 SECONDS

/obj/item/ammo_box/c35sol/ripper
	name = "ammo box (.35 Sol Short ripper)"
	desc = "A box of .35 Sol Short pistol rounds, holds twenty-four rounds. The purple stripe indicates this should hold hollowpoint-like ammunition."

	icon_state = "35box_shrapnel"

	ammo_type = /obj/item/ammo_casing/c35sol/ripper

// .35 Sol flash, similar to Polaris code flash ammo for pistols.

/obj/item/ammo_casing/c35sol/flash
	name = ".35 Sol Short flash bullet casing"
	desc = "A SolFed standard caseless less-lethal pistol round. Creates a small, pyrotechnic flash on hit; insufficient to overload cyborgs."

	icon_state = "35sol_flash"

	projectile_type = /obj/projectile/bullet/c35sol/flash
	harmful = FALSE
	print_cost = 0
	ammo_categories = AMMO_CLASS_NONE

/obj/projectile/bullet/c35sol/flash
	name = ".35 Sol Short flash bullet"
	damage = 5

	shrapnel_type = null
	sharpness = NONE
	embed_data = null

/obj/projectile/bullet/c35sol/flash/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	do_sparks(rand(1, 4), FALSE, src)
	if(isliving(target))
		var/mob/living/flashed_living = target
		flashed_living.ignite_mob() // lmao
		if(flashed_living.flash_act(intensity = 1, affect_silicon = TRUE, length = 1 SECONDS))
			flashed_living.set_confusion_if_lower(2 SECONDS)
			flashed_living.adjustStaminaLoss(rand(30, 35))

/obj/item/ammo_box/c35sol/flash
	name = "ammo box (.35 Sol Short flash)"
	desc = "A box of .35 Sol Short pistol rounds, holds twenty-four rounds. The orange stripe indicates this should hold flash ammunition, which poses an incendiary risk."

	icon_state = "35box_flash"

	ammo_type = /obj/item/ammo_casing/c35sol/flash
