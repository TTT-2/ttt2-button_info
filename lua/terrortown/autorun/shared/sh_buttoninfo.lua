buttoninfo = {}

buttoninfo.buttons = {}
buttoninfo.info = {}

function buttoninfo.GetFromEntity(button)
    local buttonID = button:GetNWInt("buttonID", 0)

    if buttonID == 0 then
        return
    end

    return buttoninfo.info[buttonID]
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
end

if CLIENT then
    net.ReceiveSteam("TTT2ButtonInfo", function(buttons)
        buttoninfo.buttons = buttons
    end)
end
