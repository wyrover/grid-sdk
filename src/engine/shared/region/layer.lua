--========= Copyright © 2013-2015, Planimeter, All rights reserved. ==========--
--
-- Purpose: Region Layer class
--
--============================================================================--

class( "regionlayer" )

function regionlayer:regionlayer( layerData )
	self.data = layerData
end

if ( _CLIENT ) then
	function regionlayer:createSpriteBatch()
		if ( self.spritebatch == nil ) then
			local image      = self:getTileset():getImage():getDrawable()
			local count      = self:getWidth() * self:getHeight()
			self.spritebatch = graphics.newSpriteBatch( image, count )
		end
	end

	function regionlayer:draw()
		if ( self:getType() == "tilelayer" ) then
			graphics.setOpacity( self:getOpacity() )
			graphics.setColor( color.white )
			graphics.draw( self:getSpriteBatch() )
		end
	end
end

function regionlayer:getData()
	return self.data
end

function regionlayer:getHighestTileGid()
	local highestTileGid = -1
	for xy, gid in ipairs( self:getData() ) do
		if ( gid >= highestTileGid ) then
			highestTileGid = gid
		end
	end
	return highestTileGid
end

function regionlayer:getName()
	return self.name
end

function regionlayer:getOpacity()
	return self.opacity
end

function regionlayer:getProperties()
	return self.properties
end

function regionlayer:getRegion()
	return self.region
end

if ( _CLIENT ) then
	function regionlayer:getSpriteBatch()
		return self.spritebatch
	end
end

function regionlayer:getTileset()
	return self.tileset
end

function regionlayer:getType()
	return self.type
end

function regionlayer:getWidth()
	return self.width
end

function regionlayer:getHeight()
	return self.height
end

function regionlayer:getX()
	return self.x
end

function regionlayer:getY()
	return self.y
end

if ( _CLIENT ) then
	function regionlayer:initializeTiles()
		self:createSpriteBatch()

		local spritebatch = self:getSpriteBatch()
		spritebatch:bind()

		local tileset     = self:getTileset()
		local tileWidth   = tileset:getTileWidth()
		local tileHeight  = tileset:getTileHeight()
		local image       = tileset:getImage()
		local imageWidth  = image:getWidth()
		local imageHeight = image:getHeight()
		local quad        = graphics.newQuad( 0,          0,
		                                      tileWidth,  tileHeight,
		                                      imageWidth, imageHeight )

		local tileX  = 0
		local tileY  = 0
		local floor  = math.floor
		local x      = 0
		local y      = 0
		local width  = self:getWidth()
		local height = self:getHeight()
		for xy, gid in ipairs( self:getData() ) do
			if ( gid ~= 0 ) then
				tileX =        ( gid - 1 ) * tileWidth % imageWidth
				tileY = floor( ( gid - 1 ) * tileWidth / imageWidth ) * tileHeight
				quad:setViewport( tileX, tileY, tileWidth, tileHeight )

				x =      ( ( xy - 1 ) % width  ) * tileWidth
				y = floor( ( xy - 1 ) / height ) * tileHeight
				spritebatch:add( quad,
				                 self:getX() + x,
				                 self:getY() + y )
			end
		end

		spritebatch:unbind()
	end
end

function regionlayer:isVisible()
	return self.visible
end

function regionlayer:parse()
	if ( not self.data ) then
		return
	end

	local data = self.data
	self:setType( data[ "type" ] )
	self:setName( data[ "name" ] )
	self:setX( data[ "x" ] )
	self:setY( data[ "y" ] )
	self:setWidth( data[ "width" ] )
	self:setHeight( data[ "height" ] )
	self:setVisible( data[ "visible" ] )
	self:setOpacity( data[ "opacity" ] )
	self:setProperties( table.copy( data[ "properties" ] ) )

	local type = self:getType()
	if ( type == "tilelayer" ) then
		self:setData( table.copy( data[ "data" ] ) )
	elseif ( type == "objectgroup" ) then
		if ( _SERVER ) then
			require( "engine.shared.entities" )
			local entities = entities.initialize( data[ "objects" ] )
			for _, entity in ipairs( entities ) do
				self:getRegion():addEntity( entity )
			end
		end
	end

	-- self.data = nil
end

function regionlayer:setData( data )
	self.data = data
end

function regionlayer:setName( name )
	self.name = name
end

function regionlayer:setOpacity( opacity )
	self.opacity = opacity
end

function regionlayer:setProperties( properties )
	self.properties = properties
end

function regionlayer:setRegion( region )
	self.region = region
end

function regionlayer:setTileset( tileset )
	self.tileset = tileset

	if ( _CLIENT ) then
		if ( self:getType() == "tilelayer" ) then
			self:initializeTiles()
		end
	end
end

function regionlayer:setType( type )
	self.type = type
end

function regionlayer:setVisible( visible )
	self.visible = visible
end

function regionlayer:setWidth( width )
	self.width = width
end

function regionlayer:setHeight( height )
	self.height = height
end

function regionlayer:setX( x )
	self.x = x
end

function regionlayer:setY( y )
	self.y = y
end

function regionlayer:__tostring()
	return "regionlayer: \"" .. self:getName() .. "\""
end
