#include "..\script_component.hpp"

params ["_selection", "_position"];
if (!isServer || {_selection isEqualTo []} || {count _position < 3}) exitWith {[]};

_selection params ["_kind", "_class"];
if (_class isEqualTo "Binocular") then {_kind = "weapon"};
private _created = [];
private _spawnOne = {
    params ["_cargoKind", "_cargoClass", "_cargoPosition"];
    private _holder = createVehicle ["GroundWeaponHolder", _cargoPosition, [], 0, "CAN_COLLIDE"];
    if (isNull _holder) exitWith {objNull};
    _holder setVariable [QGVAR(spawnedLoot), true, true];
    _holder setVariable [QGVAR(createdAt), serverTime, true];
    switch (_cargoKind) do {
        case "weapon": {_holder addWeaponCargoGlobal [_cargoClass, 1]};
        case "magazine": {_holder addMagazineCargoGlobal [_cargoClass, 1]};
        default {_holder addItemCargoGlobal [_cargoClass, 1]};
    };
    private _trackedLoot = missionNamespace getVariable [QGVAR(trackedLoot), []];
    _trackedLoot pushBack _holder;
    missionNamespace setVariable [QGVAR(trackedLoot), _trackedLoot];
    _holder
};

private _holder = [_kind, _class, _position] call _spawnOne;
if (!isNull _holder) then {_created pushBack _holder};

if (_kind isEqualTo "weapon") then {
    private _compatible = [_class] call FUNC(getWeaponMagazines);
    private _magCount = floor random 3;
    if (_compatible isNotEqualTo [] && {_magCount > 0}) then {
        for "_i" from 1 to _magCount do {
            private _magPosition = [(_position select 0) + (random 0.35 - 0.175), (_position select 1) + (random 0.35 - 0.175), _position select 2];
            private _magHolder = ["magazine", selectRandom _compatible, _magPosition] call _spawnOne;
            if (!isNull _magHolder) then {_created pushBack _magHolder};
        };
    };
};

if (_created isNotEqualTo []) then {
    [format ["Spawned loot %1 at %2", _class, _position]] call FUNC(debugLog);
};
_created
