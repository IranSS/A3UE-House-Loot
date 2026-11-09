#include "..\script_component.hpp"

if (!isServer) exitWith {};
private _players = allPlayers select {alive _x && {isPlayer _x}};

private _distance = missionNamespace getVariable [QGVAR(cleanupDistance), 500];
private _loot = missionNamespace getVariable [QGVAR(trackedLoot), []];
_loot = _loot select {!isNull _x && {_x getVariable [QGVAR(spawnedLoot), false]}};
{
    private _holder = _x;
    private _nearPlayer = (_players findIf {(_x distance2D _holder) <= _distance}) >= 0;
    if (!_nearPlayer) then {
        private _position = getPosATL _holder;
        deleteVehicle _holder;
        [format ["Cleanup removed loot at %1", _position]] call FUNC(debugLog);
    };
} forEach _loot;
missionNamespace setVariable [QGVAR(trackedLoot), _loot select {!isNull _x}];
