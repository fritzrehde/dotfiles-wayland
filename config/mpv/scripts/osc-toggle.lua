local osc_off = true

function osc_toggle ()
	osc_off = not osc_off
	mp.command("script-message osc-visibility " .. (osc_off and "never" or "always") .. " no-osd")
end

mp.add_key_binding(nil, "osc-toggle", osc_toggle)
