CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_buttoninfo_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_addons_buttoninfo")

    form:MakeCheckBox({
        serverConvar = "ttt2_buttoninfo_show_admin_info",
        label = "label_buttoninfo_show_admin_info",
    })

    local buttonList = form:MakeComboBox({
        label = "label_buttoninfo_list",
        choices = buttoninfo.GetChoices(),
    })

    form:MakeButton({
        label = "label_execute_command",
        buttonLabel = "label_buttoninfo_teleport",
        OnClick = function(slf)
            local buttonID, _ = buttonList:GetSelected()

            print("teleporting to", buttonID)
        end,
        master = buttonList,
    })
end
