local ItemSlot = require "widgets/itemslot"


local InvSlot = Class(ItemSlot, function(self, num, atlas, bgim, owner, container)
    ItemSlot._ctor(self, atlas, bgim, owner)
    self.owner = owner
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
    local character = GetPlayer()
    local slot_number = self.num
    local container = self.container
    local container_item = container[slot_number]
    
    character.SoundEmitter:PlaySound("dontstarve/HUD/click_object")
    
    if container_item then
        local loot = SpawnPrefab(container_item.prefab)
        if loot then
        
        	if stack_mod and loot.components.stackable then
        		loot.components.stackable.stacksize = 10
        	end
        
			local pt = Point(character.Transform:GetWorldPosition())
	        
			loot.Transform:SetPosition(pt.x,pt.y,pt.z)
	        
			if loot.Physics then
	        
				local angle = math.random()*2*PI
				loot.Physics:SetVel(2*math.cos(angle), 10, 2*math.sin(angle))

				if loot and loot.Physics and character and character.Physics then
					pt = pt + Vector3(math.cos(angle), 0, math.sin(angle))*((loot.Physics:GetRadius() or 1) + (character.Physics:GetRadius() or 1))
					loot.Transform:SetPosition(pt.x,pt.y,pt.z)
				end
				
				loot:DoTaskInTime(1, 
					function() 
						if not (loot.components.inventoryitem and loot.components.inventoryitem:IsHeld()) then
							if not loot:IsOnValidGround() then
								local fx = SpawnPrefab("splash_ocean")
							    local pos = loot:GetPosition()
    							fx.Transform:SetPosition(pos.x, pos.y, pos.z)
						        --PlayFX(loot:GetPosition(), "splash", "splash_ocean", "idle")
								if loot:HasTag("irreplaceable") then
									loot.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())
								else
									loot:Remove()
								end
							end
						end
					end)
			end
	        
			return loot
		end
	end
end





return InvSlot
