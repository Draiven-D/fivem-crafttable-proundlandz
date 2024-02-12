Config = {}
Config.craft_cost = 100
------- ชื่ออาวุธต้องตัวใหญ่เท่านั้นเช่น WEAPON_BAT
Config.CraftTable = {
    {
        NAME = "Food", 
        name_model = "~y~โต๊ะคราฟอาหาร",
        desc = "",
        coords = { x = 193.51, y = -1002.20, z = 31.96, h = 158.29 },
        max_distance = 1.5,
		map_blip = false,
        --model = GetHashKey("prop_cooker_03"),
		disable_model = true,
		blip_name = '<font face="THSarabunNew">โต๊ะคราฟอาหาร</font>',
        catagory = {1,2},
		job = {
			["unemployed"] = true,
			["offambulance"] = true,
			["offmechanic"] = true,
			["offpolice"] = true,
		},
		allgang = true,
		gang = {
			["none"] = true,
		}
    },
}

Config.CraftCatagory = {
    [1] = {
        NAME = "ไอเท็มทั่วไป",
        ITEM_LIST = {
			{
                item_index = "vault_key_1",
                item_name = "vault_key",
                fail_chance = 0,
                cost = 30000,
                craft_duration = 5,
				min_amount = 1,
				max_amount = 1,
				cost_type = "cash",
                equipment = {},
                fail_item = {},
                item_require = {
					["crystal"] = 150,
					["black_diamond"] = 3,
					["pink_diamond"] = 3,
				}
            },
		}
    },
	[2] = {
        NAME = "อาวุธ",
        ITEM_LIST = {
			{
				item_index = "weapon_dagger_1",
				item_name = "WEAPON_DAGGER",
				fail_chance = 92.0,
				craft_duration = 5,
				cost = 5000,
				cost_type = "cash",
				min_amount = 1,
				max_amount = 1,
                equipment = {},
                fail_item = {
					["WEAPON_BOTTLE"] = 1,
					["blade_coin"] = 1,
				},
                item_require = {
					["WEAPON_BOTTLE"] = 1,
					["metal_blade"] = 1,
					["cement"] = 20,
					["cable"] = 20,
                },
				blessed = true,
				item_blessed = "lucky_stone",
				blessed_rate = 4.0,
			},
		}
	}
}