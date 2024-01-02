util.require_natives("3095a")
menu.divider(menu.my_root(), "latiao's 刷钱大厅脚本")
menu.toggle_loop(menu.my_root(), "循环刷经验给所有人", {""}, "", function()
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give RP"))
end)
if NETWORK.NETWORK_IS_HOST() then
        local function newplayer(newplayerpid)
            local playername = players.get_name(newplayerpid)
            if NETWORK.NETWORK_IS_PLAYER_ACTIVE(newplayerpid) then
                util.log(playername)
                menu.trigger_commands("givecollectibles " .. playername)
            else
                while not NETWORK.NETWORK_IS_PLAYER_ACTIVE(newplayerpid) do
                    util.yield()
                end
                util.log(playername)
                menu.trigger_commands("givecollectibles " .. playername)
            end
        end

        for _, newplayerpid in ipairs(players.list()) do
            newplayer(newplayerpid)
        end

        players.on_join(newplayer)
end