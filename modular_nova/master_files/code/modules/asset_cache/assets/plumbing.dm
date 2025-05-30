/// add modular plumbing sprites to spritesheet so that they will show up in the plumbing RCD menu etc
/datum/asset/spritesheet_batched/plumbing/create_spritesheets()
	. = ..()
	//load only what we need from the icon files,format is icon_file_name = list of icon_states we need from this file
	var/list/essentials = list(
		'modular_nova/modules/liquids/icons/obj/structures/drains.dmi' = list(
			"drain",
			"active_input",
			"active_output",
		),
	)

	for(var/icon_file as anything in essentials)
		for(var/icon_state as anything in essentials[icon_file])
			insert_icon(icon_state, uni_icon(icon_file, icon_state))

