#include "..\script_component.hpp"

// Build these config-derived pools once per server mission, including loaded mods.
private _pools = missionNamespace getVariable [QGVAR(lootPools), []];
if (_pools isEqualTo []) then {
    private _medical = [];
    private _magazines = [];
    private _equipment = [];
    private _weapons = [];

    // Medical classes are identified by inheriting from the vanilla medical item roots.
    private _medicalRoots = ["FirstAidKit", "Medikit"];
    {
        private _weaponCfg = _x;
        private _className = configName _weaponCfg;
        if (getNumber (_weaponCfg >> "scope") >= 2) then {
            private _parent = _weaponCfg;
            private _isMedical = false;
            while {isClass _parent && {!_isMedical}} do {
                _isMedical = (configName _parent) in _medicalRoots;
                _parent = inheritsFrom _parent;
            };

            if (_isMedical) then {
                _medical pushBack _className;
            };

            private _itemInfoType = getNumber (_weaponCfg >> "ItemInfo" >> "type");
            if (_itemInfoType in [605, 616, 701, 801]) then {
                _equipment pushBack _className;
            };

            private _weaponType = getNumber (_weaponCfg >> "type");
            if (_weaponType in [1, 2, 4]) then {
                _weapons pushBack _className;
            };
        };
    } forEach ("true" configClasses (configFile >> "CfgWeapons"));

    {
        private _magazineCfg = _x;
        private _ammoClass = getText (_magazineCfg >> "ammo");
        if (
            getNumber (_magazineCfg >> "scope") >= 2 &&
            {getNumber (_magazineCfg >> "count") > 0} &&
            {isClass (configFile >> "CfgAmmo" >> _ammoClass)}
        ) then {
            _magazines pushBack (configName _magazineCfg);
        };
    } forEach ("true" configClasses (configFile >> "CfgMagazines"));

    _pools = [_medical, _magazines, _equipment, _weapons];
    missionNamespace setVariable [QGVAR(lootPools), _pools];
};

// Choose the category first using weights: medical 10, ammo 35, equipment 20, weapons 35.
private _roll = random 100;
private _kind = ["medical", "magazine", "equipment", "weapon"] select (
    [_roll < 10, _roll < 45, _roll < 65, true] find true
);

private _poolIndex = switch (_kind) do {
    case "medical": {0};
    case "magazine": {1};
    case "equipment": {2};
    default {3};
};
private _pool = _pools select _poolIndex;

if (_pool isEqualTo []) exitWith {[]};
[_kind, selectRandom _pool]
