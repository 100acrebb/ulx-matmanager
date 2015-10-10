if SERVER then
	util.AddNetworkString( "CallNoTrail" ) 
	util.AddNetworkString( "CallNoMaterials" ) 
end


--- addons to ulx
function ulx.notrails( calling_ply )
	net.Start( "CallNoTrail" )
	net.Send( calling_ply )
end
local notrails = ulx.command( "THAB", "ulx notrails", ulx.notrails, "!notrails")
notrails:defaultAccess( ULib.ACCESS_ALL )
notrails:help( "Turn off trails locally" )


function ulx.nomaterials( calling_ply )
	net.Start( "CallNoMaterials" )
	net.Send( calling_ply )
end
local nomaterials = ulx.command( "THAB", "ulx nomaterials", ulx.nomaterials, "!nomaterials")
nomaterials:defaultAccess( ULib.ACCESS_ALL )
nomaterials:help( "Turn off player materials locally" )



if CLIENT then

	function MaterialMgrEntityCreated(ent)
		if ( ent:GetClass() == "env_spritetrail" ) then
		
			if LocalPlayer().NoTrails == true then
				--print("MaterialMgrEntityCreated")
				local col = ColorAlpha(ent:GetColor(), 0)
				
				
				timer.Simple( 0.1, function()  
					if ent:GetOwner() != nil and type(ent:GetParent()) == "Player" then
						--ent:Remove()
						--print("MaterialMgrEntityCreated1")
						ent:SetColor( col ) -- Sets the players color to colBlack
					elseif ent:GetParent() != nil and type(ent:GetParent()) == "Player" then
						--ent:Remove()
						--print("MaterialMgrEntityCreated2")
						ent:SetColor( col ) -- Sets the players color to colBlack
					end
				
				end )
				
				
			end
		end
	end
	hook.Add("OnEntityCreated", "MaterialMgrEntityCreated", MaterialMgrEntityCreated)


	function MaterialMgrTrailsOff()
		--print("MaterialMgrTrailsOff")
		LocalPlayer().NoTrails = true
		
		for k, v in pairs(ents.FindByClass("env_spritetrail")) do
			local col = ColorAlpha(v:GetColor(), 0)
			if v:GetOwner() != nil and type(v:GetParent()) == "Player" then
				--v:Remove()
				v:SetColor( col ) -- Sets the players color to colBlack
			elseif v:GetParent() != nil and type(v:GetParent()) == "Player" then
				--v:Remove()
				v:SetColor( col ) -- Sets the players color to colBlack
			end
		end
	end
	
	net.Receive( "CallNoTrail", function( len )
		 MaterialMgrTrailsOff()
	end )
	
	
	
	
	
	
	
	
	
	
	
	function MaterialMgrMaterialsOff()
		--print("MaterialMgrTrailsOff")
		LocalPlayer().NoMaterials = true
		
		for k, v in pairs( player.GetAll() ) do
			v:SetMaterial(nil)
		end
		
	end
	
	net.Receive( "CallNoMaterials", function( len )
		 MaterialMgrMaterialsOff()
	end )


end