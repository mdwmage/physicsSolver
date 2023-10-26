# Evaluates to a SUVAT Value based on input

import strutils#, std/terminal

# basic yes/no question answer machine
proc y_n(question: string): bool =
  var choice: string
  while true:
    stdout.write(question & " (y/n) -> ")
    choice = readLine(stdin)
    case choice
    of "y", "Y", "yes", "YES":
      return true
    of "n", "N", "no", "NO":
      return false
    else: echo "Please specify y/n (yes/no)"


# Solves SUVAT equations based on values and known variables
proc solve(equationVariables: seq[char], values: seq[int]): int =
  var
    solvers = [['S', 'U', 'V', 'T'], ['V', 'U', 'A', 'T'], ['S', 'U', 'T', 'A'], ['V', 'U', 'A', 'S']]
  echo "Searching for proper equation"

  # Find base equation to solve
  for i in solvers.low .. solvers.high:
    for x in solvers[i].low .. solvers[i].high:

      if solvers[i].contains(equationVariables[x]):

        if x == 3:
          echo "Equation found. Solving"
          echo solvers[i]

      else:
        break

when isMainModule:
  stdout.writeLine("SUVAT equation solver.\nInput what values are known\n")

  # Initialise base variables
  var 
    knownValues = newseq[bool](5)
    letters = @['S', 'U', 'V', 'A', 'T']
    letter: char
    x: int = 0
    final: char
    suvat: seq[int]

  # Find known values
  for i in knownValues.low .. knownValues.high:
    letter = letters[x]
    knownValues[i] = y_n("Is " & $letter & " known")

    if knownValues[i] == false:
      letters.delete(letters.find(letter))
      dec(x)
    inc(x)

  # Check that there are enough values known
  if len(letters) > 4:
    echo "You already know all the values. No solving is needed"
  elif len(letters) < 3:
      echo "You don't have enough values to solve yet!"
  else:
    # Find values
    echo "Valid size found. Please input your Values\n"
    for i in 0..len(letters) - 1:
        stdout.write("Value for " & $letters[i] & " -> ")
        suvat.add(parseInt(readLine(stdin)))

    # Find value to evaluate to
    while true:
        stdout.write("What value are your solving for -> ")
        final = readLine(stdin)[0]

        if letters.contains(final) == false:

          case final
          of 's', 'u', 'v', 'a', 't':
            echo "Type an Uppercase value please"
          of 'S', 'U', 'V', 'A', 'T':
            break
          else: echo "Not a SUVAT value"
        else: echo "Existing value known. Please specify an unknown value."

    # Information
    stdout.writeLine("Values known: ")
    for i in letters.low .. letters.high:
      stdout.writeLine($letters[i] & ", Value: " & $suvat[i])
  stdout.writeLine("Evaluating for " & $final)

  # Solve
  letters.insert(final, 0)
  echo $final & " has evaluated to " & $solve(letters, suvat)
