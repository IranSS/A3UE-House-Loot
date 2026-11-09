#include "..\script_component.hpp"

if (!isServer) exitWith {};

private _players = allPlayers select {alive _x && {isPlayer _x}};
if (_players isEqualTo []) exitWith {};

private _radius = missionNamespace getVariable [QGVAR(scanRadius), 120];
private _buildings = [];
{
    _buildings append (nearestObjects [_x, ["House"], _radius, true]);
} forEach _players;

// Deduplicate buildings found around multiple players in the same scan.
{
    if (!isNull _x) then {
        private _processedAt = _x getVariable [QGVAR(processedAt), -1];
        if (_processedAt < 0) then {
            [_x] call FUNC(processBuilding);
        } else {
            private _respawnTime = missionNamespace getVariable [QGVAR(respawnTime), 3600];
            if (serverTime - _processedAt >= _respawnTime) then {
                private _oldLoot = _x getVariable [QGVAR(buildingLoot), []];
                _oldLoot = _oldLoot select {!isNull _x};
                _x setVariable [QGVAR(buildingLoot), _oldLoot];
                // Do not replace loot that is still present in a visited building.
                if (_oldLoot isEqualTo []) then {
                    _x setVariable [QGVAR(processedAt), -1];
                    [_x] call FUNC(processBuilding);
                };
            };
        };
    };
} forEach (_buildings arrayIntersect _buildings);
