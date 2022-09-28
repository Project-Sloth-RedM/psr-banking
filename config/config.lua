Config = {}
Config.Debug = false -- Enable to debug PolyZones

Config.BankLocations = {
    [1] = {name = 'Bank of Rhodes',           model = "S_M_M_BankClerk_01",		bankType = "BANKS",     	coords = vector3(1292.81, -1304.62, 77.04),    		heading = 325.62,		showblip = true},
    [2] = {name = 'Lemoyne National Bank',    model = "S_M_M_BankClerk_01",		bankType = "BANKS2",    	coords = vector3(2644.9, -1293.99, 52.25),   		heading = 18.57,		showblip = true},
    [3] = {name = 'Valentine Savings Bank',   model = "S_M_M_BankClerk_01",		bankType = "BANKS3",    	coords = vector3(-308.06, 773.64, 118.7), 			heading = 2.56,			showblip = true},
    [4] = {name = 'First National Bank',      model = "S_M_M_BankClerk_01",		bankType = "BANKS4",    	coords = vector3(-811.96, -1275.43, 43.64),   		heading = 186.83,		showblip = true},
}

Config.cardTypes = { "bankbook"}

Config.Blip = {
    blipName = Lang:t('info.bank_blip'),
    blipType = -2128054417,
    blipScale = 0.55
}

Config.BankDoors = { --Doors that will always be open unless robbery has started
	-- Valentine Savings Bank
	2642457609, -- main door
	3886827663, -- main door
	1340831050, -- bared right
	2343746133, -- bared left
	334467483, -- inner door1
	3718620420, -- inner door2
	576950805, -- vault door

	-- Bank of Rhodes
	3317756151, -- main door
	3088209306, -- main door
	2058564250, -- inner door1
	3142122679, -- inner door2
	1634148892, -- inner door3
	3483244267, -- vault

	-- Lemoyne National Bank Saint Denis
	2158285782, -- main door
	1733501235, -- main door
	2089945615, -- main door
	2817024187, -- main door
	1830999060, -- inner private door
	965922748, -- manager door
	1634115439, -- manager door
	1751238140, -- vault

	-- West Elizabeth Co-Operative Bank Blackwater
	531022111, -- main door
	2117902999, -- inner door
	2817192481, -- manager door
	1462330364, -- vault door

	-- Bank of Armadillo
	3101287960, -- main door
	3550475905, -- inner door
	1329318347, -- inner door
	1366165179, -- back door
}