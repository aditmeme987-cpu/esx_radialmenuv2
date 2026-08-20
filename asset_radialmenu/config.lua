Config = {}

Config.OpenKey = 'F1'
Config.Title = 'GANTARA'
Config.Subtitle = 'RADIAL MENU'

-- Main menu.
Config.MainItems = {
    { id = 'inventory', label = 'INVENTORY', icon = '🎒', action = 'inventory' },
    { id = 'phone',     label = 'PHONE',     icon = '📱', action = 'phone' },
    { id = 'vehicle',   label = 'VEHICLE',   icon = '🚗', action = 'vehicle', vehicleOnly = true },
    { id = 'player',    label = 'PLAYER',    icon = '👤', action = 'player' },
    { id = 'job',       label = 'JOB',       icon = '💼', action = 'job' },
    { id = 'settings',  label = 'SETTINGS',  icon = '⚙',  action = 'settings' }
}

Config.VehicleItems = {
    { id = 'engine', label = 'ENGINE', icon = '⚙', action = 'engine' },
    { id = 'doors',  label = 'DOORS',  icon = '🚪', action = 'doors' },
    { id = 'hood',   label = 'HOOD',   icon = '⬆', action = 'hood' },
    { id = 'trunk',  label = 'TRUNK',  icon = '🧰', action = 'trunk' },
    { id = 'back',   label = 'BACK',   icon = '↩', action = 'back' }
}

Config.PlayerItems = {
    { id = 'id',     label = 'MY ID',  icon = '🪪', action = 'id' },
    { id = 'job',    label = 'MY JOB', icon = '💼', action = 'job' },
    { id = 'back',   label = 'BACK',   icon = '↩', action = 'back' }
}

Config.SettingsItems = {
    { id = 'hud',    label = 'HUD',    icon = '🖥', action = 'hud' },
    { id = 'cursor', label = 'CURSOR', icon = '🖱', action = 'cursor' },
    { id = 'back',   label = 'BACK',   icon = '↩', action = 'back' }
}

-- Optional integrations. Set command/event to match your server.
Config.PhoneCommand = ''          -- e.g. 'phone'
Config.HudCommand = ''            -- e.g. 'hud'
Config.CursorCommand = ''         -- optional command
Config.InventoryCommand = ''       -- e.g. 'inventory' if your inventory uses a command

Config.Notifications = true
