/obj/item/organ/cyberimp/arm/toolkit/power_cord
	name = "charging implant"
	desc = "An internal power cord. Useful if you run on elecricity. Not so much otherwise."
	items_to_create = list(/obj/item/synth_powercord)
	zone = "l_arm"
	cannot_confiscate = TRUE

/obj/item/synth_powercord
	name = "power cord"
	desc = "An internal power cord. Useful if you run on electricity. Not so much otherwise."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "wire1"
	///Object basetypes which the powercord is allowed to connect to.
	var/static/list/synth_charge_whitelist = typecacheof(list(
		/obj/item/stock_parts/power_store,
		/obj/machinery/power/apc,
	))

// Attempt to charge from an object by using them on the power cord.
/obj/item/synth_powercord/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!can_power_draw(tool, user))
		return NONE
	try_power_draw(tool, user)
	return ITEM_INTERACT_SUCCESS

// Attempt to charge from an object by using the power cord on them.
/obj/item/synth_powercord/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_power_draw(interacting_with, user))
		return NONE
	try_power_draw(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/// Returns TRUE or FALSE depending on if the target object can be used as a power source.
/obj/item/synth_powercord/proc/can_power_draw(obj/target, mob/user)
	return ishuman(user) && is_type_in_typecache(target, synth_charge_whitelist)

/// Attempts to start using an object as a power source.
/// Checks the user's internal powercell to see if it exists.
/obj/item/synth_powercord/proc/try_power_draw(obj/target, mob/living/carbon/human/user)
	// Only robotic species can use this
	if(!(user.mob_biotypes & MOB_ROBOTIC))
		to_chat(user, span_warning("You plug into [target], but nothing happens! It seems you don't have an internal cell to charge."))
		return

	/// The current user's nutrition level in joules.
	var/nutrition_level_joules = user.nutrition * SYNTH_JOULES_PER_NUTRITION
	user.changeNext_move(CLICK_CD_MELEE)

	var/obj/item/organ/stomach/synth/synth_cell = user.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(QDELETED(synth_cell) || !istype(synth_cell))
		to_chat(user, span_warning("You plug into [target], but nothing happens! It seems you don't have an internal cell to charge."))
		return

	if(nutrition_level_joules > SYNTH_CHARGE_ALMOST_FULL)
		user.balloon_alert(user, "cell fully charged!")
		return

	user.visible_message(span_notice("[user] inserts a power connector into [target]."), span_notice("You begin to draw power from [target]."))
	do_power_draw(target, user)

	if(QDELETED(target))
		return

	user.visible_message(span_notice("[user] unplugs from [target]."), span_notice("You unplug from [target]."))

/**
 * Runs a loop to charge a synth cell (stomach) from a power cell or APC.
 * Displays chat messages to the user and nearby observers.
 *
 * Stops when:
 * - The user's internal cell is full.
 * - The cell has less than the minimum charge.
 * - The user moves, or anything else that can happen to interrupt a do_after.
 *
 * Arguments:
 * * target - The power cell or APC to drain.
 * * user - The human mob draining the power cell.
 */
/obj/item/synth_powercord/proc/do_power_draw(obj/target, mob/living/carbon/human/user)
	// Draw power from an APC if one was given.
	var/obj/machinery/power/apc/target_apc
	if(istype(target, /obj/machinery/power/apc))
		target_apc = target

	var/obj/item/stock_parts/power_store/target_cell = target_apc ? target_apc.cell : target
	var/minimum_cell_charge = target_apc ? SYNTH_APC_MINIMUM_PERCENT : 0

	if(!target_cell || target_cell.percent() < minimum_cell_charge)
		user.balloon_alert(user, "apc charge low!")
		return
	var/wait = SSmachines.wait / (1 SECONDS)
	var/energy_needed
	while(TRUE)
		// Check if the charge level of the cell is below the minimum.
		// Prevents synths from overloading the cell.
		if(target_cell.percent() < minimum_cell_charge)
			user.balloon_alert(user, "apc charge low!")
			break

		// Attempt to drain charge from the cell.
		if(!do_after(user, wait SECONDS, target))
			break

		// Check if the user is nearly fully charged.
		// Ensures minimum draw is always lower than this margin.
		var/nutrition_level_joules = user.nutrition * SYNTH_JOULES_PER_NUTRITION
		energy_needed = SYNTH_CHARGE_MAX - nutrition_level_joules

		// Calculate how much to draw from the cell this cycle.
		var/current_draw = min(energy_needed, SYNTH_CHARGE_RATE * wait)

		var/energy_delivered = target_cell.use(current_draw, force = TRUE)
		target_cell.update_appearance()
		if(!energy_delivered)
			// The cell could be sabotaged, which causes it to explode and qdelete.
			if(QDELETED(target_cell))
				return
			user.balloon_alert(user, "[target_apc ? "APC" : "Cell"] empty!")
			break

		// If charging was successful, then increase user nutrition and emit sparks.
		var/nutrition_gained = energy_delivered / SYNTH_JOULES_PER_NUTRITION
		user.nutrition = min(user.nutrition + nutrition_gained, NUTRITION_LEVEL_FULL)
		do_sparks(1, FALSE, target_cell.loc)
		if(user.nutrition > NUTRITION_LEVEL_ALMOST_FULL)
			user.balloon_alert(user, "fully charged")
			break

/datum/design/synth_charger
	name = "Charging Cord Implant"
	desc = "An internal power cord for synthetic use only. Requires connection the synthetic fuel cell to function."
	id = "synth_charger"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/cyberimp/arm/toolkit/power_cord
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_ORGANS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
