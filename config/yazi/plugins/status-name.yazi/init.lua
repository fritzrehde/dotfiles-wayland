function Status:name()
	local h = cx.active.current.hovered
	if h == nil then
		return ui.Span("")
	end

	-- Show symlink if exists
	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end

	return ui.Span(" " .. h.name .. linked)
end
