// 	Smoke particle effect for heavy-duty cyborgs
/datum/component/robot_smoke

/datum/component/robot_smoke/RegisterWithParent()
	add_verb(parent, /mob/living/silicon/robot/proc/toggle_smoke)
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(dir_change))

/datum/component/robot_smoke/UnregisterFromParent()
	remove_verb(parent, /mob/living/silicon/robot/proc/toggle_smoke)
	UnregisterSignal(parent, COMSIG_ATOM_DIR_CHANGE)

/datum/component/robot_smoke/Destroy()
	return ..()

/datum/component/robot_smoke/proc/dir_change(datum/source, olddir, newdir)
	SIGNAL_HANDLER

	var/atom/movable/movable_parent = parent

	if(!movable_parent.particles)
		return

	var/truedir = movable_parent.dir
	if(newdir && (truedir != newdir))
		truedir = newdir

	switch(truedir)
		if(NORTH)
			movable_parent.particles.position = list(-6, 12, 0)
			movable_parent.particles.drift = generator("vector", list(0, 0.4), list(0.2, -0.2))
		if(EAST)
			movable_parent.particles.position = list(-6, 12, 0)
			movable_parent.particles.drift = generator("vector", list(0, 0.4), list(-0.8, 0.2))
		if(SOUTH)
			movable_parent.particles.position = list(5, 12, 0)
			movable_parent.particles.drift = generator("vector", list(0, 0.4), list(0.2, -0.2))
		if(WEST)
			movable_parent.particles.position = list(6, 12, 0)
			movable_parent.particles.drift = generator("vector", list(0, 0.4), list(0.8, -0.2))

/datum/station_alert/New(holder, list/alarm_types, list/listener_z_level, list/listener_areas, title, camera_view)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(change_listener_level))

/datum/station_alert/Destroy()
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)

/// Signal handler for [COMSIG_GLOB_CREWMEMBER_JOINED]. Changes [/datum/alarm_listener]'s [var/list/allowed_z_levels] to our borg's Z level (which is station's Z level, as this signal only called for station crewmember)
/datum/station_alert/proc/change_listener_level(datum/source, mob/living/new_crewmember, rank)
	SIGNAL_HANDLER

	if(new_crewmember != holder)
		return
	listener.allowed_z_levels = SSmapping.levels_by_trait(ZTRAIT_STATION)

/mob/living/silicon/robot/proc/toggle_smoke()
	set name = "Toggle smoke"
	set category = "AI Commands"

	if(particles)
		dissipate()
	else if (!stat && !robot_resting)
		do_jitter_animation(10)
		playsound(src, 'modular_nova/master_files/sound/effects/robot_smoke.ogg', 50)
		particles = new /particles/smoke/robot()

/mob/living/silicon/robot/proc/dissipate()
	particles.spawning = 0
	addtimer(CALLBACK(src, PROC_REF(particles_qdel)), 1.5 SECONDS)

/mob/living/silicon/robot/proc/particles_qdel()
	QDEL_NULL(particles)

/mob/living/silicon/robot/death()
	. = ..()
	if(GetComponent(/datum/component/robot_smoke))
		dissipate()

/mob/living/silicon/robot/robot_lay_down()
	. = ..()

	if(GetComponent(/datum/component/robot_smoke))
		if(robot_resting)
			dissipate()
		else
			return

// The smoke
/particles/smoke/robot
	spawning = 0.4
	lifespan = 1 SECONDS
	fade = 0.75 SECONDS
	position = list(5, 12, 0)
	velocity = list(0, 0.2, 0)
	friction = 0.35
	scale = 0.5
	grow = 0.1
	spin = generator("num", -20, 20)

// Another smoke effect
/obj/effect/temp_visual/mook_dust/robot
	icon = 'modular_nova/modules/borgs/icons/misc/tallrobot_effects.dmi'
	icon_state = "impact_cloud"
	color = "#a9a9a93c"

/obj/effect/temp_visual/mook_dust/robot/table
	color = "#ffffffc2"
	pixel_y = -8
	layer = ABOVE_MOB_LAYER

// Update the borg's model appearance when they change models
/obj/item/robot_model/do_transform_animation()
	. = ..()
	var/mob/living/silicon/robot/cyborg = loc
	var/mutable_appearance/character_appearance = new(cyborg.appearance)
	GLOB.name_to_appearance[cyborg.real_name] = character_appearance // Cache this for Character Directory
