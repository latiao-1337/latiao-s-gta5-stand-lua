util.require_natives("3095a")

menu.action(menu.my_root(), "删除银行所有钱", {""}, "", function()

    util.spoof_script("shop_controller", function()

        local alloc_max = memory.alloc_int()
        local valid_max = NETSHOPPING.NET_GAMESERVER_BEGIN_SERVICE(alloc_max,
            util.joaat("CATEGORY_SERVICE_WITH_THRESHOLD"), util.joaat("SERVICE_EARN_BOSS"),
            util.joaat("NET_SHOP_ACTION_SPEND"), players.get_bank(players.user()), 4)
        if valid_max then
            NETSHOPPING.NET_GAMESERVER_CHECKOUT_START(memory.read_int(alloc_max))
        end
    end)

end)
menu.action(menu.my_root(), "删除钱包所有钱", {""}, "", function()

    util.spoof_script("shop_controller", function()

        local alloc_max = memory.alloc_int()
        local valid_max = NETSHOPPING.NET_GAMESERVER_BEGIN_SERVICE(alloc_max,
            util.joaat("CATEGORY_SERVICE_WITH_THRESHOLD"), util.joaat("SERVICE_EARN_BOSS"),
            util.joaat("NET_SHOP_ACTION_SPEND"), players.get_wallet(players.user()), 1)
        if valid_max then
            NETSHOPPING.NET_GAMESERVER_CHECKOUT_START(memory.read_int(alloc_max))
        end
    end)

end)