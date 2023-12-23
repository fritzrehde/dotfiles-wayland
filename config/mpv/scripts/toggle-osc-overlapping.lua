-- Available settings:
-- `osc-boxvideo=no` (the OSC overlaps the video)
-- `osc-boxvideo=yes` (the video is boxed, making it separate from the OSC)

local osc_boxvideo_transition = {
	-- prev `osc-boxvideo` = { new `osc-boxvideo`, info text }
	["no"] = { "yes", "OSC separate" },
	["yes"] = { "no", "OSC overlapping" }
}

mp.add_key_binding(nil, "toggle-osc-overlapping", function()
	old_osc_boxvideo = mp.get_opt("osc-boxvideo")
	new_osc_boxvideo, text = unpack(osc_boxvideo_transition[old_osc_boxvideo])

	-- Set new `osc-boxvideo` value
	mp.command("no-osd change-list script-opts append osc-boxvideo=" .. new_osc_boxvideo)

	-- Display `text` on OSD
	mp.command("show-text \"" .. text .. "\" 700")
end)
