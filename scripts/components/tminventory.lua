local MAXSLOTS = 1000

local Inventory = Class(function(self, inst)
    self.inst = inst

    self.itemslots = {}
	self.maxslots = MAXSLOTS

    self.recipes = {}
    self.recipe_count = 0
	
    self.acceptsstacks = true
    self.ignorescangoincontainer = false
    self.opencontainers = {}
    
end)

function Inventory:NumItems()
	local num = 0
	for k,v in pairs(self.itemslots) do
		num = num + 1
	end
	
	return num
end

function Inventory:GuaranteeItems(items)

    self.inst:DoTaskInTime(0,function()
        

        for k,v in pairs(items) do
            local item = v
            
            if self:Has(item, 1) then
                for k,v in pairs(Ents) do
                    if v.prefab == item and v.components.inventoryitem:GetGrandOwner() ~= GetPlayer() then
                        v:Remove()
                    end
                end
            else
                for k,v in pairs(Ents) do
                    if v.prefab == item then
                        item = nil
                        break
                    end
                end
                if item then
                    self:GiveItem(SpawnPrefab(item))
                end
            end
        end
    end)

end


function Inventory:CanTakeItemInSlot(item, slot)

	if not (item and item.components.inventoryitem and (item.components.inventoryitem.cangoincontainer or self.ignorescangoincontainer) ) then
		return false
	end

	return item and item.components.inventoryitem ~= nil
end

function Inventory:GetNumSlots()
    return self.maxslots
end


function Inventory:GetItemSlot(item)
    for k,v in pairs(self.itemslots) do
        if item == v then
            return k
        end
    end
end

function Inventory:FindItem(fn)
    for k,v in pairs(self.itemslots) do
        if fn(v) then
            return v
        end
    end
    
    if self.overflow then
		return self.overflow.components.container:FindItem(fn)
    end
end

function Inventory:FindItems(fn)
    local items = {}
    
    for k,v in pairs(self.itemslots) do
        if fn(v) then
            table.insert(items, v)
        end
    end
    
    local overflow_items = {}

    if self.overflow then
        overflow_items = self.overflow.components.container:FindItems(fn)
    end

    if #overflow_items > 0 then
        for k,v in pairs(overflow_items) do
            table.insert(items, v)
        end
    end

    return items
end

function Inventory:RemoveItemBySlot(slot)
    if slot and self.itemslots[slot] then
        local item = self.itemslots[slot]
		self:RemoveItem(item, true)
        return item
    end
end

function Inventory:DropItem(item, wholestack, randomdir, pos)
    if not item or not item.components.inventoryitem then
        return
    end
    
    local dropped = item.components.inventoryitem:RemoveFromOwner(wholestack) or item
    
    if dropped then
        pos = pos or Vector3(self.inst.Transform:GetWorldPosition())
        --print("Inventory:DropItem", item, pos)
		dropped.Transform:SetPosition(pos:Get())

        if dropped.components.inventoryitem then
            dropped.components.inventoryitem:OnDropped(randomdir)
        end
        
        self.inst:PushEvent("dropitem", {item = dropped})
    end

    return dropped
end

function Inventory:GetItemInSlot(slot)
    return self.itemslots[slot]
end


function Inventory:IsFull()
    for k = 1, self.maxslots do
		if not self.itemslots[k] then
			return false
		end
    end

	return true
end

---Returns the slot, and the container where the slot is (self.itemslots, self.equipslots or self.overflow)
function Inventory:GetNextAvailableSlot(item)
	
	local prefabname = nil
	if item.components.stackable ~= nil then
		prefabname = item.prefab
	
        --check for stacks that aren't full
        for k,v in pairs(self.itemslots) do
            if v.prefab == prefabname and v.components.stackable and not v.components.stackable:IsFull() then
                return k, self.itemslots
            end
        end
        if self.overflow and self.overflow.components.container then
            for k,v in pairs(self.overflow.components.container.slots) do
                if v.prefab == prefabname and v.components.stackable and not v.components.stackable:IsFull() then
                    return k, self.overflow
                end
            end
        end
	end

    --check for empty space in the container
	local empty = nil
    for k = 1, self.maxslots do
		if self:CanTakeItemInSlot(item, k) and not self.itemslots[k] then
			if prefabname ~= nil then
				if empty == nil then
            		empty = k
				end
			else
				return k, self.itemslots
			end
		end
    end
    return empty, self.itemslots
end
function Inventory:GiveItem( inst, slot, screen_src_pos )
    --print("Inventory:GiveItem", inst, slot, screen_src_pos)
    if not inst.components.inventoryitem or not inst:IsValid() then
        return
    end

	if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
        inst.components.inventoryitem:RemoveFromOwner(true)
	end

    local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst)
    if objectDestroyed then
      	return
    end

    local can_use_suggested_slot = false

    if not slot and inst.prevslot and not inst.prevcontainer then
        slot = inst.prevslot
    end

    if not slot and inst.prevslot and inst.prevcontainer and inst.prevcontainer.components then
        if inst.prevcontainer.components.inventoryitem and inst.prevcontainer.components.inventoryitem.owner == self.inst and inst.prevcontainer:IsOpen() and inst.prevcontainer:GetItemInSlot(inst.prevslot) == nil then
            inst.prevcontainer:GiveItem(inst, inst.prevslot)
            --self:RemoveItem(inst)
            return
        end
    end

    if slot then
        local olditem = self:GetItemInSlot(slot)
        can_use_suggested_slot = slot ~= nil and slot <= self.maxslots and ( olditem == nil or (olditem and olditem.components.stackable and olditem.prefab == inst.prefab)) and self:CanTakeItemInSlot(inst,slot)
    end

    local container = self.itemslots
    if not can_use_suggested_slot then
		slot,container = self:GetNextAvailableSlot(inst)
    end

    if slot then
		local leftovers = nil
        if container == self.overflow and self.overflow and self.overflow.components.container then
            local itemInSlot = self.overflow.components.container:GetItemInSlot(slot) 
            if itemInSlot then
                leftovers = itemInSlot.components.stackable:Put(inst, screen_src_pos)
            end
		else
	        if self.itemslots[slot] ~= nil then
	            leftovers = self.itemslots[slot].components.stackable:Put(inst, screen_src_pos)
	        else
                inst.components.inventoryitem:OnPutInInventory(self.inst)
	    	    self.itemslots[slot] = inst
			    self.inst:PushEvent("itemget", {item=inst, slot = slot, src_pos = screen_src_pos})
	        end
        end
        
        if leftovers then
            self:GiveItem(leftovers)
        end
        
        return slot
    elseif self.overflow and self.overflow.components.container then
		if self.overflow.components.container:GiveItem(inst, nil, screen_src_pos) then
			return true
		end
    end
    --self.inst:PushEvent("inventoryfull", {item=inst})

    --self:DropItem(inst, true, true)
    
end

function Inventory:RemoveItem(item, wholestack)

    local dec_stack = not wholestack and item and item.components.stackable and item.components.stackable:IsStack() and item.components.stackable:StackSize() > 1

    if dec_stack then
        local dec = item.components.stackable:Get()
        return dec
    else
        for k,v in pairs(self.itemslots) do
            if v == item then
                self.itemslots[k] = nil
                self.inst:PushEvent("itemlose", {slot = k})
                
                if item.components.inventoryitem then
                    item.components.inventoryitem:OnRemoved()
                end
                
                return item
            end
        end

        local ret = nil   
        
        if ret then
            if ret.components.inventoryitem and ret.components.inventoryitem.OnRemoved then
                ret.components.inventoryitem:OnRemoved()
                return ret
            end
        else
            if self.overflow then
		        return self.overflow.components.container:RemoveItem(item, wholestack)
            end
        end

    end
    return item

end


function Inventory:Has(item, amount)
    local num_found = 0
    for k,v in pairs(self.itemslots) do
        if v and v.prefab == item then
        	if v.components.stackable ~= nil then
        		num_found = num_found + v.components.stackable:StackSize()
        	else
            	num_found = num_found + 1
            end
        end
    end
    
    if self.overflow then
		local overflow_enough, overflow_found = self.overflow.components.container:Has(item, amount)
		num_found = num_found + overflow_found
    end
    
    
    
    return num_found >= amount, num_found
end



function Inventory:ConsumeByName(item, amount)
    
    local total_num_found = 0
    
    local function tryconsume(v)
		local num_found = 0
        if v and v.prefab == item then
            local num_left_to_find = amount - total_num_found
            
            if v.components.stackable then
                if v.components.stackable.stacksize > num_left_to_find then
                    v.components.stackable:SetStackSize(v.components.stackable.stacksize - num_left_to_find)
                    num_found = amount
                else
                    num_found = num_found + v.components.stackable.stacksize
                    self:RemoveItem(v, true):Remove()
                end
            else
                num_found = num_found + 1
                self:RemoveItem(v):Remove()
            end
        end
        return num_found
    end
    

    for k = 1,self.maxslots do
        local v = self.itemslots[k]
        total_num_found = total_num_found + tryconsume(v)
        
        if total_num_found >= amount then
            break
        end
    end

    if self.overflow and total_num_found < amount then
		self.overflow.components.container:ConsumeByName(item, (amount - total_num_found))
    end
    
end

function Inventory:DropEverything(ondeath, keepequip)    
--    for k = 1,self.maxslots do
--        local v = self.itemslots[k]
--        if v then
--            self:DropItem(v, true, true)
--        end
--    end
end

function Inventory:BurnNonpotatableInContainer(container)
	for j = 1,container.numslots do
		if container.slots[j] and container.slots[j]:HasTag("nonpotatable") then
			local olditem = container:RemoveItem(container.slots[j], true)
			local itemash = SpawnPrefab("ash")
			itemash.components.named:SetName( olditem.name )
			container:GiveItem(itemash,j)
			olditem:Remove()
		end
	end
end

return Inventory
