local assets=
{
	Asset("ANIM", "anim/goldfragment.zip"),
	Asset("ATLAS", "images/inventoryimages/goldfragment.xml"),
	Asset("IMAGE", "images/inventoryimages/goldfragment.tex" ),
}


STRINGS.NAMES.GOLDFRAGMENT= "Gold Fragment"		
STRINGS.RECIPE_DESC.GOLDFRAGMENT = "A fragment of gold"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDFRAGMENT = "It's so small!"


local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )    
	
    inst.AnimState:SetBank("goldfragmentbank")
    inst.AnimState:SetBuild("goldfragment")
    inst.AnimState:PlayAnimation("idle")


    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 100
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goldfragment.xml"
	
    
    return inst
end

return Prefab( "common/inventory/goldfragment", fn, assets) 
