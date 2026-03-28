local mq = require('mq')
local Write = require('knightlinc/Write')

Write.prefix = '\ay[\ax\agSacrifice.lua\ax\ay]\ax '
Write.loglevel = 'info'

local min_sac_level = 46

local args = {...}

if args[2] == nil then
    Write.Fatal("You must specify the name of the sacrificer and the sacrificee:  /lua run sacrifice Necromancer Thrall")
end

local function tchelper(first, rest)
    return first:upper()..rest:lower()
end

local function titlecase(str)
    return str:gsub("(%a)([%w_']*)", tchelper)
end

local sacrificer = titlecase(args[1])
local sacrificee = titlecase(args[2])

math.randomseed(os.time())

if mq.TLO.Me.Name() == sacrificee then
    Write.Info("I can't wait to be sacrificed!")
    while true do
        if mq.TLO.Me.Level() >= min_sac_level then
            if mq.TLO.Window('RespawnWnd').Open() then
                -- Delay between 1.5 and 3 seconds
                mq.delay(math.random(1.5, 3) * 1000)
                mq.cmd('/nomodkey /notify RespawnWnd RW_SelectButton leftmouseup')
                mq.delay(1000)
            end
            if mq.TLO.Window('ConfirmationDialogBox').Open() then
                local text_box = mq.TLO.Window('ConfirmationDialogBox/CD_TextOutput').Text()
                -- Delay between 1.5 and 3 seconds
                mq.delay(math.random(1, 3) * 1000)
                if string.find(text_box, sacrificer..' wants to SACRIFICE you.') then
                    Write.Info('Accepting sacrifice from '..sacrificer)
                    mq.cmd('/nomodkey /notify ConfirmationDialogBox Yes_Button leftmouseup')
                else
                    Write.Info('Declining dialog box with text: '..text_box)
                    mq.cmd('/nomodkey /notify ConfirmationDialogBox No_Button leftmouseup')
                end
            end
        else
            Write.Fatal('I cannot be sacrificed, my level is too low.')
        end
        mq.delay(100)
    end
elseif mq.TLO.Me.Name() == sacrificer then
    if mq.TLO.Me.Class() == 'Necromancer' then
        while true do
            local sacgem = mq.TLO.Me.Gem('Sacrifice')()
            if sacgem ~= nil then
                if mq.TLO.FindItemCount('=Emerald')() > 0 then
                    local spawn_sacrificee = mq.TLO.Spawn('pc '..sacrificee)
                    if spawn_sacrificee() ~= nil then
                        if spawn_sacrificee.Level() >= min_sac_level then
                            if spawn_sacrificee.Distance() <= 100 then
                                if mq.TLO.SpawnCount('group pc '..sacrificee)() > 0 then
                                    mq.cmd('/mqtarget id '..spawn_sacrificee.ID())
                                    mq.delay(2000, function() return mq.TLO.Target() ~= nil and mq.TLO.Target.Name() == sacrificee end)
                                    if mq.TLO.Target() ~=nil and mq.TLO.Target.Name() == sacrificee then
                                        while not mq.TLO.Me.SpellReady(sacgem)() do
                                            Write.Debug('Waiting for Sacrifice cooldown...')
                                            mq.delay(200)
                                        end
                                        Write.Info('Sacrificing '..sacrificee)
                                        while mq.TLO.Me.Casting() == nil do
                                            mq.cmd('/cast '..sacgem)
                                            mq.delay(200)
                                        end
                                        mq.delay(5200, function() return mq.TLO.Me.Casting() == nil end)
                                        local spawncount_corpses = mq.TLO.SpawnCount('pccorpse '..sacrificee)()
                                        mq.delay(30000, function() return mq.TLO.SpawnCount('pccorpse '..sacrificee)() ~= spawncount_corpses end)
                                        while mq.TLO.Me.Inventory('Cursor')() ~= nil do
                                            mq.cmd('/autoinventory')
                                            mq.delay(500)
                                        end
                                    else
                                        Write.Error('Could not target '..sacrificee..' to sacrifice.')
                                    end
                                else
                                    Write.Info('Waiting for '..sacrificee..' be in the group so we can sacrifice them...')
                                    mq.delay(5000)
                                end
                            else
                                Write.Info('Waiting for '..sacrificee..' to get in range so we can sacrifice them...')
                                mq.delay(5000)
                            end
                        else
                            Write.Fatal('Sacrificee too low to sacrifice.')
                        end
                    else
                        Write.Info('Waiting for '..sacrificee..' to show up so we can sacrifice them...')
                        mq.delay(5000)
                    end
                else
                    Write.Fatal('Sacrifice requires emeralds.')
                end
            else
                Write.Fatal('Must have Sacrifice memmed.')
            end
            mq.delay(100)
        end
    else
        Write.Fatal('Must be a necromancer to Sacrifice.')
    end
else
    Write.Fatal('You are neither the sacrificer nor the sacrificee. (%s / %s)', sacrificer, sacrificee)
end