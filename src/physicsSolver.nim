# Evaluates to a SUVAT Value based on input

import strutils, std/math#, std/terminal

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

# Finds base SUVAT equations based on values and known variables
proc findEquation(equationVariables: seq[char], values: seq[float]): float =
  var
    solvers = [['S', 'U', 'V', 'T'], ['V', 'U', 'A', 'T'], ['S', 'U', 'T', 'A'], ['V', 'U', 'A', 'S']]
  echo "Searching for proper equation"

  # Find base equation to solve
  for i in solvers.low .. solvers.high:
    for x in solvers[i].low .. solvers[i].high:
      if solvers[i].contains(equationVariables[x]):
        if x == 3:
          echo "Equation found. Solving"

          # I am not proud of this code. There are so many switch cases here. Why. I feel like there is a better solution.
          case i
          of 0:
            echo "reordering equation 1"
            case equationVariables[0]
            of 'S':
              echo "Equation: S = ((u + v)/2)*t"
              return ((values[0] + values[1])/2)*values[2]
            of 'U':
              echo "Equation: U = (s/t)*2 + v"
              return (values[0]/values[2])*2 + values[1]
            of 'V':
              echo "Equation: V = (s/t)*2 + u"
              return (values[0]/values[2])*2 + values[1]
            of 'T':
              echo "Equation: T = s/((u + v)/2)"
              return (values[0]/((values[1] + values[2])/2))
            else:
              echo "Invalid Final!"
              quit(1)
          of 1:
            echo "reordering equation 2"
            case equationVariables[0]
            of 'V':
              echo "Equation: V = u + at"
              return (values[0] + (values[1] * values[2]))
            of 'U':
              echo "Equation: U = v + at"
              return (values[0] + (values[1] * values[2]))
            of 'A':
              echo "Equation: A = (v - u)/t"
              return (values[1] - values[0])/values[2]
            of 'T':
              echo "Equation: T = (v - u)/a"
              return (values[1] - values[0])/values[2]
            else:
              echo "Invalid Final!"
              quit(1)
          of 2:
            echo "reordering equation 3"
            case equationVariables[0]
            of 'S':
              echo "Equation: S = u*t + (a/2)*(t^2)"
            else:
              echo "Invalid Final!"
              quit(1)
          of 3:
            echo "reordering equation 4"
            case equationVariables[0]
            of 'V':
              echo "Equation: V^2 = u^2 + 2*a*s"
              return sqrt(pow(values[1], 2) + (2*values[2])*values[0])
            of 'U':
              echo "Equation: -U^2 = 2*a*s - v^2"
              return sqrt(-1*((2*values[2])*values[0]-pow(values[1], 2)))
            of 'S':
              echo "Equation: "
            else:
              echo "Invalid Final!"
              quit(1)
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
    suvat: seq[float]

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
        suvat.add(parseFloat(readLine(stdin)))

    # Find value to evaluate to
    while true:
        stdout.write("What value are your solving for -> ")
        final = readLine(stdin)[0]

        if not letters.contains(final):
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
  echo $final & " has evaluated to " & $findEquation(letters, suvat)
