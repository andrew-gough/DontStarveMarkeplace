local ItemSlot = require "widgets/itemslot"


local InvSlot = Class(ItemSlot, function(self, num, atlas, bgim, owner, container,screen)
    ItemSlot._ctor(self, atlas, bgim, owner)
    self.owner = owner
	self.screen = screen
    self.container = container
    self.num = num
end)

function InvSlot:GetSlotNum()
    if self.tile and self.tile.item then
        return self.tile.item.components.inventoryitem:GetSlotNum()
    end
end

function InvSlot:OnControl(control, down)
    if InvSlot._base.OnControl(self, control, down) then return true end
    if down then
        
        if control == CONTROL_ACCEPT then
            self:Click(false)
        elseif control == CONTROL_SECONDARY then
            self:Click(true)
        else
            return false
        end
        return true
    end


end


function InvSlot:Click(stack_mod)
	local character = self.owner
	local slot_number = self.num
	local container = self.container
	local container_item = container[slot_number]
	local loot = SpawnPrefab(container_item.prefab)
	local displayName = string.lower(loot:GetDisplayName())
	--print(self.screen)
	--print("Buying?: "..tostring(self.screen:isBuying()))
	local itemData = (GetModConfigData(container_item.prefab, KnownModIndex:GetModActualName("Pigman Marketplace")))
	local goldAmount = 1
	local itemAmount = 1
	if itemData ~= "noTrade" then
			goldAmount, itemAmount = string.match(itemData, '(%d+)Gfor(%d+)')
		end
	
	--the number of items to spawn; will get this from config values
	local numberToSpawn = tonumber(itemAmount) 
	--the cost of the item stack in gold; will get this from config values
	local goldCostOfItems = tonumber(goldAmount)
		
		
	if self.screen:isSelling() then

	
		
		--print("Item: "..container_item.prefab.." Cost: "..goldCostOfItems.." For "..numberToSpawn)
		--Check if character has (1) gold
		local repeating = 1;
		if stack_mod then
			if goldCostOfItems == 1 then				
					if itemAmount == 1 then
						character.components.talker:Say("This costs "..goldCostOfItems.." gold nugget for "..numberToSpawn.." "..displayName..".")
					else
						if(string.sub(displayName,-1,-1) == "s") then
						--already plural
						character.components.talker:Say("This costs "..goldCostOfItems.." gold nugget for "..numberToSpawn.." "..displayName..".")
						else
						character.components.talker:Say("This costs "..goldCostOfItems.." gold nugget for "..numberToSpawn.." "..displayName.."s.")
						end
					end
			else
					if itemAmount == 1 then
						character.components.talker:Say("This costs "..goldCostOfItems.." gold nuggets for "..numberToSpawn.." "..displayName..".")
					else
						if(string.sub(loot.GetDisplayName(),-1,-1) == "s") then
						--already plural
						character.components.talker:Say("This costs "..goldCostOfItems.." gold nuggets for "..numberToSpawn.." "..displayName..".")
						else
						character.components.talker:Say("This costs "..goldCostOfItems.." gold nuggets for "..numberToSpawn.." "..displayName.."s.")
						end
					end
		end
		else

		if character.components.inventory:Has("goldnugget", goldCostOfItems) then
			--Character loses (1) gold

			character.components.inventory:ConsumeByName("goldnugget",goldCostOfItems)

			-- TMI code here
			
			if container_item then
					if loot.components.stackable then
						loot.components.stackable:SetStackSize(numberToSpawn)
					else
						repeating = numberToSpawn
					end
				if loot then
					
						--On Right Click
						if stack_mod then

						else
						--On Left Click
		
						local pt = Point(character.Transform:GetWorldPosition())
				
						loot.Transform:SetPosition(pt.x,pt.y,pt.z)
				
						if loot.Physics then
				
							local angle = math.random()*2*PI
							loot.Physics:SetVel(2*math.cos(angle), 10, 2*math.sin(angle))
		
							if loot and loot.Physics and character and character.Physics then
								pt = pt + Vector3(math.cos(angle), 0, math.sin(angle))*((loot.Physics:GetRadius() or 1) + (character.Physics:GetRadius() or 1))
								loot.Transform:SetPosition(pt.x,pt.y,pt.z)
							end
					
							
							end
						end
					return loot
				end
			
			
				if repeating > 1 then
					local angle = math.random()*2*PI
					for i = 2,repeating,1 do
					local loot = SpawnPrefab(container_item.prefab)
					if loot then
					
					
								if stack_mod and loot.components.stackable then
									loot.components.stackable.stacksize = 10
								end
		
								local pt = Point(character.Transform:GetWorldPosition())
				
								loot.Transform:SetPosition(pt.x,pt.y,pt.z)
				
								if loot.Physics then
			   
									loot.Physics:SetVel(2*math.cos(angle), 10, 2*math.sin(angle))
		
									if loot and loot.Physics and character and character.Physics then
										pt = pt + Vector3(math.cos(angle), 0, math.sin(angle))*((loot.Physics:GetRadius() or 1) + (character.Physics:GetRadius() or 1))
										loot.Transform:SetPosition(pt.x,pt.y,pt.z)
									end
					
									
								end
						
					return loot
				end
			
				
					end
				end
			end
		else
		--No money
		
		 character.components.talker:Say("I need gold nuggets.")
		end
		end
		
		character.SoundEmitter:PlaySound("dontstarve/HUD/click_object")
    else
	print("Marketplace is buying")	
	
	end

end





return InvSlot
