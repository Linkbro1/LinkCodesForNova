/// Belt which can turn you into a beast, once an anomaly core is inserted
/obj/item/polymorph_belt
	name = "polymorphic field inverter"
	desc = "This device can scan and store DNA from other life forms."
	slot_flags = ITEM_SLOT_BELT
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "polybelt_inactive"
	worn_icon_state = "polybelt_inactive"
	base_icon_state = "polybelt"
	item_flags = NOBLUDGEON
	/// Typepath of a mob we have scanned, we only store one at a time
	var/stored_mob_type
	/// Have we activated the belt?
	var/active = FALSE
	/// Our current transformation action
	var/datum/action/cooldown/spell/shapeshift/polymorph_belt/transform_action

/obj/item/polymorph_belt/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/polymorph_belt/Destroy(force)
	QDEL_NULL(transform_action)
	return ..()

/obj/item/polymorph_belt/examine(mob/user)
	. = ..()
	if (stored_mob_type)
		var/mob/living/will_become = stored_mob_type
		. += span_notice("It contains digitised [initial(will_become.name)] DNA.")
	if (!active)
		. += span_warning("It requires a Bioscrambler Anomaly Core in order to function.")

/obj/item/polymorph_belt/update_icon_state()
	icon_state = base_icon_state + (active ? "" : "_inactive")
	worn_icon_state = base_icon_state + (active ? "" : "_inactive")
	return ..()

/obj/item/polymorph_belt/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (!istype(tool, /obj/item/assembly/signaler/anomaly/bioscrambler))
		return NONE

	if (active)
		balloon_alert(user, "core already inserted!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "inserting...")

	if (!do_after(user, delay = 3 SECONDS, target = src))
		balloon_alert(user, "interrupted!")
		return ITEM_INTERACT_BLOCKING

	if (active)
		balloon_alert(user, "core already inserted!")
		return ITEM_INTERACT_BLOCKING

	active = TRUE
	update_appearance(UPDATE_ICON_STATE)
	update_transform_action()
	playsound(src, 'sound/machines/crate/crate_open.ogg', 50, FALSE)
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

/obj/item/polymorph_belt/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if (.)
		return
	if (!isliving(target_mob))
		return
	if (!isanimal_or_basicmob(target_mob))
		balloon_alert(user, "target too complex!")
		return TRUE
	if (target_mob.mob_biotypes & (MOB_HUMANOID|MOB_ROBOTIC|MOB_SPECIAL|MOB_SPIRIT|MOB_UNDEAD))
		balloon_alert(user, "incompatible!")
		return TRUE
	if (!target_mob.compare_sentience_type(SENTIENCE_ORGANIC))
		balloon_alert(user, "target too intelligent!")
		return TRUE
	if (stored_mob_type == target_mob.type)
		balloon_alert(user, "already scanned!")
		return TRUE
	if (DOING_INTERACTION_WITH_TARGET(user, target_mob))
		balloon_alert(user, "busy!")
		return TRUE
	balloon_alert(user, "scanning...")
	visible_message(span_notice("[user] begins scanning [target_mob] with [src]."))
	if (!do_after(user, delay = 5 SECONDS, target = target_mob))
		return TRUE
	visible_message(span_notice("[user] scans [target_mob] with [src]."))
	stored_mob_type = target_mob.type
	update_transform_action()
	// NOVA EDIT ADDITION START - For some reason this likes to reset our transform and get rid of size. Stop doing that!
	var/mob/living/carbon/carbon_mob = user
	if(istype(carbon_mob))
		carbon_mob.dna?.update_body_size(force_reapply = TRUE)
	// NOVA EDIT ADDITION END
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	return TRUE

/// Make sure we can transform into the scanned target
/obj/item/polymorph_belt/proc/update_transform_action()
	if (isnull(stored_mob_type) || !active)
		return
	if (isnull(transform_action))
		transform_action = add_item_action(/datum/action/cooldown/spell/shapeshift/polymorph_belt)
	transform_action.update_type(stored_mob_type)

/// Pre-activated polymorph belt
/obj/item/polymorph_belt/functioning
	active = TRUE
	icon_state = "polybelt"
	worn_icon_state = "polybelt"

/// Ability provided by the polymorph belt
/datum/action/cooldown/spell/shapeshift/polymorph_belt
	name = "Invert Polymorphic Field"
	cooldown_time = 30 SECONDS
	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	possible_shapes = list(/mob/living/basic/cockroach)
	can_be_shared = FALSE
	/// Amount of time it takes us to transform back or forth
	var/channel_time = 3 SECONDS

/datum/action/cooldown/spell/shapeshift/polymorph_belt/cast(mob/living/cast_on)
	cast_on = owner //make sure this is only affecting the wearer of the belt
	return ..()

/datum/action/cooldown/spell/shapeshift/polymorph_belt/Remove(mob/remove_from)
	var/datum/status_effect/shapechange_mob/shapechange = remove_from.has_status_effect(/datum/status_effect/shapechange_mob/from_spell)
	var/atom/changer = shapechange?.caster_mob || remove_from
	changer?.transform = matrix()
	return ..()

/datum/action/cooldown/spell/shapeshift/polymorph_belt/before_cast(mob/living/cast_on)
	cast_on = owner
	. = ..()
	if (. & SPELL_CANCEL_CAST)
		return
	if (channel_time <= 0)
		return
	if (DOING_INTERACTION_WITH_TARGET(cast_on, cast_on))
		return . | SPELL_CANCEL_CAST

	var/old_transform = cast_on.transform

	var/animate_step = channel_time / 6
	playsound(cast_on, 'sound/effects/wounds/crack1.ogg', 50)
	animate(cast_on, transform = matrix() * 1.1, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 0.9, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 1.2, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 0.8, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 1.3, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 0.1, time = animate_step, easing = SINE_EASING)

	cast_on.balloon_alert(cast_on, "transforming...")
	if (!do_after(cast_on, delay = channel_time, target = cast_on))
		animate(cast_on, transform = matrix(), time = 0, easing = SINE_EASING)
		cast_on.transform = old_transform
		return . | SPELL_CANCEL_CAST
	cast_on.visible_message(span_warning("[cast_on]'s body rearranges itself with a horrible crunching sound!"))
	playsound(cast_on, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)

/datum/action/cooldown/spell/shapeshift/polymorph_belt/after_cast(atom/cast_on)
	. = ..()
	if (QDELETED(owner))
		return
	animate(owner, transform = matrix() * 0.1, time = 0, easing = JUMP_EASING)
	animate(transform = matrix(), time = 0.25 SECONDS, easing = SINE_EASING)

/// Update what you are transforming to or from
/datum/action/cooldown/spell/shapeshift/polymorph_belt/proc/update_type(transform_type)
	unshift_owner()
	shapeshift_type = transform_type
	possible_shapes = list(transform_type)
	var/mob/living/will_become = transform_type
	desc = "Assume your [initial(will_become.name)] form!"
	build_all_button_icons(update_flags = UPDATE_BUTTON_NAME)
