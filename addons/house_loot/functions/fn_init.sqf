#include "..\script_component.hpp"

// Mission-level overrides may be defined before addon post-init.
missionNamespace setVariable [QGVAR(scanRadius), missionNamespace getVariable [QGVAR(scanRadius), 120]];
missionNamespace setVariable [QGVAR(scanInterval), missionNamespace getVariable [QGVAR(scanInterval), 10]];
missionNamespace setVariable [QGVAR(spawnChance), missionNamespace getVariable [QGVAR(spawnChance), 0.20]];
missionNamespace setVariable [QGVAR(maxLootPerBuilding), missionNamespace getVariable [QGVAR(maxLootPerBuilding), 3]];
missionNamespace setVariable [QGVAR(cleanupDistance), missionNamespace getVariable [QGVAR(cleanupDistance), 500]];
missionNamespace setVariable [QGVAR(respawnTime), missionNamespace getVariable [QGVAR(respawnTime), 3600]];
missionNamespace setVariable [QGVAR(cleanupInterval), missionNamespace getVariable [QGVAR(cleanupInterval), 60]];
missionNamespace setVariable [QGVAR(debug), missionNamespace getVariable [QGVAR(debug), false]];

if (!isServer) exitWith {};

missionNamespace setVariable [QGVAR(trackedLoot), []];
["Initialized (server authority)"] call FUNC(debugLog);
[] spawn FUNC(lootManager);
