CreateConVar(
    "ttt2_buttoninfo_show_admin_info",
    0,
    { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }
)

buttoninfo = {}

buttoninfo.buttons = {}
buttoninfo.info = {}

function buttoninfo.GetFromEntity(buttonEnt)
    local buttonID = buttonEnt:GetNWInt("buttonID", 0)

    if buttonID == 0 then
        return
    end

    for _, buttonInfo in pairs(buttoninfo.info) do
        if buttonInfo.buttonID == buttonID then
            return buttonInfo
        end
    end
end

function buttoninfo.GetChoices()
    local choices = {}

    for i = 1, #buttoninfo.buttons do
        local button = buttoninfo.buttons[i]

        choices[i] = {
            title = "ButtonID: " .. button.buttonID,
            value = button.buttonID,
        }
    end

    return choices
end

if SERVER then
    hook.Add("TTT2PostButtonInitialization", "buttoninfo_buttons_registered", function(buttonList)
        local buttonID = 1

        buttoninfo.buttons = {}

        for class, butons in pairs(buttonList) do
            for i = 1, #butons do
                local button = butons[i]

                buttoninfo.buttons[buttonID] = {
                    buttonID = buttonID,
                    entID = button:EntIndex(),
                }

                button:SetNWInt("buttonID", buttonID)

                buttonID = buttonID + 1
            end
        end

        net.SendStream("TTT2ButtonInfo", buttoninfo.buttons)
    end)

    hook.Add("TTT2PlayerReady", "buttoninfo_resync", function(ply)
        net.SendStream("TTT2ButtonInfo", buttoninfo.buttons, ply)
    end)

    hook.Add("TTT2FinishedLoading", "buttoninfo_load_files", function()
        fileloader.LoadFolder("terrortown/buttoninfo/" .. game.GetMap() .. "/", false, CLIENT_FILE)
    end)
end

if CLIENT then
    net.ReceiveStream("TTT2ButtonInfo", function(buttons)
        buttoninfo.buttons = buttons
    end)

    local function OnClassLoaded(class, path, name)
        print("class loaded", class, path, name)

        class.type = name
    end

    hook.Add("TTT2FinishedLoading", "buttoninfo_build_classes", function()
        print("building info classes")
        buttoninfo.info = classbuilder.BuildFromFolder(
            "terrortown/buttoninfo/" .. game.GetMap() .. "/",
            CLIENT_FILE,
            "BUTTONINFO", -- class scope
            OnClassLoaded, -- on class loaded callback
            false -- should inherit
        )
    end)
end
