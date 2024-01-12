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
                    "am_armwrestling_apartment", "am_armybase", "am_backup_heli", "am_beach_washup_cinematic",
                    "am_boat_taxi", "am_bru_box", "am_car_mod_tut", "am_casino_limo", "am_casino_luxury_car",
                    "am_casino_peds", "am_challenges", "am_contact_requests", "am_cp_collection", "am_crate_drop",
                    "am_criminal_damage", "am_darts", "am_darts_apartment", "am_dead_drop", "am_destroy_veh",
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
                    "am_mp_biker_warehouse", "am_mp_boardroom_seating", "am_mp_bunker", "am_mp_business_hub",
                    "am_mp_carwash_launch", "am_mp_car_meet_property", "am_mp_car_meet_sandbox", "am_mp_casino",
                    "am_mp_casino_apartment", "am_mp_casino_nightclub", "am_mp_casino_valet_garage",
                    "am_mp_creator_aircraft", "am_mp_creator_trailer", "am_mp_defunct_base", "am_mp_drone",
                    "am_mp_fixer_hq", "am_mp_garage_control", "am_mp_hacker_truck", "am_mp_hangar",
                    "am_mp_ie_warehouse", "am_mp_island", "am_mp_juggalo_hideout", "am_mp_multistorey_garage",
                    "am_mp_music_studio", "am_mp_nightclub", "am_mp_orbital_cannon", "am_mp_peds", "am_mp_property_ext",
                    "am_mp_property_int", "am_mp_rc_vehicle", "am_mp_salvage_yard", "am_mp_shooting_range",
                    "am_mp_simeon_showroom", "am_mp_smoking_activity", "am_mp_smpl_interior_ext",
                    "am_mp_smpl_interior_int", "am_mp_social_club_garage", "am_mp_solomon_office", "am_mp_submarine",
                    "am_mp_vehicle_organization_menu", "am_mp_vehicle_reward", "am_mp_vehicle_weapon",
                    "am_mp_vinewood_premium_garage", "am_mp_warehouse", "am_mp_yacht", "am_npc_invites",
                    "am_pass_the_parcel", "am_penned_in", "am_penthouse_peds", "am_pi_menu", "am_plane_takedown",
                    "am_prison", "am_prostitute", "am_rollercoaster", "am_rontrevor_cut", "am_taxi", "am_vehicle_spawn",
                    "animal_controller", "apartment_minigame_launcher", "apparcadebusiness", "apparcadebusinesshub",
                    "appavengeroperations", "appbikerbusiness", "appbroadcast", "appbunkerbusiness", "appbusinesshub",
                    "appcamera", "appchecklist", "appcontacts", "appcovertops", "appemail", "appextraction",
                    "appfixersecurity", "apphackertruck", "apphs_sleep", "appimportexport", "appinternet", "appjipmp",
                    "appmedia", "appmpbossagency", "appmpemail", "appmpjoblistnew", "apporganiser", "appprogresshub",
                    "apprepeatplay", "appsecurohack", "appsecuroserv", "appsettings", "appsidetask", "appsmuggler",
                    "apptextmessage", "apptrackify", "appvlsi", "appzit", "arcade_seating", "arena_box_bench_seats",
                    "arena_carmod", "arena_workshop_seats", "armenian1", "armenian2", "armenian3",
                    "armory_aircraft_carmod", "assassin_bus", "assassin_construction", "assassin_hooker",
                    "assassin_multi", "assassin_rankup", "assassin_valet", "atm_trigger", "audiotest",
                    "autosave_controller", "auto_shop_seating", "bailbond1", "bailbond2", "bailbond3", "bailbond4",
                    "bailbond_launcher", "barry1", "barry2", "barry3", "barry3a", "barry3c", "barry4", "base_carmod",
                    "base_corridor_seats", "base_entrance_seats", "base_heist_seats", "base_lounge_seats",
                    "base_quaters_seats", "base_reception_seats", "basic_creator", "beach_exterior_seating",
                    "benchmark", "bigwheel", "bj", "blackjack", "blimptest", "blip_controller", "bootycallhandler",
                    "bootycall_debug_controller", "buddydeathresponse", "bugstar_mission_export",
                    "buildingsiteambience", "building_controller", "business_battles", "business_battles_defend",
                    "business_battles_sell", "business_hub_carmod", "business_hub_garage_seats", "cablecar",
                    "camera_test", "camhedz_arcade", "cam_coord_sender", "candidate_controller", "carmod_shop",
                    "carsteal1", "carsteal2", "carsteal3", "carsteal4", "carwash1", "carwash2", "car_meet_carmod",
                    "car_meet_exterior_seating", "car_meet_interior_seating", "car_roof_test", "casinoroulette",
                    "casino_bar_seating", "casino_exterior_seating", "casino_interior_seating", "casino_lucky_wheel",
                    "casino_main_lounge_seating", "casino_nightclub_seating", "casino_penthouse_seating",
                    "casino_slots", "celebrations", "celebration_editor", "cellphone_controller", "cellphone_flashhand",
                    "charactergoals", "charanimtest", "cheat_controller", "chinese1", "chinese2", "chop",
                    "clothes_shop_mp", "clothes_shop_sp", "code_controller", "combat_test", "comms_controller",
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
                    "fm_content_bike_shop_delivery", "fm_content_business_battles", "fm_content_cargo",
                    "fm_content_cerberus", "fm_content_chop_shop_delivery", "fm_content_clubhouse_contracts",
                    "fm_content_club_management", "fm_content_club_odd_jobs", "fm_content_club_source",
                    "fm_content_convoy", "fm_content_crime_scene", "fm_content_drug_lab_work",
                    "fm_content_drug_vehicle", "fm_content_export_cargo", "fm_content_ghosthunt",
                    "fm_content_golden_gun", "fm_content_gunrunning", "fm_content_hsw_setup",
                    "fm_content_hsw_time_trial", "fm_content_island_dj", "fm_content_island_heist",
                    "fm_content_metal_detector", "fm_content_movie_props", "fm_content_mp_intro",
                    "fm_content_parachuter", "fm_content_payphone_hit", "fm_content_phantom_car",
                    "fm_content_possessed_animals", "fm_content_robbery", "fm_content_security_contract",
                    "fm_content_sightseeing", "fm_content_skydive", "fm_content_slasher", "fm_content_smuggler_ops",
                    "fm_content_smuggler_plane", "fm_content_smuggler_resupply", "fm_content_smuggler_sell",
                    "fm_content_smuggler_trail", "fm_content_source_research", "fm_content_stash_house",
                    "fm_content_taxi_driver", "fm_content_test", "fm_content_tow_truck_work",
                    "fm_content_tuner_robbery", "fm_content_vehicle_list", "fm_content_vehrob_arena",
                    "fm_content_vehrob_cargo_ship", "fm_content_vehrob_casino_prize", "fm_content_vehrob_disrupt",
                    "fm_content_vehrob_police", "fm_content_vehrob_prep", "fm_content_vehrob_scoping",
                    "fm_content_vehrob_submarine", "fm_content_vehrob_task", "fm_content_vip_contract_1",
                    "fm_content_xmas_mugger", "fm_content_xmas_truck", "fm_deathmatch_controler",
                    "fm_deathmatch_creator", "fm_hideout_controler", "fm_hold_up_tut", "fm_horde_controler",
                    "fm_impromptu_dm_controler", "fm_intro", "fm_intro_cut_dev", "fm_lts_creator",
                    "fm_maintain_cloud_header_data", "fm_maintain_transition_players", "fm_main_menu",
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
                    "line_activation_test", "liverecorder", "locates_tester", "luxe_veh_activity", "magdemo",
                    "magdemo2", "main", "maintransition", "main_install", "main_persistent", "martin1", "maude1",
                    "maude_postbailbond", "me_amanda1", "me_jimmy1", "me_tracey1", "mg_race_to_point", "michael1",
                    "michael2", "michael3", "michael4", "michael4leadout", "minigame_ending_stinger",
                    "minigame_stats_tracker", "minute1", "minute2", "minute3", "missioniaaturret", "mission_race",
                    "mission_repeat_controller", "mission_stat_alerter", "mission_stat_watcher", "mission_triggerer_a",
                    "mission_triggerer_b", "mission_triggerer_c", "mission_triggerer_d", "mmmm", "mpstatsinit",
                    "mptestbed", "mp_awards", "mp_bed_high", "mp_fm_registration", "mp_gameplay_menu", "mp_menuped",
                    "mp_player_damage_numbers", "mp_prop_global_block", "mp_prop_special_global_block",
                    "mp_registration", "mp_save_game_global_block", "mp_skycam_stuck_wiggler", "mp_unlocks",
                    "mp_weapons", "mrsphilips1", "mrsphilips2", "multistorey_garage_ext_seating",
                    "multistorey_garage_seating", "murdermystery", "music_studio_seating",
                    "music_studio_seating_external", "music_studio_smoking", "navmeshtest", "net_activity_creator_ui",
                    "net_apartment_activity", "net_apartment_activity_light", "net_bot_brain", "net_bot_simplebrain",
                    "net_cloud_mission_loader", "net_combat_soaktest", "net_freemode_debug_2023",
                    "net_freemode_debug_stat_2023", "net_jacking_soaktest", "net_session_soaktest", "net_test_drive",
                    "net_tunable_check", "nigel1", "nigel1a", "nigel1b", "nigel1c", "nigel1d", "nigel2", "nigel3",
                    "nightclubpeds", "nightclub_ground_floor_seats", "nightclub_office_seats", "nightclub_vip_seats",
                    "nodemenututorial", "nodeviewer", "ob_abatdoor", "ob_abattoircut", "ob_airdancer", "ob_bong",
                    "ob_cashregister", "ob_drinking_shots", "ob_foundry_cauldron", "ob_franklin_beer", "ob_franklin_tv",
                    "ob_franklin_wine", "ob_huffing_gas", "ob_jukebox", "ob_mp_bed_high", "ob_mp_bed_low",
                    "ob_mp_bed_med", "ob_mp_shower_med", "ob_mp_stripper", "ob_mr_raspberry_jam", "ob_poledancer",
                    "ob_sofa_franklin", "ob_sofa_michael", "ob_telescope", "ob_tv", "ob_vend1", "ob_vend2",
                    "ob_wheatgrass", "offroad_races", "omega1", "omega2", "paparazzo1", "paparazzo2", "paparazzo3",
                    "paparazzo3a", "paparazzo3b", "paparazzo4", "paradise", "paradise2", "pausemenu",
                    "pausemenucareerhublaunch", "pausemenu_example", "pausemenu_map", "pausemenu_multiplayer",
                    "pausemenu_sp_repeat", "pb_busker", "pb_homeless", "pb_preacher", "pb_prostitute",
                    "personal_carmod_shop", "photographymonkey", "photographywildlife", "physics_perf_test",
                    "physics_perf_test_launcher", "pickuptest", "pickupvehicles", "pickup_controller", "pilot_school",
                    "pilot_school_mp", "pi_menu", "placeholdermission", "placementtest", "planewarptest",
                    "player_controller", "player_controller_b", "player_scene_ft_franklin1", "player_scene_f_lamgraff",
                    "player_scene_f_lamtaunt", "player_scene_f_taxi", "player_scene_mf_traffic",
                    "player_scene_m_cinema", "player_scene_m_fbi2", "player_scene_m_kids", "player_scene_m_shopping",
                    "player_scene_t_bbfight", "player_scene_t_chasecar", "player_scene_t_insult", "player_scene_t_park",
                    "player_scene_t_tie", "player_timetable_scene", "playthrough_builder", "pm_defend", "pm_delivery",
                    "pm_gang_attack", "pm_plane_promotion", "pm_recover_stolen", "postkilled_bailbond2",
                    "postrc_barry1and2", "postrc_barry4", "postrc_epsilon4", "postrc_nigel3", "profiler_registration",
                    "prologue1", "prop_drop", "puzzle", "racetest", "rampage1", "rampage2", "rampage3", "rampage4",
                    "rampage5", "rampage_controller", "randomchar_controller", "range_modern", "range_modern_mp",
                    "replay_controller", "rerecord_recording", "respawn_controller", "restrictedareas",
                    "re_abandonedcar", "re_accident", "re_armybase", "re_arrests", "re_atmrobbery", "re_bikethief",
                    "re_border", "re_burials", "re_bus_tours", "re_cartheft", "re_chasethieves", "re_crashrescue",
                    "re_cultshootout", "re_dealgonewrong", "re_domestic", "re_drunkdriver", "re_duel", "re_gangfight",
                    "re_gang_intimidation", "re_getaway_driver", "re_hitch_lift", "re_homeland_security",
                    "re_lossantosintl", "re_lured", "re_monkey", "re_mountdance", "re_muggings", "re_paparazzi",
                    "re_prison", "re_prisonerlift", "re_prisonvanbreak", "re_rescuehostage", "re_seaplane",
                    "re_securityvan", "re_shoprobbery", "re_snatched", "re_stag_do", "re_yetarian", "rng_output",
                    "road_arcade", "rollercoaster", "rural_bank_heist", "rural_bank_prep1", "rural_bank_setup",
                    "salvage_yard_seating", "savegame_bed", "save_anywhere", "scaleformgraphictest",
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
                    "vehrob_planning", "veh_play_widget", "walking_ped", "wardrobe_mp", "wardrobe_sp",
                    "weapon_audio_widget", "wizard_arcade", "wp_partyboombox", "xml_menus", "yoga"}

function ADD_MP_INDEX(stat)
    local Exceptions = {"MP_CHAR_STAT_RALLY_ANIM", "MP_CHAR_ARMOUR_1_COUNT", "MP_CHAR_ARMOUR_2_COUNT",
                        "MP_CHAR_ARMOUR_3_COUNT", "MP_CHAR_ARMOUR_4_COUNT", "MP_CHAR_ARMOUR_5_COUNT"}
    for _, exception in pairs(Exceptions) do
        if stat == exception then
            return "MP" .. util.get_char_slot() .. "_" .. stat
        end
    end

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

function STAT_SET_DATE(stat, year, month, day, hour, min)
    local DatePTR = memory.alloc(8 * 7) -- Thanks for helping memory stuffs, aaronlink127#0127
    memory.write_int(DatePTR, year)
    memory.write_int(DatePTR + 8, month)
    memory.write_int(DatePTR + 16, day)
    memory.write_int(DatePTR + 24, hour)
    memory.write_int(DatePTR + 32, min)
    memory.write_int(DatePTR + 40, 0) -- Seconds
    memory.write_int(DatePTR + 48, 0) -- Milliseconds
    STATS.STAT_SET_DATE(util.joaat(ADD_MP_INDEX(stat)), DatePTR, 7, true)
end

function STAT_SET_MASKED_INT(stat, value1, value2)
    STATS.STAT_SET_MASKED_INT(util.joaat(ADD_MP_INDEX(stat)), value1, value2, 8, true)
end

function SET_PACKED_STAT_BOOL_CODE(stat, value)
    STATS.SET_PACKED_STAT_BOOL_CODE(stat, value, util.get_char_slot())
end

function STAT_INCREMENT(stat, value)
    STATS.STAT_INCREMENT(util.joaat(ADD_MP_INDEX(stat)), value, true)
end

function STAT_GET_INT(stat)
    local IntPTR = memory.alloc_int()
    STATS.STAT_GET_INT(util.joaat(ADD_MP_INDEX(stat)), IntPTR, -1)
    return memory.read_int(IntPTR)
end

function STAT_GET_FLOAT(stat)
    local FloatPTR = memory.alloc_int()
    STATS.STAT_GET_FLOAT(util.joaat(ADD_MP_INDEX(stat)), FloatPTR, -1)
    return tonumber(string.format("%.3f", memory.read_float(FloatPTR)))
end

function STAT_GET_BOOL(stat)
    if STAT_GET_INT(stat) ~= 0 then
        return "true"
    else
        return "false"
    end
end

function STAT_GET_STRING(stat)
    return STATS.STAT_GET_STRING(util.joaat(ADD_MP_INDEX(stat)), -1)
end

function STAT_GET_DATE(stat, type)
    local DatePTR = memory.alloc(8 * 7)
    STATS.STAT_GET_DATE(util.joaat(ADD_MP_INDEX(stat)), DatePTR, 7, true)
    local DateTypes = {"Years", "Months", "Days", "Hours", "Mins" -- Seconds,
    -- Milliseconds,
    }
    for i = 1, #DateTypes do
        if type == DateTypes[i] then
            return memory.read_int(DatePTR + 8 * (i - 1))
        end
    end
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

function SET_PACKED_INT_GLOBAL(start_global, end_global, value)
    for i = start_global, end_global do
        SET_INT_GLOBAL(262145 + i, value)
    end
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

---
---

menu.action(menu.my_root(), "restart lua", {"latiaorestartlua"}, "restartlua", function()
    util.restart_script()
end)
util.keep_running()

util.require_natives("3095a")

local killaura = menu.list(menu.my_root(), "killaura", {}, "")
local self = menu.list(menu.my_root(), "self", {}, "")
local world = menu.list(menu.my_root(), "world", {}, "")
local server = menu.list(menu.my_root(), "server", {}, "")
local test = menu.list(menu.my_root(), "test", {}, "")
local dividends = menu.list(menu.my_root(), "dividends", {}, "")
local admin = menu.list(menu.my_root(), "admin", {}, "")
local about = menu.list(menu.my_root(), "about", {}, "")

-- kill_aura_peds = false
-- kill_aura_player = false
-- kill_aura_in_vehicle = false
-- kill_aura_through_walls = false
-- kill_aura_explosion = false
-- kill_aura_nick_explosion = false
-- kill_aura_F_Loop = false
-- killaura_random_player = false

-- killaura_random_player_explosion = false

-- menu.toggle(killaura, "not IS_PED_IN_COMBAT", {}, "", function(on)
--     IS_PED_IN_COMBAT = on
-- end)
menu.toggle(killaura, "IS_ENTITY_DEAD", {}, "", function(on)
    IS_ENTITY_DEAD = on
end)

menu.toggle(killaura, "kill_aura_peds", {}, "", function(on)
    kill_aura_peds = on
end)

menu.toggle(killaura, "killaura_player", {}, "", function(on)
    kill_aura_player = on
end)

menu.toggle(killaura, "killaura_in_vehicle", {}, "", function(on)
    kill_aura_in_vehicle = on
end)

menu.toggle(killaura, "killaura_attack_walls_back", {}, "", function(on)
    kill_aura_through_walls = on
end)

menu.toggle(killaura, "killaura_use_explosion", {}, "", function(on)
    kill_aura_explosion = on
end)

menu.toggle(killaura, "killaura_use_nick_explosion", {}, "", function(on)
    kill_aura_nick_explosion = on
end)

menu.toggle(killaura, "kill_aura_use_fire_Loop", {}, "", function(on)
    kill_aura_fire_Loop = on
end)

menu.toggle(killaura, "killaura_use_random_player", {}, "", function(on)
    killaura_random_player = on
end)

menu.toggle(killaura, "killaura_use_random_player_explosion", {}, "", function(on)
    killaura_random_player_explosion = on
end)

local killauratime = menu.slider(killaura, "killauratime", {"killauratime"}, "", 0, INT_MAX, 0, 1, function()
end)

local killauraDamage = menu.slider(killaura, "killauraDamage", {"killauraDamage"}, "", 0, INT_MAX, 0, 1, function()
end)
-- menu.toggle(killaura, "kick ped to vehicle", {}, "", function(on)
--     kill_aura_kick_vehicle = on

-- end)

menu.toggle_loop(killaura, "killaura all", {"latiaokillaura"}, ("SHOOT ALL"), function()
    -- if kill_aura_peds or kill_aura_player or kill_aura_in_vehicle then
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        local list = players.list()
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
                FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, menu.get_value(killauraDamage), false, true, 0.0)
            elseif killaura_random_player_explosion then
                FIRE.ADD_OWNED_EXPLOSION(randomPid, pos.x, pos.y, pos.z, 0, menu.get_value(killauraDamage), false, true, 0.0)
            elseif killaura_random_player then
                -- util.log("killaura_random_player")
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.5, pos.x, pos.y, pos.z, menu.get_value(killauraDamage), true,
                    util.joaat("weapon_pistol"), randomPid, false, true, INT_MAX)
            else
                -- util.log("killaura_none")
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.5, pos.x, pos.y, pos.z, menu.get_value(killauraDamage), true,
                    util.joaat("weapon_pistol"), players.user_ped(), false, true, INT_MAX)
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

menu.toggle_loop(self, "heal/armour", {}, "", function()
    util.draw_debug_text("heal: " .. ENTITY.GET_ENTITY_HEALTH(players.user_ped()) .. "/" ..
                             PED.GET_PED_MAX_HEALTH(players.user_ped()) .. "\narmour: " ..
                             PED.GET_PED_ARMOUR(players.user_ped()) .. "/" ..
                             PLAYER.GET_PLAYER_MAX_ARMOUR(players.user()))
end)

menu.toggle_loop(world, "delallobjects", {"latiaodelallobjects"}, "delallobjects.", function()
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            entities.delete(ent)
        end)
        if not success then

        end

    end
end)

menu.toggle_loop(world, "delallpeds", {"latiaodelallpeds"}, "delallpeds.", function()
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

menu.toggle_loop(world, "delallvehicles", {"latiaodelallvehicles"}, "delallvehicles.", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        local success, error_message = pcall(function()
            entities.delete(ent)
        end)
        if not success then

        end

    end
end)

menu.toggle_loop(world, "delallpickups", {"latiaodelallvehicles"}, "delallvehicles.", function()
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        local success, error_message = pcall(function()
            entities.delete(ent)
        end)
        if not success then

        end

    end
end)

menu.toggle_loop(world, "delall", {"latiaodelall"}, "delall.", function()

    for _, entity in ipairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            entities.delete(entity)
        end)

        if not success then

        end
    end
end)

menu.toggle_loop(world, "TPALL 0 0 0", {"latiaodelallvehicles"}, "delallvehicles.", function()

    for _, entity in ipairs(ALL_Entities()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_COORDS(entity, 0, 0, 2600, false)
        end)

        if not success then
            print("Error teleporting entity: " .. error_message)
        end
    end
end)

menu.toggle_loop(world, "kick ped to vehicle", {"latiaokickpedvehicle"}, ("kickpedvehicle"), function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
            end
        end
    end
end)

menu.toggle_loop(world, "remove DEAD(ped)", {"latiaoremoveDEADped"}, ("latiaoremoveDEADped"), function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if ENTITY.IS_ENTITY_DEAD(ped) then
            entities.delete(ped)

        end
    end
end)

menu.toggle_loop(world, "REMOVE_ALL_PED_WEAPONS", {"latiaoREMOVE_ALL_PED_WEAPONS"}, "REMOVE_ALL_PED_WEAPONS.",
    function()
        for _, ped in pairs(entities.get_all_peds_as_handles()) do
            if not entities.is_player_ped(ped) then
                WEAPON.REMOVE_ALL_PED_WEAPONS(ped)
            end
        end
    end)
menu.toggle_loop(world, "FREEZE_ENTITY_POSITION", {"latiaoFREEZE_ENTITY_POSITION"}, "FREEZE_ENTITY_POSITION.",
    function()
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

menu.toggle_loop(world, "tppedtome", {"latiaotppedtome"}, "latiaotppedtome.", function()
    local pos = players.get_position(players.user())
    for _, ped in entities.get_all_peds_as_handles() do
        if not entities.is_player_ped(ped) then
            ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z, false)
        end
    end
end)

menu.toggle_loop(world, "silencekillallped", {"latiaosilencekillallped"}, "latiaotsilencekillallped.", function()
    for _, ped in entities.get_all_peds_as_handles() do
        if not entities.is_player_ped(ped) then
            local pos = players.get_position(players.user())
            ENTITY.SET_ENTITY_COORDS(ped, pos.x, pos.y, pos.z - 50, false)
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z - 50, 0, 1, false, true, 0.0)
        end
    end
end)

menu.toggle_loop(world, "tppedto 00", {"latiaotppedto00"}, "latiaotpped00.", function()
    for _, ped in entities.get_all_peds_as_handles() do
        if not entities.is_player_ped(ped) then
            ENTITY.SET_ENTITY_COORDS(ped, 0, 0, -200, false)
        end
    end
end)

menu.toggle_loop(world, "SET_PED_TO_RAGDOLL_WITH_FALL ped", {"latiaoSET_PED_TO_RAGDOLL_WITH_FALL"},
    "latiaoSET_PED_TO_RAGDOLL_WITH_FALL.", function()
        for _, ped in entities.get_all_peds_as_handles() do
            PED.SET_PED_TO_RAGDOLL(ped, 0, 0, 0);
        end
    end)

menu.toggle_loop(world, "CLEAR_PED_TASKS_IMMEDIATELY", {"latiaoCLEAR_PED_TASKS_IMMEDIATELY"},
    "CLEAR_PED_TASKS_IMMEDIATELY.", function()
        for _, ped in pairs(entities.get_all_peds_as_handles()) do
            if not entities.is_player_ped(ped) then
                TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
            end
        end
    end)

menu.toggle_loop(world, "CLEAR_PED_TASKS", {"LATIAOCLEAR_PED_TASKS"}, "LATIAOCLEAR_PED_TASKS.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            TASK.CLEAR_PED_TASKS(ped)
        end
    end
end)

menu.toggle_loop(world, "maxpedVEHICLE", {"latiaomaxpedVEHICLE"}, "latiaomaxpedVEHICLE.", function()
    PED.INSTANTLY_FILL_PED_POPULATION()
    VEHICLE.INSTANTLY_FILL_VEHICLE_POPULATION()
end)
menu.toggle_loop(world, "maxpedforyouteam", {"latiaomaxpedforyouteam"}, "latiaomaxpedforyouteam.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, PED.GET_PED_RELATIONSHIP_GROUP_HASH(players.user_ped()))
    end
end)
menu.toggle_loop(world, "resetteam", {"latiaomaxpedforyouteam"}, "latiaomaxpedforyouteam.", function()
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ped) then
            PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, 0xD9D08749)
        end
    end
end)
menu.toggle_loop(world, "no new cops for all", {""}, "", function()
    PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(players.user(), false)
end, function()
    PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(players.user(), true)
end)

menu.toggle_loop(world, "tp Picked", {"LatiaoTpPicked"}, ("TpPicked for you"), function()
    local pos = players.get_position(players.user())
    for _, pickup in entities.get_all_pickups_as_handles() do
        ENTITY.SET_ENTITY_COORDS(pickup, pos.x, pos.y, pos.z, false)
    end
end)

menu.toggle_loop(world, "del cops", {"latiaodelcops"}, "latiaodelcops", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        for _, copsModels in ipairs({util.joaat("s_m_y_cop_01"), util.joaat("s_m_y_sheriff_01"),
                                     util.joaat("s_m_y_swat_01"), util.joaat("s_m_y_hwaycop_01")}) do
            if ENTITY.GET_ENTITY_MODEL(ent) == copsModels then
                entities.delete(ent)
                break
            end
        end
    end
end)

menu.toggle_loop(server, "auto host", {"latiaoautohost"}, ("autohost"), function()
    if not (players.get_host() == players.user()) then
        menu.trigger_commands("kick" .. PLAYER.GET_PLAYER_NAME(players.get_host()))
    end
end)
menu.toggle_loop(server, "auto freemode Script host", {"latiaoautoScripthost"}, ("autoScripthost"), function()
    if not (players.get_script_host() == players.user()) then
        util.request_script_host("freemode")
    end
end)

menu.toggle_loop(server, "auto freemode Script host2", {"latiaoautoScripthost"}, ("autoScripthost"), function()

    util.request_script_host("freemode")
    -- end
end)
menu.action(server, "kickall exclude hosts and cheat", {"latiaokickallexcludehost"}, "latiaokickallexcludehost",
    function()
        for k, pid in pairs(players.list()) do
            if pid == players.get_host() or pid == players.user() or players.is_marked_as_modder(pid) then
                goto out
            end
            util.trigger_script_event(1 << pid, {968269233, pid, 4, 233, 1, 1, 1})
            ::out::
        end
        
    end)

menu.toggle_loop(server, "LOVEkick + report all moder", {"latiaocrashkickmod"}, "crash and kickmod.", function()
    for k, pid in pairs(players.list()) do
        if pid == players.get_host() or pid == players.user() then
            goto out
        end
        if players.is_marked_as_modder(pid) then
            local attack = PLAYER.GET_PLAYER_NAME(pid)
            if pid == players.user() then
                goto out
            end
            menu.trigger_commands("reportgriefing" .. attack)
            menu.trigger_commands("reportexploits" .. attack)
            menu.trigger_commands("reportbugabuse" .. attack)
            util.yield(500)
            menu.trigger_commands("loveletterkick" .. attack)
        end

        ::out::
    end

end)

menu.toggle_loop(server, "LOVEkick all moder", {""}, ".", function()
    for k, pid in pairs(players.list()) do
        if pid == players.get_host() or pid == players.user() then
            goto out
        end
        if players.is_marked_as_modder(pid) then
            local attack = PLAYER.GET_PLAYER_NAME(pid)
            if pid == players.user() then
                goto out
            end
            menu.trigger_commands("loveletterkick" .. attack)
        end

        ::out::
    end

end)

menu.toggle_loop(server, "if you host kick chinese", {"latiaocrashall"}, "", function()
    if NETWORK.NETWORK_IS_HOST() then
        for k, pid in pairs(players.list()) do
            local language = players.get_language(pid)
            if language == 12 then
                local attack = PLAYER.GET_PLAYER_NAME(pid)
                if pid == players.user() then
                    goto out
                end
                menu.trigger_commands("loveletterkick" .. attack)
                -- util.log(attack)
            end

        end
        ::out::
    end

end)

menu.toggle_loop(server, "if you host ban all moder", {"latiaobankallmoder"}, "latiaobankallmoder.", function()
    if NETWORK.NETWORK_IS_HOST() then
        for k, pid in pairs(players.list()) do
            if pid == players.user() then
                goto out
            end
            if players.is_marked_as_modder(pid) then
                local attack = PLAYER.GET_PLAYER_NAME(pid)
                util.toast(attack .. "kick ing")
                menu.trigger_commands("reportgriefing" .. attack)
                util.yield(100)
                menu.trigger_commands("ban" .. attack)
            end

        end
        ::out::
    end

end)

menu.toggle_loop(server, "if you no host kick for kick you cheat", {"raidallplayer"}, "", function()
    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path("Online>Protections>Events>Kick Event>Love Letter Kick>Disabled"))
    else
        menu.trigger_command(menu.ref_by_path("Online>Protections>Events>Kick Event>Love Letter Kick>Strangers"))
    end
end)

menu.action(server, "love letter kick all", {"latiaoloveletterkickall"}, "loveletter kick all.", function()
    for k, pid in pairs(players.list()) do
        if pid == players.user() then
            goto out
        end
        local player = PLAYER.GET_PLAYER_NAME(pid)

        menu.trigger_commands("loveletterkick" .. player)
        ::out::
    end

end)

menu.action(server, "hostkickall", {"latiaohostkickall"}, "latiaohostkickall.", function()
    if NETWORK.NETWORK_IS_HOST() then
        for k, pid in pairs(players.list()) do
            if pid == players.user() then
                goto out
            end
            NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)

        end
        ::out::
    end

end)

menu.action(server, "timeoutall", {"latiaotimeout"}, "latiaotimeout.", function()
    for k, pid in pairs(players.list()) do
        if pid == players.user() then
            goto out
        end
        local player = PLAYER.GET_PLAYER_NAME(pid)
        menu.trigger_commands("timeout" .. player)
        ::out::
    end

end)

menu.action(server, "kick me", {"latiaokickme"}, "latiaokickme.", function()
    NETWORK.NETWORK_SESSION_KICK_PLAYER(players.user())
end)

menu.toggle_loop(server, "if you host reportall", {"latiaoreportall"}, "reportall.", function()
    util.yield(1000)
    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path(
            "Players>All Players>Increment Commend/Report Stats>Griefing or Disruptive Gameplay"))
        menu.trigger_command(menu.ref_by_path("Players>All Players>Increment Commend/Report Stats>Cheating or Modding"))
        menu.trigger_command(menu.ref_by_path(
            "Players>All Players>Increment Commend/Report Stats>Glitching or Abusing Game Features"))
    end
end)

menu.toggle_loop(server, "loop commendation all", {"latiaoreportall"}, "reportall.", function()
    util.yield(1000)
    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path("Players>All Players>Increment Commend/Report Stats>Helpful"))
        menu.trigger_command(menu.ref_by_path("Players>All Players>Increment Commend/Report Stats>Friendly"))
    end
end)

menu.toggle_loop(server, "kick all for vehicle script_event", {"latiaoreportall"}, "reportall.", function()
    for k, pid in pairs(players.list()) do
        util.trigger_script_event(1 << pid, {-503325966})
    end
end)

menu.toggle_loop(server, "report all no host", {"latiaofackhackattackall"}, "reportall.", function()
    util.yield(1000)
    for k, pid in pairs(players.list()) do
        if pid == players.get_host() or pid == players.user() then
            goto out
        end
        local player = PLAYER.GET_PLAYER_NAME(pid)
        menu.trigger_commands("reportgriefing" .. player)
        menu.trigger_commands("reportexploits" .. player)
        menu.trigger_commands("reportbugabuse" .. player)

        ::out::
    end

end)

menu.toggle_loop(server, "bad TIMER_STOP SOUND for all", {"latiaobedsoundforall"}, "latiaobedsoundforall", function()
    AUDIO.PLAY_SOUND_FROM_COORD(-1, "TIMER_STOP", 0, 0, 0, "HUD_MINI_GAME_SOUNDSET", true, INT_MAX, true)

    -- util.yield(50)
end)

menu.toggle_loop(server, "bad WastedSounds SOUND for all", {"latiaobedsoundforall"}, "latiaobedsoundforall", function()
    AUDIO.PLAY_SOUND_FROM_COORD(-1, "MP_Flash", 0, 0, 0, "WastedSounds", true, INT_MAX, true)

    -- util.yield(50)
end)

menu.toggle_loop(server, "bad Camera_Shoot SOUND for all", {"latiaobedsoundforall"}, "latiaobedsoundforall", function()
    AUDIO.PLAY_SOUND_FROM_COORD(-1, "Camera_Shoot", 0, 0, 0, "Phone_Soundset_Franklin", true, INT_MAX, true)

    -- util.yield(50)
end)

menu.action(test, "test", {"test"}, "test.", function()

end)

-- menu.toggle_loop(server, "REQUES_ENTITY pedtest", {"latiaoREQUES_ENTITYped"}, "latiaoREQUES_ENTITYped.", function()

-- for _, target in ipairs(entities.get_all_peds_as_handles()) do
--     local success = NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)

-- end

-- end)

menu.toggle_loop(server, "REQUES_ENTITY ped2", {"latiaoREQUES_ENTITYped"}, "latiaoREQUES_ENTITYped.", function()
    for _, target in ipairs(entities.get_all_peds_as_handles()) do
        local owner = entities.get_owner(target)
        if not entities.is_player_ped(target) and owner ~= players.user() then
            local success, error_message = pcall(function()
                local require = NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)
            end)

            if not success then
                -- print(success,error_message)
            end
        end
    end

end)

menu.toggle_loop(server, "REQUES_ENTITY objects2", {"latiaoREQUES_ENTITYobjects"}, "REQUES_ENTITYobjects.", function()
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

menu.toggle_loop(server, "REQUES_ENTITY vehicles2", {"latiaoREQUES_ENTITYvehicles"}, "REQUES_ENTITYvehicles.",
    function()
        for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
            local owner = entities.get_owner(target)
            if owner ~= players.user() then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)

            end
        end
    end)

menu.toggle_loop(server, "REQUES_ENTITY vehicles no player2", {""}, ".", function()
    for _, target in ipairs(entities.get_all_vehicles_as_handles()) do
        for k, pid in pairs(players.list()) do
            local v1 = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
            if target == v1 then
                goto out
            end
            local owner = entities.get_owner(target)
            if owner ~= players.user() then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)

            end
        end
        ::out::
    end

end)

menu.toggle_loop(server, "REQUES_ENTITY pickups2", {""}, "", function()
    for k, target in pairs(entities.get_all_pickups_as_handles()) do
        local owner = entities.get_owner(target)
        if owner ~= players.user() then

            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(target)

        end
    end
end)

menu.action(test, "NETWORK_SESSION_END", {"latiaoNETWORK_SESSION_END"}, "NETWORK_SESSION_END.", function()
    NETWORK.NETWORK_SESSION_END(0, 0);
end)

menu.action(test, "IS_SCRIPTED_CONVERSATION_ONGOING", {"latiaoIS_SCRIPTED_CONVERSATION_ONGOING"},
    "IS_SCRIPTED_CONVERSATION_ONGOING.", function()
        AUDIO.STOP_SCRIPTED_CONVERSATION(false)
    end)

menu.action(world, "autoDRIVE LONGRANGE", {"latiaoautoDRIVELONGRANGE"}, "autoDRIVELONGRANGE", function()
    local pos = v3.new(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8)))
    TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(players.user_ped(), entities.get_user_vehicle_as_handle(), pos, 1000,
        787004, 0)
end)

menu.action(world, "autoDRIVE", {"latiaoautoDRIVE"}, "autoDRIVE.", function()
    local pos = v3.new(HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8)))
    TASK.TASK_VEHICLE_DRIVE_TO_COORD(players.user_ped(), entities.get_user_vehicle_as_handle(), pos, 1000, -1,
        ENTITY.GET_ENTITY_MODEL(entities.get_user_vehicle_as_handle()), 787004, -1, -1)
end)

menu.action(world, "stopautoDRIVE", {"latiaostopautoDRIVE"}, "stopautoDRIVE.", function()
    TASK.CLEAR_PED_TASKS(players.user_ped())
end)

menu.toggle_loop(test, "clean chat", {"latiaocleanchat"}, "latiaocleanchat.", function()
    chat.send_message("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", false, true, true)
end)

menu.action(test, "CLEAR_ALL_HELP_MESSAGES", {"latiaoCLEAR_ALL_HELP_MESSAGES"}, "CLEAR_ALL_HELP_MESSAGES.", function()
    HUD.CLEAR_ALL_HELP_MESSAGES()
end)

menu.toggle_loop(dividends, "jump hack", {"latiaojumphack"}, "latiaojumphack.", function()
    SET_INT_LOCAL("fm_mission_controller_2020", 24333, 5)
    SET_FLOAT_LOCAL("fm_mission_controller_2020", 30357 + 3, 100)
    SET_INT_LOCAL("fm_mission_controller_2020", 1721, GET_INT_LOCAL("fm_mission_controller_2020", 1722))
    SET_INT_LOCAL("fm_mission_controller_2020", 978 + 135, 3)
    SET_INT_LOCAL("fm_mission_controller", 52985, 5)
    SET_INT_LOCAL("fm_mission_controller", 54047, 5)
    SET_INT_LOCAL("fm_mission_controller", 10107 + 7, GET_INT_LOCAL("fm_mission_controller", 10107 + 37))
    SET_INT_LOCAL("fm_mission_controller", 1512, 3) -- For ACT I, Setup: Server Farm (Lester), https://www.unknowncheats.me/forum/3687245-post112.html
    SET_INT_LOCAL("fm_mission_controller", 1543, 2)
    SET_INT_LOCAL("fm_mission_controller", 1269 + 135, 3) -- For ACT III, https://www.unknowncheats.me/forum/3455828-post8.html
    -- SET_INT_LOCAL("fm_mission_controller", 11776 + 24, 7)
    -- SET_FLOAT_LOCAL("fm_mission_controller", 10067 + 11, 100)

end)
menu.action(dividends, "MPPLY_H3_COOLDOWN", {""}, "MPPLY_H3_COOLDOWN.", function()
    STAT_SET_INT("MPPLY_H3_COOLDOWN", -1)
end)
menu.action(dividends, "跳过赌场冷却", {}, "", function()
    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)

end)
local nohostalldividends = menu.slider(dividends, "不是主机本地分红", {"nohostcasino"}, "", -100000, 100000,
    100, 5, function()

    end)

menu.toggle_loop(dividends, "设置不是主机本地分红", {""}, "latiaonohost.", function()
    SET_INT_GLOBAL(2685249 + 6615, menu.get_value(nohostalldividends))
end)

menu.toggle_loop(dividends, "一键设置赌场前置和分红 1-4人", {""}, ".", function()


    STAT_SET_INT("H3OPT_ACCESSPOINTS", -1)
    STAT_SET_INT("H3OPT_POI", -1)
    STAT_SET_INT("H3OPT_BITSET1", -1)
    STAT_SET_INT("H3OPT_BITSET0", -1)
    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)

    STAT_SET_INT("H3OPT_CREWWEAP", 4)
    STAT_SET_INT("H3OPT_CREWDRIVER", 5)
    STAT_SET_INT("H3OPT_CREWHACKER", 4)

    SET_INT_GLOBAL(262145 + 29068, 0)
    SET_INT_GLOBAL(262145 + 29093 + 1, 0)
    SET_INT_GLOBAL(262145 + 29093 + 2, 0)
    SET_INT_GLOBAL(262145 + 29093 + 3, 0)
    SET_INT_GLOBAL(262145 + 29093 + 4, 0)
    SET_INT_GLOBAL(262145 + 29093 + 5, 0)
    SET_INT_GLOBAL(262145 + 29093 + 6, 0)
    SET_INT_GLOBAL(262145 + 29093 + 7, 0)
    SET_INT_GLOBAL(262145 + 29093 + 8, 0)
    SET_INT_GLOBAL(262145 + 29093 + 9, 0)
    SET_INT_GLOBAL(262145 + 29093 + 10, 0)
    SET_INT_GLOBAL(262145 + 29093 + 11, 0)
    SET_INT_GLOBAL(262145 + 29093 + 12, 0)
    SET_INT_GLOBAL(262145 + 29093 + 13, 0)
    SET_INT_GLOBAL(262145 + 29093 + 14, 0)
    SET_INT_GLOBAL(262145 + 29093 + 15, 0)

    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 1, 100)

    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 2, 100)

    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 3, 100)

    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 4, 100)
end)

-- =
-- end)

menu.action(dividends, "完成赌场前置", {""}, "", function()
    STAT_SET_INT("H3OPT_ACCESSPOINTS", -1)
    STAT_SET_INT("H3OPT_POI", -1)
    STAT_SET_INT("H3OPT_BITSET1", -1)
    STAT_SET_INT("H3OPT_BITSET0", -1)
    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
end)

menu.action(dividends, "设置赌场抢劫npc为最高级", {""}, "    .", function()
    STAT_SET_INT("H3OPT_CREWWEAP", 4)
    STAT_SET_INT("H3OPT_CREWDRIVER", 5)
    STAT_SET_INT("H3OPT_CREWHACKER", 4)
end)

local casino = menu.slider(dividends, "赌场抢劫分红", {""}, "", -100000, 100000, 100, 5, function()
end)
menu.toggle_loop(dividends, "设置赌场抢劫分红", {""}, "    .", function()
    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 1, menu.get_value(casino))

    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 2, menu.get_value(casino))

    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 3, menu.get_value(casino))

    SET_INT_GLOBAL(1963945 + 1497 + 736 + 92 + 4, menu.get_value(casino))
end)

menu.toggle_loop(dividends, "删除赌场npc分红", {""}, ".", function()
    SET_INT_GLOBAL(262145 + 29068, 0)
    SET_INT_GLOBAL(262145 + 29093 + 1, 0)
    SET_INT_GLOBAL(262145 + 29093 + 2, 0)
    SET_INT_GLOBAL(262145 + 29093 + 3, 0)
    SET_INT_GLOBAL(262145 + 29093 + 4, 0)
    SET_INT_GLOBAL(262145 + 29093 + 5, 0)
    SET_INT_GLOBAL(262145 + 29093 + 6, 0)
    SET_INT_GLOBAL(262145 + 29093 + 7, 0)
    SET_INT_GLOBAL(262145 + 29093 + 8, 0)
    SET_INT_GLOBAL(262145 + 29093 + 9, 0)
    SET_INT_GLOBAL(262145 + 29093 + 10, 0)
    SET_INT_GLOBAL(262145 + 29093 + 11, 0)
    SET_INT_GLOBAL(262145 + 29093 + 12, 0)
    SET_INT_GLOBAL(262145 + 29093 + 13, 0)
    SET_INT_GLOBAL(262145 + 29093 + 14, 0)
    SET_INT_GLOBAL(262145 + 29093 + 15, 0)

end)

menu.action(dividends, "刷新赌场面板", {""}, "", function()
    local Board1 = STAT_GET_INT("H3OPT_BITSET0")
    local Board2 = STAT_GET_INT("H3OPT_BITSET1")
    STAT_SET_INT("H3OPT_BITSET0", math.random(INT_MAX))
    STAT_SET_INT("H3OPT_BITSET1", math.random(INT_MAX))
    util.yield_once()
    STAT_SET_INT("H3OPT_BITSET0", Board1)
    STAT_SET_INT("H3OPT_BITSET1", Board2)
end)

menu.action(dividends, "完成末日前置", {}, "", function()
    STAT_SET_INT("GANGOPS_FLOW_MISSION_PROG", -1)
end)

local Doomsday = menu.slider(dividends, "末日分红", {""}, "2400000", -100000, 100000, 100, 5, function()
end)

menu.toggle_loop(dividends, "设置末日分红", {"设置末日分红"}, "设置末日分红.", function()
    SET_INT_GLOBAL(1959865 + 812 + 50 + 1, menu.get_value(Doomsday))

    SET_INT_GLOBAL(1959865 + 812 + 50 + 2, menu.get_value(Doomsday))

    SET_INT_GLOBAL(1959865 + 812 + 50 + 3, menu.get_value(Doomsday))

    SET_INT_GLOBAL(1959865 + 812 + 50 + 4, menu.get_value(Doomsday))
end)

menu.action(dividends, "跳过小岛冷却", {}, "", function()
    STAT_SET_INT("H4_PROGRESS", -1)

end)

menu.action(dividends, "完成小岛前置", {}, "", function()
    STAT_SET_INT("H4CNF_BS_ENTR", -1)
    STAT_SET_INT("H4CNF_BS_GEN", -1)
    STAT_SET_INT("H4CNF_BS_ABIL", -1)
    STAT_SET_INT("H4CNF_APPROACH", -1)
    STAT_SET_INT("H4_MISSIONS", -1)

end)


menu.toggle_loop(dividends, "一键设置小岛前置和分红 1-4人", {}, "", function()
    STAT_SET_INT("H4_PROGRESS", 126823)

    STAT_SET_INT("H4CNF_BS_ENTR", -1)
    STAT_SET_INT("H4CNF_BS_GEN", -1)
    STAT_SET_INT("H4CNF_BS_ABIL", -1)
    STAT_SET_INT("H4CNF_APPROACH", -1)
    STAT_SET_INT("H4_MISSIONS", -1)

    STAT_SET_INT("H4CNF_TARGET", 1)

    STAT_SET_INT("H4LOOT_CASH_I", 0)
    STAT_SET_INT("H4LOOT_CASH_C", 0)
    STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 0)
    STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
    STAT_SET_INT("H4LOOT_CASH_V", 0)
    STAT_SET_INT("H4LOOT_WEED_I", 0)
    STAT_SET_INT("H4LOOT_WEED_C", 0)
    STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 0)
    STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
    STAT_SET_INT("H4LOOT_WEED_V", 0)
    STAT_SET_INT("H4LOOT_COKE_I", 0)
    STAT_SET_INT("H4LOOT_COKE_C", 0)
    STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 0)
    STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
    STAT_SET_INT("H4LOOT_COKE_V", 0)
    STAT_SET_INT("H4LOOT_GOLD_I", 0)
    STAT_SET_INT("H4LOOT_GOLD_C", 0)
    STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
    STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 0)
    STAT_SET_INT("H4LOOT_GOLD_V", 0)
    STAT_SET_INT("H4LOOT_PAINT", 0)
    STAT_SET_INT("H4LOOT_PAINT_SCOPED", 0)
    STAT_SET_INT("H4LOOT_PAINT_V", 0)


    SET_INT_GLOBAL(1970744 + 831 + 56 + 1, 300)
    SET_INT_GLOBAL(1970744 + 831 + 56 + 2, 300)
    SET_INT_GLOBAL(1970744 + 831 + 56 + 3, 300)
    SET_INT_GLOBAL(1970744 + 831 + 56 + 4, 300)

    SET_INT_GLOBAL(262145 + 30259 + 9, 0)
    SET_INT_GLOBAL(262145 + 30259 + 10, 0)  

end)

local Perico = menu.slider(dividends, "小岛分红", {""}, "", INT_MIN, INT_MAX, 100, 5, function()
end)

menu.toggle_loop(dividends, "设置小岛分红", {""}, ".", function()
    SET_INT_GLOBAL(1970744 + 831 + 56 + 1, menu.get_value(Perico))
    SET_INT_GLOBAL(1970744 + 831 + 56 + 2, menu.get_value(Perico))
    SET_INT_GLOBAL(1970744 + 831 + 56 + 3, menu.get_value(Perico))
    SET_INT_GLOBAL(1970744 + 831 + 56 + 4, menu.get_value(Perico))
end)
menu.toggle_loop(dividends, "删除小岛npc分红", {""}, ".", function()
    SET_INT_GLOBAL(262145 + 30259 + 9, 0)
    SET_INT_GLOBAL(262145 + 30259 + 10, 0)

end)
local Pericotarget = menu.slider(dividends, "小岛目标价值", {"CayoMain"}, "CayoMain", INT_MIN, INT_MAX, 1000,
    100000, function()
    end)
menu.action(dividends, "设置小岛目标价值", {""}, "", function()
    SET_INT_GLOBAL(262145 + 30259 + 0, menu.get_value(Pericotarget))
    SET_INT_GLOBAL(262145 + 30259 + 1, menu.get_value(Pericotarget))
    SET_INT_GLOBAL(262145 + 30259 + 2, menu.get_value(Pericotarget))
    SET_INT_GLOBAL(262145 + 30259 + 3, menu.get_value(Pericotarget))
    SET_INT_GLOBAL(262145 + 30259 + 4, menu.get_value(Pericotarget))
    SET_INT_GLOBAL(262145 + 30259 + 5, menu.get_value(Pericotarget))
end)
menu.action(dividends, "小岛无限背包 ", {""}, ".", function()
    SET_INT_GLOBAL(262145 + 30009, 100000000)
end)

menu.action(dividends, "完成公寓抢劫", {""}, "", function()
    STAT_SET_INT("HEIST_PLANNING_STAGE", -1)
end)

menu.toggle_loop(dividends, "公寓抢劫总价值14500000 (you host)", {""}, ".", function()
    SET_INT_GLOBAL(262145 + 9314 + 1, 14500000)
    SET_INT_GLOBAL(262145 + 9314 + 2, 14500000)
    SET_INT_GLOBAL(262145 + 9314 + 3, 14500000)
    SET_INT_GLOBAL(262145 + 9314 + 4, 14500000)
end)

local Apartment = menu.slider(dividends, "公寓抢劫分红", {""}, "15000000", INT_MIN, INT_MAX, 100, 100, function()
end)
menu.toggle_loop(dividends, "设置公寓抢劫分红 (you host)", {""}, ".", function()
    SET_INT_GLOBAL(1930201 + 3008 + 1, menu.get_value(Apartment))
    SET_INT_GLOBAL(1930201 + 3008 + 2, menu.get_value(Apartment))
    SET_INT_GLOBAL(1930201 + 3008 + 3, menu.get_value(Apartment))
    SET_INT_GLOBAL(1930201 + 3008 + 4, menu.get_value(Apartment))
end)

menu.toggle_loop(server, "fm_mission_controller host test", {"latiaofm_mission_controllertest"},
    "latiaofm_mission_controllertest.", function()
        local host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT("fm_mission_controller", 0, 0)

        local name = PLAYER.GET_PLAYER_NAME(host)
        if name ~= "**Invalid**" then
            util.draw_debug_text("fm_mission_controller host is:" .. name)
        end

    end)
menu.toggle_loop(server, "fm_mission_controller_2020 host test", {"latiaofm_mission_controller_2020test"},
    "latiaofm_mission_controllertest_2020.", function()
        local host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT("fm_mission_controller_2020", 0, 0)

        local name = PLAYER.GET_PLAYER_NAME(host)
        -- print(name)
        if name ~= "**Invalid**" then
            util.draw_debug_text("fm_mission_controller_2020 host is: " .. name)
        end

    end)
menu.toggle_loop(server, "freemode host test", {"latiaofreemodetest"}, "latiaofreemodetest.", function()
    local host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT("freemode", -1, 0)
    local name = PLAYER.GET_PLAYER_NAME(host)
    if name ~= "**Invalid**" then
        util.draw_debug_text("freemode host is: " .. name)
    end
end)

menu.action(dividends, "request_script_host fm_mission_controller", {"latiaoNrequest_script_host"},
    "latiaoNrequest_script_host.", function()
        util.request_script_host("fm_mission_controller_2020")
        util.request_script_host("fm_mission_controller")
    end)

menu.action(dividends, "fin fm_mission_controller_2020 ", {"fin fm_mission_controller_2020"},
    "finfm_mission_controller_2020", function()
        SET_INT_LOCAL("fm_mission_controller_2020", 48513 + 1, 17784544)
        SET_INT_LOCAL("fm_mission_controller_2020", 48513 + 1765 + 1, 2000)
    end)

menu.action(dividends, "fin fm_mission_controller_2020 2 ", {"fin fm_mission_controller_2020"},
    "finfm_mission_controller_2020", function()
        SET_INT_LOCAL("fm_mission_controller_2020", 45450 + 1, 51338752)
        SET_INT_LOCAL("fm_mission_controller_2020", 45450 + 1765 + 1, 50)
    end)
local money = menu.slider(dividends, "fm_mission_controller money", {"fm_mission_controllermoney"},
    "fm_mission_controllermoney", INT_MIN, INT_MAX, 3000000, 100000, function()
    end)
menu.toggle_loop(dividends, " moneyfm_mission_controller", {"moneyfm_mission_controller"}, "moneyfinfm_mission_controller",
    function()
        SET_INT_LOCAL("fm_mission_controller", 19728 + 2686, menu.get_value(money))
    end)

menu.action(dividends, "finfm_mission_controller", {"finfmc"}, "finfm_mission_controller", function()
    SET_INT_LOCAL("fm_mission_controller", 19728 + 2686, menu.get_value(money))
    SET_INT_LOCAL("fm_mission_controller", 27489 + 859, 100000000)
    SET_INT_LOCAL("fm_mission_controller", 31603 + 69, 100000000)
end)

menu.toggle_loop(server, "if you host love kick ad bot", {}, "", function()
    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path("Online>Chat>Reactions>Advertisement>Love Letter Kick>Strangers"))
    else
        menu.trigger_command(menu.ref_by_path("Online>Chat>Reactions>Advertisement>Love Letter Kick>Disabled"))
    end
end)

-- player root
local function testMenuSetup(pid)
    local playerPED = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local playername = players.get_name(pid)
    local gameLANGUAGE = players.get_language(pid)
    local connect_ip = players.get_connect_ip(pid)
    local pos = players.get_position(pid)
    util.log(
        "player:" .. playername .. " pid:" .. pid .. " PlayerPed:" .. playerPED .. " gameLANGUAGE:" .. gameLANGUAGE ..
            " connect_ip:" .. connect_ip)
    menu.divider(menu.player_root(pid), "latiao's test menu")

    local testMenu = menu.list(menu.player_root(pid), "test", {}, "")
    menu.action(testMenu, "get_language", {}, "", function()
        util.log(players.get_language(pid))

    end)

    menu.toggle_loop(testMenu, "disabler godmode", {}, "", function()
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(testMenu, "block join", {}, "", function()
        local player = PLAYER.GET_PLAYER_NAME(pid)
        menu.trigger_commands("historyblock" .. player .. " on")
        menu.trigger_commands("historynote" .. player .. " latiaoblockjoin")
        menu.trigger_commands("loveletterkick" .. player)
    end)

    menu.toggle_loop(testMenu, "CLEAR_PED_TASKS_IMMEDIATELY", {}, "", function()
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(playerped)
    end)

    menu.toggle_loop(testMenu, "冻结", {}, "", function()
        util.trigger_script_event(1 << pid, {-1253241415, 0, 0, 1, 0})
    end)

    menu.toggle_loop(testMenu, "super kill cheat", {}, "", function()
        local pos = v3.new(players.get_position(pid))
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        menu.trigger_commands("kill" .. players.get_name(pid))
        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "super nick kill cheat", {}, "", function()
        local pos = v3.new(players.get_position(pid))
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "super weapon_stungun cheat", {}, "", function()
        util.trigger_script_event(1 << pid, {800157557, pid, 225624744, pid})
        local pos = players.get_position(pid)
        local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        -- TASK.CLEAR_PED_TASKS_IMMEDIATELY(playerped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 0, true,
            util.joaat("weapon_stungun"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "鬼畜", {}, "", function()
        local glitch_hash = util.joaat("p_spinning_anus_s")
        util.request_model(glitch_hash)

        local pos = players.get_position(pid)

        local obj = entities.create_object(glitch_hash, pos)
        ENTITY.SET_ENTITY_VISIBLE(obj, false)
        -- ENTITY.SET_ENTITY_COLLISION(obj, true, true)
        util.yield()
        entities.delete(obj)

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "weapon_pistol SHOOT", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 100, true,
            util.joaat("weapon_pistol"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "weapon_stungun SHOOT", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 0, true,
            util.joaat("weapon_stungun"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "weapon_bzgas SHOOT", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, INT_MAX, true,
            util.joaat("weapon_bzgas"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(testMenu, "weapon_molotov SHOOT", {}, "", function()
        local pos = players.get_position(pid)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, INT_MAX, true,
            util.joaat("weapon_molotov"), players.user_ped(), false, true, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "menukill", {"latiaomenukill"}, "", function()
        menu.trigger_commands("kill" .. players.get_name(pid))
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(testMenu, "scr_as_trans_smoke 5", {"latiaoscr_as_trans_smoke"}, "", function()
        STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_as_trans")
        GRAPHICS.USE_PARTICLE_FX_ASSET("scr_as_trans")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY("scr_as_trans_smoke", ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            5, false, false, false, 0, 0, 0, 255)
    end)
    menu.action(testMenu, "scr_as_trans_smoke 100", {"latiaoscr_as_trans_smoke"}, "", function()
        STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_as_trans")
        GRAPHICS.USE_PARTICLE_FX_ASSET("scr_as_trans")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY("scr_as_trans_smoke", ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            100, false, false, false, 0, 0, 0, 255)
    end)

    menu.toggle_loop(testMenu, "NickEXPLOSION", {"latiaoNickEXPLOSION"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
        -- end)
    end)

    menu.toggle_loop(testMenu, "RandomPlayerEXPLOSION", {"latiaoRandomPlayerEXPLOSION"}, "", function()
        local list = players.list()
        local index = math.random(#list)

        local randomPid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(list[index])

        local pos = players.get_position(pid)
        FIRE.ADD_OWNED_EXPLOSION(randomPid, pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "MEEXPLOSION", {"latiaoMEEXPLOSION"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
        -- end
    end)

    menu.toggle_loop(testMenu, "NickFlameLoop", {"latiaoFlameLoop"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 12, INT_MAX, false, true, 0.0)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(testMenu, "bad TASK_VEHICLE_HELI_PROTECT crash", {"latiaobadSET_MODEL_AS_NO_LONGER_NEEDEDcrash"}, "",
        function()
            util.request_model(util.joaat("oppressor"))
            util.request_model(util.joaat("u_m_m_jesus_01"))
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = players.get_position(pid)
            local oppressor = entities.create_vehicle(util.joaat("oppressor"), pos, 0)
            local jesus = entities.create_ped(0, util.joaat("u_m_m_jesus_01"), pos, 0)
            PED.SET_PED_INTO_VEHICLE(jesus, oppressor, -1)
            TASK.TASK_VEHICLE_HELI_PROTECT(jesus, oppressor, ped, 10.0, 0, 10, 0, 0)
            util.yield()
            entities.delete(jesus)
        end)

    menu.action(testMenu, "bad BREAK_OBJECT_FRAGMENT_CHILD crash", {"latiaobadBBREAK_OBJECT_FRAGMENT_CHILDcrash"}, "",
        function()
            local pos = players.get_position(pid)
            STREAMING.REQUEST_MODEL(util.joaat("prop_fragtest_cnst_04"))
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), pos)
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield()
            entities.delete(object)
            if not players.exists(pid) then
                util.stop_thread()
            end
        end)

    menu.toggle_loop(testMenu, "bad object crash", {"latiaobedojectcrash"}, "", function()
        STREAMING.REQUEST_MODEL(util.joaat("prop_tall_grass_ba"))
        local pos = players.get_position(pid)
        local object = entities.create_object(util.joaat("prop_tall_grass_ba"), pos)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(object, pos, false, true, true)

        util.yield()
        entities.delete(object)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "bad GIVE_WEAPON_TO_PED dead crash", {}, "", function()
        local ped = util.joaat('cs_manuel')
        STREAMING.REQUEST_MODEL(ped)
        util.yield()

        local pos = players.get_position(pid)
        local createped = entities.create_ped(4, ped, pos, 0)
        WEAPON.GIVE_WEAPON_TO_PED(createped, util.joaat('WEAPON_HOMINGLAUNCHER'), 100, true, true)
        util.yield()
        FIRE.ADD_EXPLOSION(pos, 0, 100.0, false, true, 100.0)
    end)




    menu.action(testMenu, "NETWORK_SESSION_KICK_PLAYER", {"latiaoNETWORK_SESSION_KICK_PLAYER"}, "", function()
        NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
    end)

    menu.toggle_loop(testMenu, "tun spamm crash", {"latiaotunspammcrash"}, "", function()
        local pos = players.get_position(pid)
        STREAMING.REQUEST_MODEL(util.joaat("tug"))

        local obj = entities.create_vehicle(util.joaat("tug"), pos, 0)
        ENTITY.SET_ENTITY_COORDS(obj, pos)
        util.yield(0)
        entities.delete(obj)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(testMenu, "tun spamm crash2", {"latiaotunspammcrash"}, "", function()
        for i = 0, 10 do
            local playerped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = players.get_position(pid)
            STREAMING.REQUEST_MODEL(util.joaat("tug"))

            local obj = entities.create_vehicle(util.joaat("tug"), pos, 0)

            ENTITY.ATTACH_ENTITY_TO_ENTITY(obj, playerped, 0, 0, 0, 0, 0, 0, 0, false, false, true, false, 0, true, 0)

            util.yield()
        end

    end)

    menu.action(testMenu, "del tun", {""}, "", function()
        for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
            if ENTITY.GET_ENTITY_MODEL(ent) == util.joaat("tug") then
                entities.delete(ent)
            end
        end
    end)
    menu.toggle_loop(testMenu, "kick vehicles", {"latiaokickvehicles"}, "latiaokickvehicles.", function()
        util.trigger_script_event(1 << pid, {-503325966})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    -- menu.action(testMenu, "host", {""}, "", function()
    --     util.trigger_script_event(1 << pid, {-1321657966, pid, 1})
    -- end)

    menu.toggle_loop(testMenu, "无限邀请加载", {""}, ".", function()
        util.trigger_script_event(1 << pid, {-1321657966, pid, pid, 0, 0, 115})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "循环邀请公寓", {""}, ".", function()
        util.trigger_script_event(1 << pid, {-1321657966, pid, pid, 0, 0, 1})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)



    menu.action(testMenu, "无效收藏品踢", {""}, ".", function()
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 233, 1, 1, 1})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.action(testMenu, "无效邀请公寓踢", {""}, ".", function()
        util.trigger_script_event(1 << pid, {-1321657966, pid, pid, 0, 0, 233})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "wok freeze", {""}, ".", function()
        -- util.yield(1000)

        util.trigger_script_event(1 << pid, {259469385})

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "bad SOUND script_event2", {""}, "", function()
        -- util.yield(1500)
        util.trigger_script_event(1 << pid, {996099702, pid})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "bad SOUND script_event", {""}, "", function()
        -- util.yield(1500)
        util.trigger_script_event(1 << pid, {-642704387, pid, 782258655, 0, 0, 0, 0, 0, 0, 0, pid, 0, 0, 0})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "info spamm", {"test1"}, "tet2", function()
        -- util.yield(1500)

        util.trigger_script_event(1 << pid,
            {-642704387, pid, 782258655, 0, 0, 0, 0, 0, 0, 0, math.random(0, 32), 0, 0, 0})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    -- menu.action(testMenu, "give_script_host all", {"give_script_host"}, "give_script_host.", function()
    --     for _, script in ipairs(ALL_script) do
    --         util.request_script_host(script)
    --         util.yield(1000)

    --         util.give_script_host(script, pid)

    --     end

    -- end)

    menu.action(testMenu, "latiaoGHOSTModetrue", {"latiaoGHOSTMode"}, "", function()
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
    end)

    menu.action(testMenu, "latiaoGHOSTModefalse", {"latiaoGHOSTMode"}, "", function()
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
    end)

    menu.action(testMenu, "casino TP", {""}, ".", function()
        util.trigger_script_event(1 << pid, {-1638522928, pid, 123, 0, 0, 0, 0, 0, 0, 0, 0, 1, INT_MAX, 0, 0})
    end)

    menu.toggle_loop(testMenu, "loop report", {""}, ".", function()
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

    menu.action(testMenu, "TASK_COMBAT_PED", {""}, ".", function()
        local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        for k, ent in pairs(entities.get_all_peds_as_handles()) do
            if not entities.is_player_ped(ped) then
                WEAPON.GIVE_WEAPON_TO_PED(ent, util.joaat("weapon_pistol"), 1000, false, true)
                TASK.TASK_COMBAT_PED(ent, player, 0, 16)
            end
        end
    end)

    menu.toggle_loop(testMenu, "GET IP", {""}, ".", function()
    end)

    menu.toggle_loop(testMenu, "GtaBanner", {}, "", function()
        util.trigger_script_event(1 << pid, {-330501227, pid})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "SoundSpam", {}, "", function()
        util.trigger_script_event(1 << pid, {996099702, pid})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "SoundSpam2", {}, "", function()
        -- for i = 0, 150 do
        util.trigger_script_event(1 << pid, {-1986344798, pid})
        -- end

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "EXPLOSIONLoop", {"latiaobedsoundforall"}, "latiaobedsoundforall", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos, 0, INT_MAX, true, false, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(testMenu, "FlameLoop", {"latiaoFlameLoop"}, "", function()
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos, 12, INT_MAX, true, false, INT_MAX)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)
    menu.toggle_loop(testMenu, "loop tp objects", {""}, "", function()
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
    menu.toggle_loop(testMenu, "loop tp peds", {""}, "", function()
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
    menu.toggle_loop(testMenu, "loop tp vehicles", {""}, "", function()
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
    menu.toggle_loop(testMenu, "loop tp pickups", {""}, "", function()
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
    menu.toggle_loop(testMenu, "loop tp", {""}, "", function()
        local pos = players.get_position(pid)
        ENTITY.SET_ENTITY_COORDS(players.user_ped(), pos.x, pos.y, pos.z, false)
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "bounty script spamm", {"latiaoscriptbountyspamm"}, "", function()
        util.trigger_script_event(1 << pid, {1517551547, pid, pid, 0, math.random(INT_MIN, INT_MAX), 0, 0, 0, 0, 0, 0,
                                             0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1})
        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "use him name killall ped ", {"latiaobedsoundforall"}, "latiaobedsoundforall", function()
        for _, ped in entities.get_all_peds_as_handles() do
            if not entities.is_player_ped(ped) and ENTITY.IS_ENTITY_DEAD(ped) == false then

                -- if not  then
                local pos = v3.new(ENTITY.GET_ENTITY_COORDS(ped))
                FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), pos.x, pos.y, pos.z, 0, INT_MAX,
                    false, true, 0.0)
                -- end
            end
        end

        if not players.exists(pid) then
            util.stop_thread()
        end
    end)

    menu.toggle_loop(testMenu, "loop giverp", {""}, "", function()
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 21, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 22, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 23, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 24, 1, 1, 1})

    end)

    menu.toggle_loop(testMenu, "loop giverp2", {""}, "", function()
        util.trigger_script_event(1 << pid, {968269233, -1, 8, -5, 1, 1, 1})

    end)

end

for _, pid in ipairs(players.list()) do
    testMenuSetup(pid)
end

players.on_join(testMenuSetup)

menu.toggle_loop(server, "raidallplayer", {"raidallplayer"}, "", function()
    for k, pid in pairs(players.list()) do
        util.trigger_script_event(1 << pid, {-1906536929, pid})
    end
end)

menu.toggle_loop(server, "bad post", {"latiaobadpost"}, ("latiaobadpost"), function()
    menu.trigger_commands("spoofpos")
end)

menu.toggle_loop(test, "debugshot", {"latiaodebugshot"}, ("latiaobadpost"), function()
    local outptr = memory.alloc(4)
    local aim_info = {
        handle = 0
    }
    local last_text = ""
    if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), outptr) then
        local handle = memory.read_int(outptr)
        aim_info.hash = ENTITY.GET_ENTITY_MODEL(handle)
        aim_info.model = util.reverse_joaat(aim_info.hash)
        aim_info.health = entities.get_health(handle)
        aim_info.OWNER = entities.get_owner(handle)
        aim_info.OWNERName = PLAYER.GET_PLAYER_NAME(entities.get_owner(handle))
        aim_info.ISNETWORKED = NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(handle)
        aim_info.ISMISSION = ENTITY.IS_ENTITY_A_MISSION_ENTITY(handle)
        -- aim_info.NETWORKID = NETWORK_GET_NETWORK_ID_FROM_ENTITY(handle) //cfx natives haha
        local text = "Hash=" .. aim_info.hash .. "," .. "Model=" .. aim_info.model .. "," .. "Health=" ..
                         aim_info.health .. "," .. "Owner=" .. aim_info.OWNER .. "," .. "OwnerName=" ..
                         aim_info.OWNERName .. "," .. "NETWORKED=" .. aim_info.ISNETWORKED .. "," .. "MISSIONENTITY=" ..
                         aim_info.ISMISSION
        --  .. "," .. "NETWORK_ID" 

        directx.draw_text(0.5, 0.25, text, 5, 0.5, {
            r = 255,
            g = 0,
            b = 0,
            a = 255
        }, true)
        util.log(text)
    end

end)

menu.toggle_loop(world, "del cctv_cam(pls use in solo if bug)", {""}, "", function()
    local Models = {util.joaat("prop_cctv_pole_04"), util.joaat("xm_prop_x17_server_farm_cctv_01"),
                    util.joaat("ch_prop_ch_cctv_cam_02a"), util.joaat("prop_cctv_cam_05a")}

    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        for _, targetModelHash in ipairs(Models) do

            local success, error_message = pcall(function()
                if ENTITY.GET_ENTITY_MODEL(ent) == targetModelHash then
                    entities.delete(ent)
                end
            end)
            if not success then
                print(error_message)
            end

        end
    end

end)

menu.action(test, "latiaoQUIT_GAME", {"latiaoQUIT_GAME"}, "", function()
    MISC.QUIT_GAME()
end)

menu.toggle_loop(server, "latiaoGHOSTMode", {"latiaoGHOSTMode"}, "", function()
    for k, pid in pairs(players.list()) do
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
    end
end, function()
    for k, pid in pairs(players.list()) do
        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
    end
end)

menu.action(server, "latiaoSET_GHOST_ALPHA", {"latiaoSET_GHOST_ALPHA"}, "", function()
    NETWORK.SET_GHOST_ALPHA(100)
end)

menu.toggle_loop(server, "TALKING TEST", {"LATIAOTALKINGTEST"}, "", function()
    for k, pid in pairs(players.list()) do
        if NETWORK.NETWORK_IS_PLAYER_TALKING(pid) then
            util.draw_debug_text(players.get_name(pid) .. " TALKING")
        end
    end
end)

menu.toggle_loop(server, "阻止变成野兽", {""}, "", function()
    if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_Beast")) > 0 then
        -- print("stop am_hunt_the_Beast")
        MISC.TERMINATE_ALL_SCRIPTS_WITH_THIS_NAME("am_hunt_the_Beast")

    end
end)

menu.toggle_loop(server, "block am_gang_call", {"latiaoblockam_gang_call"}, "latiaoblockam_gang_call", function()
    MISC.TERMINATE_ALL_SCRIPTS_WITH_THIS_NAME("am_gang_call")
end)

menu.toggle_loop(server, "block bounty", {"latiaoblockbounty"}, "latiaoblockbounty", function()
    if players.get_bounty(players.user()) ~= nil then
        menu.trigger_commands("removebounty")
        util.log("removebounty")
        util.yield(1000)
    end
end)

menu.action(server, "NETWORK_START_SOLO_TUTORIAL_SESSION", {"latiaoNETWORK_START_SOLO_TUTORIAL_SESSION"},
    "NETWORK_START_SOLO_TUTORIAL_SESSION", function()

        NETWORK.NETWORK_START_SOLO_TUTORIAL_SESSION()
    end)

menu.action(server, "NETWORK_END_TUTORIAL_SESSION", {"latiaoNETWORK_END_TUTORIAL_SESSION"},
    "NETWORK_END_TUTORIAL_SESSION", function()
        NETWORK.NETWORK_END_TUTORIAL_SESSION()
    end)

local HEALTH = menu.slider(world, "SET_ENTITY_HEALTH up", {"SET_ENTITY_HEALTH"}, "SET_ENTITY_HEALTH", INT_MIN, INT_MAX,
    100, 1, function()
    end)

menu.toggle_loop(world, "SET_ENTITY_HEALTH for get_all_objects_as_handles", {""}, "", function()
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        ENTITY.SET_ENTITY_HEALTH(ent, menu.get_value(HEALTH), -1, -1)
    end
end)
menu.toggle_loop(world, "SET_ENTITY_HEALTH for get_all_peds_as_handles", {""}, "", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            ENTITY.SET_ENTITY_HEALTH(ent, menu.get_value(HEALTH), -1, -1)
        end
    end
end)
menu.toggle_loop(world, "SET_ENTITY_HEALTH for get_all_vehicles_as_handles", {""}, "", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_HEALTH(ent, menu.get_value(HEALTH), -1, -1)
    end
end)
menu.toggle_loop(world, "SET_ENTITY_HEALTH for get_all_pickups_as_handles", {""}, "", function()
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

menu.action(admin, "Bunker", {""}, "", function()
    START_SCRIPT("appbunkerbusiness")
end)
menu.action(admin, ("Air Cargo"), {""}, "", function()
    START_SCRIPT("appsmuggler")
end)
menu.action(admin, ("Nightclub"), {""}, "", function()
    START_SCRIPT("appbusinesshub")
end)
menu.action(admin, ("The Open Road"), {""}, "(" .. ("") .. ")", function()
    START_SCRIPT("appbikerbusiness")
end)
menu.action(admin, ("Master Control Terminal"), {""}, "", function()
    START_SCRIPT("apparcadebusinesshub")
end)
menu.action(admin, ("Touchscreen Terminal"), {""}, "(" .. ("") .. ")", function()
    START_SCRIPT("apphackertruck")
end)

menu.action(admin, ("Agency App"), {""}, "(" .. ("") .. ")", function()
    START_SCRIPT("appfixersecurity")
end)

menu.toggle_loop(admin, ("摩托帮出货为最简单"), {""}, "(" .. ("") .. ")", function()
    SET_INT_LOCAL("gb_biker_contraband_sell", 719, 0)
end)
menu.toggle_loop(admin, ("ceo出货为最简单"), {""}, "(" .. ("") .. ")", function()
    SET_INT_LOCAL("gb_contraband_sell", 550, 12)
end)

menu.action(dividends, "别惹德瑞", {}, "", function()
    STAT_SET_INT("FIXER_GENERAL_BS", -1)
    STAT_SET_INT("FIXER_COMPLETED_BS", -1)
    STAT_SET_INT("FIXER_STORY_BS", -1)
end)

local ContractPayout = menu.slider(dividends, "ContractPayout", {"ContractPayout"}, "", 0, INT_MAX, 0, 1, function()

end)

menu.toggle_loop(dividends, "ContractPayout", {""}, "", function()
    SET_INT_GLOBAL(262145 + 31955, menu.get_value(ContractPayout))
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

menu.toggle_loop(test, "NETWORK_DO_TRANSITION_TO_NEW_FREEMODE", {}, "", function()
    NETWORK.NETWORK_DO_TRANSITION_TO_FREEMODE(0, 0, true, 1000, true)
end)
menu.toggle_loop(test, "NETWORK_DO_TRANSITION_TO_NEW_GAME", {}, "", function()
    NETWORK.NETWORK_DO_TRANSITION_TO_GAME(1000, true)
end)

menu.action(test, "kill freemode", {"latiaoblockfreemode"}, "", function()
    util.spoof_script("freemode", function()
        SCRIPT.TERMINATE_THIS_THREAD()
    end)
end)

menu.action(test, "tp and back", {"latiaotpback"}, "", function()
    local pos = players.get_position(players.user())

    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), pos.x, pos.y, 2600)
    util.yield(5000)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), pos.x, pos.y, pos.z)

    -- )
end)

menu.toggle_loop(test, "bad SOUND script_event2", {""}, "", function()
    -- util.yield(1500)
    for k, pid in pairs(players.list()) do
        util.trigger_script_event(1 << pid, {996099702, pid})

    end
end)

menu.toggle_loop(test, "bad SOUND script_event", {""}, "", function()
    -- util.yield(1500)
    for k, pid in pairs(players.list()) do
        util.trigger_script_event(1 << pid, {-642704387, pid, 782258655, 0, 0, 0, 0, 0, 0, 0, pid, 0, 0, 0})

    end
end)

menu.toggle_loop(test, "info spamm", {"test1"}, "tet2", function()
    -- util.yield(1500)
    for k, pid in pairs(players.list()) do
        util.trigger_script_event(1 << pid,
            {-642704387, pid, 782258655, 0, 0, 0, 0, 0, 0, 0, math.random(0, 32), 0, 0, 0})

    end
end)

menu.toggle_loop(world, "STOP_FIRE_IN_RANGE", {""}, ".", function()
    FIRE.STOP_FIRE_IN_RANGE(0, 0, 0, INT_MAX)
end)

menu.toggle_loop(world, "EVERYONE IGNORE ALL PLAYER", {}, "", function()
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(players.user(), true)
end, function()
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(players.user(), false)
end)

menu.toggle_loop(world, "SET_CAN_ATTACK_FRIENDLY", {""}, ".", function()
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), true, false)
end, function()
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), false, false)
end)

menu.toggle_loop(world, "NOISE SET 0 FOR ALL PLAYER", {}, "", function()
    PLAYER.SET_PLAYER_NOISE_MULTIPLIER(players.user(), 0.0)
    PLAYER.SET_PLAYER_SNEAKING_NOISE_MULTIPLIER(players.user(), 0.0)
end)

menu.toggle_loop(self, "SET_ENTITY_MAX_HEALTH 0", {""}, ".", function()
    ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 0)
end, function()
    ENTITY.SET_ENTITY_MAX_HEALTH(players.user_ped(), 328)
end)

menu.action(server, "super request_script_host for all ", {"request_script_hostall"}, "latiaoNrequest_script_host.",
    function()
        for _, script in ipairs(ALL_script) do
            util.request_script_host(script)
        end
    end)

menu.toggle_loop(server, "nodamage EXPLOSION spamm", {"latiaobedsoundforall"}, "latiaobedsoundforall", function()
    for k, pid in pairs(players.list()) do
        local pos = players.get_position(pid)
        FIRE.ADD_EXPLOSION(pos, 0, 0, false, true, 0.0)
    end
end)

menu.action(about, "github:latiao-1337", {""}, "", function()

end)

menu.toggle_loop(self, "SET_PLAYER_LOCKON_RANGE_OVERRIDE", {"SET_PLAYER_LOCKON_RANGE_OVERRIDE"}, "", function()
    PLAYER.SET_PLAYER_LOCKON_RANGE_OVERRIDE(players.user(), 100000000)
end)

menu.action(world, "tp ch_prop_fingerutil.log_scanner", {"latiaotpch_prop_fingerutil.log_scanner_01a"}, "", function()
    local Models = {util.joaat("ch_prop_fingerutil.log_scanner_01a"), util.joaat("ch_prop_fingerutil.log_scanner_01b"),
                    util.joaat("ch_prop_fingerutil.log_scanner_01c"), util.joaat("ch_prop_fingerutil.log_scanner_01d")}

    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        for _, targetModelHash in pairs(Models) do
            if ENTITY.GET_ENTITY_MODEL(ent) == targetModelHash then
                ENTITY.SET_ENTITY_COORDS(ent, players.get_position(players.user()), false)
                util.yield()
                break
            end
        end
    end
end)

menu.toggle_loop(server, "EXPLOSION sound spamm", {"latiaobedsoundforall"}, "latiaobedsoundforall", function()
    FIRE.ADD_EXPLOSION(0, 0, 2500, 0, INT_MAX, true, false, INT_MAX)
end)
menu.action(world, "LOAD_ALL_OBJECTS_NOW", {"LOAD_ALL_OBJECTS_NOW"}, "LOAD_ALL_OBJECTS_NOW", function()
    STREAMING.LOAD_ALL_OBJECTS_NOW()
end)

menu.action(dividends, "CREATE_VEHICLE polmav", {""}, "", function()
    util.request_model(util.joaat("polmav"))
    local pos = v3.new(579, 12, 103)
    entities.create_vehicle(util.joaat("polmav"), pos, 0)
end)

menu.action(dividends, "CREATE_VEHICLE asterope", {""}, "", function()
    util.request_model(util.joaat("asterope"))
    local pos = v3.new(905, -37, 78)
    entities.create_vehicle(util.joaat("asterope"), pos, 0)
end)

menu.toggle_loop(test, "FIX_OBJECT_FRAGMENT all", {"latiaobadBBREAK_OBJECT_FRAGMENT_CHILDcrash"}, "", function()
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            OBJECT.FIX_OBJECT_FRAGMENT(ent)
        end)
        if not success then

        end
    end
end)
menu.toggle_loop(test, "BREAK_OBJECT_FRAGMENT_CHILD all", {"latiaobadBBREAK_OBJECT_FRAGMENT_CHILDcrash"}, "", function()
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(ent, 0, false)
        end)
        if not success then

        end
    end
end)

menu.toggle_loop(server, "latiao ALL_script_test host test", {"latiaoALL_script_test"}, "latiaoALL_script_test.",
    function()
        for _, script in ipairs(ALL_script) do
            for x = -1, 0 do
                for y = 0, 0 do
                    local host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script, x, y)

                    local name = PLAYER.GET_PLAYER_NAME(host)
                    if name ~= "**Invalid**" then
                        local hostinfo = script .. "," .. x .. "," .. y .. "=" .. name
                        util.draw_debug_text(hostinfo)
                        -- print(hostinfo)
                    end
                end
            end
        end

    end)

menu.toggle_loop(server, "auto super request_script_host for all ", {"autorequest_script_hostall"},
    "autorequest_script_hostall.", function()
        for _, script in ipairs(ALL_script) do
            for x = -1, 0 do
                for y = 0, 0 do
                    local host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script, x, y)
                    if host ~= -1 and not (host == players.user()) then
                        util.request_script_host(script, x, y)
                    end
                end
            end
        end

    end)

menu.toggle_loop(test, "所有实体不无敌", {}, "", function()

    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_INVINCIBLE(ent, false)
        end)
        if not success then

        end
    end
end)

menu.toggle_loop(test, "所有实体无敌", {}, "", function()

    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_INVINCIBLE(ent, true)
        end)
        if not success then

        end
    end
end)

menu.toggle_loop(world, "解锁所有车", {""}, ".", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(ent, 0)
    end
end)

menu.toggle_loop(world, "锁定所有车", {""}, ".", function()
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(ent, 2)
    end
end)

menu.toggle_loop(test, "saveall", {""}, ".", function()
    STATS.STAT_SAVE(0, 0, 3, 0);
end)

-- menu.action(server, "task all", {"latiaotaskall"}, "latiaotaskall", function()
--     for i = 1, 12 do
--         for i2 = 1, 45 do
--             for k, pid in pairs(players.list()) do
--                 util.trigger_script_event(1 << pid, {770949062, pid, 16156, i2, i,0,1})
--             end
--         end
--     end
-- end)

-- menu.action(server, "task all", {"latiaotaskall"}, "latiaotaskall", function()
--     -- for i = 1, 8 do
--     for i2 = 1, 45 do
--         for k, pid in pairs(players.list()) do
--             util.trigger_script_event(1 << pid, {1262194935, pid, 1962800054273, i2})
--         end
--     end
--     -- end
-- end)

menu.toggle_loop(server, "if you host give Collectibles>All", {""}, "", function()

    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))
        util.yield(10000)
    end
end)

menu.toggle_loop(server, "if you host give Collectibles>All NO TIME", {""}, "", function()

    if NETWORK.NETWORK_IS_HOST() then
        menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))

    end
end)

menu.toggle_loop(server, "loop give Collectibles>All", {""}, "", function()

    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))
    util.yield(10000)

end)

menu.toggle_loop(server, "loop give Collectibles>All2", {""}, "", function()

    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))

end)

local MU = menu.slider_float(admin, "经验倍率", {"xpmu"}, "xpmu", INT_MIN, INT_MAX, 100, 1, function()
end)

menu.toggle_loop(admin, "xp", {""}, "", function()
    SET_FLOAT_GLOBAL(262145 + 1, menu.get_value(MU) / 100)
end)
menu.toggle_loop(admin, "AP", {""}, "", function()
    SET_FLOAT_GLOBAL(262145 + 26114, menu.get_value(MU) / 100)
end)
menu.toggle_loop(admin, "LS Car", {""}, "", function()
    SET_FLOAT_GLOBAL(262145 + 31855, menu.get_value(MU) / 100)
    SET_FLOAT_GLOBAL(262145 + 31856, menu.get_value(MU) / 100)
    SET_FLOAT_GLOBAL(262145 + 31857, menu.get_value(MU) / 100)
    SET_FLOAT_GLOBAL(262145 + 31858, menu.get_value(MU) / 100)

    SET_FLOAT_GLOBAL(262145 + 31860, menu.get_value(MU) / 100)
    SET_FLOAT_GLOBAL(262145 + 31861, menu.get_value(MU) / 100)
    SET_FLOAT_GLOBAL(262145 + 31862, menu.get_value(MU) / 100)
end)

menu.action(admin, "RC Bandito", {""}, ".", function()
    SET_INT_GLOBAL(2794162 + 6880, 1)
end)

menu.action(admin, "RC Tank", {""}, ".", function()
    SET_INT_GLOBAL(2794162 + 6894, 1)
end)
menu.toggle_loop(server, "是主机循环给予收藏品", {""}, "", function()
    if NETWORK.NETWORK_IS_HOST() then
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give RP"))
    util.yield(15000)
    end
end)


menu.toggle_loop(server, "循环给予收藏品", {""}, "", function()

    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give RP"))
    util.yield(15000)
end)
menu.toggle_loop(server, "循环给予收藏品2", {""}, "", function()

    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Movie Props"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Hidden Caches"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Treasure Chests"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Radio Antennas"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Media USBs"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Shipwrecks"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Buried Stashes"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Jack O' Lanterns"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>LD Organics Merchandise"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Junk Energy Skydives"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>Snowmen"))
    util.yield(3500)
    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>G's Cache"))
    util.yield(3500)
end)

menu.toggle_loop(server, "循环给予经验", {""}, "", function()

    menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give RP"))
    util.yield(1)
end)

menu.toggle_loop(world, "随机玩家击杀 ped ", {""}, "", function()
    local list = players.list()
    local index = math.random(#list)

    local randomPid = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(list[index])

    for _, ped in entities.get_all_peds_as_handles() do
        if not entities.is_player_ped(ped) and ENTITY.IS_ENTITY_DEAD(ped) == false then

            local pos = v3.new(ENTITY.GET_ENTITY_COORDS(ped))
            FIRE.ADD_OWNED_EXPLOSION(randomPid, pos.x, pos.y, pos.z, 0, INT_MAX, false, true, 0.0)
        end
    end

end)

menu.action(world, "delallnotNETWORK", {"delallnotNETWORK"}, "delallnotNETWORK.", function()
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

menu.action(world, "tp ch_prop_fingerutil.log_scanner", {"latiaotpch_prop_fingerutil.log_scanner_01a"}, "", function()
    local Models = {util.joaat("ch_prop_fingerutil.log_scanner_01a"), util.joaat("ch_prop_fingerutil.log_scanner_01b"),
                    util.joaat("ch_prop_fingerutil.log_scanner_01c"), util.joaat("ch_prop_fingerutil.log_scanner_01d")}

    local playerPos = players.get_position(players.user())

    for _, ent in pairs(entities.get_all_pickups_as_handles()) do
        for _, targetModelHash in pairs(Models) do
            local success, error_message = pcall(function()
                if ENTITY.GET_ENTITY_MODEL(ent) == targetModelHash then
                    ENTITY.SET_ENTITY_COORDS(ent, playerPos.x, playerPos.y, playerPos.z, false)
                end
            end)

            if not success then
                print("Error setting coordinates: " .. error_message)
            end
        end
    end

end)

menu.action(world, "REFRESH_INTERIOR", {""}, "", function()
    local myINTERIOR = INTERIOR.GET_INTERIOR_FROM_ENTITY((players.user_ped()))
    INTERIOR.REFRESH_INTERIOR(myINTERIOR)
end)
menu.toggle_loop(server, "clean chat", {"latiaocleanchat"}, "latiaocleanchat.", function()
    local chatt = math.random(100000000)

    chat.send_message(chatt, false, true, true)
end)

menu.toggle_loop(world, "IS_PED_IN_COMBAT", {"IS_PED_IN_COMBAT"}, "IS_PED_IN_COMBAT.", function()
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            if PED.IS_PED_IN_COMBAT(ent, players.user_ped()) then

                ENTITY.SET_ENTITY_COORDS(ent, players.get_position(players.user()), false)
            end
        end
    end
end)

menu.toggle_loop(server, "自动送温暖", {""}, ".", function()

    if not util.is_session_transition_active() then
        util.yield(5000)
        util.log("give")

        menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))
        menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give RP"))
        menu.trigger_command(menu.ref_by_path("Players>All Players>Weapons>Give Weapons>Give All Weapons"))
        menu.trigger_command(menu.ref_by_path("Players>All Players>Weapons>Give Ammo"))
        menu.trigger_command(menu.ref_by_path("Players>All Players>Weapons>Give Parachute"))

        util.log("give end")
        util.log("Wait for 15 seconds")
        util.yield(15000)

        util.log("go")
        menu.trigger_command(menu.ref_by_path("Online>New Session>Find Public Session"))
        util.yield()
    else
        print("loding")
        util.yield()
    end

end)

menu.toggle(server, "totest", {""}, ".", function()
    local test_on = false
    test_on = true
    if test_on == true then
        print("start")
        util.yield(1000)
    end
end)

menu.toggle_loop(server, "giverpforall", {""}, "", function()
    for k, pid in pairs(players.list()) do
        if pid == players.user() then
            goto out
        end
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 21, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 22, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 23, 1, 1, 1})
        util.trigger_script_event(1 << pid, {968269233, -1, 4, 24, 1, 1, 1})
        ::out::
    end

end)

menu.toggle_loop(server, "giverpforall2", {""}, "", function()
    for k, pid in pairs(players.list()) do
        if pid == players.user() then
            goto out
        end
        util.trigger_script_event(1 << pid, {968269233, -1, 8, -5, 1, 1, 1})

        ::out::
    end

end)

-- menu.toggle_loop(server, "testgiverpforall", {""}, "", function()
--     menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give Collectibles>All"))
--     menu.trigger_command(menu.ref_by_path("Players>All Players>Friendly>Give RP"))
--     util.yield(1000)
-- end)

-- menu.action(server, "super giverpforall", {""}, "", function()
--     for k, pid in pairs(players.list()) do
--         -- for i = 0, 100 do
--             for i2 = 0, 100 do
--             util.trigger_script_event(1 << pid, {968269233, -1, 5, i2, 1, 1, 1})
--             -- print(i.."."..i)
--             util.yield(1)
--         -- end
--     end
-- end
--     
-- end)

menu.toggle_loop(server, "testjoin", {""}, "", function()

    for k, pid in pairs(players.list()) do
        local player = PLAYER.GET_PLAYER_NAME(pid)
        local active = NETWORK.NETWORK_IS_PLAYER_ACTIVE(pid)
        if not active then -- 如果玩家不在线或者不在游戏中，就打印出来
            print(player .. "=" .. active)
        end
    end

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

menu.toggle_loop(server, "GET MY JOIN INFO", {""}, "", function()
    print("NETWORK_IS_PLAYER_ACTIVE=" .. NETWORK.NETWORK_IS_PLAYER_ACTIVE(players.user()))
    print("IS_PLAYER_PLAYING=" .. PLAYER.IS_PLAYER_PLAYING(players.user()))
end)

menu.action(test, "add all f", {""}, "", function()
    for k, pid in pairs(players.list()) do
        for i = 10000, INT_MAX do
            -- for i2 = 0, 100 do
            menu.trigger_commands("historyaddrid " .. i)
            print(i)
            util.yield()
            -- end
        end
    end

end)

menu.toggle_loop(world, "NETWORK_REGISTER_ENTITY_AS_NETWORKEDobjects",
    {"latiaoNETWORK_REGISTER_ENTITY_AS_NETWORKEDobjects"}, "NETWORK_REGISTER_ENTITY_AS_NETWORKEDobjects.", function()
        for k, ent in pairs(entities.get_all_objects_as_handles()) do
            local success, error_message = pcall(function()
                NETWORK.NETWORK_REGISTER_ENTITY_AS_NETWORKED(ent)
            end)
            if not success then

            end

        end
    end)

menu.toggle_loop(world, "NETWORK_REGISTER_ENTITY_AS_NETWORKEDpeds", {"latiaoNETWORK_REGISTER_ENTITY_AS_NETWORKEDpeds"},
    "NETWORK_REGISTER_ENTITY_AS_NETWORKEDpeds.", function()
        for k, ent in pairs(entities.get_all_peds_as_handles()) do
            if not entities.is_player_ped(ent) then
                local success, error_message = pcall(function()
                NETWORK.NETWORK_REGISTER_ENTITY_AS_NETWORKED(ent)
                end)
                if not success then

                end
            end

        end
    end)

menu.toggle_loop(world, "NETWORK_REGISTER_ENTITY_AS_NETWORKEDvehicles",
    {"latiaoNETWORK_REGISTER_ENTITY_AS_NETWORKEDvehicles"}, "NETWORK_REGISTER_ENTITY_AS_NETWORKEDvehicles.", function()
        for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
            local success, error_message = pcall(function()
            NETWORK.NETWORK_REGISTER_ENTITY_AS_NETWORKED(ent)
            end)
            if not success then

            end

        end
    end)

menu.toggle_loop(world, "NETWORK_REGISTER_ENTITY_AS_NETWORKEDpickups",
    {"latiaoNETWORK_REGISTER_ENTITY_AS_NETWORKEDvehicles"}, "NETWORK_REGISTER_ENTITY_AS_NETWORKEDvehicles.", function()
        for k, ent in pairs(entities.get_all_pickups_as_handles()) do
            local success, error_message = pcall(function()
            NETWORK.NETWORK_REGISTER_ENTITY_AS_NETWORKED(ent)
            end)
            if not success then

            end

        end
    end)

menu.toggle_loop(world, "tp objects", {"latiaotp objects"}, "tp objects.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_objects_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
        end)
        if not success then
            print(error_message)
        end

    end
end)

menu.toggle_loop(world, "tp peds", {"latiaotp peds"}, "tp peds.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            local success, error_message = pcall(function()
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end)
            if not success then
                print(error_message)
            end
        end

    end
end)

menu.toggle_loop(world, "tp vehicles", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
        end)
        if not success then
            print(error_message)
        end

    end
end)

menu.toggle_loop(world, "tp pickups", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        local success, error_message = pcall(function()
            ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
        end)
        if not success then
            print(error_message)
        end

    end
end)

menu.toggle_loop(world, "tp NETWORKED objects", {"latiaotp objects"}, "tp objects.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_objects_as_handles()) do

        local success, error_message = pcall(function()
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end
        end)
        if not success then
            print(error_message)
        end

    end
end)

menu.toggle_loop(world, "tp NETWORKED peds", {"latiaotp peds"}, "tp peds.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        if not entities.is_player_ped(ent) then
            local success, error_message = pcall(function()
                if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                    ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
                end
            end)
            if not success then
                print(error_message)
            end
        end

    end
end)

menu.toggle_loop(world, "tp NETWORKED vehicles", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        local success, error_message = pcall(function()
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end
        end)
        if not success then
            print(error_message)
        end

    end
end)

menu.toggle_loop(world, "tp NETWORKED pickups", {"latiaotp vehicles"}, "tp vehicles.", function()
    local pos = players.get_position(players.user())
    for k, ent in pairs(entities.get_all_pickups_as_handles()) do
        local success, error_message = pcall(function()
            if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
                ENTITY.SET_ENTITY_COORDS(ent, pos.x, pos.y, pos.z, false)
            end
        end)
        if not success then
            print(error_message)
        end

    end
end)


menu.slider_float(world, "风速", {"SET_WIND"}, "", 0, INT_MAX, -1, 1, function(value)
        MISC.SET_WIND(value)
    end)
    menu.slider_float(world, "雨量", {"SET_RAIN"}, "", 0, INT_MAX, -1, 1, function(value)
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
