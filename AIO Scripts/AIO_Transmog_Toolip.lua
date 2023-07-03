local AIO = AIO or require("AIO")

if AIO.AddAddon() then
    -- we are on server
	local function FindAppearance(player, msg)
		local Result = CharDBQuery("SELECT item_template_id FROM custom_unlocked_appearances WHERE account_id ="..player:GetAccountId().." AND item_template_id = "..msg);
		if not(Result) then
			AIO.Msg():Add("AppearanceResult", msg):Send(player)
		end
	end
	
	--Register Events
	AIO.RegisterEvent("FindAppearance", FindAppearance)
else
	local Self = 0;
	local AppearanceSet = 0;
    -- we are on client


	if (AppearanceSet == 0) then
		local function addLine(self,id)
			self:AddLine("|cfff194f7New Appearance")
			self:Show()
		end

		local function attachItemTooltip(self)
			if (AppearanceSet == 0) then
				local link = select(2,self:GetItem())
				if not link then return end
				local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
				itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
				if itemEquipLoc == "INVTYPE_AMMO" or itemEquipLoc == "INVTYPE_NECK" or itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" or itemEquipLoc == "INVTYPE_BAG" or itemEquipLoc == "INVTYPE_QUIVER" then 
					return
				end
				if IsEquippableItem(id) then
					Self = self;
					AIO.Msg():Add("FindAppearance", id):Send()
				end
			end
		end

		local function AppearanceResult(player, id)
			--addLine(Self,id,true)
			GameTooltip:AddLine("|cfff194f7New Appearance")
			GameTooltip:Show();
		end
		
		AIO.RegisterEvent("AppearanceResult", AppearanceResult)
		
		GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
	end
	
end