
// NEW NODES

/datum/techweb_node/adv_vision
	id = TECHWEB_NODE_ADVANCED_VISION
	display_name = "Combat Cybernetic Eyes"
	description = "Military grade combat implants to improve vision."
	prereq_ids = list(TECHWEB_NODE_COMBAT_IMPLANTS, TECHWEB_NODE_ALIEN_SURGERY)
	design_ids = list(
		"ci-thermals",
		"ci-xray",
		"ci-thermals-moth",
		"ci-xray-moth",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_MEDICAL)

/datum/techweb_node/borg_shapeshifter
	id = TECHWEB_NODE_BORG_SHAPESHIFTER
	display_name = "Illegal Cyborg Addition"
	description = "Some sort of experimental tool that was once used by an rival company."
	prereq_ids = list(TECHWEB_NODE_SYNDICATE_BASIC)
	design_ids = list("borg_shapeshifter_module")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)

/datum/techweb_node/android_chassis
	id = TECHWEB_NODE_ANDROID_CHASSIS
	starting_node = TRUE
	display_name = "Android Technology"
	description = "Shiny parts for your shiny friends!"
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"synth_head",
		"synth_chest",
		"synth_l_arm",
		"synth_r_arm",
		"synth_l_leg",
		"synth_r_leg",
		"synth_l_d_leg",
		"synth_r_d_leg",
	)

/datum/techweb_node/android_organs
	id = TECHWEB_NODE_ANDROID_ORGANS
	starting_node = TRUE
	display_name = "Android Organs"
	description = "Internal Mechanisms for Synthetics and IPC's."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"synth_eyes",
		"synth_tongue",
		"synth_liver",
		"synth_lungs",
		"synth_stomach",
		"synth_charger",
		"synth_ears",
		"synth_heart",
	)

/datum/techweb_node/ammobench_more
	id = TECHWEB_NODE_AMMOBENCH_MORE
	display_name = "Ammunition Bench Authentication Protocols"
	description = "Turns out it's really easy to flash fabrication module reauthentication firmware onto blank circuits."
	design_ids = list(
		"ammobench_reauth",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	hidden = TRUE
	experimental = TRUE
	announce_channels = list(RADIO_CHANNEL_SECURITY, RADIO_CHANNEL_SUPPLY)

// MODULAR ADDITIONS AND REMOVALS

//Base Nodes
/datum/techweb_node/atmos/New()
	design_ids += list(
		"vox_gas_filter",
		"vaporizer",
	)
	return ..()

/datum/techweb_node/construction/New()
	design_ids += list(
		"polarizer",
	)
	return ..()

/datum/techweb_node/office_equip/New()
	design_ids += list(
		"gbp_machine",
		"pen",
	)
	return ..()

/datum/techweb_node/augmentation/New()
	design_ids += list(
		"affection_module",
	)
	return ..()

/datum/techweb_node/medbay_equip/New()
	design_ids += list(
		"surgical_gown",
		"anesthetic_machine",
		"smartdartgun",
		"cone_of_shame",
	)
	return ..()

/////////////////////////Biotech/////////////////////////

/datum/techweb_node/medbay_equip_adv/New()
	design_ids += list(
		"monkey_helmet",
		"brute2medicell",
		"burn2medicell",
		"toxin2medicell",
		"oxy2medicell",
		"relocatemedicell",
		"tempmedicell",
		"bodymedicell",
		"clotmedicell",
	)
	return ..()

/////////////////////////EMP tech/////////////////////////

/datum/techweb_node/energy_manipulation/New()
	design_ids += list(
		"gownmedicell",
		"bedmedicell",
		"tray_goggles_prescription",
	)
	return ..()

////////////////////////Computer tech////////////////////////

/datum/techweb_node/consoles/New()
	design_ids += list(
		"nif_service_tools",
		"idcard_guest",
	)
	return ..()


/datum/techweb_node/hud/New()
	design_ids += list(
		"health_hud_prescription",
		"security_hud_prescription",
		"diagnostic_hud_prescription",
		"science_hud_prescription",
		"health_hud_aviator",
		"security_hud_aviator",
		"diagnostic_hud_aviator",
		"meson_hud_aviator",
		"science_hud_aviator",
		"health_hud_projector",
		"security_hud_projector",
		"diagnostic_hud_projector",
		"meson_hud_projector",
		"science_hud_projector",
		"permit_glasses",
		"nifsoft_money_sense",
		"nifsoft_hud_kit",
		"nifsoft_hud_science",
		"nifsoft_hud_meson",
		"nifsoft_hud_medical",
		"nifsoft_hud_security",
		"nifsoft_hud_diagnostic",
		"nifsoft_hud_cargo",
	)
	return ..()

////////////////////////Medical////////////////////////
/datum/techweb_node/surgery/New()
	design_ids += list(
		"nif_surgery_tools",
	)
	return ..()

/datum/techweb_node/medbay_equip_adv/New()
	design_ids += list(
		"self_actualization_device",
	)
	return ..()

/datum/techweb_node/cyber/cyber_organs/New()
	design_ids += list(
		"cybernetic_tongue",
		"cybernetic_tongue_lizard",
	)
	return ..()

// Modularly removes x-ray and thermals from here, it's in adv_vision instead
/datum/techweb_node/cyber/cyber_organs_adv/New()
	design_ids -= list(
		"ci-thermals",
		"ci-xray",
		"ci-thermals-moth",
		"ci-xray-moth",
	)
	return ..()

////////////////////////Tools////////////////////////

/datum/techweb_node/hydroponics/New()
	design_ids += list(
		"salvemedicell",
	)
	return ..()

/datum/techweb_node/sec_equip/New()
	design_ids += list(
		"nifsoft_remover",
		"nif_detective_tools",

	)
	return ..()

/////////////////////////weaponry tech/////////////////////////

/datum/techweb_node/basic_arms/New()
	design_ids += list(
		"ammo_workbench",
	)
	return ..()

/datum/techweb_node/riot_supression/New()
	design_ids += list(
		"ammobench_gimmick",
	)
	return ..()

/datum/techweb_node/electric_weapons/New()
	design_ids += list(
		"medigun_speed",
	)
	return ..()

/datum/techweb_node/mod_security/New()
	design_ids += list(
		"mod_retract_plates",
	)
	return ..()

/datum/techweb_node/exotic_ammo/New()
	design_ids += list(
		"c38_haywire",
		"c38_haywire_mag",
		"ammobench_niche",
	)
	return ..()

////////////////////////Alien technology////////////////////////

/datum/techweb_node/alien_surgery/New()
	design_ids += list(
		"brute3medicell",
		"burn3medicell",
		"oxy3medicell",
		"toxin3medicell",
	)
	return ..()

/////////////////////////engineering tech/////////////////////////

/datum/techweb_node/parts_upg/New()
	design_ids += list(
		"nif_general_tools",
	)
	return ..()

/datum/techweb_node/fusion/New()
	design_ids += list(
		"engine_goggles_prescription",
	)
	return ..()

/datum/techweb_node/exp_tools/New()
	design_ids += list(
		"multi_cell_charger",
	)
	return ..()

/datum/techweb_node/chem_synthesis/New()
	design_ids += list(
		"hypokit",
		"hypomkii",
		"large_hypovial",
		"medipen_atropine",
		"medipen_epinephrine",
		"medipen_oxandrolone",
		"medipen_penacid",
		"medipen_salacid",
		"medipen_salbutamol",
		"medipen_universal",
		"medipen_universal_lowpressure",
		"plumbing_eng",
	)
	return ..()

/datum/techweb_node/mining/New()
	design_ids += list(
		"mesons_prescription",
		"bsc_nt",
	)
	return ..()

/////////////////////////robotics tech/////////////////////////

/datum/techweb_node/robotics/New()
	design_ids += list(
		"borg_upgrade_snacks",
		"mini_soulcatcher",
	)
	return ..()

/datum/techweb_node/passive_implants/New()
	design_ids += list(
		"soulcatcher_device",
		"rsd_interface",
	)
	return ..()

/datum/techweb_node/borg_utility/New()
	design_ids += list(
		"borg_upgrade_clamp",
		"borg_upgrade_brush",
		"borg_upgrade_shrink",
	)
	return ..()

/datum/techweb_node/borg_engi/New()
	design_ids += list(
		"advanced_materials",
		"borg_upgrade_welding",
	)
	return ..()

/datum/techweb_node/borg_medical/New()
	design_ids += list(
		"borg_upgrade_surgicaltools",
	)
	return ..()

/////////////////////////Applied Bluespace /////////////////////////

/datum/techweb_node/applied_bluespace/New()
	design_ids += list(
		"plantbag_holding",
	)
	return ..()
