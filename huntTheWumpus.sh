#!/bin/bash

#####declare variables
player=0
wumpus=0
bats=0
hole=0
flavor=0
collision="none"

##### FUNCTIONS #####

#Random funcitons start by using the current date in
#seconds as the random number. To avoid each element
#having the same value, they each use a different
#pair of digits in the 8-digit decimal value
#representing the current second of today's date.
#since the values can be 0-99, they are divided by
#4 to get 0-24.
#Values must be 0-24 because bash doesn't support
#multidimensional arrays, which would otherwise
#have represented the game board. Instead, this
#value can be divided (/) by 5 to get the Y position
#and modulus-ed (%) by 5 to get the X position.
getRandomPlayer () {
    playerDateSeconds=$(date +"%2N")
    firstTwo=$((playerDateSeconds%100))
    player=$((firstTwo/4))
}
getRandomWumpus () {
    wumpusDateSeconds=$(date +"%4N")
    secondTwo=$((wumpusDateSeconds%100))
    wumpus=$((secondTwo/4))
}
getRandomBats () {
    batsDateSeconds=$(date +"%6N")
    thirdTwo=$((batsDateSeconds%100))
    bats=$((thirdTwo/4))
}
getRandomHole () {
    holeDateSeconds=$(date +"%8N")
    fourthTwo=$((holeDateSeconds%100))
    hole=$((fourthTwo/4))
}
getRandomFlavor () {
    flavorDateSeconds=$(date +"%1N")
    flavor=$((flavorDateSeconds%100))
}



#### aesthetic commands
printTitlecard() {
    echo "#------------------------------------#"
    echo "|                          _____     |"
    echo "|     |   |  |   |  |\  |    |       |"
    echo "|     |___|  |   |  | \ |    |       |"
    echo "|     |   |  |   |  |  \|    |       |"
    echo "|     |   |  |___|  |   |    |       |"
    echo "|        _____          ___          |"
    echo "|          |    |   |  |             |"
    echo "|          |    |___|  |___          |"
    echo "|          |    |   |  |             |"
    echo "|          |    |   |  |___          |"
    echo "|                    __         ___  |"
    echo "| |   | |   | |\ /| |  \ |   | /   \ |"
    echo "| |   | |   | | | | |__/ |   | \___  |"
    echo "| | | | |   | | | | |    |   |     \ |"
    echo "| |/ \| |___| |   | |    |___| \___/ |"
    echo "|                                    |"
    echo "#------------------------------------#"
}
printGameBoard(){
    echo "___________________________________________________"
    echo "|         |         |         |         |         |"
    echo "|   0,4   |   1,4   |   2,4   |   3,4   |   4,4   |"
    echo "|_________|_________|_________|_________|_________|"
    echo "|         |         |         |         |         |"
    echo "|   0,3   |   1,3   |   2,3   |   3,3   |   4,3   |"
    echo "|_________|_________|_________|_________|_________|"
    echo "|         |         |         |         |         |"
    echo "|   0,2   |   1,2   |   2,2   |   3,2   |   4,2   |"
    echo "|_________|_________|_________|_________|_________|"
    echo "|         |         |         |         |         |"
    echo "|   0,1   |   1,1   |   2,1   |   3,1   |   4,1   |"
    echo "|_________|_________|_________|_________|_________|"
    echo "|         |         |         |         |         |"
    echo "|   0,0   |   1,0   |   2,0   |   3,0   |   4,0   |"
    echo "|_________|_________|_________|_________|_________|"
    echo ""
} 
printTitleOptions(){
    echo "Please select an option:"
    echo "  1) Play Game"
    echo "  2) Instructions"
    echo "  3) Quit Game"
    echo ""
}
printControls() {
    printGameBoard
    echo "The object of this game is to search a 5x5 grid for a wumpus."
    echo "If you run into the wumpus, it will eat you. Shoot it before"
    echo "it has the chance."
    echo ""
    echo "When you are near a wumpus, you will smell it."
    echo ""
    echo "You can move or shoot by selecting the corresponding option"
    echo "from the ingame menu, then using the "
    echo "           W   "
    echo "         A S D "
    echo "keys to select the direciton."
    echo "Note that you still must hit Enter to confirm the action."
    echo ""
    echo "There is also a hole you may fall down, as well as a swarm"
    echo "of bats that will carry you to a random space."
    echo "You will feel a breeze or hear flapping when they are near."
    echo ""
    echo "Press Enter to continue."
    read delay
}
printPlayerActions () {
    echo "What would you like to do?"
    echo "  1) Move"
    echo "  2) Shoot an Arrow"
    echo "  3) Quit to Game"
    echo ""
}
printErrorMessage () {
    echo "      Invalid input."
    echo "      Please enter a number 1-3."
    echo ""
}
printMovementError () {
    echo "You've hit a wall. You can't move any"
    echo "further in that direction."
    getPosition "You" "$player"
    echo ""
}
printMovementOptions () {
    echo "You may use the following keys to move:"
    echo "         W    "
    echo "       A S D  "
    echo "Enter in lowercase."
    echo ""
}
printShootOptions () {
    echo "You may use the following keys to shoot:"
    echo "         W    "
    echo "       A S D  "
    echo "Enter in lowercase."
    echo ""
}
flavorTextEat () {
    getRandomFlavor
    case $flavor in
        0) echo "He wore your intestines as a hat.";;
        1) echo "There was blood everywhere.";;
        2) echo "It was brutal.";;
        3) echo "You tasted okay.";;
        4) echo "You were pretty gamey.";;
        5) echo "He skipped rope with your intestines afterward.";;
        6) echo "Your shirt got stuck in his teeth.";;
        7) echo "You tasted better than you smelled.";;
        8) echo "You smelled better than you tasted.";;
        9) echo "git gud scrub";;
    esac
}
flavorTextFall () {
    getRandomFlavor
    case $flavor in
        0) echo "Maybe someone will come for you eventually.";;
        1) echo "There was blood everywhere.";;
        2) echo "It was brutal.";;
        3) echo "Say hi to Wile E Coyote.";;
        4) echo "You had plenty of time to think about your"
           echo "mistakes on the way down.";;
        5) echo "Splat.";;
        6) echo "Wheeeeeeeeeee!";;
        7) echo "First day with your new legs?";;
        8) echo "It turns out the hole was a Sarlacc pit."
           echo "You'll be digested for the next 5 years.";;
        9) echo "git gud scrub";;
    esac
}
printHitNotificaiton () {
    echo "You killed the wumpus."
    getPosition "Wumpus" "$wumpus"
    echo ""
    echo "You won!"
    echo ""
    echo "Press Enter to continue."
    read delay
}
printMissNotification () {
    echo "You missed."
    echo ""
    echo "Press Enter to continue."
    read delay
}



##### game logic
getPosition() { #pass name, value
    y=$(($2/5))
    x=$(($2%5))
    echo "$1 are at $x,$y."
}
checkSurroundings () {
    # check for hole
    holeXDist=$(( (player%5) - (hole%5) )) # get raw difference
    holeYDist=$(( (player/5) - (hole/5) ))
    if [ ${holeXDist#-} -le 1 ] && [ ${holeYDist#-} -le 1 ] # check if abs val of difference for both x and y is less than or equal to 1
    then
        echo "You feel a breeze."
    fi

    # check for bats
    batXDist=$(( (player%5) - (bats%5) ))
    batYDist=$(( (player/5) - (bats/5) ))
    if [ ${batXDist#-} -le 1 ] && [ ${batYDist#-} -le 1 ]
    then
        echo "You hear flapping."
    fi

    # check for wumpus
    wumpusXDist=$(( (player%5) - (wumpus%5) ))
    wumpusYDist=$(( (player/5) - (wumpus/5) ))
    if [ ${wumpusXDist#-} -le 1 ] && [ ${wumpusYDist#-} -le 1 ]
    then
        echo "You smell a wumpus."
    fi
}
movePlayer () {
    printMovementOptions
    read input

    case $input in
    'w' | 'W' )
        if [ $((player/5)) -ge 4 ]
        then
            validAction='False'
            printMovementError
        else
            player=$((player+5))
            validAction='True'
        fi
        ;;
    's' | 'S' )
        if [ $((player/5)) -le 0 ]
        then
            validAction='False'
            printMovementError
        else
            player=$((player-5))
            validAction='True'
        fi
        ;;
    'a' | 'A' )
        if [ $((player%5)) -le 0 ]
        then
            validAction='False'
            printMovementError
        else
            player=$((player-1))
            validAction='True'
        fi
        ;;
    'd' | 'D' )
        if [ $((player%5)) -ge 4 ]
        then
            validAction='False'
            printMovementError
        else
            player=$((player+1))
            validAction='True'
        fi
        ;;
    *)
        validAction='False'
        echo "Not a valid action"
        getPosition "You" "$player"
        ;;
    esac
}
shootArrow () {
    printShootOptions
    read input

    case $input in
    'w' | 'W' )
        if [ $((player/5)) -le $((wumpus/5)) ] # hit up
        then
            printHitNotificaiton
            gameWon="True"
        else
            printMissNotification
        fi
        validAction='True'
        ;;
    's' | 'S' )
        if [ $((player/5)) -ge $((wumpus/5)) ] # hit down
        then
            printHitNotificaiton
            gameWon="True"
        else
            printMissNotification
        fi
        validAction='True'
        ;;
    'a' | 'A' )
        if [ $((player%5)) -ge $((wumpus%5)) ] # hit left
        then
            printHitNotificaiton
            gameWon="True"
        else
            printMissNotification
        fi
        validAction='True'
        ;;
    'd' | 'D' )
        if [ $((player%5)) -le $((wumpus%5)) ] # hit right
        then
            printHitNotificaiton
            gameWon="True"
        else
            printMissNotification
        fi
        validAction='True'
        ;;
    *)
        validAction='False'
        echo "Not a valid action"
        getPosition "You" "$player"
        ;;
    esac
}


##### logic loops
gameLoop() {
    
    echo "New game started."
    echo ""

    #generate locations
    getRandomBats
    getRandomHole
    getRandomPlayer
    getRandomWumpus

    gameWon="False"
    while true
    do
        if [ $gameWon == "True" ]
        then
            break
        fi

        printGameBoard
        getPosition "You" "$player"

        case $player in
        $wumpus)
            echo "You were eaten by a wumpus."
            flavorTextEat
            echo ""
            echo "Press Enter to continue."
            read cont
            break
        ;;
        $bats)
            echo "You were carried away by bats."
            getRandomPlayer
            getRandomBats
            getPosition "You" "$player"
        ;;
        $hole)
            echo "You fell down a hole."
            flavorTextFall
            echo ""
            echo "Press Enter to continue."
            read cont
            break
        ;;
        esac

        checkSurroundings
        ingameMenuLoop
    done
}
mainMenuLoop() {
    while true
    do
        printTitlecard
        echo ""
        printTitleOptions
        read input
        echo ""

        case $input in
            "1") gameLoop ;;
            "2") printControls ;;
            "3") echo "Thanks for playing!"
                 break ;;
            *) printErrorMessage ;;
        esac
    done
}
ingameMenuLoop () {
    validAction='False'
    while [ $validAction == 'False' ]
    do
        printPlayerActions
        read input

        case $input in
            "1")
                movePlayer
            ;;
            "2")
                shootArrow
            ;;
            "3")
                echo "Game ended."
                echo ""
                echo "Thanks for playing!"
                exit 0
            ;;
            *)
                printErrorMessage
            ;;
        esac
    done
}



##### MAIN #####
mainMenuLoop

exit 0