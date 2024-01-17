Crafting = {}

Crafting = {
    Command = 'createCrafting',
    PropBench = 'gr_prop_gr_bench_02b',
    EnableDebug = true,
    XpSystem = false,
    ExperiancePerCraft = 2.5,
    Weapon = {
        -- ["w_pi_pistol_mk2"] = {
        --     weaponCode = 'WEAPON_PISTOL_MK2',
        --     weaponName = 'Pistol MK2',
        --     requiredJob = false,
        --     requiredXp = 10,
        --     allowlistJob = {
        --         "police"
        --     },
        --     ItemRequired = {
        --         {label = 'Phone', itemName = "phone", quantity = 2},
        --         {label = 'Burger', itemName = "burger", quantity = 5}
        --     }
        -- },
        ["w_pi_pistol"] = {
            weaponCode = 'WEAPON_PISTOL',
            weaponName = 'Pistol',
            requiredJob = false,
            requiredGang = true,
            requiredXp = 0,
            allowlistJob = {
                "police"
            },
            allowlistGang = {
                "crips"
            },
            ItemRequired = {
                {label = 'Metal Scrap', itemName = "metalscrap", quantity = 5}
            }
        },
        ["w_ar_carbinerifle"] = {
            weaponCode = 'WEAPON_SWITCHBLADE',
            weaponName = 'Switch Blade',
            requiredJob = true,
            requiredXp = 0,
            allowlistJob = {
                "police",
            },
            ItemRequired = {
                {label = 'Water', itemName = "water", quantity = 1}
            }
        }
    },

    PositionCrafting = {
        {coords = vector3(-16.471076965332, 4.4761486053467, 70.613090515137), heading =165.0}
    }
}