# Game goal: dream of what you wish.

*Dreams are often out of control and many random events happen there, preventing anyone to imagine what he would like to imagine. The player is immersed in the unconscious of a character who wants his dream to follow a scenario he has already defined (e.g. he wishes to save a princess in his dream, then the player will have to do so).*

The dream of the character has the form of a platformer and the player will have to achieve the main objective inside. However, the following issues occur:

- the player doesn't know what is the main objective
- the map (and even the player himself) has a too chaotic behaviour to directly advance
- the dream can stop when many random events are triggered
- in the next dream (respawn), the map is different.

Fortunately, the player will be able to find structure in the middle of this chaos:
- first and foremost, a famous synthetic voice will guide him
- he is able to get permanent skills to get better controls and attenuate the tantrum of the map
- some patterns will be remarkable in the behaviour of the obstacles
- finally, many hints in the maps will enable the player to learn more about the personality of the character, which will help him to investigate about the main objective to accomplish.

# Dev notes: simulating a scalable chaos in the level

Here is a list of solutions to do so:

- initialising the platforms' positions at ~random values
- moving plaforms ~randomly
- setting the camera zoom and position with ~random values.
- sometimes moving the player without the request of any keyboard input.
- sometimes changing the speed of the player
- if a level is defined as a pack of maps (generated in a slightly random way) in which the player can travel through *doors*, then the position and the visibilty of doors can be random.
- of course, having fun with the behaviour of the NPCs!

Additional notes:
> A cooperative game is still possible.

> This markdown file has the goal to start a more substantial game documentation.