require "util"
local Screen = require "widgets/screen"
local AnimButton = require "widgets/animbutton"
local Button = require "widgets/button"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local Menu = require "widgets/menu"
local Grid = require "widgets/grid"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Spinner = require "widgets/spinner"
local NumericSpinner = require "widgets/numericspinner"
local Widget = require "widgets/widget"
local Inv = require "widgets/marketinventorybar"
local HoverText = require "widgets/markethoverer"



--require "screens/popupdialog"


local status = "Buying"
local text_font = UIFONT--NUMBERFONT

MarketScreen = Class(Screen, function(self, in_game,owner)
	--Screen._ctor(self, "MarketScreen")
	Widget._ctor(self, "MarketScreen")
	self.in_game = in_game
	self.owner = owner
	
    
	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0,0,0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    
    self.itemspanel = self.root:AddChild( Image( "images/globalpanels.xml", "panel_skinny.tex" ) )
	self.itemspanel:SetScale(1,1,1)
	self.itemspanel:SetPosition(-380,0,0)
       
    self.inv = self.itemspanel:AddChild(Inv(GetPlayer()))
	self.inv:SetPosition(-135, 190, 0)
	
	self.closebutton = self.itemspanel:AddChild(ImageButton())
	self.closebutton:SetText("Buying")
    self.closebutton:SetPosition(0, -188, 0)
    self.closebutton:SetScale(0.6)
    self.closebutton:SetOnClick( function() self:StatusToggle() end)
	
	self.hover = self:AddChild(HoverText(self))
	self.hover:SetScaleMode(SCALEMODE_PROPORTIONAL)
	self.hover.isFE = true
end)


function MarketScreen:OnControl(control, down)
    if MarketScreen._base.OnControl(self, control, down) then return true end
    
    if (control == CONTROL_PAUSE or control == CONTROL_CANCEL) and not down then
		self:Accept()
		return true
    end
end

function MarketScreen:isBuying()
	return status == "Buying" 
end

function MarketScreen:StatusToggle()
	if status == "Buying" then
		status = "Selling"
	else
		status = "Buying"
	end
	self.closebutton:SetText(status)
end

function MarketScreen:Accept()
	self.inv:Delete()
	TheFrontEnd:PopScreen(self)
end

function MarketScreen:OnUpdate(dt)
	self.hover:Update()
	self.inv:Update(dt)
end


function MarketScreen:UpdateMenu()
	self.menu:Clear()
	self.menu:AddItem(STRINGS.UI.OPTIONS.CLOSE, function() self:Accept() end)
end
