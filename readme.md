# SANITARIUM TRANSLATION

This is a helper to create translations files for Sanitarium game. You can find the game here:

* [Steam](https://store.steampowered.com/agecheck/app/284050/)
* [GOG](https://www.gog.com/game/sanitarium)

## HOW DOES IT WORKS

The game Sanitarium reads the strings from a file called RES.000, a file with all the strings encoded in a custom format.

This projects helps people to create this RES.000 file with the translated strings from a plain text file. The user only have to worry to make the translation.

## HOW TO USE

Translate the `strings.txt` (English) texts to the desired language. Please, translate every line one by one, don't add or remove any line. The game will look for lines as they are in the original `strings.txt` file.

Download the helper for [windows](https://github.com/josuigoa/sanitarium-translation/releases/download/1.0.0/sanitarium_translation.exe) or [linux](https://github.com/josuigoa/sanitarium-translation/releases/download/1.0.0/sanitarium_translation).

When you have the translations in the file `strings.txt`:

* Execute the downloaded helper
* It will get the strings in the `strings.txt` file and will create a RES.000 file with them.
* Replace the RES.000 file that is in the game directory to see the new strings in the game.
