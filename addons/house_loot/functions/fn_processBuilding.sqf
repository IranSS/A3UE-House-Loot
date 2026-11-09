#include "..\script_component.hpp"

params ["_building"];
if (!isServer || {isNull _building}) exitWith {};

// Mark before doing any work so overlapping calls cannot spawn twice.
_building setVariable [QGVAR(processedAt), serverTime];
_building setVariable [QGVAR(buildingLoot), []];

// buildingPos -1 returns PositionAGL, accepted by createVehicle on land.
private _positions = _building buildingPos -1;
_positions = _positions select {
    (_x isEqualType []) && {count _x >= 3} &&
    {(_x distance2D (getPosATL _building)) > 1.5} &&
    {!surfaceIsWater _x}
};
if (_positions isEqualTo []) exitWith {};

[format ["Processing building %1 (%2 positions)", typeOf _building, count _positions]] call FUNC(debugLog);

if (random 1 >= (missionNamespace getVariable [QGVAR(spawnChance), 0.20])) exitWith {};

private _maxLoot = floor ((missionNamespace getVariable [QGVAR(maxLootPerBuilding), 3]) max 0);
if (_maxLoot isEqualTo 0) exitWith {};

_positions = _positions call BIS_fnc_arrayShuffle;
private _count = 1 + floor random _maxLoot;
_count = _count min count _positions;
for "_i" from 0 to (_count - 1) do {
    private _selection = [] call FUNC(selectLoot);
    if (_selection isNotEqualTo []) then {
        private _position = _positions select _i;
        private _spawned = [_selection, _position] call FUNC(spawnLoot);
        if (_spawned isNotEqualTo []) then {
            private _buildingLoot = _building getVariable [QGVAR(buildingLoot), []];
            _buildingLoot append _spawned;
            _building setVariable [QGVAR(buildingLoot), _buildingLoot];
        };
    };
};
