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
    local inAdminMode = GetConVar("ttt2_buttoninfo_show_admin_info"):GetBool()
        and admin.IsAdmin(client)
    local toggleState = ent:GetNWInt("m_toggle_state", -1)

    if buttonInfo then
        if buttonInfo.title then
            tData:SetTitle(TryT(buttonInfo.title))
        end

        if buttonInfo.description then
            tData:AddDescriptionLine(TryT(buttonInfo.description))
        end

        if istable(buttonInfo.descriptionForState) then
            local descriptionForState = buttonInfo.descriptionForState[toggleState]

            if descriptionForState then
                tData:AddDescriptionLine(TryT(descriptionForState))
            end
        end
    end

    if inAdminMode then
        -- add an empty line if there's already data in the description area
        if tData:GetAmountDescriptionLines() > 0 then
            tData:AddDescriptionLine()
        end

        tData:AddDescriptionLine(
            ParT("buttoninfo_admin_info", { id = buttonID }),
            COLOR_ORANGE
            --{ materialDNATargetID }
        )

        tData:AddDescriptionLine("toggle state: " .. tostring(toggleState))
    end

    -- if hidden and not in admin mode: hide
    if
        buttonInfo
        and (
            buttonInfo.hidden
            or istable(buttonInfo.hideForState) and buttonInfo.hideForState[toggleState]
        )
    then
        if inAdminMode then
            tData:SetKey(nil)

            tData:AddDescriptionLine(
                TryT("buttoninfo_admin_hidden"),
                COLOR_ORANGE
                --{ materialDNATargetID }
            )
        else
            tData:EnableText(false)
            tData:EnableOutline(false)
        end
    end
end)
