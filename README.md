
# Projet Game Jam

Projet de Game Jam pour GCC, ça sera un platformer, mais c'est tout ce qu'on sait pour l'instant

# Équipe
 - Nemo D'ACREMONT (I1)
 - Thomas Horrut (I1)


# Convention (copie du fichier convention.md)

## Fichiers
- nom: snake\_case

## Variables
- Constantes: ALL\_CAPS
- Variables: snake\_case
- classe: UpperCamelCase
- node godot: Pascal\_Snake\_Case

Lorsque créé une variable, toujours indiquer le type:

### Quelques exemples:
const TIMER\_DURATION: float = 0.3
@onready var mon\_timer: Timer = $Mon\_Timer
@onready animation\_node: AnimatedSprite2D = $My\_Animated\_Sprit\_2D
var is\_moving: bool = false

## Manipulation de données
- Accès à un attribut: obj.attribut  (pas de getter)
- Modification d'un attribut: obj.attribut = jsp  (pas de setter)

### Accès à une node (plus rapide d'après la doc)
@onready var node = $Nom\_De\_La\_Node
...
jsp(node)


