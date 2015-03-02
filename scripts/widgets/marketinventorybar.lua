
require "class"
require "itemlist"


 
local inventory = require("components/marketinventory")
local InvSlot = require "widgets/marketinvslot"
local TileBG = require "widgets/tilebg"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local ItemTile = require "widgets/marketitemtile"
local Text = require "widgets/text"
local AnimButton = require "widgets/animbutton"
local TextButton = require "widgets/textbutton"
local ImageButton = require "widgets/imagebutton"

local HUD_ATLAS = "images/hud.xml"
local NUM_COLUMS = 7
local MAX_ROWS = 8
local MAXSLOTS = NUM_COLUMS * MAX_ROWS




local Inv = Class(Widget, function(self, owner)
	Widget._ctor(self, "Inventory")
	
	self.slots = self:AddChild(Widget("SLOTS"))
	self.inventory = {}
	self.maxpages = 0
	self.currentpage = 0
    self.owner = owner
	self.base_scale = .6
	self.selected_scale = .8
    self:SetScale(self.base_scale)
    
	-- resets all tiles
    if self.inv then
	    for k,v in pairs(self.inv) do
			v:SetTile(nil)
		end
	end

    self.inv = {}
    
    local strItems = {}
    -- pulls in new items from the itemlist which arn't blueprints
    for k,v in pairs(ITEMLIST) do 
    	if not contains(strItems, v) and not string.find(v, "blueprint") then
			if(GetModConfigData(v, KnownModIndex:GetModActualName("Pigman Marketplace"))) == "noTrade" then
				--Item is disabled in config
			else
				--Item is enabled in config
				table.insert(strItems, v)
			end
    	end
    end
    
	
	-- for all the items, turn them from a string into the prefab in the self.inventory table
    local i = 0
	for k,v in pairs(strItems) do
	
			local item = SpawnPrefab(v)
			if item ~= nil then
				--print(item)
				if item.components and item.components.inventoryitem then
					self.inventory[i] = item
		
					i = i + 1
				else
					item:Remove()
				end
			end
    end
	
	

    --Sort table alphabetically
    --table.sort(self.inventory, function(a,b) return a:GetDisplayName() < b:GetDisplayName() end)
    
	
	
    self.menu = self:AddChild(Widget("MENU"))
	self.menu:SetPosition(225, -0, 0)

	self.prevbutton = self.menu:AddChild(ImageButton())
	self.prevbutton:SetText("Prev")
    self.prevbutton:SetPosition(-175, -630, 0)
    self.prevbutton:SetOnClick( function() self:Scroll(-1) end)
    self.prevbutton:Hide()
	
	self.nextbutton = self.menu:AddChild(ImageButton())
	self.nextbutton:SetText("Next")
    self.nextbutton:SetPosition(175, -630, 0)
    self.nextbutton:SetOnClick( function() self:Scroll(1) end)
    
	
    local num_slots = #self.inventory
    self.maxpages = math.floor(num_slots / MAXSLOTS)
	if self.maxpages == 0 then
		self.nextbutton:Hide()
	end
	
    self.pagetext = self.menu:AddChild(Text(DEFAULTFONT, 60))
    self.pagetext:SetString("1/1")
    self.pagetext:SetColour(1,1,1,1)
	self.pagetext:SetPosition(0, -690, 0)

	self.rebuild_pending = true
end)

function Inv:Rebuild()

	self.slots:KillAllChildren()

    for k,v in pairs(self.inv) do
    	v:Kill()
    end

    self.inv = {}

    local num_slots = #self.inventory
    self.maxpages = math.floor(num_slots / MAXSLOTS)
    
    if self.maxpages <= 0 then
    	--self.nextbutton:Hide()
    end
    
    self.pagetext:SetString((self.currentpage+1).."/"..(self.maxpages+1))
    
    local W = 76
    local H = 76
    local maxwidth = (W * NUM_COLUMS)
	
	local positions = 0
    for k = self.currentpage * MAXSLOTS, math.min(num_slots-1, (self.currentpage + 1) * MAXSLOTS - 1)+1 do
    	local height = math.floor(positions / NUM_COLUMS) * H
        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, self.inventory)
        self.inv[k] = self.slots:AddChild(slot)
		self.inv[k]:SetTile(ItemTile(self.inventory[k],self.owner))
        
        local remainder = positions % NUM_COLUMS
        local row = math.floor(positions / NUM_COLUMS) * H

        local x = W * remainder
        slot:SetPosition(x,-row,0)
		--print(x,-row,0)
        positions = positions + 1
		--print(k)
    end

	self.rebuild_pending = false
end


function Inv:Update(dt)

	if self.rebuild_pending == true then
		self:Rebuild()
		--self:Refresh()
	end
end

function Inv:OnControl(control, down)
	if Inv._base.OnControl(self, control, down) then return true end
	
	if self.open then
		if not down then 
			if control == CONTROL_ACCEPT then
				self.inv[self.active_slot]:Click()
			end
		end
	end
end

function Inv:Refresh()
	
	for k,v in pairs(self.inv) do
		v:SetTile(nil)
	end

	for k,v in pairs(self.inventory) do
		if v then
			local tile = ItemTile(v, self,self.owner)
			if (self.inv[k]) then	
				self.inv[k]:SetTile(tile)
			end
		end
	end
end

function Inv:Delete()
	for k,v in pairs(self.inventory) do
    	v:Remove()
    end
	for k,v in pairs(self.inv) do
    	v:Kill()
    end
end

function contains(tab,val)
	for k,v in pairs(tab) do 
		if v == val then 
			return true 
		end
	end

	return false
end

function Inv:Scroll(dir)

	local tempcurrentpage = self.currentpage
	
	self.currentpage = self.currentpage + dir
	
	if self.currentpage <= 0 then
		self.currentpage = 0
		self.prevbutton:Hide()
	else
		self.prevbutton:Show()
	end
	
	if self.currentpage >= self.maxpages then
		self.currentpage = self.maxpages
		self.nextbutton:Hide()
	else
		self.nextbutton:Show()
	end
	
	if tempcurrentpage ~= self.currentpage then
		for k,v in pairs(self.inv) do
	    	v:Kill()
	    end
		
		self.rebuild_pending = true
	end
	
end

return Inv