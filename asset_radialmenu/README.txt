ESX RADIAL MENU V2
==================

INSTALL:
1. Extract folder "esx_radialmenu" into:
   resources/[esx]/esx_radialmenu

2. Add to server.cfg:
   ensure esx_radialmenu

3. Restart server/resource.

CONTROLS:
F1 = Open / close
ESC = Close
Click center = Close
Click outside = Close

MENU:
- Inventory: opens ox_inventory if it is started.
- Phone: use Config.PhoneCommand.
- Vehicle: opens Vehicle submenu when inside a vehicle.
- Player: opens Player submenu.
- Job: shows current job.
- Settings: opens Settings submenu.

VEHICLE SUBMENU:
- Engine
- Doors
- Hood
- Trunk
- Back

CONFIG EXAMPLES:
Config.PhoneCommand = 'phone'
Config.HudCommand = 'hud'
Config.CursorCommand = 'cursor'
Config.InventoryCommand = 'inventory'

IMPORTANT:
If your phone/hud uses a different command, change it in config.lua.
No ox_lib is required by this resource.

kalo mahu hilangkan background ini

.backdrop {
    position: absolute;
    inset: 0;
    background: transparent;
    backdrop-filter: none;
} 

ganti di style.css
