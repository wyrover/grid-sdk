--========= Copyright © 2013-2015, Planimeter, All rights reserved. ==========--
--
-- Purpose: Drop-Down List Item Group class
--
--============================================================================--

class "dropdownlistitemgroup" ( gui.radiobuttongroup )

function dropdownlistitemgroup:dropdownlistitemgroup( parent, name )
	gui.radiobuttongroup.radiobuttongroup( self, nil, name )
	self.width		  = parent:getWidth()
	self.dropDownList = parent
	self:setScheme( "Default" )
end

function dropdownlistitemgroup:addItem( item, default )
	item:setParent( self )
	gui.radiobuttongroup.addItem( self, item )

	if ( default or #self:getItems() == 1 ) then
		item:setDefault( true )
	end

	self:invalidateLayout()
end

function dropdownlistitemgroup:draw()
	if ( not self:isVisible() ) then
		return
	end

	gui.panel.draw( self )

	local property = "dropdownlistitem.backgroundColor"
	local height   = self:getHeight()
	local width	   = self:getWidth()
	graphics.setColor( self:getScheme( property ) )
	graphics.line( 0, 0, width, 0 )
	graphics.line( 0, height - 1, width, height - 1 )
	property = "dropdownlistitem.outlineColor"
	graphics.setColor( self:getScheme( property ) )
	graphics.line( 0, 0, width, 0 )
	graphics.line( 0, height - 1, width, height - 1 )
end

function dropdownlistitemgroup:getDropDownList()
	return self.dropDownList
end

function dropdownlistitemgroup:invalidateLayout()
	self:updatePos()
	self:setWidth( self:getDropDownList():getWidth() )

	local listItems = self:getItems()
	if ( listItems ) then
		local y = 0
		for _, listItem in ipairs( listItems ) do
			listItem:setY( y )
			listItem:setWidth( self:getWidth() )
			y = y + listItem:getHeight()
		end
		self:setHeight( y )
	end
end

function dropdownlistitemgroup:isVisible()
	local dropDownList = self:getDropDownList()
	return dropDownList:isVisible() and dropDownList:isActive()
end

function dropdownlistitemgroup:mousepressed( x, y, button )
	if ( not self:isVisible() ) then
		return
	end

	if ( button == "l" ) then
		local dropDownList = self:getDropDownList()
		if ( dropDownList ~= gui.topPanel and
		   ( not ( self.mouseover or self:isChildMousedOver() ) ) ) then
			dropDownList:setActive( false )
		end
	end

	gui.panel.mousepressed( self, x, y, button )
end

function dropdownlistitemgroup:onValueChanged( oldValue, newValue )
	local dropDownList = self:getDropDownList()
	dropDownList:setActive( false )
	dropDownList:onValueChanged( oldValue, newValue )
end

local sx, sy = 0, 0

function dropdownlistitemgroup:updatePos()
	local dropDownList = self:getDropDownList()
	if ( dropDownList ) then
		sx, sy = dropDownList:localToScreen( dropDownList:getX(),
											 dropDownList:getY() )
		self:setPos( sx, sy + dropDownList:getHeight() )
	end
end

gui.register( dropdownlistitemgroup, "dropdownlistitemgroup" )
