# Changelog - Poprawki

## AttackSystem.lua
- ✅ Dodana flaga `isAttacking` aby zapobiec spamowaniu ataków
- ✅ Lepsze sprawdzanie null-pointerów (`if not character then return end`)
- ✅ Wyczyszczanie cache animacji dla usuniętych charakterów
- ✅ Reset animacji przed odtworzeniem (`track:Stop()` + `task.wait(0.05)`)
- ✅ Lepszy system cooldownu - ustawienie `lastAttack` przed wysłaniem eventa

## DamageNumbers.lua
- ✅ Owinięcie logiki w funkcję `createDamageNumber()` - łatwiejsze do testowania
- ✅ Połączenie tweenów z `Completed` eventami zamiast `Debris:AddItem()`
- ✅ Lepsze null-checki (`if position and amount then`)
- ✅ Automatyczne czyszczenie części po animacji
- ✅ Lepszy easing - `EasingDirection.In` dla fade out

## CombatConfig.lua
- ✅ Bez zmian - config był ok!
