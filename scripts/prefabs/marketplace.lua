require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/pig_king.zip"),
	Asset("SOUND", "sound/pig.fsb"),
}

local slotpos = {}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
	end
end

local prefabs = 
{
	"goldnugget",
}

local function OnGetItemFromPlayer(inst, giver, item)
 print("get item from player")
end

local function onopen(inst)
	--stuff when chest is being opened
end

local function onclose(inst)
	-- stuff when chest is being closed
end

local function OnRefuseItem(inst, giver, item)
	inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingReject")
    inst.AnimState:PlayAnimation("unimpressed")
	inst.AnimState:PushAnimation("idle", true)
	inst.happy = false
end

local function ShouldAcceptItem(inst, item)
	if item.prefab == "goldnugget" then
		return true
	end
end

local function cantakeitem(inst, item, slot)
	return item.prefab == "goldnugget"
end

local function fn(Sim)
    
	local inst = CreateEntity()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetPriority( 5 )
	minimap:SetIcon( "pigking.png" )
	minimap:SetPriority( 1 )

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize( 10, 5 )
    
    MakeObstaclePhysics(inst, 2, .5)
    --inst.Transform:SetScale(1.5,1.5,1.5)
    
    inst:AddTag("king")
    inst.AnimState:SetBank("Pig_King")
    inst.AnimState:SetBuild("Pig_King")
    inst.AnimState:PlayAnimation("idle", true)
    
    inst:AddComponent("inspectable")

	inst:AddComponent("container")

	inst.components.container:SetNumSlots(#slotpos)
	
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
		
	inst.components.container.widgetslotpos = slotpos
	
	-- will need to change this for when the buying mechanic is in
	
	
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0,200,0)
	inst.components.container.side_align_tip = 160	
	inst.components.container.acceptsstacks = true
	inst.components.container.type = "market"
	inst.components.container.itemtestfn = cantakeitem
	
	
    inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem

	inst:ListenForEvent( "nighttime", function(global, data)  
        inst.components.trader:Disable()
        inst.AnimState:PlayAnimation("sleep_pre")
        inst.AnimState:PushAnimation("sleep_loop", true)    
    end, GetWorld())
    
	inst:ListenForEvent( "daytime", function(global, data)
        inst.components.trader:Enable()
        inst.AnimState:PlayAnimation("sleep_pst")
        inst.AnimState:PushAnimation("idle", true)    
    end, GetWorld())
    
    return inst
end

return Prefab( "common/objects/marketplace", fn, assets, prefabs),
MakePlacer("common/objects/marketplace_placer", "marketplace", "marketplace", "idle")
	