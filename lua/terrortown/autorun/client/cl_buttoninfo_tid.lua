local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation

hook.Add("TTTRenderEntityInfo", "buttoninfo_tid", function(tData)
    local client = LocalPlayer()
    local ent = tData:GetEntity()

    if
        not IsValid(client)
        or not client:IsTerror()
        or not IsValid(ent)
        or not ent:IsButton()
        or tData:GetEntityDistance() > 100
    then
        return
    end

    local buttonID = ent:GetNWInt("buttonID", 0)

    if buttonID == 0 then
        return
    end

    local buttonInfo = buttoninfo.GetInfoFromEntity(ent)

    if buttonInfo then
        if buttonInfo.title then
            tData:SetTitle(TryT(buttonInfo.title))
        end

        if buttonInfo.description then
            tData:AddDescriptionLine(TryT(buttonInfo.description))
        end
    end

    if GetConVar("ttt2_buttoninfo_show_admin_info"):GetBool() and admin.IsAdmin(client) then
        -- add an empty line if there's already data in the description area
        if tData:GetAmountDescriptionLines() > 0 then
            tData:AddDescriptionLine()
        end

        tData:AddDescriptionLine(
            ParT("buttoninfo_admin_info", { id = buttonID }),
            COLOR_ORANGE
            --{ materialDNATargetID }
        )

        tData:AddDescriptionLine(
            "toggle state: " .. tostring(ent:GetInternalVariable("m_toggle_state") or nil)
        )
    else
        return
    end

    -- if hidden and not in admin mode: hide
    if buttonInfo and buttonInfo.hidden then
        tData:EnableText(false)
        tData:EnableOutline(false)
    end
end)
