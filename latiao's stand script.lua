-- copy for 
-- chat gpt
-- JinxScript
-- Heist Control
function latiao_server_TRANSACTION(hash)

    print(hash)
    util.spoof_script("shop_controller", function()
        local cash = NETSHOPPING.NET_GAMESERVER_GET_PRICE(hash, util.joaat("CATEGORY_SERVICE_WITH_THRESHOLD"), true)
        -- if NETSHOPPING.NET_GAMESERVER_BASKET_IS_ACTIVE() then
        --     NETSHOPPING.NET_GAMESERVER_BASKET_END()
        -- end

        local alloc_max = memory.alloc_int()
        local valid_max = NETSHOPPING.NET_GAMESERVER_BEGIN_SERVICE(alloc_max,
            util.joaat("CATEGORY_SERVICE_WITH_THRESHOLD"), hash, util.joaat("NET_SHOP_ACTION_EARN"), cash, 2)
        if valid_max then
            NETSHOPPING.NET_GAMESERVER_CHECKOUT_START(memory.read_int(alloc_max))
        end
    end)

end

function latiao_log(message)

    print(message, TOAST_ALL)
end
latiao_log("start")
function latiao_filter_log(message)
    if message ~= last_message then
        print(message, TOAST_ALL)
        last_message = message
    end

end

function getTeamID(pid)
    -- if not isNetPlayerOk(pid) then return end
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pPed = entities.handle_to_pointer(ped)
    local net_obj = memory.read_long(pPed + 0xD0)
    if net_obj == 0 then
        return
    end
    print(net_obj)
    local teamID = memory.read_byte(net_obj + 0x469)

    return teamID

end

function getInstanceID(pid)

    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pPed = entities.handle_to_pointer(ped)
    local net_obj = memory.read_long(pPed + 0xD0)
    if net_obj == 0 then
        return
    end
    local instanceID = memory.read_byte(net_obj + 0x46A)

    return instanceID

end

function int2ip(num)

    local ip = "" -- 初始化结果为空字符串
    for i = 3, 0, -1 do -- 遍历4个字节
        local b = num % 256 -- 取出最低字节
        num = math.floor(num / 256) -- 右移一个字节
        ip = b .. "." .. ip -- 将字节拼接到结果中
    end
    return ip:sub(1, -2) -- 去掉最后的点号并返回结果
end
-- copy chat gpt

local language_code = {
    [0] = "american (en-US)",
    [1] = "french (fr-FR)",
    [2] = "german (de-DE)",
    [3] = "italian (it-IT)",
    [4] = "spanish (es-ES)",
    [5] = "brazilian (pt-BR)",
    [6] = "polish (pl-PL)",
    [7] = "russian (ru-RU)",
    [8] = "korean (ko-KR)",
    [9] = "chinesetrad (zh-TW)",
    [10] = "japanese (ja-JP)",
    [11] = "mexican (es-MX)",
    [12] = "chinesesimp (zh-CN)"
}

local function ALL_Entities()
    local targets = {}

    for _, ped in ipairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            table.insert(targets, ped)
        end
    end

    for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
        table.insert(targets, vehicle)
    end

    for _, object in ipairs(entities.get_all_objects_as_handles()) do
        table.insert(targets, object)
    end

    for _, pickups in ipairs(entities.get_all_pickups_as_handles()) do
        table.insert(targets, pickups)
    end

    return targets
end
local INT_MAX = 2147483647
local INT_MIN = -2147483647

local ALL_script = {"abigail1", "abigail2", "achievement_controller", "activity_creator_prototype_launcher",
                    "act_cinema", "af_intro_t_sandy", "agency_heist1", "agency_heist2", "agency_heist3a",
                    "agency_heist3b", "agency_prep1", "agency_prep2amb", "aicover_test", "ainewengland_test",
                    "altruist_cult", "ambientblimp", "ambient_diving", "ambient_mrsphilips", "ambient_solomon",
                    "ambient_sonar", "ambient_tonya", "ambient_tonyacall", "ambient_tonyacall2", "ambient_tonyacall5",
                    "ambient_ufos", "am_agency_suv", "am_airstrike", "am_ammo_drop", "am_arena_shp", "am_armwrestling",
                    "am_armwrestling_value", "am_armybase", "am_backup_heli", "am_beach_washup_cinematic",
                    "am_boat_taxi", "am_bru_box", "am_car_mod_tut", "am_casino_limo", "am_casino_luxury_car",
                    "am_casino_peds", "am_challenges", "am_contact_requests", "am_cp_collection", "am_crate_drop",
                    "am_criminal_damage", "am_darts", "am_darts_value", "am_dead_drop", "am_destroy_veh",
                    "am_distract_cops", "am_doors", "am_ferriswheel", "am_gang_call", "am_ga_pickups", "am_heist_int",
                    "am_heli_taxi", "am_hi_plane_land_cinematic", "am_hi_plane_take_off_cinematic", "am_hold_up",
                    "am_hot_property", "am_hot_target", "am_hs4_isd_take_vel", "am_hs4_lsa_land_nimb_arrive",
                    "am_hs4_lsa_land_vel", "am_hs4_lsa_take_vel", "am_hs4_nimb_isd_lsa_leave",
                    "am_hs4_nimb_lsa_isd_arrive", "am_hs4_nimb_lsa_isd_leave", "am_hs4_vel_lsa_isd",
                    "am_hunt_the_beast", "am_imp_exp", "am_island_backup_heli", "am_joyrider", "am_kill_list",
                    "am_king_of_the_castle", "am_launcher", "am_lester_cut", "am_lowrider_int",
                    "am_lsia_take_off_cinematic", "am_luxury_showroom", "am_mission_launch", "am_mp_acid_lab",
                    "am_mp_arcade", "am_mp_arcade_claw_crane", "am_mp_arcade_fortune_teller", "am_mp_arcade_love_meter",
                    "am_mp_arcade_peds", "am_mp_arcade_strength_test", "am_mp_arc_cab_manager", "am_mp_arena_box",
                    "am_mp_arena_garage", "am_mp_armory_aircraft", "am_mp_armory_truck", "am_mp_auto_shop",
                    "am_mp_bail_office", "am_mp_biker_warehouse", "am_mp_boardroom_seating", "am_mp_bunker",
                    "am_mp_business_hub", "am_mp_carwash_launch", "am_mp_car_meet_property", "am_mp_car_meet_sandbox",
                    "am_mp_casino", "am_mp_casino_value", "am_mp_casino_nightclub", "am_mp_casino_valet_garage",
                    "am_mp_creator_aircraft", "am_mp_creator_trailer", "am_mp_defunct_base", "am_mp_drone",
                    "am_mp_fixer_hq", "am_mp_garage_control", "am_mp_hacker_truck", "am_mp_hangar",
                    "am_mp_ie_warehouse", "am_mp_island", "am_mp_juggalo_hideout", "am_mp_multistorey_garage",
                    "am_mp_music_studio", "am_mp_nightclub", "am_mp_orbital_cannon", "am_mp_peds", "am_mp_property_ext",
                    "am_mp_property_int", "am_mp_rc_vehicle", "am_mp_salvage_yard", "am_mp_shooting_range",
                    "am_mp_simeon_showroom", "am_mp_smoking_activity", "am_mp_smpl_interior_ext",
                    "am_mp_smpl_interior_int", "am_mp_social_club_garage", "am_mp_solomon_office", "am_mp_submarine",
                    "am_mp_vehicle_organization_menu", "am_mp_vehicle_reward", "am_mp_vehicle_weapon",
                    "am_mp_vinewood_premium_garage", "am_mp_vinewood_premium_modshop", "am_mp_warehouse", "am_mp_yacht",
                    "am_npc_invites", "am_pass_the_parcel", "am_penned_in", "am_penthouse_peds", "am_pi_menu",
                    "am_plane_takedown", "am_prison", "am_prostitute", "am_rollercoaster", "am_rontrevor_cut",
                    "am_taxi", "am_vehicle_spawn", "animal_controller", "value_minigame_launcher", "apparcadebusiness",
                    "apparcadebusinesshub", "appavengeroperations", "appbailoffice", "appbikerbusiness", "appbroadcast",
                    "appbunkerbusiness", "appbusinesshub", "appcamera", "appchecklist", "appcontacts", "appcovertops",
                    "appemail", "appextraction", "appfixersecurity", "apphackertruck", "apphs_sleep", "appimportexport",
                    "appinternet", "appjipmp", "appmedia", "appmpbossagency", "appmpemail", "appmpjoblistnew",
                    "apporganiser", "appprogresshub", "apprepeatplay", "appsecurohack", "appsecuroserv", "appsettings",
                    "appsidetask", "appsmuggler", "apptextmessage", "apptrackify", "appvinewoodmenu", "appvlsi",
                    "appzit", "arcade_seating", "arena_box_bench_seats", "arena_carmod", "arena_workshop_seats",
                    "armenian1", "armenian2", "armenian3", "armory_aircraft_carmod", "assassin_bus",
                    "assassin_construction", "assassin_hooker", "assassin_multi", "assassin_rankup", "assassin_valet",
                    "atm_trigger", "audiotest", "autosave_controller", "auto_shop_seating", "bailbond1", "bailbond2",
                    "bailbond3", "bailbond4", "bailbond_launcher", "bail_office_seating", "barry1", "barry2", "barry3",
                    "barry3a", "barry3c", "barry4", "base_carmod", "base_corridor_seats", "base_entrance_seats",
                    "base_heist_seats", "base_lounge_seats", "base_quaters_seats", "base_reception_seats",
                    "basic_creator", "beach_exterior_seating", "benchmark", "bigwheel", "bj", "blackjack", "blimptest",
                    "blip_controller", "bootycallhandler", "bootycall_debug_controller", "buddydeathresponse",
                    "bugstar_mission_export", "buildingsiteambience", "building_controller", "business_battles",
                    "business_battles_defend", "business_battles_sell", "business_hub_carmod",
                    "business_hub_garage_seats", "cablecar", "camera_test", "camhedz_arcade", "cam_coord_sender",
                    "candidate_controller", "carmod_shop", "carsteal1", "carsteal2", "carsteal3", "carsteal4",
                    "carwash1", "carwash2", "car_meet_carmod", "car_meet_exterior_seating", "car_meet_interior_seating",
                    "car_roof_test", "casinoroulette", "casino_bar_seating", "casino_exterior_seating",
                    "casino_interior_seating", "casino_lucky_wheel", "casino_main_lounge_seating",
                    "casino_nightclub_seating", "casino_penthouse_seating", "casino_slots", "celebrations",
                    "celebration_editor", "cellphone_controller", "cellphone_flashhand", "charactergoals",
                    "charanimtest", "cheat_controller", "chinese1", "chinese2", "chop", "clothes_shop_mp",
                    "clothes_shop_sp", "code_controller", "combat_test", "comms_controller",
                    "completionpercentage_controller", "component_checker", "context_controller",
                    "controller_ambientarea", "controller_races", "controller_taxi", "controller_towing",
                    "controller_trafficking", "coordinate_recorder", "country_race", "country_race_controller",
                    "creation_startup", "creator", "custom_config", "cutscenemetrics", "cutscenesamples",
                    "cutscene_test", "darts", "debug", "debug_app_select_screen", "debug_clone_outfit_testing",
                    "debug_launcher", "debug_ped_data", "degenatron_games", "density_test", "dialogue_handler",
                    "director_mode", "docks2asubhandler", "docks_heista", "docks_heistb", "docks_prep1", "docks_prep2b",
                    "docks_setup", "dont_cross_the_line", "dreyfuss1", "drf1", "drf2", "drf3", "drf4", "drf5", "drunk",
                    "drunk_controller", "dynamixtest", "email_controller", "emergencycall", "emergencycalllauncher",
                    "epscars", "epsdesert", "epsilon1", "epsilon2", "epsilon3", "epsilon4", "epsilon5", "epsilon6",
                    "epsilon7", "epsilon8", "epsilontract", "epsrobes", "error_listener", "error_thrower",
                    "event_controller", "exile1", "exile2", "exile3", "exile_city_denial", "extreme1", "extreme2",
                    "extreme3", "extreme4", "fairgroundhub", "fake_interiors", "fameorshame_eps", "fameorshame_eps_1",
                    "fame_or_shame_set", "family1", "family1taxi", "family2", "family3", "family4", "family5",
                    "family6", "family_scene_f0", "family_scene_f1", "family_scene_m", "family_scene_t0",
                    "family_scene_t1", "fanatic1", "fanatic2", "fanatic3", "fbi1", "fbi2", "fbi3", "fbi4", "fbi4_intro",
                    "fbi4_prep1", "fbi4_prep2", "fbi4_prep3", "fbi4_prep3amb", "fbi4_prep4", "fbi4_prep5", "fbi5a",
                    "finalea", "finaleb", "finalec1", "finalec2", "finale_choice", "finale_credits", "finale_endgame",
                    "finale_heist1", "finale_heist2a", "finale_heist2b", "finale_heist2_intro", "finale_heist_prepa",
                    "finale_heist_prepb", "finale_heist_prepc", "finale_heist_prepd", "finale_heist_prepeamb",
                    "finale_intro", "fixer_hq_carmod", "fixer_hq_seating", "fixer_hq_seating_op_floor",
                    "fixer_hq_seating_pq", "floating_help_controller", "flowintrotitle", "flowstartaccept",
                    "flow_autoplay", "flow_controller", "flow_help", "flyunderbridges", "fmmc_contentquicklauncher",
                    "fmmc_launcher", "fmmc_playlist_controller", "fm_bj_race_controler", "fm_capture_creator",
                    "fm_content_acid_lab_sell", "fm_content_acid_lab_setup", "fm_content_acid_lab_source",
                    "fm_content_ammunation", "fm_content_armoured_truck", "fm_content_auto_shop_delivery",
                    "fm_content_bank_shootout", "fm_content_bar_resupply", "fm_content_bicycle_time_trial",
                    "fm_content_bike_shop_delivery", "fm_content_bounty_targets", "fm_content_business_battles",
                    "fm_content_cargo", "fm_content_cerberus", "fm_content_chop_shop_delivery",
                    "fm_content_clubhouse_contracts", "fm_content_club_management", "fm_content_club_odd_jobs",
                    "fm_content_club_source", "fm_content_convoy", "fm_content_crime_scene", "fm_content_daily_bounty",
                    "fm_content_dispatch_work", "fm_content_drug_lab_work", "fm_content_drug_vehicle",
                    "fm_content_export_cargo", "fm_content_ghosthunt", "fm_content_golden_gun", "fm_content_gunrunning",
                    "fm_content_hsw_setup", "fm_content_hsw_time_trial", "fm_content_island_dj",
                    "fm_content_island_heist", "fm_content_metal_detector", "fm_content_movie_props",
                    "fm_content_mp_intro", "fm_content_parachuter", "fm_content_payphone_hit", "fm_content_phantom_car",
                    "fm_content_pizza_delivery", "fm_content_possessed_animals", "fm_content_robbery",
                    "fm_content_security_contract", "fm_content_sightseeing", "fm_content_skydive",
                    "fm_content_slasher", "fm_content_smuggler_ops", "fm_content_smuggler_plane",
                    "fm_content_smuggler_resupply", "fm_content_smuggler_sell", "fm_content_smuggler_trail",
                    "fm_content_source_research", "fm_content_stash_house", "fm_content_taxi_driver", "fm_content_test",
                    "fm_content_tow_truck_work", "fm_content_tuner_robbery", "fm_content_ufo_abduction",
                    "fm_content_vehicle_list", "fm_content_vehrob_arena", "fm_content_vehrob_cargo_ship",
                    "fm_content_vehrob_casino_prize", "fm_content_vehrob_disrupt", "fm_content_vehrob_police",
                    "fm_content_vehrob_prep", "fm_content_vehrob_scoping", "fm_content_vehrob_submarine",
                    "fm_content_vehrob_task", "fm_content_vip_contract_1", "fm_content_xmas_mugger",
                    "fm_content_xmas_truck", "fm_deathmatch_controler", "fm_deathmatch_creator", "fm_hideout_controler",
                    "fm_hold_up_tut", "fm_horde_controler", "fm_impromptu_dm_controler", "fm_intro", "fm_intro_cut_dev",
                    "fm_lts_creator", "fm_maintain_cloud_header_data", "fm_maintain_transition_players", "fm_main_menu",
                    "fm_mission_controller", "fm_mission_controller_2020", "fm_mission_creator", "fm_race_controler",
                    "fm_race_creator", "fm_street_dealer", "fm_survival_controller", "fm_survival_creator",
                    "forsalesigns", "fps_test", "fps_test_mag", "franklin0", "franklin1", "franklin2", "freemode",
                    "freemode_clearglobals", "freemode_creator", "freemode_init", "friendactivity",
                    "friends_controller", "friends_debug_controller", "fullmap_test", "fullmap_test_flow",
                    "game_server_test", "gb_airfreight", "gb_amphibious_assault", "gb_assault", "gb_bank_job",
                    "gb_bellybeast", "gb_biker_bad_deal", "gb_biker_burn_assets", "gb_biker_contraband_defend",
                    "gb_biker_contraband_sell", "gb_biker_contract_killing", "gb_biker_criminal_mischief",
                    "gb_biker_destroy_vans", "gb_biker_driveby_assassin", "gb_biker_free_prisoner", "gb_biker_joust",
                    "gb_biker_last_respects", "gb_biker_race_p2p", "gb_biker_rescue_contact", "gb_biker_rippin_it_up",
                    "gb_biker_safecracker", "gb_biker_search_and_destroy", "gb_biker_shuttle",
                    "gb_biker_stand_your_ground", "gb_biker_steal_bikes", "gb_biker_target_rival",
                    "gb_biker_unload_weapons", "gb_biker_wheelie_rider", "gb_carjacking", "gb_cashing_out", "gb_casino",
                    "gb_casino_heist", "gb_casino_heist_planning", "gb_collect_money", "gb_contraband_buy",
                    "gb_contraband_defend", "gb_contraband_sell", "gb_data_hack", "gb_deathmatch", "gb_delivery",
                    "gb_finderskeepers", "gb_fivestar", "gb_fortified", "gb_fragile_goods", "gb_fully_loaded",
                    "gb_gangops", "gb_gang_ops_planning", "gb_gunrunning", "gb_gunrunning_defend",
                    "gb_gunrunning_delivery", "gb_headhunter", "gb_hunt_the_boss", "gb_ie_delivery_cutscene",
                    "gb_illicit_goods_resupply", "gb_infiltration", "gb_jewel_store_grab", "gb_ploughed",
                    "gb_point_to_point", "gb_ramped_up", "gb_rob_shop", "gb_salvage", "gb_security_van", "gb_sightseer",
                    "gb_smuggler", "gb_stockpiling", "gb_target_pursuit", "gb_terminate", "gb_transporter",
                    "gb_vehicle_export", "gb_velocity", "gb_yacht_rob", "general_test", "ggsm_arcade",
                    "globals_fmmcstruct2_registration", "globals_fmmc_struct_registration", "golf", "golf_ai_foursome",
                    "golf_ai_foursome_putting", "golf_mp", "gpb_andymoon", "gpb_baygor", "gpb_billbinder",
                    "gpb_clinton", "gpb_griff", "gpb_jane", "gpb_jerome", "gpb_jesse", "gpb_mani", "gpb_mime",
                    "gpb_pameladrake", "gpb_superhero", "gpb_tonya", "gpb_zombie", "grid_arcade_cabinet",
                    "gtest_airplane", "gtest_avoidance", "gtest_boat", "gtest_divingfromcar",
                    "gtest_divingfromcarwhilefleeing", "gtest_helicopter", "gtest_nearlymissedbycar", "gunclub_shop",
                    "gunfighttest", "gunslinger_arcade", "hacker_truck_carmod", "hairdo_shop_mp", "hairdo_shop_sp",
                    "hangar_carmod", "hao1", "headertest", "heatmap_test", "heatmap_test_flow", "heist_ctrl_agency",
                    "heist_ctrl_docks", "heist_ctrl_finale", "heist_ctrl_jewel", "heist_ctrl_rural",
                    "heist_island_planning", "heli_gun", "heli_streaming", "hud_creator", "hunting1", "hunting2",
                    "hunting_ambient", "idlewarper", "ingamehud", "initial", "item_ownership_output", "jewelry_heist",
                    "jewelry_prep1a", "jewelry_prep1b", "jewelry_prep2a", "jewelry_setup1", "josh1", "josh2", "josh3",
                    "josh4", "juggalo_hideout_carmod", "juggalo_hideout_seating", "lamar1", "landing_pre_startup",
                    "laptop_trigger", "launcher_abigail", "launcher_barry", "launcher_basejumpheli",
                    "launcher_basejumppack", "launcher_carwash", "launcher_darts", "launcher_dreyfuss",
                    "launcher_epsilon", "launcher_extreme", "launcher_fanatic", "launcher_golf", "launcher_hao",
                    "launcher_hunting", "launcher_hunting_ambient", "launcher_josh", "launcher_maude",
                    "launcher_minute", "launcher_mrsphilips", "launcher_nigel", "launcher_offroadracing",
                    "launcher_omega", "launcher_paparazzo", "launcher_pilotschool", "launcher_racing",
                    "launcher_rampage", "launcher_range", "launcher_stunts", "launcher_tennis", "launcher_thelastone",
                    "launcher_tonya", "launcher_triathlon", "launcher_yoga", "lester1", "lesterhandler", "letterscraps",
                    "line_activation_test", "liverecorder", "localpopulator", "locates_tester", "luxe_veh_activity",
                    "magdemo", "magdemo2", "main", "maintransition", "main_install", "main_persistent", "martin1",
                    "maude1", "maude_postbailbond", "me_amanda1", "me_jimmy1", "me_tracey1", "mg_race_to_point",
                    "michael1", "michael2", "michael3", "michael4", "michael4leadout", "minigame_ending_stinger",
                    "minigame_stats_tracker", "minute1", "minute2", "minute3", "missioniaaturret", "mission_race",
                    "mission_repeat_controller", "mission_stat_alerter", "mission_stat_watcher", "mission_triggerer_a",
                    "mission_triggerer_b", "mission_triggerer_c", "mission_triggerer_d", "mmmm", "mpstatsinit",
                    "mptestbed", "mp_awards", "mp_bed_high", "mp_fm_registration", "mp_gameplay_menu", "mp_menuped",
                    "mp_player_damage_numbers", "mp_prop_global_block", "mp_prop_special_global_block",
                    "mp_registration", "mp_save_game_global_block", "mp_skycam_stuck_wiggler", "mp_unlocks",
                    "mp_weapons", "mrsphilips1", "mrsphilips2", "multistorey_garage_ext_seating",
                    "multistorey_garage_seating", "murdermystery", "music_studio_seating",
                    "music_studio_seating_external", "music_studio_smoking", "navmeshtest", "net_activity_creator_ui",
                    "net_value_activity", "net_value_activity_light", "net_bot_brain", "net_bot_simplebrain",
                    "net_cloud_mission_loader", "net_combat_soaktest", "net_freemode_debug_2023",
                    "net_freemode_debug_stat_2023", "net_jacking_soaktest", "net_rank_tunable_loader",
                    "net_session_soaktest", "net_test_drive", "net_tunable_check", "nigel1", "nigel1a", "nigel1b",
                    "nigel1c", "nigel1d", "nigel2", "nigel3", "nightclubpeds", "nightclub_ground_floor_seats",
                    "nightclub_office_seats", "nightclub_vip_seats", "nodemenututorial", "nodeviewer", "ob_abatdoor",
                    "ob_abattoircut", "ob_airdancer", "ob_bong", "ob_cashregister", "ob_drinking_shots",
                    "ob_foundry_cauldron", "ob_franklin_beer", "ob_franklin_tv", "ob_franklin_wine", "ob_huffing_gas",
                    "ob_jukebox", "ob_mp_bed_high", "ob_mp_bed_low", "ob_mp_bed_med", "ob_mp_shower_med",
                    "ob_mp_stripper", "ob_mr_raspberry_jam", "ob_poledancer", "ob_sofa_franklin", "ob_sofa_michael",
                    "ob_telescope", "ob_tv", "ob_vend1", "ob_vend2", "ob_wheatgrass", "offroad_races", "omega1",
                    "omega2", "paparazzo1", "paparazzo2", "paparazzo3", "paparazzo3a", "paparazzo3b", "paparazzo4",
                    "paradise", "paradise2", "pausemenu", "pausemenucareerhublaunch", "pausemenu_example",
                    "pausemenu_map", "pausemenu_multiplayer", "pausemenu_sp_repeat", "pb_busker", "pb_homeless",
                    "pb_preacher", "pb_prostitute", "personal_carmod_shop", "photographymonkey", "photographywildlife",
                    "physics_perf_test", "physics_perf_test_launcher", "pickuptest", "pickupvehicles",
                    "pickup_controller", "pilot_school", "pilot_school_mp", "pi_menu", "placeholdermission",
                    "placementtest", "planewarptest", "player_controller", "player_controller_b",
                    "player_scene_ft_franklin1", "player_scene_f_lamgraff", "player_scene_f_lamtaunt",
                    "player_scene_f_taxi", "player_scene_mf_traffic", "player_scene_m_cinema", "player_scene_m_fbi2",
                    "player_scene_m_kids", "player_scene_m_shopping", "player_scene_t_bbfight",
                    "player_scene_t_chasecar", "player_scene_t_insult", "player_scene_t_park", "player_scene_t_tie",
                    "player_timetable_scene", "playthrough_builder", "pm_defend", "pm_delivery", "pm_gang_attack",
                    "pm_plane_promotion", "pm_recover_stolen", "postkilled_bailbond2", "postrc_barry1and2",
                    "postrc_barry4", "postrc_epsilon4", "postrc_nigel3", "profiler_registration", "prologue1",
                    "prop_drop", "public_mission_creator", "puzzle", "racetest", "rampage1", "rampage2", "rampage3",
                    "rampage4", "rampage5", "rampage_controller", "randomchar_controller", "range_modern",
                    "range_modern_mp", "rcpdata", "replay_controller", "rerecord_recording", "respawn_controller",
                    "restrictedareas", "re_abandonedcar", "re_accident", "re_armybase", "re_arrests", "re_atmrobbery",
                    "re_bikethief", "re_border", "re_burials", "re_bus_tours", "re_cartheft", "re_chasethieves",
                    "re_crashrescue", "re_cultshootout", "re_dealgonewrong", "re_domestic", "re_drunkdriver", "re_duel",
                    "re_gangfight", "re_gang_intimidation", "re_getaway_driver", "re_hitch_lift",
                    "re_homeland_security", "re_lossantosintl", "re_lured", "re_monkey", "re_mountdance", "re_muggings",
                    "re_paparazzi", "re_prison", "re_prisonerlift", "re_prisonvanbreak", "re_rescuehostage",
                    "re_seaplane", "re_securityvan", "re_shoprobbery", "re_snatched", "re_stag_do", "re_yetarian",
                    "rng_output", "road_arcade", "rollercoaster", "rural_bank_heist", "rural_bank_prep1",
                    "rural_bank_setup", "salvage_yard_seating", "savegame_bed", "save_anywhere", "scaleformgraphictest",
                    "scaleformminigametest", "scaleformprofiling", "scaleformtest", "scene_builder",
                    "sclub_front_bouncer", "scripted_cam_editor", "scriptplayground", "scripttest1", "scripttest2",
                    "scripttest3", "scripttest4", "script_metrics", "scroll_arcade_cabinet", "sctv",
                    "sc_lb_global_block", "selector", "selector_example", "selling_short_1", "selling_short_2",
                    "shooting_camera", "shoprobberies", "shop_controller", "shot_bikejump", "shrinkletter",
                    "sh_intro_f_hills", "sh_intro_m_home", "simeon_showroom_seating", "smoketest", "social_controller",
                    "solomon1", "solomon2", "solomon3", "spaceshipparts", "spawn_activities", "speech_reverb_tracker",
                    "spmc_instancer", "spmc_preloader", "sp_dlc_registration", "sp_editor_mission_instance",
                    "sp_menuped", "sp_pilotschool_reg", "standard_global_init", "standard_global_reg", "startup",
                    "startup_install", "startup_locationtest", "startup_positioning", "startup_smoketest",
                    "stats_controller", "stock_controller", "streaming", "stripclub", "stripclub_drinking",
                    "stripclub_mp", "stripperhome", "stunt_plane_races", "tasklist_1", "tattoo_shop", "taxilauncher",
                    "taxiservice", "taxitutorial", "taxi_clowncar", "taxi_cutyouin", "taxi_deadline", "taxi_followcar",
                    "taxi_gotyounow", "taxi_gotyourback", "taxi_needexcitement", "taxi_procedural", "taxi_takeiteasy",
                    "taxi_taketobest", "tempalpha", "temptest", "tennis", "tennis_ambient", "tennis_family",
                    "tennis_network_mp", "test_startup", "thelastone", "three_card_poker", "timershud",
                    "title_update_registration", "title_update_registration_2", "tonya1", "tonya2", "tonya3", "tonya4",
                    "tonya5", "towing", "traffickingsettings", "traffickingteleport", "traffick_air", "traffick_ground",
                    "train_create_widget", "train_tester", "trevor1", "trevor2", "trevor3", "trevor4", "triathlonsp",
                    "tunables_registration", "tuneables_processing", "tuner_planning", "tuner_property_carmod",
                    "tuner_sandbox_activity", "turret_cam_script", "ufo", "ugc_global_registration",
                    "ugc_global_registration_2", "underwaterpickups", "utvc", "vehiclespawning", "vehicle_ai_test",
                    "vehicle_force_widget", "vehicle_gen_controller", "vehicle_plate", "vehicle_stealth_mode",
                    "vehrob_planning", "veh_play_widget", "vinewood_premium_garage_carmod", "walking_ped",
                    "wardrobe_mp", "wardrobe_sp", "weapon_audio_widget", "wizard_arcade", "wp_partyboombox",
                    "xml_menus", "yoga"}

function ADD_MP_INDEX(stat)
    if not string.contains(stat, "MP_") and not string.contains(stat, "MPPLY_") then
        return "MP" .. util.get_char_slot() .. "_" .. stat
    end
    return stat
end

function STAT_SET_INT(stat, value)
    STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(stat)), value, true)
end
function STAT_SET_BOOL(stat, value)
    STATS.STAT_SET_BOOL(util.joaat(ADD_MP_INDEX(stat)), value, true)
end
function STAT_SET_STRING(stat, value)
    STATS.STAT_SET_STRING(util.joaat(ADD_MP_INDEX(stat)), value, true)
end

function STAT_INCREMENT(stat, value)
    STATS.STAT_INCREMENT(util.joaat(ADD_MP_INDEX(stat)), value, true)
end

function STAT_GET_INT(stat)
    local IntPTR = memory.alloc_int()
    STATS.STAT_GET_INT(util.joaat(ADD_MP_INDEX(stat)), IntPTR, -1)
    return memory.read_int(IntPTR)
end
function STAT_GET_STRING(stat)
    return STATS.STAT_GET_STRING(util.joaat(ADD_MP_INDEX(stat)), -1)
end

function SET_INT_GLOBAL(global, value)
    memory.write_int(memory.script_global(global), value)
end

function SET_FLOAT_GLOBAL(global, value)
    memory.write_float(memory.script_global(global), value)
end

function GET_INT_GLOBAL(global)
    return memory.read_int(memory.script_global(global))
end

function SET_INT_LOCAL(script, script_local, value)
    if memory.script_local(script, script_local) ~= 0 then
        memory.write_int(memory.script_local(script, script_local), value)
    end
end
function SET_FLOAT_LOCAL(script, script_local, value)
    if memory.script_local(script, script_local) ~= 0 then
        memory.write_float(memory.script_local(script, script_local), value)
    end
end

function GET_INT_LOCAL(script, script_local)
    if memory.script_local(script, script_local) ~= 0 then
        local ReadLocal = memory.read_int(memory.script_local(script, script_local))
        if ReadLocal ~= nil then
            return ReadLocal
        end
    end
end

function SET_BIT(bits, place) -- Credit goes to WiriScript
    return (bits | (1 << place))
end
function SET_LOCAL_BIT(script, script_local, bit)
    if memory.script_local(script, script_local) ~= 0 then
        local Addr = memory.script_local(script, script_local)
        memory.write_int(Addr, SET_BIT(memory.read_int(Addr), bit))
    end
end

menu.action(menu.my_root(), "restart lua", {"latiaorestartlua"}, "restartlua", function()
    util.restart_script()
end)
util.keep_running()

util.require_natives("3095a")

local killaura = menu.list(menu.my_root(), "杀戮", {}, "")
local self = menu.list(menu.my_root(), "自我", {}, "")
local world = menu.list(menu.my_root(), "世界", {}, "")
local server = menu.list(menu.my_root(), "多人", {}, "")
local test = menu.list(menu.my_root(), "测试", {}, "")

local admin = menu.list(menu.my_root(), "管理", {}, "")

local about = menu.list(menu.my_root(), "关于", {}, "")

menu.toggle(killaura, "死亡npc", {}, "", function(on)
    IS_ENTITY_DEAD = on
end)

menu.toggle(killaura, "npc", {}, "", function(on)
    kill_aura_peds = on
end)

menu.toggle(killaura, "玩家", {}, "", function(on)
    kill_aura_player = on
end)

menu.toggle(killaura, "在载具", {}, "", function(on)
    kill_aura_in_vehicle = on
end)

menu.toggle(killaura, "在墙后", {}, "", function(on)
    kill_aura_through_walls = on
end)

menu.toggle(killaura, "用爆炸", {}, "", function(on)
    kill_aura_explosion = on
end)

menu.toggle(killaura, "用匿名爆炸", {}, "", function(on)
    kill_aura_nick_explosion = on
end)

menu.toggle(killaura, "用火", {}, "", function(on)
    kill_aura_fire_Loop = on
end)

menu.toggle(killaura, "用weapon_tranquilizer", {}, "", function(on)
    kill_aura_weapon_tranquilizer = on
end)

menu.toggle(killaura, "用手中武器", {}, "", function(on)
    killaura_my_WEAPON = on
end)

-- menu.toggle(killaura, "随机玩家爆炸", {}, "", function(on)
--     killaura_random_player_explosion = on
-- end)

local killauratime = menu.slider(killaura, "等待", {"killauratime"}, "", 0, INT_MAX, 0, 1, function()
end)

local killauraDamage = menu.slider(killaura, "伤害", {"killauraDamage"}, "", 0, INT_MAX, 0, 1, function()
end)
-- menu.toggle(killaura, "kick ped to vehicle", {}, "", function(on)
--     kill_aura_kick_vehicle = on

-- end)

menu.toggle_loop(killaura, "开启", {"latiaokillaura"}, ("SHOOT ALL"), function()
    local my_WEAPON = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
    -- if kill_aura_peds or kill_aura_player or kill_aura_in_vehicle then
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        local list = players.list(true, true, true)
        local index = math.random(#list)
        local randomPid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(list[index])

        if randomPid == players.user() then
            goto out
        end

        local pos = v3.new(ENTITY.GET_ENTITY_COORDS(ped))

        if not (players.user_ped() == ped or (ENTITY.IS_ENTITY_DEAD(ped) and not IS_ENTITY_DEAD) or
            (PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not kill_aura_in_vehicle) or
            (entities.is_player_ped(ped) == false and not kill_aura_peds) or
            (entities.is_player_ped(ped) == true and not kill_aura_player) or
            -- (PED.IS_PED_IN_COMBAT(ped, players.user_ped()) and not IS_PED_IN_COMBAT) or
            (ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(players.user_ped(), ped, 17) == false and not kill_aura_through_walls)) then

            if kill_aura_fire_Loop then
                FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 12, menu.get_value(killauraDamage), false, true, 0.0)
            elseif kill_aura_nick_explosion then
                FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, menu.get_value(killauraDamage), false, true, 0.0)
            elseif kill_aura_explosion then
                FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, menu.get_value(killauraDamage),
                    false, true, 0.0)
                -- elseif killaura_random_player_explosion then
                -- FIRE.ADD_OWNED_EXPLOSION(randomPid, pos.x, pos.y, pos.z, 0, menu.get_value(killauraDamage), false, true, 0.0)
            elseif killaura_my_WEAPON then
                --  latiao_log("killaura_random_player")
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.5, pos.x, pos.y, pos.z,
                    menu.get_value(killauraDamage), true, my_WEAPON, randomPid, false, true, INT_MAX)
            elseif kill_aura_weapon_tranquilizer then
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.5, pos.x, pos.y, pos.z,
                menu.get_value(killauraDamage), true, util.joaat("weapon_tranquilizer"), players.user_ped(), false, true, INT_MAX)
            

            else
                --  latiao_log("killaura_none")
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.5, pos.x, pos.y, pos.z,
                    menu.get_value(killauraDamage), true, util.joaat("WEAPON_HEAVYSNIPER"), players.user_ped(), false, true,
                    INT_MAX)
                util.yield(menu.get_value(killauratime))
            end
        end
        ::out::
    end
    -- end
    -- end
    -- end
    -- end

end)

menu.toggle_loop(self, "血量/护甲 信息", {}, "", function()
    util.draw_debug_text("血量: " .. ENTITY.GET_ENTITY_HEALTH(players.user_ped()) .. "/" ..
                             PED.GET_PED_MAX_HEALTH(players.user_ped()) .. "\n护甲: " ..
                             PED.GET_PED_ARMOUR(players.user_ped()) .. "/" ..
                             PLAYER.GET_PLAYER_MAX_ARMOUR(players.user()))
end)

menu.action(world, "删除所有物体", {"latiaodelallobjects"}, "delallobjects.", function()
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            entities.delete(ent)
        end)
        if not success then

        end

    end
end)

menu.action(world, "删除所有npc", {"latiaodelallpeds"}, "delallpeds.", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            local success, error_message = pcall(function()
                entities.delete(ent)
            end)
            if not success then

            end
        end

    end
end)

menu.action(world, "删除所有车", {"latiaodelallvehicles"}, "delallvehicles.", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        local success, error_message = pcall(function()
            entities.delete(ent)
        end)
        if not success then

        end

    end
end)

menu.action(world, "删除可拾取物品", {"latiaodelallvehicles"}, "delallvehicles.", function()
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        local success, error_message = pcall(function()
            entities.delete(ent)
        end)
        if not success then

        end

    end
end)

menu.action(world, "删除所有", {"latiaodelall"}, "delall.", function()

    for _, entity in ipairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            entities.delete(entity)
        end)

        if not success then

        end
    end
end)

menu.toggle_loop(world, "删除所有死亡npc", {"latiaoremoveDEADped"}, ("latiaoremoveDEADped"), function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if ENTITY.IS_ENTITY_DEAD(ped) then
            entities.delete(ped)

        end
    end
end)

menu.toggle_loop(world, "移除所有npc枪", {"latiaoREMOVE_ALL_PED_WEAPONS"}, "REMOVE_ALL_PED_WEAPONS.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            WEAPON.REMOVE_ALL_PED_WEAPONS(ped)
        end
    end
end)
menu.toggle_loop(world, "冻结所有npc", {"latiaoFREEZE_ENTITY_POSITION"}, "FREEZE_ENTITY_POSITION.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then

            ENTITY.FREEZE_ENTITY_POSITION(ped, true)

        end
    end
end, function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            ENTITY.FREEZE_ENTITY_POSITION(ped, false)
        end
    end
end)

menu.action(world, "触发所有npc布娃娃", {"SET_PED_TO_RAGDOLL"}, "SET_PED_TO_RAGDOLL.", function()
    for _, ped in entities.get_all_peds_as_handles() do
        PED.SET_PED_TO_RAGDOLL(ped, 0, 0, 0, false, false, false);
    end
end)

menu.toggle_loop(world, "CLEAR_PED_TASKS_IMMEDIATELY(冻结npc)", {"latiaoCLEAR_PED_TASKS_IMMEDIATELY"},
    "CLEAR_PED_TASKS_IMMEDIATELY.", function()
        for _, ped in pairs(entities.get_all_peds_as_handles()) do
            if not entities.is_player_ped(ped) then
                TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
            end
        end
    end)

menu.toggle_loop(world, "CLEAR_PED_TASKS(冻结npc)", {"LATIAOCLEAR_PED_TASKS"}, "LATIAOCLEAR_PED_TASKS.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            TASK.CLEAR_PED_TASKS(ped)
        end
    end
end)

menu.toggle_loop(world, "最大刷新npc和载具", {"latiaomaxpedVEHICLE"}, "latiaomaxpedVEHICLE.", function()
    PED.INSTANTLY_FILL_PED_POPULATION()
    VEHICLE.INSTANTLY_FILL_VEHICLE_POPULATION()
end)
menu.toggle_loop(world, "所有npc为你的团队", {"latiaomaxpedforyouteam"}, "latiaomaxpedforyouteam.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, PED.GET_PED_RELATIONSHIP_GROUP_HASH(players.user_ped()))
    end
end)
menu.toggle_loop(world, "重置npc团队", {"latiaomaxpedforyouteam"}, "latiaomaxpedforyouteam.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, 0xD9D08749)
        end
    end
end)
menu.toggle_loop(world, "不刷警察", {""}, "", function()
    PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(players.user(), false)
end, function()
    PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(players.user(), true)
end)

menu.toggle_loop(world, "删除警察", {"latiaodelcops"}, "latiaodelcops", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        for _, copsModels in ipairs({util.joaat("s_m_y_cop_01"), util.joaat("s_m_y_sheriff_01"),
                                     util.joaat("s_m_y_swat_01"), util.joaat("s_m_y_hwaycop_01")}) do
            if ENTITY.GET_ENTITY_MODEL(ent) == copsModels then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
                if entities.get_owner(ent) == players.user() then
                    entities.delete(ent)
                end

            end
        end
    end
end)

menu.toggle_loop(server, "自动主机", {"latiaoautohost"}, ("autohost"), function()
    if not (players.get_host() == players.user()) then
        menu.trigger_commands("kick" .. players.get_name(players.get_host()))
    end
end)
menu.toggle_loop(server, "自动自由模式脚本主机", {"latiaoautoScripthost"}, ("autoScripthost"), function()
    if not (players.get_script_host() == players.user()) then
        util.request_script_host("freemode")
    end
end)

menu.action(server, "无效收藏品脚本事件踢所有人", {"latiaokickallexcludehost"}, "latiaokickallexcludehost",
    function()

        util.trigger_script_event(util.get_session_players_bitflag(), {968269233, players.user(), 4, 233, 1, 1, 1})

    end)
menu.action(server, "情书踢所有人", {"latiaoloveletterkickall"}, "loveletter kick all.", function()
    for k, pid in pairs(players.list(false, true, true)) do
        local player = players.get_name(pid)

        menu.trigger_commands("loveletterkick" .. player)

    end

end)
menu.action(server, "主机踢所有人", {"latiaohostkickall"}, "latiaohostkickall", function()
    for k, pid in pairs(players.list(false, true, true)) do

        local player = players.get_name(pid)

        menu.trigger_commands("hostkick" .. player)

    end

end)

menu.action(server, "主机踢所有人排除外挂", {"latiaohostkickall"}, "latiaohostkickall", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if pid == players.get_host() or players.is_marked_as_modder(pid) then
            goto out
        end

        local player = players.get_name(pid)

        menu.trigger_commands("hostkick" .. player)
        ::out::
    end

end)

menu.action(server, "非主机踢所有人", {"latiaonohostkickall"}, "latiaonohostkickall.", function()
    for k, pid in pairs(players.list(false, true, true)) do
        local player = players.get_name(pid)

        menu.trigger_commands("nohostkick " .. player)

    end

end)

menu.action(server, "NETWORK_SESSION_KICK_PLAYER踢所有人", {"latiaohostkickall"}, "latiaohostkickall.", function()
    for k, pid in pairs(players.list(false, true, true)) do
        NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)

    end

end)
menu.action(server, "无效收藏品脚本事件 排除主机和作弊玩家", {"latiaokickallexcludehost"},
    "latiaokickallexcludehost", function()
        for k, pid in pairs(players.list(false, true, true)) do
            if pid == players.get_host() or players.is_marked_as_modder(pid) then
                goto out
            end
            util.trigger_script_event(1 << pid, {968269233, pid, 4, 233, 1, 1, 1})
            ::out::
        end

    end)

menu.action(server, "givecollectibles所有人排除主机和作弊玩家", {"latiaokickallexcludehost"},
    "latiaokickallexcludehost", function()
        for k, pid in pairs(players.list(false, true, true)) do
            local attack = players.get_name(pid)
            if pid == players.get_host() or players.is_marked_as_modder(pid) then
                goto out
            end
            menu.trigger_commands("givecollectibles" .. attack)
            ::out::
        end

    end)

menu.toggle_loop(server, "情书踢作弊玩家", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if pid == players.get_host() then
            goto out
        end
        if players.is_marked_as_modder(pid) then
            local attack = players.get_name(pid)
            menu.trigger_commands("loveletterkick" .. attack)
        end

        ::out::
    end

end)

menu.toggle_loop(server, "情书踢影身玩家", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if pid == players.get_host() then
            goto out
        end
        if not players.is_visible(pid) then
            local attack = players.get_name(pid)
            menu.trigger_commands("loveletterkick" .. attack)
        end

        ::out::
    end

end)

menu.toggle_loop(server, "踢游戏语言为中文的玩家", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        local language = players.get_language(pid)
        if language == 12 then
            local attack = players.get_name(pid)
            menu.trigger_commands("loveletterkick" .. attack)
            --  latiao_log(attack)
        end
        ::out::
    end

end)

menu.toggle_loop(server, "不是主机反弹踢你的玩家", {"raidallplayer"}, "", function()
    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path("Online>Protections>Events>Kick Event>Love Letter Kick>Disabled"))
    else
        menu.trigger_command(menu.ref_by_path("Online>Protections>Events>Kick Event>Love Letter Kick>Strangers"))
    end
end)

menu.action(server, "开超时所有人", {"latiaotimeouton"}, "latiaotimeouton.", function()
    for k, pid in pairs(players.list(false, true, true)) do
        local player = players.get_name(pid)
        menu.trigger_commands("timeout" .. player .. " on")
    end

end)

menu.action(server, "关超时所有人", {"latiaotimeoutoff"}, "latiaotimeoutoff.", function()
    for k, pid in pairs(players.list(false, true, true)) do
        local player = players.get_name(pid)
        menu.trigger_commands("timeout" .. player .. " off")
    end

end)
menu.action(server, "踢自己", {"latiaokickme"}, "latiaokickme.", function()
    NETWORK.NETWORK_SESSION_KICK_PLAYER(players.user())
end)

menu.toggle_loop(server, "循环举报所有人", {"latiaoreportall"}, "reportall.", function()

    -- menu.trigger_command(menu.ref_by_path(
    -- "Players>All Players>Increment Commend/Report Stats>Griefing or Disruptive Gameplay"))
    menu.trigger_command(menu.ref_by_path("Players>All Players>Increment Commend/Report Stats>Cheating or Modding"))
    -- menu.trigger_command(menu.ref_by_path(
    -- "Players>All Players>Increment Commend/Report Stats>Glitching or Abusing Game Features"))
    util.yield(5000)
end)

menu.toggle_loop(server, "循环举报外挂", {"latiaoreportall"}, "reportall.", function()
    util.yield(5000)
    for k, pid in pairs(players.list(false, true, true)) do
        if players.is_marked_as_modder(pid) then
            local attack = players.get_name(pid)
            -- menu.trigger_commands("reportgriefing" .. attack)
            menu.trigger_commands("reportexploits" .. attack)
            -- menu.trigger_commands("reportbugabuse" .. attack)
        end

        ::out::
    end
end)

menu.toggle_loop(server, "称赞所有人", {"latiaoreportall"}, "reportall.", function()
    util.yield(1000)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Increment Commend/Report Stats>Helpful"))
    -- menu.trigger_command(menu.ref_by_path("Players>All Players>Increment Commend/Report Stats>Friendly"))
end)

menu.toggle_loop(server, "所有人踢出载具", {"latiaoreportall"}, "reportall.", function()
    -- for k, pid in pairs(players.list()) do
    util.trigger_script_event(util.get_session_players_bitflag(), {-503325966})
    -- end
end)

menu.toggle_loop(server, "请求所有 行人", {"latiaoREQUES_ENTITYped"}, "latiaoREQUES_ENTITYped.", function()
    for _, target in ipairs(entities.get_all_peds_as_handles()) do
        local owner = entities.get_owner(target)
        if not entities.is_player_ped(target) and owner ~= players.user() then
            local success, error_message = pcall(function()
                local require = NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)
            end)

            if not success then
                --  latiao_log(success,error_message)
            end
        end
    end

end)

menu.toggle_loop(server, "请求所有 实体", {"latiaoREQUES_ENTITYobjects"}, "REQUES_ENTITYobjects.", function()
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local owner = entities.get_owner(ent)
        if owner ~= players.user() then
            local success, error_message = pcall(function()
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)

            end)

            if not success then

            end
        end
    end

end)

menu.toggle_loop(server, "请求所有 载具", {"latiaoREQUES_ENTITYvehicles"}, "REQUES_ENTITYvehicles.", function()
    for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
        local owner = entities.get_owner(target)
        if owner ~= players.user() then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)

        end
    end
end)

-- menu.toggle_loop(server, "请求所有 载具 排除玩家", {""}, "", function()
--     for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
--         for k, pid in pairs(players.list(false,true,true)) do
--             local v1 = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
--             if target == v1 then
--                 goto out
--             end
--             local owner = entities.get_owner(target)
--             if owner ~= players.user() then
--                 NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)

--             end
--         end
--         ::out::
--     end

-- end)

menu.toggle_loop(server, "请求所有 可拾取2", {""}, "", function()
    for k, target in pairs(entities.get_all_pickups_as_handles()) do
        local owner = entities.get_owner(target)
        if owner ~= players.user() then

            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)

        end
    end
end)

menu.action(test, "跳过对话", {"latiaoIS_SCRIPTED_CONVERSATION_ONGOING"}, "IS_SCRIPTED_CONVERSATION_ONGOING.",
    function()
        AUDIO.STOP_SCRIPTED_CONVERSATION(false)
    end)

menu.action(world, "自动驾驶LONGRANGE", {"latiaoautoDRIVELONGRANGE"}, "autoDRIVELONGRANGE", function()
    local pos = v3.new(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8)))
    TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(players.user_ped(), entities.get_user_vehicle_as_handle(), pos, 1000,
        787004, 0)
end)

menu.action(world, "自动驾驶", {"latiaoautoDRIVE"}, "autoDRIVE.", function()
    local pos = v3.new(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8)))
    TASK.TASK_VEHICLE_DRIVE_TO_COORD(players.user_ped(), entities.get_user_vehicle_as_handle(), pos, 1000, -1,
        ENTITY.GET_ENTITY_MODEL(entities.get_user_vehicle_as_handle()), 787004, -1, -1)
end)

menu.toggle_loop(world, "清除自身TASKS", {"latiaostopautoDRIVE"}, "stopautoDRIVE.", function()
    TASK.CLEAR_PED_TASKS(players.user_ped())
end)

menu.toggle_loop(server, "清屏", {"latiaocleanchat"}, "latiaocleanchat.", function()
    chat.send_message("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", false, true, true)
end)
menu.toggle_loop(server, "无效刷屏", {"latiaocleanchat"}, "latiaocleanchat.", function()
    chat.send_message("", false, true, true)
end)
menu.toggle_loop(server, "数字刷屏", {"latiaocleanchat"}, "latiaocleanchat.", function()
    chat.send_message(math.random(INT_MIN, INT_MAX), false, true, true)
end)

menu.action(test, "跳过教程CLEAR_ALL_HELP_MESSAGES", {"latiaoCLEAR_ALL_HELP_MESSAGES"}, "CLEAR_ALL_HELP_MESSAGES.",
    function()
        HUD.CLEAR_ALL_HELP_MESSAGES()
    end)
local dividends = menu.list(menu.my_root(), "任务", {}, "")
local dividends_general = menu.list(dividends, "通用", {}, "")
local dividends_dc = menu.list(dividends, "赌场", {}, "")
local dividends_plkd = menu.list(dividends, "佩里克岛", {}, "")
local dividends_mr = menu.list(dividends, "末日", {}, "")
local dividends_gy = menu.list(dividends, "公寓", {}, "")
local dividends_brdr = menu.list(dividends, "事务所", {}, "")
local dividends_gzp = menu.list(dividends, "改装铺", {}, "")
local dividends_hsz = menu.list(dividends, "回收站", {}, "")
local dividends_bjbgs = menu.list(dividends, "保金办公室", {}, "")

menu.action(dividends_dc, "跳过赌场手机匹配冷却", {""}, "", function()
    STAT_SET_INT("MPPLY_H3_COOLDOWN", -1)
end)
menu.action(dividends_dc, "跳过赌场冷却", {}, "", function()
    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)

end)

menu.action(dividends_dc, "完成赌场前置", {""}, "", function()
    STAT_SET_INT("H3OPT_ACCESSPOINTS", -1)
    STAT_SET_INT("H3OPT_POI", -1)
    STAT_SET_INT("H3OPT_BITSET1", -1)
    STAT_SET_INT("H3OPT_BITSET0", -1)
    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
    STAT_SET_INT("H3OPT_MODVEH", 3)
end)

menu.action(dividends_dc, "设置赌场抢劫npc为最高级", {""}, "    .", function()
    STAT_SET_INT("H3OPT_CREWWEAP", 4)
    STAT_SET_INT("H3OPT_CREWDRIVER", 5)
    STAT_SET_INT("H3OPT_CREWHACKER", 4)
    STAT_SET_INT("H3OPT_VEHS", 1)
    STAT_SET_INT("H3OPT_WEAPS", 1)

end)

menu.slider(dividends_dc, "赌场抢劫分红", {""}, "", INT_MIN, INT_MAX, 100, 1, function(value)
    SET_INT_GLOBAL(1964849 + 1497 + 736 + 92 + 1, value)

    SET_INT_GLOBAL(1964849 + 1497 + 736 + 92 + 2, value)

    SET_INT_GLOBAL(1964849 + 1497 + 736 + 92 + 3, value)

    SET_INT_GLOBAL(1964849 + 1497 + 736 + 92 + 4, value)
end)

menu.action(dividends_dc, "刷新赌场面板", {""}, "", function()
    local Board1 = STAT_GET_INT("H3OPT_BITSET0")
    local Board2 = STAT_GET_INT("H3OPT_BITSET1")
    STAT_SET_INT("H3OPT_BITSET0", math.random(INT_MAX))
    STAT_SET_INT("H3OPT_BITSET1", math.random(INT_MAX))
    util.yield_once()
    STAT_SET_INT("H3OPT_BITSET0", Board1)
    STAT_SET_INT("H3OPT_BITSET1", Board2)
end)

menu.action(dividends_mr, "完成末日前置", {}, "", function()
    STAT_SET_INT("GANGOPS_FLOW_MISSION_PROG", -1)
end)

menu.slider(dividends_mr, "末日分红", {"mrfh"}, "2400000", INT_MIN, INT_MAX, 100, 1, function(value)
    SET_INT_GLOBAL(1960755 + 812 + 50 + 1, value)

    SET_INT_GLOBAL(1960755 + 812 + 50 + 2, value)

    SET_INT_GLOBAL(1960755 + 812 + 50 + 3, value)

    SET_INT_GLOBAL(1960755 + 812 + 50 + 4, value)
end)

menu.action(dividends_plkd, "跳过小岛冷却", {}, "", function()
    STAT_SET_INT("H4_PROGRESS", -1)

end)

menu.action(dividends_plkd, "完成小岛前置", {}, "", function()
    STAT_SET_INT("H4CNF_BS_ENTR", -1)
    STAT_SET_INT("H4CNF_BS_GEN", -1)
    STAT_SET_INT("H4CNF_BS_ABIL", -1)
    STAT_SET_INT("H4CNF_APPROACH", -1)
    STAT_SET_INT("H4CNF_WEAPONS", 5)
    STAT_SET_INT("H4_MISSIONS", -1)

end)

menu.slider(dividends_plkd, "小岛分红", {""}, "", INT_MIN, INT_MAX, 100, 5, function(value)
    SET_INT_GLOBAL(1971648 + 831 + 56 + 1, value)
    SET_INT_GLOBAL(1971648 + 831 + 56 + 2, value)
    SET_INT_GLOBAL(1971648 + 831 + 56 + 3, value)
    SET_INT_GLOBAL(1971648 + 831 + 56 + 4, value)
end)

menu.toggle_loop(dividends_plkd, "设置小岛分红", {""}, "", function()

end)

menu.action(dividends_gy, "完成公寓抢劫", {""}, "", function()
    STAT_SET_INT("HEIST_PLANNING_STAGE", -1)
end)

menu.slider(dividends_gy, "公寓抢劫分红", {"dividends_gy_fh"}, "15000000", INT_MIN, INT_MAX, 100, 1,
    function(value)
        SET_INT_GLOBAL(1930926 + 3008 + 1, value)
        SET_INT_GLOBAL(1930926 + 3008 + 2, value)
        SET_INT_GLOBAL(1930926 + 3008 + 3, value)
        SET_INT_GLOBAL(1930926 + 3008 + 4, value)
    end)

menu.action(dividends_general, "一键完成任务_2020 ", {"finfmc2020"}, "finfm_mission_controller_2020", function()
    for i = 0, 3 do
        SET_INT_LOCAL("fm_mission_controller_2020", 50150 + 1770 + 1 + i, 264666)
    end
    SET_INT_LOCAL("fm_mission_controller_2020", 50150, 9)
end)

menu.action(dividends_general, "一键完成任务", {"finfmc"}, "finfm_mission_controller", function()
    for i = 0, 3 do
        SET_INT_LOCAL("fm_mission_controller", 19746 + 1232 + 1 + i, 264666)
    end

    SET_INT_LOCAL("fm_mission_controller", 19746, 12)
end)

menu.toggle_loop(server, "是主机踢广告机", {}, "", function()
    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path("Online>Chat>Reactions>Advertisement>Love Letter Kick>Strangers"))
    else
        menu.trigger_command(menu.ref_by_path("Online>Chat>Reactions>Advertisement>Love Letter Kick>Disabled"))
    end
end)

-- player root
local function latiaostandMenuSetup(pid)
    -- local playerPED = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playername = players.get_name(pid)
    local gameLANGUAGE = language_code[players.get_language(pid)]
    local connect_ip = int2ip(players.get_ip(pid))
    local get_connect_port = players.get_port(pid)
    -- local pos = players.get_position(pid)
    latiao_log("玩家:" .. playername .. " 槽位:" .. pid .. " 连接ip:" .. connect_ip .. " 连接端口:" ..
                   get_connect_port)

    menu.divider(menu.player_root(pid), "latiao's STAND menu")

    local latiaostandMenu = menu.list(menu.player_root(pid), "latiao's STAND menu", {}, "")

    menu.action(latiaostandMenu, "WastedSounds  声音轰炸", {""}, "latiaobadsoundforall", function()
        for i = 1, 10, 1 do
            AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "MP_Flash", PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), "WastedSounds", true,
                -1)
        end

        -- util.yield(50)
    end)

    menu.toggle_loop(latiaostandMenu, "误报踢出检查", {""}, "", function()
        util.trigger_script_event(1 << pid, {-725328141})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.toggle_loop(latiaostandMenu, "test", {""}, "", function()
        util.trigger_script_event(1 << pid, {-901348601, players.user(), 0, 35, 3, 0, 0})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.toggle_loop(latiaostandMenu, "误报崩溃", {""}, "", function()
        util.trigger_script_event(1 << pid, {323285304})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "误报TSECommand", {""}, "", function()
        util.trigger_script_event(1 << pid, {800157557})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "查询他的游戏语言", {}, "", function()
        latiao_log(language_code[players.get_language(pid)])

    end)

    menu.toggle_loop(latiaostandMenu, "关闭无敌", {}, "", function()
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "阻止加入", {}, "", function()
        local player = players.get_name(pid)
        menu.trigger_commands("historyblock" .. player .. " on")
        menu.trigger_commands("historynote" .. player .. " latiaoblockjoin")
        menu.trigger_commands("loveletterkick" .. player)
    end)

    menu.toggle_loop(latiaostandMenu, "冻结", {}, "", function()
        util.trigger_script_event(1 << pid, {-1253241415, 0, 0, 1, 0})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "普通爆炸", {}, "", function()
        local pos = v3.new(players.get_position(pid))

        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, INT_MAX, true, false, 0.0)

    end)
    menu.toggle_loop(latiaostandMenu, "超级爆炸击杀外挂玩家", {}, "", function()
        local pos = v3.new(players.get_position(pid))
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)

        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        util.trigger_script_event(1 << pid, {-503325966})
        -- menu.trigger_commands("kill" .. players.get_name(pid))
        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, math.random(0, 82), INT_MAX, false, true, 0.0)

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "超级近战击杀外挂玩家", {}, "", function()
        local pos = v3.new(players.get_position(pid))
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)

        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        util.trigger_script_event(1 << pid, {-503325966})
        menu.trigger_commands("kill" .. players.get_name(pid))
        -- FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, math.random(0, 82), INT_MAX, false, true, 0.0)

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "超级匿名击杀外挂玩家", {}, "", function()
        local pos = v3.new(players.get_position(pid))
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        util.trigger_script_event(1 << pid, {-503325966})
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, math.random(0, 82), INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "超级电击外挂玩家", {}, "", function()
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        local pos = players.get_position(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        util.trigger_script_event(1 << pid, {-503325966})
        -- TASK.CLEAR_PED_TASKS_IMMEDIATELY(playerped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 0, true,
            util.joaat("weapon_stungun"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "无效a_c_rat动作崩溃", {""}, "", function()
        local pos = players.get_cam_pos(pid)
        local ped = util.joaat('a_c_rat')
        util.request_model(ped)
        local createped = entities.create_ped(28, ped, pos, 0)
        WEAPON.GIVE_WEAPON_TO_PED(createped, util.joaat('weapon_grenade'), INT_MAX, true, true)
        util.yield(1000)
        TASK.TASK_THROW_PROJECTILE(createped, pos.x, pos.y, pos.z, 0, 0)

    end)
    menu.action(latiaostandMenu, "无效u_m_m_jesus_01驾驶动作崩溃", {""}, "", function()
        local pos = players.get_cam_pos(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local mdl = util.joaat("u_m_m_jesus_01")
        local veh_mdl = util.joaat("oppressor")
        util.request_model(veh_mdl)
        util.request_model(mdl)
        local veh = entities.create_vehicle(veh_mdl, pos, 0)
        local jesus = entities.create_ped(2, mdl, pos, 0)
        PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
        util.yield(1000)
        TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, playerped, INT_MAX, 0, INT_MAX, 0, 0)
        for i = 1, 10, 1 do
            entities.give_control(veh, pid)
            entities.give_control(jesus, pid)
            util.yield()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "TASK_COMBAT_PED", {}, "", function()
        for k, ent in pairs(entities.get_all_peds_as_handles()) do
            if not entities.is_player_ped(ent) then
                WEAPON.GIVE_WEAPON_TO_PED(ent, util.joaat("weapon_pistol"), INT_MAX, false, true)
                TASK.TASK_COMBAT_PED(ent, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 16)
            end
        end
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "鬼畜", {}, "", function()
        local glitch_hash = util.joaat("p_spinning_anus_s")
        util.request_model(glitch_hash)

        local pos = players.get_position(pid)

        local obj = entities.create_object(glitch_hash, pos)
        ENTITY.SET_ENTITY_VISIBLE(obj, false)
        util.yield()
        entities.delete(obj)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "手枪子弹射击", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 100, true,
            util.joaat("weapon_pistol"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "电击枪射击", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 0, true,
            util.joaat("weapon_stungun"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "烟雾弹射击", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, INT_MAX, true,
            util.joaat("weapon_bzgas"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "燃烧瓶 射击", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, INT_MAX, true,
            util.joaat("weapon_molotov"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "菜单击杀", {"latiaomenukill"}, "", function()
        menu.trigger_commands("kill" .. players.get_name(pid))
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "烟雾 5", {"latiaoscr_as_trans_smoke"}, "", function()

        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_as_trans")
        GRAPHICS.USE_PARTICLE_FX_ASSET("scr_as_trans")
        if ptfx == nil or not GRAPHICS.DOES_PARTICLE_FX_LOOPED_EXIST(ptfx) then
            ptfx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY("scr_as_trans_smoke", ped, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 5.0, false, false, false, 0, 0, 0, 255)
        end
    end, function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        GRAPHICS.REMOVE_PARTICLE_FX(ptfx)
        STREAMING.REMOVE_NAMED_PTFX_ASSET("scr_as_trans")

    end)

    menu.toggle_loop(latiaostandMenu, "匿名爆炸", {"latiaoNickEXPLOSION"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, math.random(0, 82), INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
        -- end)
    end)

    menu.toggle_loop(latiaostandMenu, "实名爆炸", {"latiaoMEEXPLOSION"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, math.random(0, 82), INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
        -- end
    end)

    menu.toggle_loop(latiaostandMenu, "匿名火焰", {"latiaoFlameLoop"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 12, INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "无效物体崩溃", {"latiaobadojectcrash"}, "", function()
        util.request_model(util.joaat("prop_tall_grass_ba"))
        local pos = players.get_cam_pos(pid)
        local object = entities.create_object(util.joaat("prop_tall_grass_ba"), pos)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(object, pos, false, true, true)

        util.yield()
        entities.delete(object)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "无效行人动作崩溃", {}, "", function()
        local ped = util.joaat('cs_manuel')
        util.request_model(ped)

        local pos = players.get_cam_pos(pid)
        local createped = entities.create_ped(4, ped, pos, 0)

        WEAPON.GIVE_WEAPON_TO_PED(createped, util.joaat('WEAPON_HOMINGLAUNCHER'), INT_MAX, true, true)
        util.yield()
        ENTITY.SET_ENTITY_HEALTH(createped, 0, -1, -1)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "主机踢NETWORK_SESSION_KICK_PLAYER", {"latiaoNETWORK_SESSION_KICK_PLAYER"}, "",
        function()
            NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
        end)

    menu.toggle_loop(latiaostandMenu, "船轰炸", {"latiaotunspammcrash"},
        "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
            local pos = players.get_cam_pos(pid)
            util.request_model(util.joaat("tug"))

            local obj = entities.create_vehicle(util.joaat("tug"), pos, 0)
            ENTITY.SET_ENTITY_COORDS(obj, pos)
            util.yield(0)
            entities.delete(obj)
            if not players.exists(pid) then
                util.stop_thread()
            end
        end)

    menu.toggle_loop(latiaostandMenu, "踢出载具", {"latiaokickvehicles"}, "latiaokickvehicles.", function()
        util.trigger_script_event(1 << pid, {-503325966})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "无限邀请加载", {""}, "", function()
        util.trigger_script_event(1 << pid, {-1321657966, players.user() - 1, 0, 0, 115})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "循环邀请公寓", {""}, "", function()
        util.trigger_script_event(1 << pid, {-1321657966, players.user(), pid, 0, 0, 1, 0, 0, 0, 0})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "无效收藏品踢", {""}, "", function()
        util.trigger_script_event(1 << pid, {968269233, -1, 4, INT_MAX, 1, 1, 1})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "循环发送到工作", {""}, "", function()
        -- util.yield(1000)

        util.trigger_script_event(1 << pid, {259469385})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "脚本声音轰炸 邀请 ", {""}, "", function()
        -- util.yield(1500)
        util.trigger_script_event(1 << pid, {996099702, pid})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "脚本声音轰炸 检查点", {""}, "", function()
        -- util.yield(1500)
        -- util.yield(math.random(1000, 1500))
        util.trigger_script_event(1 << pid, {-642704387, pid, 782258655, 0, 0, 0, 0, 0, 0, 0, pid, 0, 0, 0})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "检查点信息轰炸", {"test1"}, "tet2", function()
        -- util.yield(math.random(1000, 1500))
        local list = players.list()
        local index = math.random(#list)

        local randomPid = (list[index])

        util.trigger_script_event(1 << pid, {-642704387, pid, 782258655, 0, 0, 0, 0, 0, 0, 0, randomPid, 0, 0, 0})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    -- menu.action(latiaostandMenu, "give_script_host all", {"give_script_host"}, "give_script_host.", function()
    --     for _, script in ipairs(ALL_script) do
    --         util.request_script_host(script)
    --         util.yield(1000)

    --         util.give_script_host(script, pid)

    --     end

    -- end)

    menu.action(latiaostandMenu, "和他被动 开", {"latiaoGHOSTMode"}, "", function()
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
    end)

    menu.action(latiaostandMenu, "和他被动 关", {"latiaoGHOSTMode"}, "", function()
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
    end)

    menu.toggle_loop(latiaostandMenu, "循环举报", {""}, "", function()
        util.yield(1000)
        local player = players.get_name(pid)
        menu.trigger_commands("reportgriefing" .. player)
        menu.trigger_commands("reportexploits" .. player)
        menu.trigger_commands("reportbugabuse" .. player)
        menu.trigger_commands("reportannoying" .. player)
        menu.trigger_commands("reporthate" .. player)
        menu.trigger_commands("reportvcannoying" .. player)
        menu.trigger_commands("reportvchate" .. player)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "循环爆炸", {""}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos, math.random(0, 82), INT_MAX, true, false, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环火焰", {"latiaoFlameLoop"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos, 12, INT_MAX, true, false, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环传送实体", {""}, "", function()
        local pos = players.get_position(pid)
        for _, target in ipairs(entities.get_all_objects_as_handles()) do
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
                ENTITY.SET_ENTITY_COORDS(target, pos.x, pos.y, pos.z, false)
            end
        end
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环传送实体行人", {""}, "", function()
        local pos = players.get_position(pid)
        for _, target in ipairs(entities.get_all_peds_as_handles()) do
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
                if not entities.is_player_ped(target) then
                    ENTITY.SET_ENTITY_COORDS(target, pos.x, pos.y, pos.z, false)
                end
            end
        end
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环传送载具", {""}, "", function()
        local pos = players.get_position(pid)
        for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
                ENTITY.SET_ENTITY_COORDS(target, pos.x, pos.y, pos.z, false)
            end

        end
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环传送可拾取物", {""}, "", function()
        local pos = players.get_position(pid)
        for _, target in ipairs(entities.get_all_pickups_as_handles()) do
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
                ENTITY.SET_ENTITY_COORDS(target, pos.x, pos.y, pos.z, false)
            end

        end
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环传送自身", {""}, "", function()
        local pos = players.get_position(pid)
        ENTITY.SET_ENTITY_COORDS(players.user_ped(), pos.x, pos.y, pos.z, false)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "附加自身", {""}, "", function()
        local pos = players.get_position(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(players.user_ped(), playerped, 0, 0, 0, 0, 0, 0, 0, false, false, false, false,
            0, false, 0)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "循环CREATE_RANDOM_PED", {""}, "", function()
        local pos = players.get_position(pid)
        local createobj = PED.CREATE_RANDOM_PED(pos.x, pos.y, pos.z)
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createobj, true, true)

        util.yield(0)
        entities.delete(createobj)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "用他名击杀npc ", {""}, "", function()
        for _, ped in entities.get_all_peds_as_handles() do
            if not entities.is_player_ped(ped) and ENTITY.IS_ENTITY_DEAD(ped) == false then

                -- if not  then
                local pos = v3.new(ENTITY.GET_ENTITY_COORDS(ped))
                FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), pos.x, pos.y, pos.z,
                    math.random(0, 82), INT_MAX, false, true, 0.0)
                -- end
            end
        end

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "循环送经验", {""}, "", function()
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 21, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 22, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 23, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 24, 1, 1, 1})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.toggle_loop(latiaostandMenu, "循环送经验2", {""}, "", function()
        util.trigger_script_event(1 << pid, {968269233, -1, 8, -5, 1, 1, 1})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)
    menu.toggle_loop(latiaostandMenu, "刷钱袋", {""}, "", function()
        local pickup = util.joaat("Prop_LD_CASE_01")
        util.request_model(pickup)
        local pos = players.get_position(pid)

        OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_MONEY_CASE"), pos.x, pos.y, pos.z, 0, INT_MAX, pickup, true,
            false)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "刷手办", {""}, "", function()
        local pickup = util.joaat("vw_prop_vw_colle_prbubble")
        util.request_model(pickup)
        local pos = players.get_position(pid)

        OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y, pos.z, 0, 0, pickup, true, false)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "刷纸牌", {""}, "", function()
        local pickup = util.joaat("vw_prop_vw_lux_card_01a")
        util.request_model(pickup)
        local pos = players.get_position(pid)

        OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y, pos.z, 0, 0, pickup, true, false)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "脚本传送到机场", {""}, "", function()
        util.trigger_script_event(1 << pid, {-1604421397, pid, 60, 4, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid)})
        -- -1604421397, players.user(),0,60,4,
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "无效物体破坏崩溃", {"latiaobadojectcrash"}, "", function()
        local badobject = entities.create_object(util.joaat("prop_fragtest_cnst_04"),
            ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
        OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(badobject, 1, false)
        -- end
        -- entities.delete_by_handle(badobject)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "循环踢出ceo", {""}, "", function()
        util.trigger_script_event(1 << pid, {-972329058})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "关取消传出所有人", {"latiaodesyncoff"}, "只对他同步超时其他人",
        function()
            menu.trigger_commands("latiaodesyncoff")

        end)

    menu.action(latiaostandMenu, "只对他同步(取消传出其他人)", {""}, "只对他同步超时其他人",
        function()
            for k, newpid in pairs(players.list(false, true, true)) do
                if newpid == pid then
                    goto out
                end

                local player = players.get_name(newpid)

                menu.trigger_commands("desync" .. player .. " on")
                ::out::

            end
        end)

    menu.toggle_loop(latiaostandMenu, "过多实体vehicle掉帧/崩溃", {""},
        "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
            local pos = players.get_cam_pos(pid)
            local vehicletobj = util.joaat("tug")
            util.request_model(vehicletobj)
            local createobj = entities.create_vehicle(vehicletobj, pos, 0)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createobj, true, true)

            util.yield(0)
            entities.delete(createobj)

            if not players.exists(pid) then
                util.stop_thread()
            end
        end)

    menu.toggle_loop(latiaostandMenu, "过多object实体掉帧/崩溃", {""},
        "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
            local pos = players.get_cam_pos(pid)
            local objectobj = util.joaat("p_spinning_anus_s")
            util.request_model(objectobj)
            local createobj = entities.create_object(objectobj, pos)

            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createobj, true, true)
            util.yield(0)
            entities.delete(createobj)

            if not players.exists(pid) then
                util.stop_thread()
            end
        end)

    menu.toggle_loop(latiaostandMenu, "过多ped实体掉帧/崩溃", {""},
        "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
            local pos = players.get_cam_pos(pid)
            local pedobj = util.joaat("s_m_y_cop_01")
            util.request_model(pedobj)
            local createpedobj = entities.create_ped(6, pedobj, pos, 0)

            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createpedobj, true, true)
            util.yield(0)
            entities.delete(createpedobj)

            if not players.exists(pid) then
                util.stop_thread()
            end
        end)
    menu.toggle_loop(latiaostandMenu, "骚扰信息", {""}, "", function()
        util.trigger_script_event(1 << pid, {-642704387, -1, -295926414, math.random(0, INT_MAX)})
        util.trigger_script_event(1 << pid, {-642704387, -1, -242911964, math.random(0, INT_MAX)})
        util.trigger_script_event(1 << pid, {-642704387, -1, 94410750, math.random(0, INT_MAX)})
        util.trigger_script_event(1 << pid, {-642704387, -1, -994541138})
        util.trigger_script_event(1 << pid, {-642704387, -1, 782258655})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "只对他同步(超时其他人)", {""}, "只对他同步超时其他人", function()
        for k, newpid in pairs(players.list(false, true, true)) do
            if newpid == pid then
                goto out
            end

            local player = players.get_name(newpid)

            menu.trigger_commands("timeout" .. player .. " on")
            ::out::

        end

    end)

    menu.action(latiaostandMenu, "关超时所有人", {"latiaotimeoutoff"}, "latiaotimeoutoff.", function()
        menu.trigger_commands("latiaotimeoutoff")

    end)

    menu.toggle_loop(latiaostandMenu, "对他聊天刷屏", {""}, "", function()
        local player = players.get_name(pid)
        menu.trigger_commands("sendpm" .. player .. " " .. math.random(INT_MIN, INT_MAX))
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.toggle_loop(latiaostandMenu, "传送到边界击杀", {""}, "", function()
        players.teleport_3d(pid, 10000, 10000, -100)
        util.yield(5000)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环修车give_pickup_reward", {""}, "", function()
        players.give_pickup_reward(pid, "REWARD_VEHICLE_FIX")
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环回血give_pickup_reward", {""}, "", function()
        players.give_pickup_reward(pid, "REWARD_HEALTH")
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(latiaostandMenu, "循环补充防弹衣give_pickup_reward", {""}, "", function()
        players.give_pickup_reward(pid, "REWARD_ARMOUR")
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)
    menu.action(latiaostandMenu, "npc偷车", {""}, "", function()
        local pos = players.get_cam_pos(pid)
        local pedobj = util.joaat("s_f_y_hooker_01")
        util.request_model(pedobj)
        local createpedobj = entities.create_ped(6, pedobj, pos, 0)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local vehicle = PED.GET_VEHICLE_PED_IS_USING(playerped)

        entities.set_can_migrate(createpedobj, false)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(createpedobj, true)
        PED.SET_PED_INTO_VEHICLE(createpedobj, vehicle, -2)

        TASK.TASK_SHUFFLE_TO_NEXT_VEHICLE_SEAT(createpedobj, vehicle, false)

        util.yield(2500)
        entities.delete(createpedobj)

    end)

    menu.toggle_loop(latiaostandMenu, "踢出载具SET_VEHICLE_EXCLUSIVE_DRIVER", {""}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
        VEHICLE.SET_VEHICLE_EXCLUSIVE_DRIVER(vehicle, players.user_ped(), 0)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "栽赃击杀自己", {""}, "", function()

        local randomPid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)

        local pos = v3.new(players.get_position(players.user()))
        FIRE.ADD_OWNED_EXPLOSION(randomPid, pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(latiaostandMenu, "无效行人动作崩溃2", {}, "", function()
        local ped = util.joaat('cs_taostranslator')
        util.request_model(ped)

        local pos = players.get_cam_pos(pid)
        local createped = entities.create_ped(4, ped, pos, 0)
        WEAPON.GIVE_WEAPON_TO_PED(createped, util.joaat('WEAPON_HOMINGLAUNCHER'), INT_MAX, true, true)
        util.yield(1000)
        ENTITY.SET_ENTITY_HEALTH(createped, 0, -1, -1)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "开启拉机能量跳伞", {""}, "", function()
        util.trigger_script_event(1 << pid, {1450115979, players.user(), 267, -1})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)
    menu.toggle_loop(latiaostandMenu, "送上ufo", {""}, "", function()
        util.trigger_script_event(1 << pid, {1450115979, players.user(), 314, -1})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)
    menu.toggle_loop(latiaostandMenu, "开启派遣工作", {""}, "", function()
        util.trigger_script_event(1 << pid, {1450115979, players.user(), 339, -1})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)
    menu.toggle_loop(latiaostandMenu, "152", {""}, "", function()
        util.trigger_script_event(1 << pid, {1450115979, players.user(), 152, -1})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.action(latiaostandMenu, "强制送披萨", {""}, "", function()

        util.trigger_script_event(1 << pid, {1450115979, players.user(), 340, -1})

        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.action(latiaostandMenu, "无效开始任务踢", {""}, "", function()

        util.trigger_script_event(1 << pid, {1450115979, players.user(), 1})

        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.toggle_loop(latiaostandMenu, "设置假身作弊到他", {"latiaofakepos"}, ("latiaofakepos"), function()
        local pos = v3.new(players.get_position(pid))

        menu.trigger_commands("spoofedposition " .. pos.x .. "," .. pos.y .. "," .. pos.z)
        -- util.yield(100)

    end)

    menu.toggle_loop(latiaostandMenu, "骚扰sms", {""}, (""), function()
        players.send_sms(pid, "sb")

    end)
    menu.toggle_loop(latiaostandMenu, "随机载具填充池", {""}, (""), function()

        local vehicles = util.get_vehicles()

        local random_index = math.random(1, #vehicles)
        local random_vehicle = vehicles[random_index]

        local vehicletobj = util.joaat(random_vehicle.name)
        util.request_model(vehicletobj)
        util.create_thread(function()
            local createobj = entities.create_vehicle(vehicletobj, players.get_position(pid), 0)
            util.yield(1)
            entities.delete(createobj)
            ENTITY.FREEZE_ENTITY_POSITION(vehicletobj, true)
        end)

    end)

    menu.action(latiaostandMenu, "无效TASK_VEHICLE_HELI_PROTECT动作崩溃", {""}, "", function()
        local pos = players.get_cam_pos(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local mdl = util.joaat("a_m_y_stlat_01")
        local veh_mdl = util.joaat("dilettante")
        util.request_model(veh_mdl)
        util.request_model(mdl)
        local veh = entities.create_vehicle(veh_mdl, pos, 0)
        local ped = entities.create_ped(2, mdl, pos, 0)

        PED.SET_PED_INTO_VEHICLE(ped, veh, -1)
        util.yield(1000)
        TASK.TASK_VEHICLE_HELI_PROTECT(ped, veh, playerped, INT_MAX, 0, INT_MAX, 0, 0)
        util.yield(1000)
        for i = 1, 10, 1 do
            entities.give_control(veh, pid)
            entities.give_control(ped, pid)
            util.yield()
        end

    end)

    menu.action(latiaostandMenu, "无效TASK_SUBMARINE_GOTO_AND_STOP动作崩溃", {""}, "", function()
        local pos = players.get_cam_pos(pid)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("a_m_y_stlat_01")
        local veh_mdl = util.joaat("dilettante")
        util.request_model(veh_mdl)
        util.request_model(mdl)

        local veh = entities.create_vehicle(veh_mdl, pos, 0)
        local jesus = entities.create_ped(2, mdl, pos, 0)

        PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
        util.yield(1000)
        TASK.TASK_SUBMARINE_GOTO_AND_STOP(mdl, veh, 0, 0, 0, true)
        util.yield(1000)
        for i = 1, 10, 1 do
            entities.give_control(veh, pid)
            entities.give_control(jesus, pid)
            util.yield()
        end

    end)

    menu.action(latiaostandMenu, "无效TASK_PLANE_LAND动作崩溃", {""}, "", function()
        local pos = players.get_cam_pos(pid)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("a_m_y_stlat_01")
        local veh_mdl = util.joaat("dilettante")
        util.request_model(veh_mdl)
        util.request_model(mdl)

        local veh = entities.create_vehicle(veh_mdl, pos, 0)
        local jesus = entities.create_ped(2, mdl, pos, 0)

        PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
        util.yield(1000)
        TASK.TASK_PLANE_LAND(jesus, veh, ped, 0, 10, 0, 0, 0)
        util.yield(1000)
        for i = 1, 10, 1 do
            entities.give_control(veh, pid)
            entities.give_control(jesus, pid)
            util.yield()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "蠢人帮差事", {""}, "", function()
        util.trigger_script_event(1 << pid, {1450115979, players.user(), 307, -1})
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.action(latiaostandMenu, "yim crash test", {}, "", function()

        local pos = players.get_cam_pos(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local mdl = util.joaat("u_m_m_jesus_01")
        local veh_mdl = util.joaat("oppressor")
        local ped = util.joaat('cs_manuel')
        util.request_model(ped)
        util.request_model(veh_mdl)
        util.request_model(mdl)
        local veh = entities.create_vehicle(veh_mdl, pos, 0)
        local jesus = entities.create_ped(2, mdl, pos, 0)
        local createped = entities.create_ped(4, ped, pos, 0)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(createped, true)
        PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
        TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, playerped, INT_MAX, 0, INT_MAX, 0, 0)

        entities.give_control(veh, pid)
        entities.give_control(jesus, pid)
        for i = 1, 10, 1 do
            entities.give_control(veh, pid)
            entities.give_control(jesus, pid)
            util.yield()
        end

        WEAPON.GIVE_WEAPON_TO_PED(createped, util.joaat('WEAPON_HOMINGLAUNCHER'), INT_MAX, true, true)
        util.yield(1000)
        ENTITY.SET_ENTITY_HEALTH(createped, 0, -1, -1)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.action(latiaostandMenu, "无效开始任务踢", {""}, "", function()

        util.trigger_script_event(1 << pid, {1450115979, players.user(), 1})

    end)
    menu.action(latiaostandMenu, "火车池填充崩溃", {""}, "", function()

        local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
        pos.z = pos.z + 50
        local allvehs = entities.get_all_vehicles_as_handles()
        local model_array = {184361638, 3186376089, 410882957, 1077420264, 240201337}
        local spawn_veh = {}
        for spawn_, vels in pairs(model_array) do
            for i = 1, 15, 1 do
                util.request_model(vels)
                spawn_veh[spawn_] = entities.create_vehicle(vels, pos, 0)
                ENTITY.FREEZE_ENTITY_POSITION(spawn_veh[spawn_], true)
                util.yield(0)
            end
        end

    end)

    menu.action(latiaostandMenu, "crash", {""}, "", function()

        local ped = util.joaat('a_c_poodle')
        util.request_model(ped)

        local pos = players.get_cam_pos(pid)
        local createped = entities.create_ped(4, ped, pos, 0)

        WEAPON.GIVE_WEAPON_TO_PED(createped, util.joaat('WEAPON_HOMINGLAUNCHER'), INT_MAX, true, true)
        util.yield()
        ENTITY.SET_ENTITY_HEALTH(createped, 0, -1, -1)
        if not players.exists(pid) then
            util.stop_thread()
        end

    end)

    menu.toggle_loop(latiaostandMenu, "电线杆", {"latiaotunspammcrash"},
        "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
            local pos = players.get_cam_pos(pid)
            util.request_model(util.joaat("tug"))

            local obj = entities.create_object(util.joaat("prop_streetlight_01"), pos, 0)
            ENTITY.SET_ENTITY_COORDS(obj, pos)
            util.yield(0)
            entities.delete(obj)
            if not players.exists(pid) then
                util.stop_thread()
            end
        end)

    menu.toggle_loop(latiaostandMenu, "火车", {"latiaotunspammcrash"},
        "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
            local pos = players.get_cam_pos(pid)
            util.request_model(util.joaat("freightcar"))

            local obj = entities.create_vehicle(util.joaat("freightcar"), pos, 0)
            ENTITY.SET_ENTITY_COORDS(obj, pos)
            util.yield(1000)
            -- entities.delete(obj)
            if not players.exists(pid) then
                util.stop_thread()
            end
        end)

    menu.action(latiaostandMenu, "中断fm脚本任务", {""}, "", function()

        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})

    end)

    menu.slider(latiaostandMenu, "SET_ENTITY_MAX_HEALTH", {"SET_ENTITY_MAX_HEALTH"}, "SET_ENTITY_MAX_HEALTH", 0,
        INT_MAX, 100, 1, function(value)
            local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            ENTITY.SET_ENTITY_MAX_HEALTH(playerped, value)

        end)

    menu.slider(latiaostandMenu, "SET_ENTITY_HEALTH", {"SET_ENTITY_HEALTH"}, "SET_ENTITY_HEALTH", 0, INT_MAX, 100, 1,
        function(value)
            local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            ENTITY.SET_ENTITY_HEALTH(playerped, value, -1, -1)

        end)
    menu.toggle_loop(latiaostandMenu, "循环加入他的子战局", {""}, "", function()
        NETWORK.NETWORK_ALLOW_GANG_TO_JOIN_TUTORIAL_SESSION(getTeamID(pid), getInstanceID(pid))
    end, function()
        NETWORK.NETWORK_END_TUTORIAL_SESSION()
    end)

    menu.toggle_loop(latiaostandMenu, "print", {""}, "", function()
        local team = getTeamID(pid)
        print(team)
    end)

    menu.toggle_loop(latiaostandMenu, "超级无限死亡击杀", {}, "", function()
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        local pos = players.get_position(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        util.trigger_script_event(1 << pid, {-503325966})
        -- TASK.CLEAR_PED_TASKS_IMMEDIATELY(playerped)
        -- (Type: weapon_tranquilizer, Damage: 0, Flags: 540688, true, 3)

        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 0, true,
            util.joaat("weapon_tranquilizer"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(latiaostandMenu, "无限死亡击杀", {}, "", function()
        -- util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        local pos = players.get_position(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
-- // (Type: weapon_tranquilizer, Damage: 0, Flags: 513, true, 3)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 0, true,
            util.joaat("weapon_tranquilizer"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

end

for _, pid in ipairs(players.list()) do
    latiaostandMenuSetup(pid)
end

players.on_join(latiaostandMenuSetup)

menu.toggle_loop(server, "闪现坐标", {"latiaobadpost"}, ("latiaobadpost"), function()
    menu.trigger_commands("spoofpos")
end)

menu.action(test, "退游戏", {"latiaoQUIT_GAME"}, "", function()
    MISC.QUIT_GAME()
end)

menu.toggle_loop(server, "被动模式", {"latiaoGHOSTMode"}, "", function()
    for k, pid in pairs(players.list()) do
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
    end
end, function()
    for k, pid in pairs(players.list()) do
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
    end
end)

menu.toggle_loop(server, "显示谁在开麦克风", {"LATIAOTALKINGTEST"}, "", function()
    for k, pid in pairs(players.list()) do
        if NETWORK.NETWORK_IS_PLAYER_TALKING(pid) then
            util.draw_debug_text(players.get_name(pid) .. " 在说话")
        end
    end
end)

menu.action(server, "启动子战局", {"latiaoNETWORK_START_SOLO_TUTORIAL_SESSION"},
    "NETWORK_START_SOLO_TUTORIAL_SESSION", function()

        NETWORK.NETWORK_START_SOLO_TUTORIAL_SESSION()
    end)

menu.action(server, "关闭子战局", {"latiaoNETWORK_END_TUTORIAL_SESSION"}, "NETWORK_END_TUTORIAL_SESSION",
    function()
        NETWORK.NETWORK_END_TUTORIAL_SESSION()
    end)

local HEALTH = menu.slider(world, "设置血量 ", {"SET_ENTITY_HEALTH"}, "SET_ENTITY_HEALTH", INT_MIN, INT_MAX, 100, 1,
    function()
    end)

menu.toggle_loop(world, "设置血量 for get_all_objects_as_handles", {""}, "", function()
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        ENTITY.SET_ENTITY_HEALTH(ent, menu.get_value(HEALTH), -1, -1)
    end
end)
menu.toggle_loop(world, "设置血量 for get_all_peds_as_handles", {""}, "", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            ENTITY.SET_ENTITY_HEALTH(ent, menu.get_value(HEALTH), -1, -1)
        end
    end
end)
menu.toggle_loop(world, "设置血量 for get_all_vehicles_as_handles", {""}, "", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_HEALTH(ent, menu.get_value(HEALTH), -1, -1)
    end
end)
menu.toggle_loop(world, "设置血量 for get_all_pickups_as_handles", {""}, "", function()
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        ENTITY.SET_ENTITY_HEALTH(ent, menu.get_value(HEALTH), -1, -1)
    end
end)

function START_SCRIPT(name)
    SCRIPT.REQUEST_SCRIPT(name)
    repeat
        util.yield_once()
    until SCRIPT.HAS_SCRIPT_LOADED(name)
    SYSTEM.START_NEW_SCRIPT(name, 5000)
end

menu.action(admin, "远控地堡", {""}, "", function()
    START_SCRIPT("appbunkerbusiness")
end)
menu.action(admin, "远控机库", {""}, "", function()
    START_SCRIPT("appsmuggler")
end)
menu.action(admin, "远控夜总会", {""}, "", function()
    START_SCRIPT("appbusinesshub")
end)
menu.action(admin, "远控摩托帮", {""}, "", function()
    START_SCRIPT("appbikerbusiness")
end)
menu.action(admin, "远控莱斯特面板", {""}, "", function()
    START_SCRIPT("apparcadebusinesshub")
end)
menu.action(admin, "远控恐霸", {""}, "", function()
    START_SCRIPT("apphackertruck")
end)

menu.action(admin, "远控事务所", {""}, "", function()
    START_SCRIPT("appfixersecurity")
end)

menu.toggle_loop(admin, "摩托帮出货为最简单", {""}, "", function()
    SET_INT_LOCAL("gb_biker_contraband_sell", 704 + 17, 0)
end)
menu.toggle_loop(admin, "ceo出货为最简单", {""}, "", function()
    SET_INT_LOCAL("gb_contraband_sell", 550, 12)
end)

menu.action(dividends_brdr, "开启别惹德瑞", {}, "", function()
    STAT_SET_INT("FIXER_GENERAL_BS", -1)
    STAT_SET_INT("FIXER_COMPLETED_BS", -1)
    STAT_SET_INT("FIXER_STORY_BS", -1)
end)

menu.toggle_loop(test, "CLEAR_AREA", {""}, "", function()
    MISC.CLEAR_AREA(0, 0, 0, INT_MAX, false, false, false, false)
end)

menu.toggle_loop(test, "CLEAR_AREA_OF_OBJECTS", {""}, "", function()
    MISC.CLEAR_AREA_OF_OBJECTS(0, 0, 0, INT_MAX, 0)
end)

menu.toggle_loop(test, "CLEAR_AREA_OF_PEDS", {""}, "", function()
    MISC.CLEAR_AREA_OF_PEDS(0, 0, 0, INT_MAX, 0)
end)
menu.toggle_loop(test, "CLEAR_AREA_OF_VEHICLES", {""}, "", function()
    MISC.CLEAR_AREA_OF_VEHICLES(0, 0, 0, INT_MAX, false, false, false, false, false, false, 0)
end)
menu.toggle_loop(test, "CLEAR_AREA_OF_COPS", {""}, "", function()
    MISC.CLEAR_AREA_OF_COPS(0, 0, 0, INT_MAX, 0)
end)

menu.action(test, "刷新当前区块(tp and back)", {"latiaotpback"}, "", function()
    local pos = players.get_position(players.user())

    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), pos.x, pos.y, 2600)
    util.yield(5000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), pos.x, pos.y, pos.z)

    -- )
end)

menu.toggle_loop(test, "脚本声音轰炸", {""}, "", function()
    -- util.yield(1500)
    util.trigger_script_event(util.get_session_players_bitflag(), {996099702})

end)

menu.toggle_loop(test, "检查点信息轰炸", {""}, "", function()
    -- util.yield(1500)
    util.trigger_script_event(util.get_session_players_bitflag(),
        {-642704387, players.user(), 782258655, 0, 0, 0, 0, 0, 0, 0, players.user(), 0, 0, 0})

end)

menu.toggle_loop(test, "信息轰炸", {"test1"}, "tet2", function()
    -- util.yield(1500)
    util.trigger_script_event(util.get_session_players_bitflag(),
        {-642704387, players.user(), 782258655, 0, 0, 0, 0, 0, 0, 0, math.random(0, 32), 0, 0, 0})

end)

menu.toggle_loop(world, "停止世界所有火焰STOP_FIRE_IN_RANGE", {""}, "", function()
    FIRE.STOP_FIRE_IN_RANGE(0, 0, 0, INT_MAX)
end)

menu.toggle_loop(world, "所有人忽略EVERYONE IGNORE ALL PLAYER", {}, "", function()
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(players.user(), true)
end, function()
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(players.user(), false)
end)

menu.toggle_loop(world, "可以射击队友", {""}, "", function()
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), true, false)
end, function()
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), false, false)
end)

menu.toggle_loop(world, "没有噪音", {}, "", function()
    PLAYER.SET_PLAYER_NOISE_MULTIPLIER(players.user(), 0)
    PLAYER.SET_PLAYER_SNEAKING_NOISE_MULTIPLIER(players.user(), 0)
end)

menu.toggle_loop(self, "假死 SET_ENTITY_MAX_HEALTH 0", {""}, "", function()
    ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 0)
end, function()
    ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 328)
end)

menu.action(about, "github:latiao-1337", {""}, "", function()

end)

menu.toggle_loop(self, "设置玩家锁定范围覆盖最大", {"SET_PLAYER_LOCKON_RANGE_OVERRIDE"}, "", function()
    PLAYER.SET_PLAYER_LOCKON_RANGE_OVERRIDE(players.user(), INT_MAX)
end)

menu.toggle_loop(server, "爆炸声音轰炸", {""}, "", function()
    FIRE.ADD_EXPLOSION(0, 0, 2500, math.random(0, 82), INT_MAX, true, false, INT_MAX)
end)

menu.action(dividends_dc, "赌场停车场生成载具", {""}, "", function()
    util.request_model(util.joaat("polmav"))
    local pos = v3.new(579, 12, 103)
    entities.create_vehicle(util.joaat("polmav"), pos, 0)
end)

menu.action(dividends_dc, "警察局房顶生成飞机", {""}, "", function()
    util.request_model(util.joaat("asterope"))
    local pos = v3.new(905, -37, 78)
    entities.create_vehicle(util.joaat("asterope"), pos, 0)
end)

menu.toggle_loop(test, "FIX_OBJECT_FRAGMENT all", {"latiaobadBBREAK_OBJECT_FRAGMENT_CHILDcrash"}, "", function()
    for k, ent in ipairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            OBJECT.FIX_OBJECT_FRAGMENT(ent)
        end)
        if not success then

        end
    end
end)
menu.toggle_loop(test, "BREAK_OBJECT_FRAGMENT_CHILD all", {"latiaobadBBREAK_OBJECT_FRAGMENT_CHILDcrash"}, "", function()
    for k, ent in ipairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(ent, 0, false)
        end)
        if not success then

        end
    end
end)

menu.toggle_loop(test, "所有实体不无敌", {}, "", function()

    for k, ent in ipairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_INVINCIBLE(ent, false)
        end)
        if not success then

        end
    end
end)

menu.toggle_loop(test, "所有实体无敌", {}, "", function()

    for k, ent in pairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_INVINCIBLE(ent, true)
        end)
        if not success then

        end
    end
end)

menu.toggle_loop(world, "解锁周围所有车", {""}, "", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(ent, 0)
    end
end)

menu.toggle_loop(world, "锁定周围所有车", {""}, "", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(ent, 2)
    end
end)

menu.toggle_loop(server, "循环给予收藏品", {""}, "", function()
    -- if NETWORK.NETWORK_IS_HOST() then
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))

    util.yield(30000)
    -- end
end)

menu.toggle_loop(server, "循环给予经验", {""}, "", function()

    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give RP"))
    -- util.yield()
end)

menu.toggle_loop(world, "随机玩家击杀 ped ", {""}, "", function()
    local list = players.list()
    local index = math.random(#list)

    local randomPid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(list[index])

    for _, ped in entities.get_all_peds_as_handles() do
        if not entities.is_player_ped(ped) and ENTITY.IS_ENTITY_DEAD(ped) == false then

            local pos = v3.new(ENTITY.GET_ENTITY_COORDS(ped))
            FIRE.ADD_OWNED_EXPLOSION(randomPid, pos.x, pos.y, pos.z, math.random(0, 82), INT_MAX, false, true, 0.0)
        end
    end

end)

menu.action(world, "删除所有非网络实体", {"latiaodelallnotNETWORK"}, "latiaodelallnotNETWORK.", function()
    for _, entity in ipairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            if not NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(entity) then
                entities.delete(entity)
            end
        end)

        if not success then

        end
    end

end)

menu.action(world, "刷新室内", {""}, "", function()
    local myINTERIOR = INTERIOR.GET_INTERIOR_FROM_ENTITY((players.user_ped()))
    INTERIOR.REFRESH_INTERIOR(myINTERIOR)
end)

menu.toggle_loop(server, "giverpforall", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {968269233, -1, 4, 21, 1, 1, 1})
    util.trigger_script_event(util.get_session_players_bitflag(), {968269233, -1, 4, 22, 1, 1, 1})
    util.trigger_script_event(util.get_session_players_bitflag(), {968269233, -1, 4, 23, 1, 1, 1})
    util.trigger_script_event(util.get_session_players_bitflag(), {968269233, -1, 4, 24, 1, 1, 1})

end)

menu.toggle_loop(server, "giverpforall2", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {968269233, -1, 8, -5, 1, 1, 1})

end)

menu.toggle_loop(self, "锁定玩家", {}, "允许使用制导发射器锁定玩家", function()

    for k, pid in pairs(players.list()) do
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)

        PLAYER.ADD_PLAYER_TARGETABLE_ENTITY(players.user(), playerped)
        ENTITY.SET_ENTITY_IS_TARGET_PRIORITY(playerped, false, 0)
    end

end)

menu.toggle_loop(world, "超级npc无视", {""}, "", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        PED.SET_PED_SEEING_RANGE(ent, 0)
        PED.SET_PED_ID_RANGE(ent, 0)
        PED.SET_PED_HEARING_RANGE(ent, 0)
    end
end)

menu.toggle_loop(world, "传送 物体 到我 ", {"latiaotpobjects"}, "tp objects.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
        end)
        if not success then
            latiao_log(error_message)
        end

    end
end)

menu.toggle_loop(world, "传送 npc 到我", {"latiaotppeds"}, "tppeds.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            local success, error_message = pcall(function()
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end)
            if not success then
                latiao_log(error_message)
            end
        end

    end
end)

menu.toggle_loop(world, "传送 载具 到我", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
        end)
        if not success then
            latiao_log(error_message)
        end

    end
end)

menu.toggle_loop(world, "传送 可拾取 到我", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
        end)
        if not success then
            latiao_log(error_message)
        end

    end
end)

menu.toggle_loop(world, "传送网络 实体", {"latiaotp objects"}, "tp objects.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_objects_as_handles()) do

        local success, error_message = pcall(function()
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end
        end)
        if not success then
            latiao_log(error_message)
        end

    end
end)

menu.toggle_loop(world, "传送网络 peds", {"latiaotp peds"}, "tp peds.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            local success, error_message = pcall(function()
                if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                    ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
                end
            end)
            if not success then
                latiao_log(error_message)
            end
        end

    end
end)

menu.toggle_loop(world, "传送网络 载具", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        local success, error_message = pcall(function()
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end
        end)
        if not success then
            latiao_log(error_message)
        end

    end
end)

menu.toggle_loop(world, "传送网络 可拾取物", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        local success, error_message = pcall(function()
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end
        end)
        if not success then
            latiao_log(error_message)
        end

    end
end)

menu.slider_float(world, "风速", {"SET_WIND"}, "", 0, 5, -1, 1, function(value)
    MISC.SET_WIND(value)
end)
menu.slider_float(world, "雨量", {"SET_RAIN"}, "", 0, 5, -1, 1, function(value)
    MISC.SET_RAIN(value)
end)

menu.toggle_loop(world, "tp到附近的网络objects", {""}, "", function()
    for _, target in ipairs(entities.get_all_objects_as_handles()) do
        if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
            local objectspos = ENTITY.GET_ENTITY_COORDS(target, true)
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), objectspos.x, objectspos.y, objectspos.z, false)
        end
    end
end)
menu.toggle_loop(world, "tp到附近的网络 peds", {""}, "", function()
    for _, target in ipairs(entities.get_all_peds_as_handles()) do
        if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
            if not entities.is_player_ped(target) then
                local objectspos = ENTITY.GET_ENTITY_COORDS(target, true)
                ENTITY.SET_ENTITY_COORDS(players.user_ped(), objectspos.x, objectspos.y, objectspos.z, false)
            end
        end
    end
end)
menu.toggle_loop(world, "tp到附近的网络 vehicles", {""}, "", function()
    for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
        if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
            local objectspos = ENTITY.GET_ENTITY_COORDS(target, true)
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), objectspos.x, objectspos.y, objectspos.z, false)
        end

    end
end)
menu.toggle_loop(world, "tp到附近的网络 pickups", {""}, "", function()
    for _, target in ipairs(entities.get_all_pickups_as_handles()) do
        if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(target) then
            local objectspos = ENTITY.GET_ENTITY_COORDS(target, true)
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), objectspos.x, objectspos.y, objectspos.z, false)
        end

    end
end)
menu.action(admin, "呼叫虎鲸", {""}, "", function()
    SET_INT_GLOBAL(2738587 + 960, 1)
end)
menu.action(dividends_gzp, "跳过改装铺前置", {""}, "", function()
    STAT_SET_INT("TUNER_GEN_BS", -1)
end)

menu.toggle_loop(test, "自动收集(左键连点)", {""}, "", function()
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 237, 1)
    util.yield()
end)

menu.toggle_loop(world, "tp radar_temp_3", {""}, "", function()
    local pos = v3.new(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(431)))
    ENTITY.SET_ENTITY_COORDS(players.user_ped(), pos.x, pos.y, pos.z, false)
end)
menu.action(dividends_hsz, "跳过回收站前置", {""}, "", function()
    STAT_SET_INT("SALV23_FM_PROG", -1)
end)

menu.toggle_loop(world, "随机tp", {""}, "", function()
    local pos = math.random(0, 10000)
    ENTITY.SET_ENTITY_COORDS(players.user_ped(), pos, pos, 0, false)
end)
menu.action(dividends_hsz, "回收站所有抢劫载具可选", {""}, "", function()
    STAT_SET_INT("SALV23_VEHROB_STATUS0", -1)
    STAT_SET_INT("SALV23_VEHROB_STATUS1", -1)
    STAT_SET_INT("SALV23_VEHROB_STATUS2", -1)
end)

-- menu.toggle_loop(world, "CREATE_AMBIENT_PICKUP", {""}, "", function()
--     local pos = players.get_position(players.user())

--     OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y, pos.z, 0, 1,
--         util.joaat("vw_prop_vw_colle_prbubble"), false, false)
-- end)
-- menu.toggle_loop(world, "CREATE_AMBIENT_PICKUP", {""}, "", function()
--     for k, pid in pairs(players.list()) do
--         local pos = players.get_position(pid)
--         -- OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT") ,pos.x,pos.y,pos.z,0,1,util.joaat("vw_prop_vw_lux_card_01a"),false,false)
--         OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y, pos.z, 0, 1,
--             util.joaat("vw_prop_vw_colle_prbubble"), false, false)
--         -- util.yield()
--     end
-- end)
-- menu.toggle_loop(world, "CREATE_AMBIENT_PICKUP", {""}, "", function()
--     for k, pid in pairs(players.list()) do
--         local pos = players.get_position(pid)
--         OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y, pos.z, 0, 1,
--             util.joaat("vw_prop_vw_lux_card_01a"), false, false)
--         -- OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT") ,pos.x,pos.y,pos.z,0,1,util.joaat("vw_prop_vw_colle_prbubble"),false,false)
--         -- util.yield()
--     end
-- end)

menu.toggle_loop(server, "主机踢你时踢所有人", {"latiaokickallexcludehost"}, "latiaokickallexcludehost",
    function()

        if players.is_marked_as_attacker(players.get_host()) then
            for k, pid in pairs(players.list(false, true, true)) do
                if pid == players.get_host() or players.is_marked_as_modder(pid) then
                    goto out
                end
                util.trigger_script_event(1 << pid, {968269233, pid, 4, 233, 1, 1, 1})
                ::out::
            end
            -- else
            -- latiao_log("nohost")
        end

    end)
menu.toggle_loop(world, "过度测试", {""}, "", function()
    -- local function getTransitionState()
    --     return memory.read_int(memory.script_global(1575008))  
    -- end
    latiao_log(memory.read_int(memory.script_global(1575008)))
end)

menu.toggle_loop(world, "TASK_COMBAT_PED", {"TASK_COMBAT_PED"}, "TASK_COMBAT_PED.", function()
    for k, ent in pairs(entities.get_all_peds_ads_handles()) do
        if not entities.is_player_ped(ent) then
            TASK.TASK_COMBAT_PED(ent, players.user_ped(), 0, 16)
        end
    end
end)

menu.action(server, "NETWORK_HASH_FROM_PLAYER_HANDLE", {""}, "", function()
    for k, pid in pairs(players.list()) do
        local name = players.get_name(pid)
        latiao_log(name .. "," .. NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid))
    end
end)

menu.toggle_loop(test, "key test", {"keytest"}, "keytest.", function()
    if util.is_key_down(0x09) then
        latiao_log("true")
    end
end)
local obinfo = menu.list(menu.my_root(), "实体控制枪", {}, "")
menu.toggle_loop(obinfo, "实体控制枪", {"latiaodebuggun"}, ("latiaodebuggun"), function()
    local outptr = memory.alloc(4)
    local aim_info = {
        handle = 0
    }
    -- local last_text = ""
    if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), outptr) then
        -- latiao_log(handle)
        local handle = memory.read_int(outptr)
        aim_info.hash = ENTITY.GET_ENTITY_MODEL(handle)
        aim_info.model = util.reverse_joaat(aim_info.hash)
        aim_info.health = entities.get_health(handle)
        aim_info.OWNER = entities.get_owner(handle)
        aim_info.OWNERName = players.get_name(entities.get_owner(handle))
        aim_info.ISNETWORKED = NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(handle)
        aim_info.ISMISSION = ENTITY.IS_ENTITY_A_MISSION_ENTITY(handle)
        aim_info.CANmigrate = entities.get_can_migrate(handle)
        aim_info.IsInvulnerable = entities.is_invulnerable(handle)
        local guninfo = "U请求实体 I传送到我 O删除 K爆炸 H设置实体无敌"

        local text = "Hash=" .. aim_info.hash .. "," .. "Model=" .. aim_info.model .. "," .. "Health=" ..
                         aim_info.health .. "," .. "Owner=" .. aim_info.OWNER .. "," .. "OwnerName=" ..
                         aim_info.OWNERName .. "," .. "NETWORKED=" .. aim_info.ISNETWORKED .. "," .. "MISSIONENTITY=" ..
                         aim_info.ISMISSION .. "," .. "Handle=" .. handle .. "," .. "CANmigrate=" .. aim_info.CANmigrate ..
                         "," .. "无敌=" .. aim_info.IsInvulnerable

        directx.draw_text(0.5, 0.2, guninfo, 5, 0.5, {
            r = 1,
            g = 0,
            b = 0,
            a = 1
        }, true)

        directx.draw_text(0.5, 0.25, text, 5, 0.5, {
            r = 1,
            g = 0,
            b = 0,
            a = 1
        }, true)

        latiao_filter_log(text)
        if util.is_key_down(0x49) then
            local pos = players.get_position(players.user())
            ENTITY.SET_ENTITY_COORDS(handle, pos.x, pos.y, pos.z, false)

        end
        if util.is_key_down(0x55) then
            entities.request_control(handle)
        end
        if util.is_key_down(0x4F) then
            entities.delete(handle)

        end
        if util.is_key_down(0x4B) then
            -- entities.delete(handle)
            local pos = v3.new(ENTITY.GET_ENTITY_COORDS(handle))
            -- MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.5, pos.x, pos.y, pos.z,
            -- INT_MAX, true, util.joaat("weapon_pistol"), players.user_ped(), false, true,
            -- INT_MAX)
            -- ENTITY.SET_ENTITY_HEALTH(handle, 0, -1, -1)
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)

        end
        if util.is_key_down(0x48) then
            if entities.is_invulnerable(handle) then
                ENTITY.SET_ENTITY_INVINCIBLE(handle, false)
                print("SET_ENTITY_INVINCIBLE=false")
            else
                ENTITY.SET_ENTITY_INVINCIBLE(handle, true)
                print("SET_ENTITY_INVINCIBLE=true")
            end

        end

    end
end)

menu.toggle_loop(test, "SET_PED_DENSITY_MULTIPLIER_THIS_FRAME", {""}, "", function()

    PED.SET_PED_DENSITY_MULTIPLIER_THIS_FRAME(INT_MAX)

end)
menu.toggle_loop(dividends_general, "删除摄像头", {"latiaodelcctv"}, "latiaodelcctv", function()
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        for _, Models in ipairs({util.joaat("xm_prop_x17_server_farm_cctv_01"), util.joaat("ch_prop_ch_cctv_cam_02a"),
                                 util.joaat("prop_cctv_cam_01b")}) do
            if ENTITY.GET_ENTITY_MODEL(ent) == Models then
                entities.request_control(ent)
                if entities.get_owner(ent) == players.user() then
                    entities.delete(ent)
                end

            end
        end
    end
end)

menu.toggle_loop(server, "刷屏", {"latiaocleanchat"}, "latiaocleanchat.", function()
    chat.send_message((math.random(INT_MIN, INT_MAX)), false, true, true)
    util.yield(1000)
end)

menu.action(server, "无效a_c_rat动作崩溃", {""}, "", function()
    local pos = v3.new(0, 0, 75)
    local ped = util.joaat('a_c_rat')
    util.request_model(ped)
    local createped = entities.create_ped(28, ped, pos, 0)
    WEAPON.GIVE_WEAPON_TO_PED(createped, util.joaat('weapon_grenade'), INT_MAX, true, true)
    util.yield(1000)
    TASK.TASK_THROW_PROJECTILE(createped, pos.x, pos.y, pos.z, 0, 0)

end)
menu.action(server, "无效u_m_m_jesus_01驾驶动作崩溃", {""}, "", function()
    local pos = v3.new(0, 0, 75)
    local mdl = util.joaat("u_m_m_jesus_01")
    local veh_mdl = util.joaat("oppressor")
    util.request_model(veh_mdl)
    util.request_model(mdl)
    local veh = entities.create_vehicle(veh_mdl, pos, 0)
    local jesus = entities.create_ped(2, mdl, pos, 0)

    PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
    util.yield(1000)
    TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, players.user_ped(), INT_MAX, 0, INT_MAX, 0, 0)

end)

menu.toggle_loop(server, "虚假stnad崩溃", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {323285304})

end)

menu.toggle_loop(server, "虚假stnad踢出检查", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {-901348601})

end)

menu.toggle_loop(server, "空收藏品脚本", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {968269233})

end)

menu.toggle_loop(server, "空GENERAL脚本", {""}, "", function()
    for i = 1, 1000, 1 do
        util.trigger_script_event(util.get_session_players_bitflag(), {800157557})
    end

end)
menu.toggle_loop(server, "空公寓邀请脚本", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {-1321657966})

end)

menu.toggle_loop(server, "所有人循环踢出ceo", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {-11681548})

end)

menu.toggle_loop(server, "entities.request_control请求所有 行人", {"latiaoREQUES_ENTITYped"},
    "latiaoREQUES_ENTITYped.", function()
        for _, target in ipairs(entities.get_all_peds_as_handles()) do
            local owner = entities.get_owner(target)
            if not entities.is_player_ped(target) and owner ~= players.user() then
                util.create_thread(function()

                    entities.request_control(target)
                end)
            end

        end

    end)

menu.toggle_loop(server, "entities.request_control请求所有 实体", {"latiaoREQUES_ENTITYobjects"},
    "REQUES_ENTITYobjects.", function()
        for k, target in pairs(entities.get_all_objects_as_handles()) do
            local owner = entities.get_owner(target)
            if owner ~= players.user() then
                util.create_thread(function()

                    entities.request_control(target)
                end)

            end
        end

    end)

menu.toggle_loop(server, "entities.request_control请求所有 载具", {"latiaoREQUES_ENTITYvehicles"},
    "REQUES_ENTITYvehicles.", function()
        for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
            local owner = entities.get_owner(target)
            if owner ~= players.user() then
                util.create_thread(function()

                    entities.request_control(target)
                end)

            end
        end
    end)
menu.toggle_loop(server, "entities.request_control请求所有 可拾取2", {""}, "", function()
    for k, target in pairs(entities.get_all_pickups_as_handles()) do
        local owner = entities.get_owner(target)
        if owner ~= players.user() then

            util.create_thread(function()

                entities.request_control(target)
            end)
        end
    end
end)

menu.toggle_loop(server, "entities.set_can_migrate false请求所有 行人", {"latiaoREQUES_ENTITYped"},
    "latiaoREQUES_ENTITYped.", function()
        for _, target in ipairs(entities.get_all_peds_as_handles()) do
            local owner = entities.get_owner(target)
            if not entities.is_player_ped(target) and owner ~= players.user() then
                util.create_thread(function()

                    entities.request_control(target)
                end)
            else
                util.create_thread(function()
                    entities.set_can_migrate(target, false)
                end)

            end

        end

    end)

menu.toggle_loop(server, "entities.set_can_migrate false所有 实体", {"latiaoREQUES_ENTITYobjects"},
    "REQUES_ENTITYobjects.", function()
        for k, target in pairs(entities.get_all_objects_as_handles()) do
            local owner = entities.get_owner(target)
            if owner ~= players.user() then
                util.create_thread(function()

                    entities.request_control(target)
                end)
            else
                util.create_thread(function()
                    entities.set_can_migrate(target, false)
                end)

            end

        end

    end)

menu.toggle_loop(server, "entities.set_can_migrate false所有 载具", {"latiaoREQUES_ENTITYvehicles"},
    "REQUES_ENTITYvehicles.", function()
        for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
            local owner = entities.get_owner(target)
            if owner ~= players.user() then
                util.create_thread(function()

                    entities.request_control(target)
                end)
            else
                util.create_thread(function()
                    entities.set_can_migrate(target, false)
                end)

            end
        end
    end)
menu.toggle_loop(server, "entities.set_can_migrate false所有 可拾取", {""}, "", function()
    for k, target in pairs(entities.get_all_pickups_as_handles()) do
        local owner = entities.get_owner(target)
        if owner ~= players.user() then

            util.create_thread(function()

                entities.request_control(target)
            end)
        else
            util.create_thread(function()
                entities.set_can_migrate(target, false)
            end)

        end
    end
end)

menu.toggle_loop(server, "控制权迁移到其他玩家 所有行人", {""}, "", function()
    local list = players.list(false, true, true)
    local index = math.random(#list)
    for _, target in ipairs(entities.get_all_peds_as_handles()) do
        local owner = entities.get_owner(target)
        if not entities.is_player_ped(target) and not owner ~= players.user() then
            -- latiao_log(target)
            util.create_thread(function()
                entities.set_can_migrate(target, true)
                entities.give_control(target, index)
            end)

        end
    end

end)

menu.toggle_loop(server, "控制权迁移到其他玩家 所有objects", {""}, "", function()
    local list = players.list(false, true, true)
    local index = math.random(#list)
    for _, target in ipairs(entities.get_all_objects_as_handles()) do
        local owner = entities.get_owner(target)
        if not entities.is_player_ped(target) and not owner ~= players.user() then
            -- latiao_log(target)
            util.create_thread(function()
                entities.set_can_migrate(target, true)
                entities.give_control(target, index)
            end)
        end
    end

end)

menu.toggle_loop(server, "控制权迁移到其他玩家 所有可拾取", {""}, "", function()
    local list = players.list(false, true, true)
    local index = math.random(#list)
    for k, target in pairs(entities.get_all_pickups_as_handles()) do
        local owner = entities.get_owner(target)
        if not entities.is_player_ped(target) and not owner ~= players.user() then
            -- latiao_log(target)
            util.create_thread(function()
                entities.set_can_migrate(target, true)
                entities.give_control(target, index)
            end)
        end
    end

end)
menu.toggle_loop(server, "控制权迁移到其他玩家 所有载具", {""}, "", function()
    local list = players.list(false, true, true)
    local index = math.random(#list)
    for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
        local owner = entities.get_owner(target)
        if not entities.is_player_ped(target) and not owner ~= players.user() then
            -- latiao_log(target)
            util.create_thread(function()
                entities.set_can_migrate(target, true)
                entities.give_control(target, index)
            end)
        end

    end

end)

menu.action(server, "关取消传出所有人", {"latiaodesyncoff"}, "只对他同步超时其他人", function()
    for k, newpid in pairs(players.list(false, true, true)) do

        local player = players.get_name(newpid)

        menu.trigger_commands("desync" .. player .. " off")
        ::out::

    end

end)

menu.toggle_loop(server, "禁止别人抢夺公文包", {""}, "", function()
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        if ENTITY.GET_ENTITY_MODEL(ent) == util.joaat("set_can_migrate") then
            local owner = entities.get_owner(ent)
            if owner ~= players.user() then
                latiao_log("set_can_migrate" .. ent)
                entities.set_can_migrate(ent, true)

            else
                latiao_log("request_control" .. ent)
                entities.request_control(ent)
            end
        end

    end

end)

menu.toggle_loop(dividends_general, "禁止任务失败", {""}, "", function()
    SET_LOCAL_BIT("fm_mission_controller", 15166, 7)
end)
menu.action(server, "NETWORK_PREVENT_SCRIPT_HOST_MIGRATION ", {""}, "", function()
    for _, script in ipairs(ALL_script) do
        util.request_script_host(script)
        util.spoof_script(script, function()
            NETWORK.NETWORK_PREVENT_SCRIPT_HOST_MIGRATION()
        end)
    end
end)
menu.action(server, "查询启动的游戏脚本 ", {""}, "", function()
    local POSITION = NETWORK.NETWORK_GET_POSITION_HASH_OF_THIS_SCRIPT()
    local INSTANCE = NETWORK.NETWORK_GET_INSTANCE_ID_OF_THIS_SCRIPT()
    for _, script in ipairs(ALL_script) do
        -- util.request_script_host(script)

        util.spoof_script(script, function()
            util.create_thread(function()

                latiao_log("script=" .. script .. "," .. "POSITION=" .. POSITION .. ",INSTANCE=" .. INSTANCE)
            end)
        end)
    end
end)

menu.toggle_loop(server, "查询是否为启动的游戏脚本主机NETWORK_IS_HOST_OF_THIS_SCRIPT", {""}, "",
    function()
        for _, script in ipairs(ALL_script) do
            -- util.request_script_host(script)
            util.create_thread(function()
                util.spoof_script(script, function()
                    -- latiao_log(script.."="..NETWORK.NETWORK_IS_HOST_OF_THIS_SCRIPT())
                    local hostinfo = script .. "=" .. NETWORK.NETWORK_IS_HOST_OF_THIS_SCRIPT()
                    util.draw_debug_text(hostinfo)
                end)
            end)
        end
    end)
menu.toggle_loop(server, "查询谁是否为启动的游戏脚本主机NETWORK_GET_HOST_OF_SCRIPT", {""}, "", function()
    for _, script in ipairs(ALL_script) do
        util.spoof_script(script, function()
            util.create_thread(function()
                local POSITION = NETWORK.NETWORK_GET_POSITION_HASH_OF_THIS_SCRIPT()
                local INSTANCE = NETWORK.NETWORK_GET_INSTANCE_ID_OF_THIS_SCRIPT()
                local Host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script, INSTANCE, POSITION)
                if Host ~= -1 then

                    local HostName = players.get_name(Host)
                    local scripthostinfo = script .. "=" .. HostName
                    util.draw_debug_text(scripthostinfo)
                    -- latiao_filter_log(scripthostinfo)
                end
            end)
        end)

    end

end)

menu.toggle_loop(server, "自动获取所有脚本主机2", {""}, "", function()
    for _, script in ipairs(ALL_script) do
        util.spoof_script(script, function()
            util.create_thread(function()
                local POSITION = NETWORK.NETWORK_GET_POSITION_HASH_OF_THIS_SCRIPT()
                local INSTANCE = NETWORK.NETWORK_GET_INSTANCE_ID_OF_THIS_SCRIPT()
                local Host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script, INSTANCE, POSITION)
                if Host ~= players.user() and Host ~= -1 then
                    latiao_log("尝试获取主机=" .. script .. ",Host=" .. Host, ",Name=" .. players.get_name(Host))
                    util.request_script_host(script)
                end
            end)

        end)
    end
end)

menu.toggle_loop(server, "将脚本主机给随机玩家", {""}, "", function()
    local list = players.list(false, true, true)
    local index = math.random(#list)
    for _, script in ipairs(ALL_script) do
        util.spoof_script(script, function()
            util.create_thread(function()
                local POSITION = NETWORK.NETWORK_GET_POSITION_HASH_OF_THIS_SCRIPT()
                local INSTANCE = NETWORK.NETWORK_GET_INSTANCE_ID_OF_THIS_SCRIPT()
                local Host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script, INSTANCE, POSITION)
                if Host == players.user() then
                    print(script .. "," .. index)
                    util.give_script_host(script, index)
                end
            end)

        end)
    end
end)

menu.toggle_loop(server, "自动获取所有脚本主机2阻止主机迁移", {""}, "", function()
    for _, script in ipairs(ALL_script) do
        util.spoof_script(script, function()
            util.create_thread(function()
                local POSITION = NETWORK.NETWORK_GET_POSITION_HASH_OF_THIS_SCRIPT()
                local INSTANCE = NETWORK.NETWORK_GET_INSTANCE_ID_OF_THIS_SCRIPT()
                local Host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script, INSTANCE, POSITION)

                if Host ~= players.user() and Host ~= -1 then
                    latiao_log("尝试获取主机并且阻止主机迁移=" .. script .. ",Host=" ..
                                   players.get_name(Host))
                    util.request_script_host(script)
                    NETWORK.NETWORK_PREVENT_SCRIPT_HOST_MIGRATION()
                end
            end)

        end)
    end
end)

menu.action(server, "强制获取所有脚本主机阻止主机迁移", {""}, "", function()
    for _, script in ipairs(ALL_script) do
        util.spoof_script(script, function()
            util.create_thread(function()

                util.request_script_host(script)
                NETWORK.NETWORK_PREVENT_SCRIPT_HOST_MIGRATION()

            end)

        end)
    end
end)

menu.toggle_loop(server, "所有人刷手办", {""}, "", function()
    local pickup = util.joaat("vw_prop_vw_colle_prbubble")
    util.request_model(pickup)
    for k, pid in pairs(players.list(false, true, true)) do
        local pos = players.get_position(pid)
        -- util.create_thread(function()

        OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y, pos.z, 0, 0, pickup, true, false)
        -- end)
    end
end)

menu.toggle_loop(server, "所有人刷纸牌", {""}, "", function()
    local pickup = util.joaat("vw_prop_vw_lux_card_01a")
    util.request_model(pickup)

    -- util.create_thread(function()
    for k, pid in pairs(players.list(false, true, true)) do
        local pos = players.get_position(pid)
        OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y, pos.z, 0, 0, pickup, true, false)
    end
    -- end)
end)

menu.toggle_loop(server, "刷手办给自己附近", {""}, "", function()
    local pickup = util.joaat("vw_prop_vw_colle_prbubble")
    util.request_model(pickup)

    local pos = players.get_position(players.user())
    OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y + 5, pos.z, 0, 0, pickup, true, false)

end)

menu.toggle_loop(server, "刷纸牌给自己附近", {""}, "", function()
    local pickup = util.joaat("vw_prop_vw_lux_card_01a")
    util.request_model(pickup)

    local pos = players.get_position(players.user())
    OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_CUSTOM_SCRIPT"), pos.x, pos.y + 5, pos.z, 0, 0, pickup, true, false)

end)

menu.toggle_loop(server, "过多实体vehicle掉帧/崩溃", {""},
    "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
        local vehicletobj = util.joaat("tug")
        util.request_model(vehicletobj)
        local pos = v3.new(0, 0, -198)
        local createobj = entities.create_vehicle(vehicletobj, pos, 0)
        util.create_thread(function()
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createobj, true, true)
            util.yield(0)
            entities.delete(createobj)
        end)

    end)

menu.toggle_loop(server, "过多object实体掉帧/崩溃", {""},
    "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
        local pos = v3.new(0, 0, -198)
        local objectobj = util.joaat("p_spinning_anus_s")
        util.request_model(objectobj)
        local createobj = entities.create_object(objectobj, pos)

        util.create_thread(function()
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createobj, true, true)
            util.yield(0)
            entities.delete(createobj)
        end)

    end)

menu.toggle_loop(server, "过多ped实体掉帧/崩溃", {""},
    "配合使用 线上/保护选项/同步信息/传出/克隆删除/阻止", function()
        local pos = v3.new(0, 0, -198)
        local pedobj = util.joaat("s_m_y_cop_01")
        util.request_model(pedobj)
        local createpedobj = entities.create_ped(24, pedobj, pos, 0)
        util.create_thread(function()
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createpedobj, true, true)
            util.yield(0)
            entities.delete(createpedobj)
        end)
    end)

menu.toggle_loop(dividends_general, "所有任务最低玩家限制为0", {""}, "", function()
    local status, err = pcall(function()
        local iArrayPos = GET_INT_LOCAL("fmmc_launcher", 19709 + 34)
        SET_INT_GLOBAL(794744 + 4 + 1 + iArrayPos * 89 + 69, 1)
        SET_INT_LOCAL("fmmc_launcher", 19709 + 15, 1)
        SET_INT_GLOBAL(4718592 + 3523, 1)
        SET_INT_GLOBAL(4718592 + 3529 + 1, 1)
        SET_INT_GLOBAL(4718592 + 178821 + 1, 0)
        SET_INT_GLOBAL(4718592 + 3526, 1)
        SET_INT_GLOBAL(4718592 + 3527, 1)
    end)
    if not status then
        -- latiao_log(err)
    end
end)
menu.action(dividends_general, "跳过检查点", {""}, "", function()
    local status, err = pcall(function()
        SET_LOCAL_BIT("fm_mission_controller", 19746 + 2, 17)
    end)
    if not status then
        -- latiao_log(err)
    end
end)

menu.action(test, "绑定所有实体到自己ATTACH_ENTITY_TO_ENTITY all", {""}, ".", function()
    for _, entity in ipairs(ALL_Entities()) do
        ENTITY.ATTACH_ENTITY_TO_ENTITY(entity, players.user_ped(), 0, 0, 0, 0, 0, 0, 0, false, false, false, false, 0,
            false, 0)

    end
end)

menu.action(test, "触发过场动画START_CUTSCENE", {""}, ".", function()
    CUTSCENE.REQUEST_CUTSCENE("fin_a_int", 0)

    CUTSCENE.START_CUTSCENE(0)

end)

menu.toggle_loop(test, "爆炸所有车EXPLODE_VEHICLE_IN_CUTSCENE", {""}, ".", function()

    for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
        VEHICLE.EXPLODE_VEHICLE_IN_CUTSCENE(target)
    end
end)

menu.toggle_loop(test, "爆炸所有车NETWORK_EXPLODE_VEHICLE", {""}, ".", function()

    for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
        NETWORK.NETWORK_EXPLODE_VEHICLE(target, true, false, 0)
    end
end)

menu.toggle_loop(server, "所有人无限加血give_pickup_reward", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do

        players.give_pickup_reward(pid, "REWARD_HEALTH")
        util.yield()

    end
end)
menu.toggle_loop(server, "所有人无限加防弹衣give_pickup_reward", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do

        players.give_pickup_reward(pid, "REWARD_ARMOUR")
        util.yield()

    end
end)
menu.toggle_loop(server, "所有人无限修车give_pickup_reward", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do

        players.give_pickup_reward(pid, "REWARD_VEHICLE_FIX")
        util.yield()

    end
end)

menu.toggle_loop(server, "所有人实名爆炸", {""}, "", function()

    for k, pid in pairs(players.list(false, true, true)) do
        local pos = players.get_position(pid)
        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, math.random(0, 82), INT_MAX, true, false,
            INT_MAX)
    end
end)
menu.toggle_loop(server, "所有人实名无伤爆炸", {""}, "", function()

    for k, pid in pairs(players.list(false, true, true)) do
        local pos = players.get_position(pid)
        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, 0, false, true, 0.0)
    end
end)

menu.action(server, "无效人物伞崩", {""}, "", function()
    WEAPON.GIVE_DELAYED_WEAPON_TO_PED(players.user_ped(), util.joaat("gadget_parachute"), INT_MAX, false)
    PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), util.joaat("v_ind_meatpacks_03"))
    TASK.TASK_PARACHUTE_TO_TARGET(players.user_ped(), 0, 0, 0)

end)
menu.action(server, "清理无效人物伞崩CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE", {""}, "", function()

    TASK.CLEAR_PED_TASKS_IMMEDIATELY(players.user_ped())
    PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())

end)

menu.action(server, "重新生成自身NETWORK_RESURRECT_LOCAL_PLAYER", {""}, "", function()
    NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(0, 0, 100, 0, false, false, false, 0, 0)
end)

menu.toggle_loop(server, "打印观看玩家记录到控制台", {""}, "", function()
    for k, pid in pairs(players.list()) do
        local spectate = players.get_spectate_target(pid)
        if spectate ~= -1 then
            latiao_filter_log(players.get_name(pid) .. "正在观看" .. players.get_name(spectate))
        end

    end

end)

menu.action(server, "无效收藏品脚本事件踢所有人", {"latiaokickallexcludehost"}, "latiaokickallexcludehost",
    function()

        util.trigger_script_event(util.get_session_players_bitflag(), {968269233, players.user(), 4, 233, 1, 1, 1})

    end)

menu.toggle_loop(dividends_bjbgs, "所有目标奖励40000", {""}, "", function()

    STAT_SET_INT("BOUNTY24_STD_TARG_RWD_0", 40000)
    STAT_SET_INT("BOUNTY24_STD_TARG_RWD_1", 40000)
    STAT_SET_INT("BOUNTY24_STD_TARG_RWD_2", 40000)
end)

menu.toggle_loop(world, "GIVE_WEAPON_TO_PED all", {}, "", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            WEAPON.GIVE_WEAPON_TO_PED(ent, util.joaat("weapon_pistol"), INT_MAX, false, true)
        end
    end
end)

menu.toggle_loop(server, "对作弊玩家被动", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do

        if players.is_marked_as_modder(pid) then

            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
        end

    end

end)

local servermoney = menu.list(menu.my_root(), "服务器交易", {}, "")

menu.toggle_loop(server, "对无敌玩家被动", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do

        if players.is_godmode(pid) then

            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
        end

    end

end)

menu.action(server, "取消对所有玩家被动", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do

        -- if players.is_marked_as_modder(pid) then

        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
        -- end

    end

end)

-- menu.action(test,"entities.player_info_get_game_state",{""},"",function()
--     for k, pid in pairs(players(false,true,true)) do
--         local playersped = players.get

--     end

-- end

-- )

local servermoney = menu.list(servermoney, "中等服务器交易", {}, "")

menu.action(servermoney, "赌场分红", {""}, "", function()
    latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_CASINO_HEIST_FINALE"))
end)

menu.action(servermoney, "佩里克岛直接分红", {""}, "", function()
    latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_ISLAND_HEIST_FINALE"))
end)

menu.action(servermoney, "末日豪直接分红", {""}, "", function()
    latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_GANGOPS_FINALE"))
end)

menu.toggle_loop(servermoney, "普通任务奖励(无冷却)", {""}, "", function()
    latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_JOBS"))
end)

menu.action(servermoney, "SERVICE_EARN_JOB_BONUS", {""}, "", function()
    latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_JOB_BONUS"))
end)
menu.action(servermoney, "SERVICE_EARN_BEND_JOB", {""}, "", function()
    latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_BEND_JOB"))
end)

menu.toggle_loop(world, "删除拥有网络所有权的所有物体", {""}, "delallobjects.", function()
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        util.create_thread(function()
            if entities.get_owner(ent) == players.user() and NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then

                entities.delete(ent)

            end
        end)
    end
end)

menu.toggle_loop(world, "删除拥有网络所有权的所有npc", {""}, "delallpeds.", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        util.create_thread(function()
            if entities.get_owner(ent) == players.user() and NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then

                entities.delete(ent)

            end
        end)
    end
end)

menu.toggle_loop(world, "删除拥有网络所有权的所有车", {""}, "delallvehicles.", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        util.create_thread(function()
            if entities.get_owner(ent) == players.user() and NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then

                entities.delete(ent)
            end
        end)
    end
end)

menu.toggle_loop(world, "删除拥有网络所有权的可拾取物品", {""}, "delallvehicles.", function()
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        util.create_thread(function()
            if entities.get_owner(ent) == players.user() and NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then

                entities.delete(ent)
            end
        end)
    end
end)

menu.toggle_loop(world, "删除拥有网络所有权的所有", {""}, "delall.", function()

    for _, ent in ipairs(ALL_Entities()) do
        util.create_thread(function()
            if entities.get_owner(ent) == players.user() and NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then

                entities.delete(ent)

            end
        end)
    end
end)

menu.toggle_loop(world, "随机玩家击杀 自己 ", {""}, "", function()
    local list = players.list()
    local index = math.random(#list)

    local randomPid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(list[index])

    local pos = v3.new(players.get_position(players.user()))
    FIRE.ADD_OWNED_EXPLOSION(randomPid, pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)

end)

menu.toggle_loop(world, "删除网络所有权异常的所有", {""}, "delall.", function()

    for _, ent in ipairs(ALL_Entities()) do
        util.create_thread(function()
            if entities.get_owner(ent) == 255 then

                entities.delete(ent)

            end
        end)
    end
end)

menu.toggle_loop(server, "随机假身作弊", {"latiaofakepos"}, ("latiaofakepos"), function()
    menu.trigger_commands(
        "spoofedposition " .. math.random(-10000, 10000) .. "," .. math.random(-10000, 10000) .. "," ..
            math.random(-200, 1500))
    util.yield(100)

end)

menu.action(server, "超时所有绿色玩家", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if not players.is_marked_as_modder(pid) then
            local attack = players.get_name(pid)
            menu.trigger_commands("desync" .. attack .. " on")
        end

        ::out::
    end

end)

menu.action(server, "阻止传出所有作弊玩家", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if players.is_marked_as_modder(pid) then
            local attack = players.get_name(pid)
            -- menu.trigger_commands("timeout" .. attack .. " on")
            menu.trigger_commands("desync" .. attack .. " on")
        end

        ::out::
    end

end)

menu.slider(dividends_general, "设置抢劫金钱", {"setfmccash"}, "", 0, INT_MAX, 0, 1, function(value)
    SET_INT_LOCAL("fm_mission_controller", 19746 + 2686, value)

end)

menu.action(server, "所有人强制开启拉机能量跳伞", {""}, "", function()

    util.trigger_script_event(util.get_session_players_bitflag(), {1450115979, players.user(), 267, -1})

end)

menu.toggle_loop(server, "给与小于125等级的人刷经验(直到他等级达到125)", {""}, "", function()
    for k, pid in pairs(players.list(true, true, true)) do
        if players.get_rank(pid) < 125 then
            util.trigger_script_event(1 << pid, {968269233, pid, 4, 21, 1, 1, 1})
        end

    end
end)

menu.action(world, "get_vehicles all", {""}, "", function()
    local vehicles = util.get_vehicles()

    for index, vehicle in ipairs(vehicles) do
        print("Vehicle " .. index .. ":")
        print("Name: " .. vehicle.name)
        print("Manufacturer: " .. vehicle.manufacturer)
        print("Class: " .. vehicle.class)

    end

end)

menu.toggle_loop(world, "随机载具填充池", {""}, "", function()
    local pos = v3.new(0, 0, 0)
    local vehicles = util.get_vehicles()

    local random_index = math.random(1, #vehicles)
    local random_vehicle = vehicles[random_index]

    local vehicletobj = util.joaat(random_vehicle.name)
    util.request_model(vehicletobj)
    util.create_thread(function()
        local createobj = entities.create_vehicle(vehicletobj, pos, 0)
        ENTITY.FREEZE_ENTITY_POSITION(createobj)
        util.yield(1)
        entities.delete(createobj)

    end)

end)

menu.action(world, "all vehicles SET_MODEL_AS_NO_LONGER_NEEDED", {""}, "", function()
    local vehicles = util.get_vehicles()

    for index, vehicle in ipairs(vehicles) do
        local vehicle = util.joaat(vehicle.name)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicle)
    end

end)

menu.action(world, "all vehicles util.request_model", {""}, "", function()
    local vehicles = util.get_vehicles()

    for index, vehicle in ipairs(vehicles) do
        local vehicle = util.joaat(vehicle.name)
        util.request_model(vehicle)

    end

end)

menu.toggle_loop(server, "NETWORK_SESSION_GET_KICK_VOTE", {""}, "", function()
    print(NETWORK.NETWORK_SESSION_GET_KICK_VOTE(players.user()))

end)
menu.toggle_loop(server, "", {""}, "", function()

    util.trigger_script_event(util.get_session_players_bitflag(), {-972329058, players.user(), 0})

end)

menu.toggle_loop(world, "所有人不会射击你", {""}, "", function()
    PED.SET_PED_RESET_FLAG(players.user_ped(), 124, true)

end)

menu.toggle_loop(world, "SET_RIOT_MODE_ENABLED", {""}, "", function()

    MISC.SET_RIOT_MODE_ENABLED(true)
end, function()
    MISC.SET_RIOT_MODE_ENABLED(false)

end)

menu.action(server, "超时所有作弊玩家", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if players.is_marked_as_modder(pid) then
            local attack = players.get_name(pid)
            menu.trigger_commands("timeout" .. attack .. " on")
        end

        ::out::
    end

end)

menu.action(server, "绳子全局崩", {""}, "", function()

    PHYSICS.ADD_ROPE(0, 0, 0, 0, 0, 0, INT_MAX, 4, INT_MAX, 0, INT_MAX, false, false, false, 0, false, 0)

end)

menu.action(server, "强制送披萨", {""}, "", function()

    -- util.trigger_script_event(util.get_session_players_bitflag(), {1613825825, players.user(), 340, -1,-1,-1,-1})
    util.trigger_script_event(util.get_session_players_bitflag(), {1450115979, players.user(), 340, -1, -1, -1, -1})

end)
menu.action(test, "ACTIVATE_PHYSICS", {""}, "", function()

    PHYSICS.ACTIVATE_PHYSICS(players.user_ped())

end)

menu.toggle_loop(server, "get_all_objects_as_handles 实体", {"latiaoREQUES_ENTITYobjects"}, "REQUES_ENTITYobjects.",
    function()
        for k, ent in pairs(entities.get_all_objects_as_handles()) do
            print(ent)
        end

    end)
-- menu.slider_float(world, "变速", {"SET_RAIN"}, "", INT_MIN, INT_MAX, -1, 1, function(value)
--     MISC.SET_TIME_SCALE(value)
-- end)
menu.toggle_loop(test, "自动收集(空格连点)", {""}, "", function()
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 224, 1)

    util.yield()
end)
local szc = menu.list(menu.my_root(), "收支差", {}, "")
menu.action(szc, "查询收支差", {""}, "", function()

    local get_money = players.get_money(players.user())
    local SHOURU = STAT_GET_INT("MPPLY_TOTAL_EVC")
    local HUAFEI = STAT_GET_INT("MPPLY_TOTAL_SVC")
    local remaining_money = get_money - HUAFEI - SHOURU
    util.toast(remaining_money, TOAST_ALL)

end)

-- menu.action(szc, "清理收支差", {""}, "", function()
--     local get_money = players.get_money(players.user())
--     local SHOURU = STAT_GET_INT("MPPLY_TOTAL_EVC")
--     local HUAFEI = STAT_GET_INT("MPPLY_TOTAL_SVC")
--     local remaining_money = get_money - HUAFEI - SHOURU
--     if remaining_money < 0 then
--         local fix = HUAFEI + remaining_money
--         print("MPPLY_TOTAL_SVC"..fix )
--         STAT_SET_INT("MPPLY_TOTAL_SVC",fix)

--     elseif remaining_money > 0 then
--         local fix = SHOURU + remaining_money
--         print("MPPLY_TOTAL_EVC"..fix)
--         STAT_SET_INT("MPPLY_TOTAL_EVC", fix)

--     end
-- end)

menu.toggle_loop(server, "随机假身作弊", {"latiaofakepos"}, ("latiaofakepos"), function()
    local pos = players.get_position(players.user())
    local x = pos.x + math.random(1, 5)
    local y = pos.y + math.random(1, 5)
    local z = pos.z + math.random(1, 5)

    menu.trigger_commands("spoofedposition " .. x .. "," .. y .. "," .. z)
    util.yield(100)

end)

-- menu.action(server, "循环抢劫所有人开", {""}, ".", function()
--     for k, pid in pairs(players.list(false, true, true)) do
--         local player = players.get_name(pid)
--         menu.trigger_commands("mugloop" .. player .. " on")
--     end

-- end)

-- menu.action(server, "循环抢劫所有人关", {""}, ".", function()
--     for k, pid in pairs(players.list(false, true, true)) do
--         local player = players.get_name(pid)
--         menu.trigger_commands("mugloop" .. player .. " off")
--     end

-- end)

local dividends_Tunable = menu.list(dividends, "可调参数", {}, "")
menu.action(dividends_Tunable, "刷新游戏可调参数", {""}, "", function()
    SET_INT_LOCAL("social_controller", 65, 1)

end)

NpcCut = {28313, -- CH_LESTER_CUT
28339, -- HEIST3_PREPBOARD_GUNMEN_KARL_CUT
28340, -- HEIST3_PREPBOARD_GUNMEN_GUSTAVO_CUT
28341, -- HEIST3_PREPBOARD_GUNMEN_CHARLIE_CUT
28342, -- HEIST3_PREPBOARD_GUNMEN_CHESTER_CUT
28343, -- HEIST3_PREPBOARD_GUNMEN_PATRICK_CUT
28344, -- HEIST3_DRIVERS_KARIM_CUT
28345, -- HEIST3_DRIVERS_TALIANA_CUT
28346, -- HEIST3_DRIVERS_EDDIE_CUT
28347, -- HEIST3_DRIVERS_ZACH_CUT
28348, -- HEIST3_DRIVERS_CHESTER_CUT
28349, -- HEIST3_HACKERS_RICKIE_CUT
28350, -- HEIST3_HACKERS_CHRISTIAN_CUT
28351, -- HEIST3_HACKERS_YOHAN_CUT
28352, -- HEIST3_HACKERS_AVI_CUT
28353, -- HEIST3_HACKERS_PAIGE_CUT
22475, -- SMUG_SELL_RONS_CUT
24074, -- BB_SELL_MISSIONS_TONYS_CUT
29467, -- IH_DEDUCTION_FENCING_FEE
29468, -- IH_DEDUCTION_PAVEL_CUT
30334 -- TUNER_ROBBERY_CONTACT_FEE
}

MissionCooldowns = {15499, -- EXEC_BUY_COOLDOWN
15500, -- EXEC_SELL_COOLDOWN
19077, -- IMPEXP_STEAL_COOLDOWN
19153, -- IMPEXP_SELL_COOLDOWN
19432, -- IMPEXP_SELL_1_CAR_COOLDOWN
19433, -- IMPEXP_SELL_2_CAR_COOLDOWN
19434, -- IMPEXP_SELL_3_CAR_COOLDOWN
19435, -- IMPEXP_SELL_4_CAR_COOLDOWN
22433, -- SMUG_STEAL_EASY_COOLDOWN_TIMER
22434, -- SMUG_STEAL_MED_COOLDOWN_TIMER
22435, -- SMUG_STEAL_HARD_COOLDOWN_TIMER
22436, -- SMUG_STEAL_ADDITIONAL_CRATE_COOLDOWN_TIME
22474, -- SMUG_SELL_SELL_COOLDOWN_TIMER
26794, -- VC_WORK_REQUEST_COOLDOWN
31038, -- FIXER_SECURITY_CONTRACT_COOLDOWN_TIME
31118, -- REQUEST_FRANKLIN_PAYPHONE_HIT_COOLDOWN
31892, -- EXPORT_CARGO_LAUNCH_CD_TIME
32005, -- SUM2_BUNKER_DUNELOADER_TIMER
32183, -- BUNKER_SOURCE_RESEARCH_CD_TIME
32184, -- NIGHTCLUB_SOURCE_GOODS_CD_TIME
33141, -- JUGALLO_BOSS_WORK_COOLDOWN_TIME
24026, -- BB_CLUB_MANAGEMENT_CLUB_MANAGEMENT_MISSION_COOLDOWN
24067, -- BB_SELL_MISSIONS_MISSION_COOLDOWN
31880, -- NC_TROUBLEMAKER_MIN_DELAY_IN_MINUTES
31881, -- NC_TROUBLEMAKER_MAX_DELAY_IN_MINUTES
24208, -- BB_HACKER_WORK_CLIENT_WORK_GLOBAL_COOLDOWN
24209, -- BB_HACKER_WORK_CLIENT_WORK_COOLDOWN_BANK_JOB
24210, -- BB_HACKER_WORK_CLIENT_WORK_COOLDOWN_DATA_HACK
24211, -- BB_HACKER_WORK_CLIENT_WORK_COOLDOWN_INFILTRATION
24212, -- BB_HACKER_WORK_CLIENT_WORK_COOLDOWN_JEWEL_STORE_GRAB
24213, -- BB_HACKER_WORK_HACKER_CHALLENGE_COOLDOWN_GLOBAL_COOLDOWN
24214, -- BB_HACKER_WORK_HACKER_CHALLENGE_COOLDOWN_SECURITY_VANS
24215, -- BB_HACKER_WORK_HACKER_CHALLENGE_COOLDOWN_TARGET_PURSUIT
18571, -- BIKER_CLUB_WORK_COOLDOWN_GLOBAL
31870, -- BIKER_RESUPPLY_MISSION_COOLDOWN
4382, -- ON_CALL_HEIST_COOLDOWN
4387, -- NEXT_TEXT_DELAY_H
4388, -- PLAYED_NEXT_TEXT_DELAY_H
4383, -- H2_ON_CALL_FINALE_COOLDOWN_2_PLAYER
4384, -- H2_ON_CALL_FINALE_COOLDOWN_3_PLAYER
4385, -- H2_ON_CALL_FINALE_COOLDOWN_4_PLAYER
23010, -- H2_IAA_REPLAY_COOLDOWN_TIME
23011, -- H2_SUB_REPLAY_COOLDOWN_TIME
23012, -- H2_REPLAY_COOLDOWN_2_PLAYER_IAA
23013, -- H2_REPLAY_COOLDOWN_2_PLAYER_SUB
23014, -- H2_REPLAY_COOLDOWN_2_PLAYER_SILO
23015, -- H2_REPLAY_COOLDOWN_3_PLAYER_IAA
23016, -- H2_REPLAY_COOLDOWN_3_PLAYER_SUB
23017, -- H2_REPLAY_COOLDOWN_3_PLAYER_SILO
23018, -- H2_REPLAY_COOLDOWN_4_PLAYER_IAA
23019, -- H2_REPLAY_COOLDOWN_4_PLAYER_SUB
23020, -- H2_REPLAY_COOLDOWN_4_PLAYER_SILO
23021, -- H2_SILO_REPLAY_COOLDOWN_TIME
4364, -- CASINO_HEIST_ON_CALL_COOL_DOWN
28399, -- H3_HEIST_COOLDOWN_BEFORE_REPLAY
4365, -- ISLAND_HEIST_ON_CALL_COOL_DOWN
29380, -- H4_COOLDOWN_TIME
29381, -- H4_COOLDOWN_HARD_TIME
29382, -- H4_SOLO_COOLDOWN
30357, -- TUNER_ROBBERY_COOLDOWN_TIME
31036, -- FIXER_STORY_COOLDOWN_POSIX
33064, -- SALV23_VEH_ROB_COOLDOWN_TIME
33065 -- SALV23_CFR_COOLDOWN_TIME
}

RequestCooldowns = {11708, -- PEGASUS_CRIM_COOL_DOWN
11942, -- LESTER_VEHICLE_CRIM_COOL_DOWN
12813, -- GB_CALL_VEHICLE_COOLDOWN
19018, -- SV_MECHANIC_COOLDOWN
21286, -- GR_MOBILE_OPERATIONS_CENTRE_COOLDOWN_TIMER
21289, -- AA_TRAILER_EQ_COOLDOWN_TIMER
21573, -- ACID_LAB_REQUEST_COOLDOWN
22371, -- SMUG_REQUEST_PERSONAL_AIRCRAFT_COOLDOWN
22743, -- H2_AVENGER_INTN_MENU_REQUEST_AVENGER_COOLDOWN
24068, -- BB_SELL_MISSIONS_DELIVERY_VEHICLE_COOLDOWN_AFTER_SELL_MISSION
24234, -- BB_TERRORBYTE_DRONE_COOLDOWN_TIME
24266, -- BB_TERRORBYTE_TERRORBYTE_COOLDOWN_TIMER
24282, -- BB_SUBMARINE_REQUEST_COOLDOWN_TIMER
24283, -- BB_SUBMARINE_DINGHY_REQUEST_COOLDOWN_TIMER
25373, -- BANDITO_COOLDOWN_TIME
25374, -- TANK_COOLDOWN_TIME
27932, -- VC_COOLDOWN_REQUEST_CAR_SERVICE
27933, -- VC_COOLDOWN_REQUEST_LIMO_SERVICE
27968, -- OPPRESSOR2CD
30224, -- IH_MOON_POOL_COOLDOWN
31119, -- REQUEST_COMPANY_SUV_SERVICE_COOLDOWN
31114, -- IMANI_SOURCE_MOTORCYCLE_COOLDOWN
32538, -- TONY_LIMO_COOLDOWN_TIME
32539, -- BUNKER_VEHICLE_COOLDOWN_TIME
33142, -- JUGALLO_BOSS_VEHICLE_COOLDOWN_TIME
12815, -- GB_DROP_AMMO_COOLDOWN
12816, -- GB_DROP_ARMOR_COOLDOWN
12817, -- GB_DROP_BULLSHARK_COOLDOWN
12818, -- GB_GHOST_ORG_COOLDOWN
12819, -- GB_BRIBE_AUTHORITIES_COOLDOWN
20906, -- BALLISTICARMOURREQUESTCOOLDOWN
23609, -- H2_STRIKE_TEAM_COOLDOWN_TIMER
31112, -- FRANKLIN_SUPPLY_STASH_COOLDOWN
31116 -- IMANI_OUT_OF_SIGHT_COOLDOWN
}
menu.toggle_loop(dividends_Tunable, "禁用npc分红", {""}, "", function()

    for _, list in pairs(NpcCut) do
        SET_INT_GLOBAL(262145 + list, 0)
    end

end)

menu.toggle_loop(dividends_Tunable, "禁用任务和抢劫冷却", {""}, "", function()

    for _, list in pairs(MissionCooldowns) do
        SET_INT_GLOBAL(262145 + list, 0)
    end
end)

menu.toggle_loop(dividends_Tunable, "禁用请求冷却", {""}, "", function()
    for _, list in pairs(RequestCooldowns) do
        SET_INT_GLOBAL(262145 + list, 0)
    end

end)

menu.slider(dividends_Tunable, "自定义所有任务分红金额", {"MISSIONS_MODIFIER"}, "MISSIONS_MODIFIER", 0,
    INT_MAX, 100, 1, function(value)

        SET_INT_GLOBAL(262145 + 2403, value)
        SET_INT_GLOBAL(262145 + 2407, value)

    end)
function GLOBAL_SET_BOOL(global, value)
    memory.write_int(memory.script_global(global), value and 1 or 0)
end
function GLOBAL_GET_BOOL(global)
    return memory.read_int(memory.script_global(global)) == 1
end

menu.action(server, "无效开始任务踢所有人", {""}, "", function()

    util.trigger_script_event(util.get_session_players_bitflag(), {1450115979, players.user(), 1})

end)

menu.action(server, "无效开始任务踢所有人排除主机和作弊", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if pid == players.get_host() or players.is_marked_as_modder(pid) then
            goto out
        end

        util.trigger_script_event(1 << pid, {1450115979, players.user(), 1})

        ::out::

    end
end)

menu.action(server, "所有人开始任务藏匿屋", {""}, "", function()

    util.trigger_script_event(util.get_session_players_bitflag(), {1450115979, players.user(), 308})

end)

menu.toggle_loop(world, "循环CREATE_RANDOM_PED池填充", {""}, "", function()
    local pos = players.get_position(players.user())
    local createobj = PED.CREATE_RANDOM_PED(pos.x, pos.y, pos.z)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(createobj, true, true)

    util.yield(1)
    entities.delete(createobj)

end)

-- menu.action(servermoney, "SERVICE_EARN_GANGOPS_AWARD_MASTERMIND_4", {""}, "", function()
--     latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_GANGOPS_AWARD_MASTERMIND_4"))
-- end)
-- menu.action(servermoney, "SERVICE_EARN_JOB_BONUS_CRIMINAL_MASTERMIND", {""}, "", function()
--     latiao_server_TRANSACTION(util.joaat("SERVICE_EARN_JOB_BONUS_CRIMINAL_MASTERMIND"))
-- end)

menu.toggle_loop(world, "循环发送我的坐标", {""}, "", function()
    local pos = players.get_position(players.user())
    print(pos.x .. "," .. pos.y .. "," .. pos.z)

end)
menu.toggle_loop(test, "暂停freemode", {""}, "", function()
    util.spoof_script("freemode", function()
        SYSTEM.WAIT("0")
    end)
end)
menu.toggle_loop(test, "暂停所有游戏脚本", {""}, "", function()
    for _, script in ipairs(ALL_script) do

        util.spoof_script(script, function()
            SYSTEM.WAIT("0")
        end)
    end
end)
menu.toggle_loop(test, "暂停fm_mission_controller", {""}, "", function()
    util.spoof_script("fm_mission_controller", function()
        SYSTEM.WAIT("0")
    end)
end)

menu.toggle_loop(test, "暂停fm_mission_controller_2020", {""}, "", function()
    util.spoof_script("fm_mission_controller_2020", function()
        SYSTEM.WAIT("0")
    end)
end)

menu.action(server, "开启派遣工作", {""}, "", function()

    util.trigger_script_event(util.get_session_players_bitflag(), {1450115979, players.user(), 339, -1})

end)

menu.toggle_loop(server, "刷钱袋", {""}, "", function()
    local pickup = util.joaat("prop_cash_pile_01")
    util.request_model(pickup)
    local pos = players.get_position(players.user())

    OBJECT.CREATE_AMBIENT_PICKUP(util.joaat("PICKUP_MONEY_CASE"), pos.x, pos.y, pos.z, 0, math.random(1, 2000), pickup,
        true, false)

end)
menu.action(server, "所有人送上ufo", {""}, "", function()
    util.trigger_script_event(util.get_session_players_bitflag(), {1450115979, players.user(), 314, -1})

end)

menu.toggle_loop(server, "情书踢无敌玩家(误报几率大)", {""}, "", function()
    for k, pid in pairs(players.list(false, true, true)) do
        if pid == players.get_host() then
            goto out
        end
        if players.is_godmode(pid) then
            local attack = players.get_name(pid)
            menu.trigger_commands("loveletterkick" .. attack)
        end

        ::out::
    end

end)
menu.action(server, "送上ufo 排除主机和作弊玩家", {"latiaokickallexcludehost"}, "latiaokickallexcludehost",
    function()
        for k, pid in pairs(players.list(false, true, true)) do
            if pid == players.get_host() or players.is_marked_as_modder(pid) then
                goto out
            end
            util.trigger_script_event(1 << pid, {1450115979, players.user(), 314, -1})
            ::out::
        end

    end)

-- menu.action(server, "所有人送上ufo", {""}, "", function()
--     util.trigger_script_event(util.get_session_players_bitflag(), {1450115979, players.user(), 314, -1})

-- end)

local   weapons = {
    "WEAPON_UNARMED",
    "WT_UNARMED",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_ANIMAL",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_COUGAR",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_KNIFE",
    "WT_KNIFE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_KNIFE_VARMOD_XM3",
    "WCT_KNIFE_XM3",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_01",
    "WCT_KNIFE_XM301",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_02",
    "WCT_KNIFE_XM302",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_03",
    "WCT_KNIFE_XM303",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_04",
    "WCT_KNIFE_XM304",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_05",
    "WCT_KNIFE_XM305",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_06",
    "WCT_KNIFE_XM306",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_07",
    "WCT_KNIFE_XM307",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_08",
    "WCT_KNIFE_XM308",
    "WCD_VAR_DESC",
    "COMPONENT_KNIFE_VARMOD_XM3_09",
    "WCT_KNIFE_XM309",
    "WCD_VAR_DESC",
    "WEAPON_NIGHTSTICK",
    "WT_NGTSTK",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_HAMMER",
    "WT_HAMMER",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BAT",
    "WT_BAT",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_BAT_VARMOD_XM3",
    "WCT_BAT_XM3",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_01",
    "WCT_BAT_XM301",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_02",
    "WCT_BAT_XM302",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_03",
    "WCT_BAT_XM303",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_04",
    "WCT_BAT_XM304",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_05",
    "WCT_BAT_XM305",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_06",
    "WCT_BAT_XM306",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_07",
    "WCT_BAT_XM307",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_08",
    "WCT_BAT_XM308",
    "WCD_VAR_DESC",
    "COMPONENT_BAT_VARMOD_XM3_09",
    "WCT_BAT_XM309",
    "WCD_VAR_DESC",
    "WEAPON_GOLFCLUB",
    "WT_GOLFCLUB",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_CROWBAR",
    "WT_CROWBAR",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_PISTOL",
    "WT_PIST",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_PISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_P_CLIP1",
    "COMPONENT_PISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_P_CLIP2",
    "COMPONENT_AT_PI_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_PI_SUPP_02",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_PISTOL_VARMOD_LUXE",
    "WCT_VAR_GOLD",
    "WCD_VAR_P",
    "COMPONENT_PISTOL_CLIP_01",
    "COMPONENT_PISTOL_CLIP_02",
    "COMPONENT_AT_PI_FLSH",
    "COMPONENT_AT_PI_SUPP_02",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_COMBATPISTOL",
    "WT_PIST_CBT",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_COMBATPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_CP_CLIP1",
    "COMPONENT_COMBATPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_CP_CLIP2",
    "COMPONENT_AT_PI_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_PI_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
    "WCT_VAR_GOLD",
    "WCD_VAR_CBP",
    "COMPONENT_COMBATPISTOL_CLIP_01",
    "COMPONENT_COMBATPISTOL_CLIP_02",
    "COMPONENT_AT_PI_FLSH",
    "COMPONENT_AT_PI_SUPP",
    "COMPONENT_COMBATPISTOL_VARMOD_XMAS23",
    "WCD_VAR_DESC",
    "WEAPON_APPISTOL",
    "WT_PIST_AP",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_APPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_AP_CLIP1",
    "COMPONENT_APPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_AP_CLIP2",
    "COMPONENT_AT_PI_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_PI_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_APPISTOL_VARMOD_LUXE",
    "WCT_VAR_METAL",
    "WCD_VAR_AP",
    "COMPONENT_APPISTOL_CLIP_01",
    "COMPONENT_APPISTOL_CLIP_02",
    "COMPONENT_AT_PI_FLSH",
    "COMPONENT_AT_PI_SUPP",
    "COMPONENT_APPISTOL_VARMOD_SECURITY",
    "WCT_VAR_STUD",
    "WCD_VAR_AP",
    "WEAPON_PISTOL50",
    "WT_PIST_50",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_PISTOL50_CLIP_01",
    "WCT_CLIP1",
    "WCD_P50_CLIP1",
    "COMPONENT_PISTOL50_CLIP_02",
    "WCT_CLIP2",
    "WCD_P50_CLIP2",
    "COMPONENT_AT_PI_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_PISTOL50_VARMOD_LUXE",
    "WCT_VAR_SIL",
    "WCD_VAR_P50",
    "COMPONENT_PISTOL50_CLIP_01",
    "COMPONENT_PISTOL50_CLIP_02",
    "COMPONENT_AT_PI_FLSH",
    "COMPONENT_AT_AR_SUPP_02",
    "WEAPON_MICROSMG",
    "WT_SMG_MCR",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MICROSMG_CLIP_01",
    "WCT_CLIP1",
    "WCDMSMG_CLIP1",
    "COMPONENT_MICROSMG_CLIP_02",
    "WCT_CLIP2",
    "WCDMSMG_CLIP2",
    "COMPONENT_AT_PI_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_MACRO",
    "WCT_SCOPE_MAC",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_MICROSMG_VARMOD_LUXE",
    "WCT_VAR_GOLD",
    "WCD_VAR_MSMG",
    "COMPONENT_MICROSMG_CLIP_01",
    "COMPONENT_MICROSMG_CLIP_02",
    "COMPONENT_AT_PI_FLSH",
    "COMPONENT_AT_SCOPE_MACRO",
    "COMPONENT_AT_AR_SUPP_02",
    "COMPONENT_MICROSMG_VARMOD_SECURITY",
    "WCT_VAR_WEED",
    "WCD_VAR_MSMG",
    "COMPONENT_MICROSMG_VARMOD_XM3",
    "WCT_MSMG_XM3",
    "WCD_VAR_DESC",
    "COMPONENT_MICROSMG_VARMOD_FRN",
    "WCD_VAR_DESC",
    "WEAPON_SMG",
    "WT_SMG",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_SMG_CLIP_01",
    "WCT_CLIP1",
    "WCD_SMG_CLIP1",
    "COMPONENT_SMG_CLIP_02",
    "WCT_CLIP2",
    "WCD_SMG_CLIP2",
    "COMPONENT_SMG_CLIP_03",
    "WCT_CLIP_DRM",
    "WCD_CLIP3",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_MACRO_02",
    "WCT_SCOPE_MAC",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_PI_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_SMG_VARMOD_LUXE",
    "WCT_VAR_GOLD",
    "WCD_VAR_SMG",
    "COMPONENT_SMG_CLIP_01",
    "COMPONENT_SMG_CLIP_02",
    "COMPONENT_SMG_CLIP_03",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_SCOPE_MACRO_02",
    "COMPONENT_AT_PI_SUPP",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_ASSAULTSMG",
    "WT_SMG_ASL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_ASSAULTSMG_CLIP_01",
    "WCT_CLIP1",
    "WCD_ASMG_CLIP1",
    "COMPONENT_ASSAULTSMG_CLIP_02",
    "WCT_CLIP2",
    "WCD_ASMG_CLIP2",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_MACRO",
    "WCT_SCOPE_MAC",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER",
    "WCT_VAR_GOLD",
    "WCD_VAR_ASMG",
    "COMPONENT_ASSAULTSMG_CLIP_01",
    "COMPONENT_ASSAULTSMG_CLIP_02",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_SCOPE_MACRO",
    "COMPONENT_AT_AR_SUPP_02",
    "WEAPON_ASSAULTRIFLE",
    "WT_RIFLE_ASL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_ASSAULTRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_AR_CLIP1",
    "COMPONENT_ASSAULTRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_AR_CLIP2",
    "COMPONENT_ASSAULTRIFLE_CLIP_03",
    "WCT_CLIP_DRM",
    "WCD_CLIP3",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_MACRO",
    "WCT_SCOPE_MAC",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
    "WCT_VAR_GOLD",
    "WCD_VAR_AR",
    "COMPONENT_ASSAULTRIFLE_CLIP_01",
    "COMPONENT_ASSAULTRIFLE_CLIP_02",
    "COMPONENT_ASSAULTRIFLE_CLIP_03",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_AR_AFGRIP",
    "COMPONENT_AT_SCOPE_MACRO",
    "COMPONENT_AT_AR_SUPP_02",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_CARBINERIFLE",
    "WT_RIFLE_CBN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_CARBINERIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_CR_CLIP1",
    "COMPONENT_CARBINERIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_CR_CLIP2",
    "COMPONENT_CARBINERIFLE_CLIP_03",
    "WCT_CLIP_BOX",
    "WCD_CLIP3",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_RAILCOVER_01",
    "WCT_RAIL",
    "WCD_AT_RAIL",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "WCT_SCOPE_MED",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_CARBINERIFLE_VARMOD_LUXE",
    "WCT_VAR_GOLD",
    "WCD_VAR_CR",
    "COMPONENT_CARBINERIFLE_CLIP_01",
    "COMPONENT_CARBINERIFLE_CLIP_02",
    "COMPONENT_CARBINERIFLE_CLIP_03",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_AR_AFGRIP",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "COMPONENT_AT_AR_SUPP",
    "COMPONENT_CARBINERIFLE_VARMOD_MICH",
    "WCD_VAR_DESC",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_ADVANCEDRIFLE",
    "WT_RIFLE_ADV",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_ADVANCEDRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_AR_CLIP1",
    "COMPONENT_ADVANCEDRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_AR_CLIP2",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_SMALL",
    "WCT_SCOPE_SML",
    "WCD_SCOPE_SML",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE",
    "WCT_VAR_METAL",
    "WCD_VAR_ADR",
    "COMPONENT_ADVANCEDRIFLE_CLIP_01",
    "COMPONENT_ADVANCEDRIFLE_CLIP_02",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_SCOPE_SMALL",
    "COMPONENT_AT_AR_SUPP",
    "WEAPON_MG",
    "WT_MG",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MG_CLIP_01",
    "WCT_CLIP1",
    "WCD_MG_CLIP1",
    "COMPONENT_MG_CLIP_02",
    "WCT_CLIP2",
    "WCD_MG_CLIP2",
    "COMPONENT_AT_SCOPE_SMALL_02",
    "WCT_SCOPE_SML",
    "WCD_SCOPE_SML",
    "COMPONENT_MG_VARMOD_LOWRIDER",
    "WCT_VAR_GOLD",
    "WCD_VAR_MG",
    "COMPONENT_MG_CLIP_01",
    "COMPONENT_MG_CLIP_02",
    "COMPONENT_AT_SCOPE_SMALL_02",
    "WEAPON_COMBATMG",
    "WT_MG_CBT",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_COMBATMG_CLIP_01",
    "WCT_CLIP1",
    "WCDCMG_CLIP1",
    "COMPONENT_COMBATMG_CLIP_02",
    "WCT_CLIP2",
    "WCDCMG_CLIP2",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "WCT_SCOPE_MED",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_COMBATMG_VARMOD_LOWRIDER",
    "WCT_VAR_ETCHM",
    "WCD_VAR_CBMG",
    "COMPONENT_COMBATMG_CLIP_01",
    "COMPONENT_COMBATMG_CLIP_02",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "COMPONENT_AT_AR_AFGRIP",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_PUMPSHOTGUN",
    "WT_SG_PMP",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_PUMPSHOTGUN_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SR_SUPP",
    "WCT_SUPP",
    "WCD_SR_SUPP",
    "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER",
    "WCT_VAR_GOLD",
    "WCD_VAR_PSHT",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_SR_SUPP",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "COMPONENT_PUMPSHOTGUN_VARMOD_SECURITY",
    "WCT_VAR_BONE",
    "WCD_VAR_PSHT",
    "COMPONENT_PUMPSHOTGUN_VARMOD_XM3",
    "WCT_PUMPSHT_XM3",
    "WCD_VAR_PSHT",
    "WEAPON_SAWNOFFSHOTGUN",
    "WT_SG_SOF",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_SAWNOFFSHOTGUN_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE",
    "WCT_VAR_METAL",
    "WCD_VAR_SOF",
    "WEAPON_ASSAULTSHOTGUN",
    "WT_SG_ASL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_ASSAULTSHOTGUN_CLIP_01",
    "WCT_CLIP1",
    "WCD_AS_CLIP1",
    "COMPONENT_ASSAULTSHOTGUN_CLIP_02",
    "WCT_CLIP2",
    "WCD_AS_CLIP2",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "WEAPON_BULLPUPSHOTGUN",
    "WT_SG_BLP",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_BULLPUPSHOTGUN_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "WEAPON_STUNGUN",
    "WT_STUN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_SNIPERRIFLE",
    "WT_SNIP_RIF",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_SNIPERRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_SR_CLIP1",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_SCOPE_LARGE",
    "WCT_SCOPE_LRG",
    "WCD_SCOPE_LRG",
    "COMPONENT_AT_SCOPE_MAX",
    "WCT_SCOPE_MAX",
    "WCD_SCOPE_MAX",
    "COMPONENT_SNIPERRIFLE_VARMOD_LUXE",
    "WCT_VAR_WOOD",
    "WCD_VAR_SNP",
    "COMPONENT_SNIPERRIFLE_CLIP_01",
    "COMPONENT_AT_SCOPE_LARGE",
    "COMPONENT_AT_SCOPE_MAX",
    "COMPONENT_AT_AR_SUPP_02",
    "WEAPON_HEAVYSNIPER",
    "WT_SNIP_HVY",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_HEAVYSNIPER_CLIP_01",
    "WCT_CLIP1",
    "WCD_HS_CLIP1",
    "COMPONENT_AT_SCOPE_LARGE",
    "WCT_SCOPE_LRG",
    "WCD_SCOPE_LRG",
    "COMPONENT_AT_SCOPE_MAX",
    "WCT_SCOPE_MAX",
    "WCD_SCOPE_MAX",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "COMPONENT_HEAVYSNIPER_VARMOD_XMAS23",
    "WCD_VAR_DESC",
    "WEAPON_REMOTESNIPER",
    "WT_SNIP_RMT",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_GRENADELAUNCHER",
    "WT_GL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_GRENADELAUNCHER_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_SCOPE_SMALL",
    "WCT_SCOPE_SML",
    "WCD_SCOPE_SML",
    "WEAPON_GRENADELAUNCHER_SMOKE",
    "WT_GL_SMOKE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_SCOPE_SMALL",
    "WCT_SCOPE_SML",
    "WCD_SCOPE_SML",
    "WEAPON_RPG",
    "WT_RPG",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_RPG_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_RPG_VARMOD_TVR",
    "WCD_VAR_DESC",
    "WEAPON_PASSENGER_ROCKET",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_RPG_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_AIRSTRIKE_ROCKET",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_RPG_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_STINGER",
    "WT_RPG",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_RPG_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_MINIGUN",
    "WT_MINIGUN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MINIGUN_CLIP_01",
    "WCT_CLIP2",
    "WCD_MIG_CLIP2",
    "WEAPON_GRENADE",
    "WT_GNADE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_STICKYBOMB",
    "WT_GNADE_STK",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_SMOKEGRENADE",
    "WT_GNADE_SMK",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BZGAS",
    "WT_BZGAS",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_MOLOTOV",
    "WT_MOLOTOV",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_FIREEXTINGUISHER",
    "WT_FIRE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_PETROLCAN",
    "WT_PETROL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_DIGISCANNER",
    "WT_DIGI",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "GADGET_NIGHTVISION",
    "WT_NV",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "GADGET_PARACHUTE",
    "WT_PARA",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "OBJECT",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "POLICE_TORCH_FLASHLIGHT",
    "WCT_FLASH",
    "WCD_FLASH",
    "WEAPON_BRIEFCASE",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BRIEFCASE_02",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BALL",
    "WT_BALL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_FLARE",
    "WT_FLARE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_TANK",
    "WT_V_TANK",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_SPACE_ROCKET",
    "WT_V_PLANEMSL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_PLANE_ROCKET",
    "WT_V_PLANEMSL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_PLAYER_LASER",
    "WT_V_PLRLSR",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_PLAYER_BULLET",
    "WT_V_PLRBUL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_PLAYER_BUZZARD",
    "WT_V_PLRBUL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_PLAYER_HUNTER",
    "WT_V_PLRBUL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_PLAYER_LAZER",
    "WT_V_LZRCAN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_ENEMY_LASER",
    "WT_A_ENMYLSR",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_SEARCHLIGHT",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_RADAR",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_VEHICLE_ROCKET",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_RPG_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_BARBED_WIRE",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_DROWNING",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_DROWNING_IN_VEHICLE",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BLEEDING",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_ELECTRIC_FENCE",
    "WT_ELCFEN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_EXPLOSION",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_FALL",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_EXHAUSTION",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_HIT_BY_WATER_CANNON",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_RAMMED_BY_CAR",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_RUN_OVER_BY_CAR",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_HELI_CRASH",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_ROTORS",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_FIRE",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_ANIMAL_RETRIEVER",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_SMALL_DOG",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_TIGER_SHARK",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_HAMMERHEAD_SHARK",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_KILLER_WHALE",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BOAR",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_PIG",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_COYOTE",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_DEER",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_HEN",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_RABBIT",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_CAT",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_COW",
    "WT_INVALID",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BIRD_CRAP",
    "WT_GNADE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_BOTTLE",
    "WT_BOTTLE",
    "WTD_BOTTLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_SNSPISTOL",
    "WT_SNSPISTOL",
    "WTD_SNSPISTOL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_SNSPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_SNSP_CLIP1",
    "COMPONENT_SNSPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_SNSP_CLIP2",
    "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER",
    "WCT_VAR_WOOD",
    "WCD_VAR_SNS",
    "COMPONENT_SNSPISTOL_CLIP_01",
    "COMPONENT_SNSPISTOL_CLIP_02",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_HEAVYPISTOL",
    "WT_HVYPISTOL",
    "WTD_HVYPISTOL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_HEAVYPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_HPST_CLIP1",
    "COMPONENT_HEAVYPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_HPST_CLIP2",
    "COMPONENT_AT_PI_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_PI_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_HEAVYPISTOL_VARMOD_LUXE",
    "WCT_VAR_WOOD",
    "WCD_VAR_HPST",
    "COMPONENT_HEAVYPISTOL_CLIP_01",
    "COMPONENT_HEAVYPISTOL_CLIP_02",
    "COMPONENT_AT_PI_FLSH",
    "COMPONENT_AT_PI_SUPP",
    "WEAPON_SPECIALCARBINE",
    "WT_SPCARBINE",
    "WTD_SPCARBINE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_SPECIALCARBINE_CLIP_01",
    "WCT_CLIP1",
    "WCD_SCRB_CLIP1",
    "COMPONENT_SPECIALCARBINE_CLIP_02",
    "WCT_CLIP2",
    "WCD_SCRB_CLIP2",
    "COMPONENT_SPECIALCARBINE_CLIP_03",
    "WCT_CLIP_DRM",
    "WCD_CLIP3",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "WCT_SCOPE_MED",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER",
    "WCT_VAR_ETCHM",
    "WCD_VAR_SCAR",
    "COMPONENT_SPECIALCARBINE_CLIP_01",
    "COMPONENT_SPECIALCARBINE_CLIP_02",
    "COMPONENT_SPECIALCARBINE_CLIP_03",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_AR_AFGRIP",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "COMPONENT_AT_AR_SUPP_02",
    "COMPONENT_SPECIALCARBINE_VARMOD_XMAS23",
    "WCD_VAR_DESC",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_BULLPUPRIFLE",
    "WT_BULLRIFLE",
    "WTD_BULLRIFLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_BULLPUPRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_BRIF_CLIP1",
    "COMPONENT_BULLPUPRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_BRIF_CLIP2",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_SMALL",
    "WCT_SCOPE_SML",
    "WCD_SCOPE_SML",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_BULLPUPRIFLE_VARMOD_LOW",
    "WCT_VAR_METAL",
    "WCD_VAR_BPR",
    "COMPONENT_BULLPUPRIFLE_CLIP_01",
    "COMPONENT_BULLPUPRIFLE_CLIP_02",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_AR_AFGRIP",
    "COMPONENT_AT_SCOPE_SMALL",
    "COMPONENT_AT_AR_SUPP",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WT_BULLRIFLE2",
    "WTD_BULLRIFLE2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_BULLPUPRIFLE_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING",
    "WCT_CLIP_AP",
    "WCD_CLIP_AP",
    "COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MACRO_02_MK2",
    "WCT_SCOPE_MAC2",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_SCOPE_SMALL_MK2",
    "WCT_SCOPE_SML2",
    "WCD_SCOPE_SML",
    "COMPONENT_AT_BP_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_BP_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_MUZZLE_01",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_02",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_03",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_04",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_05",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_06",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_07",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_AR_AFGRIP_02",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_MARKSMANRIFLE_MK2",
    "WT_MKRIFLE2",
    "WTD_MKRIFLE2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_MARKSMANRIFLE_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_MARKSMANRIFLE_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING",
    "WCT_CLIP_AP",
    "WCD_CLIP_AP",
    "COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MEDIUM_MK2",
    "WCT_SCOPE_MED2",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2",
    "WCT_SCOPE_LRG2",
    "WCD_SCOPE_LRF",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_MUZZLE_01",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_02",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_03",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_04",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_05",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_06",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_07",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_AR_AFGRIP_02",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_MRFL_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_MRFL_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WT_SG_PMP2",
    "WTD_SG_PMP2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_PUMPSHOTGUN_MK2_CLIP_01",
    "WCT_SHELL",
    "WCD_SHELL",
    "COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING",
    "WCT_SHELL_AP",
    "WCD_SHELL_AP",
    "COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE",
    "WCT_SHELL_EX",
    "WCD_SHELL_EX",
    "COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT",
    "WCT_SHELL_HP",
    "WCD_SHELL_HP",
    "COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY",
    "WCT_SHELL_INC",
    "WCD_SHELL_INC",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MACRO_MK2",
    "WCT_SCOPE_MAC2",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_SCOPE_SMALL_MK2",
    "WCT_SCOPE_SML2",
    "WCD_SCOPE_SML",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SR_SUPP_03",
    "WCT_SUPP",
    "WCD_SR_SUPP",
    "COMPONENT_AT_MUZZLE_08",
    "WCT_MUZZ",
    "WCD_MUZZ_SR",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_SNSPISTOL_MK2",
    "WT_SNSPISTOL2",
    "WTD_SNSPISTOL2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_SNSPISTOL_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_SNSPISTOL_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_SNSPISTOL_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR_RV",
    "COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC_NS",
    "COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT",
    "WCT_CLIP_HP",
    "WCD_CLIP_HP_RV",
    "COMPONENT_SNSPISTOL_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ_RV",
    "COMPONENT_AT_PI_FLSH_03",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_PI_RAIL_02",
    "WCT_SCOPE_PI",
    "WCD_SCOPE_PI",
    "COMPONENT_AT_PI_SUPP_02",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_AT_PI_COMP_02",
    "WCT_COMP",
    "WCD_COMP",
    "COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE",
    "WCT_CAMO_2",
    "COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE",
    "WCT_CAMO_3",
    "COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE",
    "WCT_CAMO_4",
    "COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE",
    "WCT_CAMO_5",
    "COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE",
    "WCT_CAMO_6",
    "COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE",
    "WCT_CAMO_7",
    "COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE",
    "WCT_CAMO_8",
    "COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE",
    "WCT_CAMO_9",
    "COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE",
    "WCT_CAMO_10",
    "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE",
    "WCT_CAMO_IND",
    "COMPONENT_SNSPISTOL_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_SNSPISTOL_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_SNSPISTOL_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_SNSPISTOL_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_SNSPISTOL_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_SNSPISTOL_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_SNSPISTOL_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_SNSPISTOL_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_SNSPISTOL_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_SNSPISTOL_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_SPECIALCARBINE_MK2",
    "WT_SPCARBINE2",
    "WTD_SPCARBINE2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_SPECIALCARBINE_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_SPECIALCARBINE_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING",
    "WCT_CLIP_AP",
    "WCD_CLIP_AP",
    "COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MACRO_MK2",
    "WCT_SCOPE_MAC2",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_SCOPE_MEDIUM_MK2",
    "WCT_SCOPE_MED2",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_MUZZLE_01",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_02",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_03",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_04",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_05",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_06",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_07",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_AR_AFGRIP_02",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_SC_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_SC_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_ARENA_MACHINE_GUN",
    "WT_V_PLRBUL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_ARENA_HOMING_MISSILE",
    "WT_V_LZRCAN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_ACIDPACKAGE",
    "WT_ACIDPACKAGE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_CANDYCANE",
    "WT_CANDYCANE",
    "WTD_CANDYCANE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_RAILGUNXM3",
    "WT_RAILGUNXM3",
    "WTD_RAILGUNXM3",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_RAILGUNXM3_CLIP_01",
    "WCT_CLIP1",
    "WCD_RLGN_CLIP1",
    "WEAPON_PISTOLXM3",
    "WT_PISTOLXM3",
    "WTD_PISTOLXM3",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_PISTOLXM3_CLIP_01",
    "WCT_CLIP1",
    "WCD_PXM3_CLIP1",
    "COMPONENT_PISTOLXM3_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "WEAPON_HOMINGLAUNCHER",
    "WT_HOMLNCH",
    "WTD_HOMLNCH",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_HOMINGLAUNCHER_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_PROXMINE",
    "WT_PRXMINE",
    "WTD_PRXMINE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_SNOWBALL",
    "WT_SNWBALL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_DOUBLEACTION",
    "WT_REV_DA",
    "WTD_REV_DA",
    "WM_TINT0",
    "COMPONENT_DOUBLEACTION_CLIP_01",
    "WCT_CLIP1",
    "WCD_REV_DA_CLIP",
    "WEAPON_REVOLVER_MK2",
    "WT_REVOLVER2",
    "WTD_REVOLVER2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_REVOLVER_MK2_CLIP_01",
    "WCT_CLIP1_RV",
    "WCD_CLIP1_RV",
    "COMPONENT_REVOLVER_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ_RV",
    "COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT",
    "WCT_CLIP_HP",
    "WCD_CLIP_HP_RV",
    "COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC_RV",
    "COMPONENT_REVOLVER_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR_RV",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MACRO_MK2",
    "WCT_SCOPE_MAC2",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_PI_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_PI_COMP_03",
    "WCT_COMP",
    "WCD_COMP",
    "COMPONENT_REVOLVER_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_REVOLVER_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_REVOLVER_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_REVOLVER_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_REVOLVER_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_REVOLVER_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_REVOLVER_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_REVOLVER_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_REVOLVER_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_REVOLVER_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_REVOLVER_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_RAYPISTOL",
    "WT_RAYPISTOL",
    "WTD_RAYPISTOL",
    "RWT_TINT0",
    "RWT_TINT1",
    "RWT_TINT2",
    "RWT_TINT3",
    "RWT_TINT4",
    "RWT_TINT5",
    "RWT_TINT6",
    "COMPONENT_RAYPISTOL_VARMOD_XMAS18",
    "WCT_VAR_RAY18",
    "WCD_VAR_RAY18",
    "WEAPON_RAYCARBINE",
    "WT_RAYCARBINE",
    "WTD_RAYCARBINE",
    "RWT_TINT0",
    "RWT_TINT1",
    "RWT_TINT2",
    "RWT_TINT3",
    "RWT_TINT4",
    "RWT_TINT5",
    "RWT_TINT6",
    "WEAPON_RAYMINIGUN",
    "WT_RAYMINIGUN",
    "WTD_RAYMINIGUN",
    "RWT_TINT0",
    "RWT_TINT1",
    "RWT_TINT2",
    "RWT_TINT3",
    "RWT_TINT4",
    "RWT_TINT5",
    "RWT_TINT6",
    "COMPONENT_MINIGUN_CLIP_01",
    "WCT_CLIP2",
    "WCD_MIG_CLIP2",
    "WEAPON_GUSENBERG",
    "WT_GUSNBRG",
    "WTD_GUSNBRG",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_GUSENBERG_CLIP_01",
    "WCT_CLIP1",
    "WCD_GSNB_CLIP1",
    "COMPONENT_GUSENBERG_CLIP_02",
    "WCT_CLIP2",
    "WCD_GSNB_CLIP2",
    "WEAPON_DAGGER",
    "WT_DAGGER",
    "WTD_DAGGER",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_VINTAGEPISTOL",
    "WT_VPISTOL",
    "WTD_VPISTOL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_VINTAGEPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_VPST_CLIP1",
    "COMPONENT_VINTAGEPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_VPST_CLIP2",
    "COMPONENT_AT_PI_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "WEAPON_MUSKET",
    "WT_MUSKET",
    "WTD_MUSKET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MUSKET_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_FIREWORK",
    "WT_FIREWRK",
    "WTD_FIREWRK",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_FIREWORK_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_RAILGUN",
    "WT_RAILGUN",
    "WTD_RAILGUN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_RAILGUN_CLIP_01",
    "WCT_CLIP1",
    "WCD_RLGN_CLIP1",
    "WEAPON_HATCHET",
    "WT_HATCHET",
    "WTD_HATCHET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_MARKSMANRIFLE",
    "WT_MKRIFLE",
    "WTD_MKRIFLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MARKSMANRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_MKRF_CLIP1",
    "COMPONENT_MARKSMANRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_MKRF_CLIP2",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM",
    "WCT_SCOPE_LRG",
    "WCD_SCOPE_LRF",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_MARKSMANRIFLE_VARMOD_LUXE",
    "WCT_VAR_GOLD",
    "WCD_VAR_MKRF",
    "COMPONENT_MARKSMANRIFLE_CLIP_01",
    "COMPONENT_MARKSMANRIFLE_CLIP_02",
    "COMPONENT_AT_AR_FLSH",
    "COMPONENT_AT_AR_AFGRIP",
    "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM",
    "COMPONENT_AT_AR_SUPP",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_HEAVYSHOTGUN",
    "WT_HVYSHGN",
    "WTD_HVYSHGN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_HEAVYSHOTGUN_CLIP_01",
    "WCT_CLIP1",
    "WCD_HVSG_CLIP1",
    "COMPONENT_HEAVYSHOTGUN_CLIP_02",
    "WCT_CLIP2",
    "WCD_HVSG_CLIP2",
    "COMPONENT_HEAVYSHOTGUN_CLIP_03",
    "WCT_CLIP_DRM",
    "WCD_CLIP3",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "WEAPON_GARBAGEBAG",
    "WT_KNIFE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_HANDCUFFS",
    "WT_KNIFE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_CERAMICPISTOL",
    "WT_CERPST",
    "WTD_CERPST",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_CERAMICPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_P_CLIP1",
    "COMPONENT_CERAMICPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_P_CLIP2",
    "COMPONENT_CERAMICPISTOL_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "WEAPON_HAZARDCAN",
    "WT_HAZARDCAN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_TRANQUILIZER",
    "WT_STUN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_COMBATSHOTGUN",
    "WT_CMBSHGN",
    "WTD_CMBSHGN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_COMBATSHOTGUN_CLIP_01",
    "WCT_SHELL",
    "WCD_SHELL",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "WEAPON_GADGETPISTOL",
    "WT_GDGTPST",
    "WTD_GDGTPST",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_GADGETPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_MILITARYRIFLE",
    "WT_MLTRYRFL",
    "WTD_MLTRYRFL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MILITARYRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_AR_CLIP1",
    "COMPONENT_MILITARYRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_AR_CLIP2",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_MILITARYRIFLE_SIGHT_01",
    "WCT_MRFL_SIGHT",
    "WCD_MRFL_SIGHT",
    "COMPONENT_AT_SCOPE_SMALL",
    "WCT_SCOPE_SML",
    "WCD_SCOPE_SML",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "VEHICLE_WEAPON_PLAYER_SAVAGE",
    "WT_V_LZRCAN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_NOSE_TURRET_VALKYRIE",
    "WT_V_PLRBUL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_TURRET_VALKYRIE",
    "WT_V_TURRET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_TURRET_TECHNICAL",
    "WT_V_TURRET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_TURRET_INSURGENT",
    "WT_V_TURRET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_FLAREGUN",
    "WT_FLAREGUN",
    "WTD_FLAREGUN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_FLAREGUN_CLIP_01",
    "WCT_CLIP1",
    "WCT_INVALID",
    "WEAPON_NAVYREVOLVER",
    "WT_REV_NV",
    "WTD_REV_NV",
    "WM_TINT0",
    "COMPONENT_NAVYREVOLVER_CLIP_01",
    "WCT_CLIP1",
    "WEAPON_KNUCKLE",
    "WT_KNUCKLE",
    "WTD_KNUCKLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_KNUCKLE_VARMOD_BASE",
    "WT_KNUCKLE",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_PIMP",
    "WCT_KNUCK_02",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_BALLAS",
    "WCT_KNUCK_BG",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_DOLLAR",
    "WCT_KNUCK_DLR",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_DIAMOND",
    "WCT_KNUCK_DMD",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_HATE",
    "WCT_KNUCK_HT",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_LOVE",
    "WCT_KNUCK_LV",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_PLAYER",
    "WCT_KNUCK_PC",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_KING",
    "WCT_KNUCK_SLG",
    "WCD_VAR_DESC",
    "COMPONENT_KNUCKLE_VARMOD_VAGOS",
    "WCT_KNUCK_VG",
    "WCD_VAR_DESC",
    "WEAPON_MARKSMANPISTOL",
    "WT_MKPISTOL",
    "WTD_MKPISTOL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MARKSMANPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_COMBATPDW",
    "WT_COMBATPDW",
    "WTD_COMBATPDW",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_COMBATPDW_CLIP_01",
    "WCT_CLIP1",
    "WCD_PDW_CLIP1",
    "COMPONENT_COMBATPDW_CLIP_02",
    "WCT_CLIP2",
    "WCD_PDW_CLIP2",
    "COMPONENT_COMBATPDW_CLIP_03",
    "WCT_CLIP_DRM",
    "WCD_CLIP3",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_SCOPE_SMALL",
    "WCT_SCOPE_SML",
    "WCD_SCOPE_SML",
    "WEAPON_DBSHOTGUN",
    "WT_DBSHGN",
    "WTD_DBSHGN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_DBSHOTGUN_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "WEAPON_COMPACTRIFLE",
    "WT_CMPRIFLE",
    "WTD_CMPRIFLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_COMPACTRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_CMPR_CLIP1",
    "COMPONENT_COMPACTRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_CMPR_CLIP2",
    "COMPONENT_COMPACTRIFLE_CLIP_03",
    "WCT_CLIP_DRM",
    "WCD_CLIP3",
    "WEAPON_MACHINEPISTOL",
    "WT_MCHPIST",
    "WTD_MCHPIST",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MACHINEPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_MCHP_CLIP1",
    "COMPONENT_MACHINEPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_MCHP_CLIP2",
    "COMPONENT_MACHINEPISTOL_CLIP_03",
    "WCT_CLIP_DRM",
    "WCD_CLIP3",
    "COMPONENT_AT_PI_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "WEAPON_MACHETE",
    "WT_MACHETE",
    "WTD_MACHETE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_FLASHLIGHT",
    "WT_FLASHLIGHT",
    "WTD_FLASHLIGHT",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_FLASHLIGHT_LIGHT",
    "WCT_FLASH",
    "WCD_FLASH",
    "VEHICLE_WEAPON_TURRET_LIMO",
    "WT_V_TURRET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_AIR_DEFENCE_GUN",
    "WT_V_LZRCAN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_REVOLVER",
    "WT_REVOLVER",
    "WTD_REVOLVER",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_REVOLVER_CLIP_01",
    "WCT_CLIP1",
    "WCD_REV_CLIP1",
    "COMPONENT_REVOLVER_VARMOD_BOSS",
    "WCT_REV_VARB",
    "WCD_REV_VARB",
    "COMPONENT_REVOLVER_VARMOD_GOON",
    "WCT_REV_VARG",
    "WCD_REV_VARG",
    "COMPONENT_GUNRUN_MK2_UPGRADE",
    "WCT_VAR_GUN",
    "WCD_VAR_GUN",
    "WEAPON_SWITCHBLADE",
    "WT_SWBLADE",
    "WTD_SWBLADE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_SWITCHBLADE_VARMOD_BASE",
    "WCT_SB_BASE",
    "WCD_VAR_DESC",
    "COMPONENT_SWITCHBLADE_VARMOD_VAR1",
    "WCT_SB_VAR1",
    "WCD_VAR_DESC",
    "COMPONENT_SWITCHBLADE_VARMOD_VAR2",
    "WCT_SB_VAR2",
    "WCD_VAR_DESC",
    "VEHICLE_WEAPON_TURRET_BOXVILLE",
    "WT_V_TURRET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_RUINER_BULLET",
    "WT_V_PLRBUL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_RUINER_ROCKET",
    "WT_V_PLANEMSL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "VEHICLE_WEAPON_CANNON_BLAZER",
    "WT_V_PLRBUL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_AUTOSHOTGUN",
    "WT_AUTOSHGN",
    "WTD_AUTOSHGN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_AUTOSHOTGUN_CLIP_01",
    "WCT_CLIP1",
    "WEAPON_BATTLEAXE",
    "WT_BATTLEAXE",
    "WTD_BATTLEAXE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_COMPACTLAUNCHER",
    "WT_CMPGL",
    "WTD_CMPGL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_COMPACTLAUNCHER_CLIP_01",
    "WCT_CLIP1",
    "WEAPON_MINISMG",
    "WT_MINISMG",
    "WTD_MINISMG",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_MINISMG_CLIP_01",
    "WCT_CLIP1",
    "WCD_SCRP_CLIP1",
    "COMPONENT_MINISMG_CLIP_02",
    "WCT_CLIP2",
    "WCD_SCRP_CLIP2",
    "WEAPON_POOLCUE",
    "WT_POOLCUE",
    "WTD_POOLCUE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_WRENCH",
    "WT_WRENCH",
    "WTD_WRENCH",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_PIPEBOMB",
    "WT_PIPEBOMB",
    "WTD_PIPEBOMB",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_CARBINERIFLE_MK2",
    "WT_RIFLE_CBN2",
    "WTD_RIFLE_CBN2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING",
    "WCT_CLIP_AP",
    "WCD_CLIP_AP",
    "COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MACRO_MK2",
    "WCT_SCOPE_MAC2",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_SCOPE_MEDIUM_MK2",
    "WCT_SCOPE_MED2",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_MUZZLE_01",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_02",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_03",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_04",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_05",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_06",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_07",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_AR_AFGRIP_02",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_CR_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_CR_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_CARBINERIFLE_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WT_RIFLE_ASL2",
    "WTD_RIFLE_ASL2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_ASSAULTRIFLE_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING",
    "WCT_CLIP_AP",
    "WCD_CLIP_AP",
    "COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MACRO_MK2",
    "WCT_SCOPE_MAC2",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_SCOPE_MEDIUM_MK2",
    "WCT_SCOPE_MED2",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_MUZZLE_01",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_02",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_03",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_04",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_05",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_06",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_07",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_AR_AFGRIP_02",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_AR_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_AR_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_COMBATMG_MK2",
    "WT_MG_CBT2",
    "WTD_MG_CBT2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_COMBATMG_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_COMBATMG_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING",
    "WCT_CLIP_AP",
    "WCD_CLIP_AP",
    "COMPONENT_COMBATMG_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_COMBATMG_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_AT_SIGHTS",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_SMALL_MK2",
    "WCT_SCOPE_SML2",
    "WCD_SCOPE_SML",
    "COMPONENT_AT_SCOPE_MEDIUM_MK2",
    "WCT_SCOPE_MED2",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_MUZZLE_01",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_02",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_03",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_04",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_05",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_06",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_07",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_AR_AFGRIP_02",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_AT_MG_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_MG_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_COMBATMG_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_COMBATMG_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_COMBATMG_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_COMBATMG_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_COMBATMG_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_COMBATMG_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_COMBATMG_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_COMBATMG_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_COMBATMG_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_COMBATMG_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_COMBATMG_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_SMG_MK2",
    "WT_SMG2",
    "WTD_SMG2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_SMG_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_SMG_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_SMG_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT",
    "WCT_CLIP_HP",
    "WCD_CLIP_HP",
    "COMPONENT_SMG_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_SMG_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_SIGHTS_SMG",
    "WCT_HOLO",
    "WCD_HOLO",
    "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
    "WCT_SCOPE_MAC2",
    "WCD_SCOPE_MAC",
    "COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
    "WCT_SCOPE_SML2",
    "WCD_SCOPE_SML",
    "COMPONENT_AT_PI_SUPP",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_AT_MUZZLE_01",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_02",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_03",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_04",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_05",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_06",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_MUZZLE_07",
    "WCT_MUZZ",
    "WCD_MUZZ",
    "COMPONENT_AT_SB_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_SB_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_SMG_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_SMG_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_SMG_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_SMG_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_SMG_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_SMG_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_SMG_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_SMG_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_SMG_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_SMG_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_SMG_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_HEAVYSNIPER_MK2",
    "WT_SNIP_HVY2",
    "WTD_SNIP_HVY2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_HEAVYSNIPER_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_HEAVYSNIPER_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING",
    "WCT_CLIP_AP",
    "WCD_CLIP_AP",
    "COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE",
    "WCT_CLIP_EX",
    "WCD_CLIP_EX",
    "COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC_SN",
    "COMPONENT_AT_SCOPE_LARGE_MK2",
    "WCT_SCOPE_LRG2",
    "WCD_SCOPE_LRG",
    "COMPONENT_AT_SCOPE_MAX",
    "WCT_SCOPE_MAX",
    "WCD_SCOPE_MAX",
    "COMPONENT_AT_SCOPE_NV",
    "WCT_SCOPE_NV",
    "WCD_SCOPE_NV",
    "COMPONENT_AT_SCOPE_THERMAL",
    "WCT_SCOPE_TH",
    "WCD_SCOPE_TH",
    "COMPONENT_AT_SR_SUPP_03",
    "WCT_SUPP",
    "WCD_SR_SUPP",
    "COMPONENT_AT_MUZZLE_08",
    "WCT_MUZZ",
    "WCD_MUZZ_SR",
    "COMPONENT_AT_MUZZLE_09",
    "WCT_MUZZ",
    "WCD_MUZZ_SR",
    "COMPONENT_AT_SR_BARREL_01",
    "WCT_BARR",
    "WCD_BARR",
    "COMPONENT_AT_SR_BARREL_02",
    "WCT_BARR2",
    "WCD_BARR2",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_PISTOL_MK2",
    "WT_PIST2",
    "WTD_PIST2",
    "WCT_TINT_0",
    "WCT_TINT_1",
    "WCT_TINT_2",
    "WCT_TINT_3",
    "WCT_TINT_4",
    "WCT_TINT_5",
    "WCT_TINT_6",
    "WCT_TINT_7",
    "WCT_TINT_8",
    "WCT_TINT_9",
    "WCT_TINT_10",
    "WCT_TINT_11",
    "WCT_TINT_12",
    "WCT_TINT_13",
    "WCT_TINT_14",
    "WCT_TINT_15",
    "WCT_TINT_16",
    "WCT_TINT_17",
    "WCT_TINT_18",
    "WCT_TINT_19",
    "WCT_TINT_20",
    "WCT_TINT_21",
    "WCT_TINT_22",
    "WCT_TINT_23",
    "WCT_TINT_24",
    "WCT_TINT_25",
    "WCT_TINT_26",
    "WCT_TINT_27",
    "WCT_TINT_28",
    "WCT_TINT_29",
    "WCT_TINT_30",
    "WCT_TINT_31",
    "COMPONENT_PISTOL_MK2_CLIP_01",
    "WCT_CLIP1",
    "WCD_CLIP1",
    "COMPONENT_PISTOL_MK2_CLIP_02",
    "WCT_CLIP2",
    "WCD_CLIP2",
    "COMPONENT_PISTOL_MK2_CLIP_FMJ",
    "WCT_CLIP_FMJ",
    "WCD_CLIP_FMJ",
    "COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT",
    "WCT_CLIP_HP",
    "WCD_CLIP_HP",
    "COMPONENT_PISTOL_MK2_CLIP_INCENDIARY",
    "WCT_CLIP_INC",
    "WCD_CLIP_INC",
    "COMPONENT_PISTOL_MK2_CLIP_TRACER",
    "WCT_CLIP_TR",
    "WCD_CLIP_TR",
    "COMPONENT_AT_PI_RAIL",
    "WCT_SCOPE_PI",
    "WCD_SCOPE_PI",
    "COMPONENT_AT_PI_FLSH_02",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_PI_SUPP_02",
    "WCT_SUPP",
    "WCD_PI_SUPP",
    "COMPONENT_AT_PI_COMP",
    "WCT_COMP",
    "WCD_COMP",
    "COMPONENT_PISTOL_MK2_VARMOD_XM3_SLIDE",
    "COMPONENT_PISTOL_MK2_VARMOD_XM3",
    "WCT_PISTMK2_XM3",
    "COMPONENT_PISTOL_MK2_CAMO_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_02_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_03_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_04_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_05_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_06_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_07_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_08_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_09_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_10_SLIDE",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE",
    "WCT_CAMO_IND",
    "COMPONENT_PISTOL_MK2_CAMO",
    "WCT_CAMO_1",
    "COMPONENT_PISTOL_MK2_CAMO_02",
    "WCT_CAMO_2",
    "COMPONENT_PISTOL_MK2_CAMO_03",
    "WCT_CAMO_3",
    "COMPONENT_PISTOL_MK2_CAMO_04",
    "WCT_CAMO_4",
    "COMPONENT_PISTOL_MK2_CAMO_05",
    "WCT_CAMO_5",
    "COMPONENT_PISTOL_MK2_CAMO_06",
    "WCT_CAMO_6",
    "COMPONENT_PISTOL_MK2_CAMO_07",
    "WCT_CAMO_7",
    "COMPONENT_PISTOL_MK2_CAMO_08",
    "WCT_CAMO_8",
    "COMPONENT_PISTOL_MK2_CAMO_09",
    "WCT_CAMO_9",
    "COMPONENT_PISTOL_MK2_CAMO_10",
    "WCT_CAMO_10",
    "COMPONENT_PISTOL_MK2_CAMO_IND_01",
    "WCT_CAMO_IND",
    "WEAPON_STONE_HATCHET",
    "WT_SHATCHET",
    "WTD_SHATCHET",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_TACTICALRIFLE",
    "WT_TACRIFLE",
    "WTD_TACRIFLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_TACTICALRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_CR_CLIP1",
    "COMPONENT_TACTICALRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_CR_CLIP2",
    "COMPONENT_AT_AR_FLSH_REH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "WEAPON_METALDETECTOR",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_PRECISIONRIFLE",
    "WT_PRCSRIFLE",
    "WTD_PRCSRIFLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_PRECISIONRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_CR_CLIP1",
    "WEAPON_FERTILIZERCAN",
    "WT_FERTILIZERCAN",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_HEAVYRIFLE",
    "WT_HEAVYRIFLE",
    "WTD_HEAVYRIFLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_HEAVYRIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_HVRFL_CLIP1",
    "COMPONENT_HEAVYRIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_HVRFL_CLIP2",
    "COMPONENT_HEAVYRIFLE_SIGHT_01",
    "WCT_HVYRFLE_SIG",
    "WCD_HVRFL_SIG",
    "COMPONENT_AT_SCOPE_MEDIUM",
    "WCT_SCOPE_MED",
    "WCD_SCOPE_MED",
    "COMPONENT_AT_AR_FLSH",
    "WCT_FLASH",
    "WCD_FLASH",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "COMPONENT_AT_AR_AFGRIP",
    "WCT_GRIP",
    "WCD_GRIP",
    "COMPONENT_HEAVYRIFLE_CAMO1",
    "WCT_CAMO_1",
    "WEAPON_STUNGUN_MP",
    "WT_STUN",
    "WTD_STNGUNMP",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_STUNGUN_VARMOD_BAIL",
    "WCD_VAR_DESC",
    "WEAPON_EMPLAUNCHER",
    "WT_EMPL",
    "WTD_EMPL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_EMPLAUNCHER_CLIP_01",
    "WCT_CLIP1",
    "WEAPON_TECPISTOL",
    "WT_TECPISTOL",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_TECPISTOL_CLIP_01",
    "WCT_CLIP1",
    "WCD_TECP_CLIP1",
    "COMPONENT_TECPISTOL_CLIP_02",
    "WCT_CLIP2",
    "WCD_TECP_CLIP2",
    "COMPONENT_AT_AR_SUPP_02",
    "WCT_SUPP",
    "WCD_AR_SUPP2",
    "COMPONENT_AT_SCOPE_MACRO",
    "WCT_SCOPE_MAC",
    "WCD_SCOPE_MAC",
    "WEAPON_BATTLERIFLE",
    "WT_BATTLERIFLE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "COMPONENT_BATTLERIFLE_CLIP_01",
    "WCT_CLIP1",
    "WCD_BTRIF_CLIP1",
    "COMPONENT_BATTLERIFLE_CLIP_02",
    "WCT_CLIP2",
    "WCD_BTRIF_CLIP2",
    "COMPONENT_AT_AR_SUPP",
    "WCT_SUPP",
    "WCD_AR_SUPP",
    "WEAPON_HACKINGDEVICE",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_SNOWLAUNCHER",
    "WT_SNOWLNCHR",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
    "WEAPON_STUNROD",
    "WM_TINT0",
    "WM_TINT1",
    "WM_TINT2",
    "WM_TINT3",
    "WM_TINT4",
    "WM_TINT5",
    "WM_TINT6",
    "WM_TINT7",
}

menu.action(test, "GIVE_WEAPON_TO_PED", {}, "", function()

        for _, list in pairs(weapons) do
            WEAPON.GIVE_WEAPON_TO_PED(players.user_ped(),util.joaat(list),INT_MAX,false,false)
-- print(list)
        end
end)


menu.toggle_loop(world, "TASK_COMBAT_PED", {}, "", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            for _, list in pairs(weapons) do
                WEAPON.GIVE_WEAPON_TO_PED(ent,util.joaat(list),INT_MAX,false,true)
    -- print(list)
            end
            -- TASK.TASK_COMBAT_PED(ent, players.user_ped(), 0, 16)
        end
    end

end)
