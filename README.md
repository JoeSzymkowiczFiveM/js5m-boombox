![image](https://user-images.githubusercontent.com/70592880/210274011-c5c49f4c-d5a8-4522-8cbe-4e37543c8e49.png)
## Description
This is an updated version of a boombox script I previously released, that lets the player have a useable boombox item in their inventory and use it to play songs/sounds. This utilizes ox_lib and a better 3d sound resource.

## Usage
Add song mp3/ogg files to the chHyperSound resource, and add them to the js5m-boombox config. In its current state, the menu will only display the tapes/songs that you have available in your inventory, via GetPlayerData().items in the client. The person that put down the boombox is the only person that can interact with the boombox.

I have included a pdn template file I've used to create tape/song inventory images, using real covers, and an example of one of them.

## Items
You will need a useable item of a boombox to be added to your items.

**boombox**

## Make Your Own Tapes

See the config for information about the tape items.

## Dependencies
- qb-core
- [ox_lib](https://github.com/overextended/ox_lib)
- [chHyperSound](https://github.com/JoeSzymkowiczFiveM/chHyperSound) - Using my own fork of HyperSound as the original has been archived. Huge credit to charleshacks for creating this. It's a far-superior version of 3d sound than my original attempt.

## Preview
[Youtube](https://youtu.be/NQtuZApIDA8)

## Discord
[Joe Szymkowicz FiveM Development](https://discord.gg/5vPGxyCB4z)
