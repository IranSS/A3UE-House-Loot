#include "..\script_component.hpp"

params ["_message"];
if (missionNamespace getVariable [QGVAR(debug), false]) then {
    diag_log format ["[A3UE House Loot] %1", _message];
};
