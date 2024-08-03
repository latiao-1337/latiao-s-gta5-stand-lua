local latiaofakelagvalueset = menu.slider(menu.my_root(), "Fakelag Value", {"latiaofakelagvalue"}, "", 250, 1000, 250, 1, function()
end)
menu.toggle_loop(menu.my_root(), "fake lag", {"latiaofakelag"}, ("latiaofakelag"), function()
    menu.trigger_commands("spoofpos".." on")
    local pos = players.get_position(players.user())
    local x = pos.x
    local y = pos.y
    local z = pos.z
    util.yield(menu.get_value(latiaofakelagvalueset))
    menu.trigger_commands("spoofedposition " .. x .. "," .. y .. "," .. z)
    

end,function()
    menu.trigger_commands("spoofpos".." off")
end)