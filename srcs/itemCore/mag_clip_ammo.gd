extends XRToolsPickable
#Base for all the 'physical' ammo related things.
#	needs a bit more work


var ammo_can = 60 #
@export_enum("SMG:60") var pickup_type #I'm sure there's a way to avoid having to set it without calling _super_ready()

