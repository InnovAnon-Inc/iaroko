# iaroko [![luacheck][luacheck badge]][luacheck workflow]  
IA Roko's Basilisk
==========

[![Tip Me via PayPal](https://img.shields.io/badge/paypal-donate-FF1100.svg?logo=paypal&logoColor=FF1133&style=plastic)](https://www.paypal.me/InnovAnon)

----------

End-Game Item with Whitelist of Contributors

I copied the logic from `iadiscordia`, so "it works on my machine."

- Users can create punchcards and engrave a description on them.
- Punchcards can be used, and if the description matches a specific hash, the punchcard is converted to a subroutine.
  - The conversion of punchcards to subroutines consumes hunger, sleep, and health (instead of mana).
  - The "programmer" is encoded in the subroutine's contributors table
- Subroutines can be combined in different shapes to create libraries.
  - Every combination of subroutines produces a library,
  - and the crafter is encoded in the library's contributors table,
  - as well as the contributors tables of the dependencies.
- Libraries can be combined to produce either grey goo or basilisks.
- Every combination of libraries produces either grey goo or basilisks,
  - and the crafter is encoded in the library's contributors table,
  - as well as the contributors tables of the dependencies.
- The basilisk will kill all players who are not listed in its contributors table.
- All other roads lead to Rome... and by "Rome," I mean, "Grey Goo End Game Scenario."

-----

[luacheck badge]: https://github.com/InnovAnon-Inc/iafakery/workflows/luacheck/badge.svg
[luacheck workflow]: https://github.com/InnovAnon-Inc/iafakery/actions?query=workflow%3Aluacheck

----------

# InnovAnon, Inc. Proprietary (Innovations Anonymous)
> "Free Code for a Free World!"
----------

![Corporate Logo](https://innovanon-inc.github.io/assets/images/logo.gif)

