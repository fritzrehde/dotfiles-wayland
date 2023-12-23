-- Available settings:
-- `osc-visibilty=always` (the OSC is always shown)
-- `osc-visbility=never` (the OSC is never shown, i.e. always hidden)

local osc_visibility_transition = {
	-- prev `osc-visibility` = { new `osc-visibility` }
	["never"] = "always",
	["always"] = "never"
}

mp.add_key_binding(nil, "toggle-osc-visibility", function()
	old_osc_visibility = mp.get_opt("osc-visibility")
	new_osc_visibility = osc_visibility_transition[old_osc_visibility]

	-- Set new `osc-visibility` value
	mp.command("no-osd change-list script-opts append osc-visibility=" .. new_osc_visibility)
end)
