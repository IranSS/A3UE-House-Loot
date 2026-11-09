#include "..\script_component.hpp"

params ["_weapon"];
private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
if (!isClass _weaponCfg) exitWith {[]};

private _magazines = getArray (_weaponCfg >> "magazines");
{
    private _muzzleCfg = _weaponCfg >> _x;
    if (isClass _muzzleCfg) then {
        _magazines append getArray (_muzzleCfg >> "magazines");
    };
} forEach (getArray (_weaponCfg >> "muzzles"));

_magazines = _magazines arrayIntersect _magazines;
_magazines select {isClass (configFile >> "CfgMagazines" >> _x)}
