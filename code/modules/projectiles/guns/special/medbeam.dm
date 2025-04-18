/obj/item/gun/medbeam
	name = "Medical Beamgun"
	desc = "Don't cross the streams!"
	icon = 'icons/obj/chronos.dmi'
	icon_state = "chronogun"
	inhand_icon_state = "chronogun"
	w_class = WEIGHT_CLASS_NORMAL

	var/mob/living/current_target
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 8
	var/active = FALSE
	var/datum/beam/current_beam = null
	var/mounted = 0 //Denotes if this is a handheld or mounted version

	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/medbeam/Destroy(mob/user)
	LoseTarget()
	return ..()

/obj/item/gun/medbeam/dropped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/medbeam/equipped(mob/user)
	..()
	LoseTarget()

/**
 * Proc that always is called when we want to end the beam and makes sure things are cleaned up, see beam_died()
 */
/obj/item/gun/medbeam/proc/LoseTarget()
	if(active)
		QDEL_NULL(current_beam)
		active = FALSE
		on_beam_release(current_target)
	STOP_PROCESSING(SSobj, src)
	current_target = null

/**
 * Proc that is only called when the beam fails due to something, so not when manually ended.
 * manual disconnection = LoseTarget, so it can silently end
 * automatic disconnection = beam_died, so we can give a warning message first
 */
/obj/item/gun/medbeam/proc/beam_died()
	SIGNAL_HANDLER
	current_beam = null
	active = FALSE //skip qdelling the beam again if we're doing this proc, because
	if(isliving(loc))
		to_chat(loc, span_warning("You lose control of the beam!"))
	LoseTarget()

/obj/item/gun/medbeam/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(isliving(user))
		add_fingerprint(user)

	if(current_target)
		LoseTarget()
	if(!isliving(target))
		return

	current_target = target
	active = TRUE
	current_beam = user.Beam(current_target, icon_state="medbeam", time = 10 MINUTES, maxdistance = max_range, beam_type = /obj/effect/ebeam/medical)
	RegisterSignal(current_beam, COMSIG_QDELETING, PROC_REF(beam_died))//this is a WAY better rangecheck than what was done before (process check)
	START_PROCESSING(SSobj, src)

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE

/obj/item/gun/medbeam/process()
	if(!mounted && !isliving(loc))
		LoseTarget()
		return

	if(!current_target)
		LoseTarget()
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(!los_check(get_atom_on_turf(src), current_target, mid_check = CALLBACK(src, PROC_REF(mid_los_check))))
		QDEL_NULL(current_beam)//this will give the target lost message
		return

	if(current_target)
		on_beam_tick(current_target)

/obj/item/gun/medbeam/proc/mid_los_check(atom/movable/user, mob/target, pass_args = PASSTABLE|PASSGLASS|PASSGRILLE, turf/next_step, obj/dummy)
	for(var/obj/effect/ebeam/medical/B in next_step)// Don't cross the str-beams!
		if(QDELETED(current_beam))
			break //We shouldn't be processing anymore.
		if(QDELETED(B))
			continue
		if(!B.owner)
			stack_trace("beam without an owner! [B]")
			continue
		if(B.owner.origin != current_beam.origin)
			explosion(B.loc, heavy_impact_range = 3, light_impact_range = 5, flash_range = 8, explosion_cause = src)
			qdel(dummy)
			return FALSE
	return TRUE

/obj/item/gun/medbeam/proc/on_beam_hit(mob/living/target)
	return

/obj/item/gun/medbeam/proc/on_beam_tick(mob/living/target)
	if(target.health != target.maxHealth)
		new /obj/effect/temp_visual/heal(get_turf(target), COLOR_HEALING_CYAN)
	var/need_mob_update
	need_mob_update = target.adjustBruteLoss(-4, updating_health = FALSE, forced = TRUE)
	need_mob_update += target.adjustFireLoss(-4, updating_health = FALSE, forced = TRUE)
	need_mob_update += target.adjustToxLoss(-1, updating_health = FALSE, forced = TRUE)
	need_mob_update += target.adjustOxyLoss(-1, updating_health = FALSE, forced = TRUE)
	if(need_mob_update)
		target.updatehealth()
	return

/obj/item/gun/medbeam/proc/on_beam_release(mob/living/target)
	return

/obj/effect/ebeam/medical
	name = "medical beam"

//////////////////////////////Mech Version///////////////////////////////
/obj/item/gun/medbeam/mech
	mounted = TRUE

/obj/item/gun/medbeam/mech/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSobj, src) //Mech mediguns do not process until installed, and are controlled by the holder obj
