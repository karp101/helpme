extends Node

var ammoAquired = [true, false, false, false, true, false, false];

var ammo = {
		"Poison": {
		"Type": "Status",
		"Base Damage": 15,
		"DOT Duration": 1,
		"Damage Tick": 4,
		"Tick Rate": 0.1,
		"Color": "843a89"
		
	},  "Red Poison": {
		"Type": "Status",
		"Base Damage": 15,
		"DOT Duration": 2,
		"Damage Tick": 6,
		"Tick Rate": 0.1,
		"Color": "832830"
		
	}, "Black Poison": {
		"Type": "Status",
		"Base Damage": 55,
		"DOT Duration": 0,
		"Damage Tick": 0,
		"Tick Rate": 0,
		"Color": "090b0e"
	},
		"AntiPoison": {
		"Type": "Status",
		"DOT Duration": 3.0,
		"Tick Rate": 0.3,
		"Heal Tick": 20,
		"Color":"548845"
	},
		"Heal": {
		"Type": "Heal",
		"Base Heal": 90,
		"Color":"548845"
	}, 
	"Antidote": {
		"Type": "Effect",
		"Duration": 5.0
		
	}, "Amplifier": {
		"Type": "Effect",
		"Duration": 5.0 # STILL NEEDS TO BE IMPLEMENTED
	}
}
