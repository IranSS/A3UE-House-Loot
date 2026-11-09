#include "..\script_component.hpp"

if (!isServer) exitWith {};

private _lastCleanup = 0;
while {true} do {
    [] call FUNC(scanBuildings);

    private _cleanupInterval = missionNamespace getVariable [QGVAR(cleanupInterval), 60];
    if (diag_tickTime - _lastCleanup >= _cleanupInterval) then {
        [] call FUNC(cleanupLoot);
        _lastCleanup = diag_tickTime;
    };

    sleep (missionNamespace getVariable [QGVAR(scanInterval), 10]);
};
