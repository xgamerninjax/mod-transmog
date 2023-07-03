local AIO = AIO or require("AIO")

if AIO.AddAddon() then
    -- we are on server
	local function FindAppearance(player, msg)
		local results = {}

		local query = "SELECT item_template_id FROM custom_unlocked_appearances WHERE account_id =" .. player:GetAccountId()
		local dbResult = CharDBQuery(query)

		if dbResult then
			repeat
				local itemTemplateId = dbResult:GetUInt32(0)
				table.insert(results, itemTemplateId)
			until not dbResult:NextRow()
		end
		
		AIO.Msg():Add("AppearanceResult", results):Send(player)
	end
	
	--Register Events
	AIO.RegisterEvent("FindAppearance", FindAppearance)
else
    -- we are on client

	local function addLine(self,id)
		self:AddLine("|cfff194f7New Appearance")
		self:Show()
	end

	local function attachItemTooltip(self)
		local link = select(2,self:GetItem())
		if not link then return end
		local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
		itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(id)
		if itemEquipLoc == "INVTYPE_AMMO" or itemEquipLoc == "INVTYPE_NECK" or itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" or itemEquipLoc == "INVTYPE_BAG" or itemEquipLoc == "INVTYPE_QUIVER" or tContains(TransmogTipList, tonumber(id)) then 
		return
	  end
		if IsEquippableItem(id) then
			Self = self;
			addLine(self,id,true)
	  end
	end


	local TransmogTip = CreateFrame("Frame")
	TransmogTip:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	TransmogTip:RegisterEvent("ADDON_LOADED")
	TransmogTip:SetScript("OnEvent", function(self, event, arg1, ...) onEvent(self, event, arg1, ...) end);

	function onEvent(self, event, arg1, ...)
	  if event == "ADDON_LOADED" then
		if TransmogTipList == nill then
		  TransmogTipList = {}
		  AIO.Msg():Add("FindAppearance", "."):Send()
		end
	  end
	  if event== "PLAYER_EQUIPMENT_CHANGED" then
		AIO.Msg():Add("FindAppearance", "."):Send()
	  end
	end
	
	GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
	ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
	ShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)

	
	local function AppearanceResult(player, msg)
		for index, value in ipairs(msg) do
			if not tContains(TransmogTipList, value) then
				table.insert(TransmogTipList, value)
			end
		end
	end
	
	--Register Events
	AIO.RegisterEvent("AppearanceResult", AppearanceResult)
end

