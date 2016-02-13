gpio = require 'rpi-gpio'
async = require 'async'

delay = 35

num0 = '1110011111100111'
num1 = '0010000100100001'
num2 = '1100101111001011'
num3 = '0110101101101011'
num4 = '0010110100101101'
num5 = '0110111001101110'
num6 = '1110111011101110'
num7 = '0010001100100011'
num8 = '1110111111101111'
num9 = '0010111100101111'
numa = '1010111110101111'
numb = '1110110011101100'
numc = '1100011011000110'
numd = '1110100111101001'
nume = '1100111011001110'
numf = '1000111010001110'


zero = '0000000000000000'
full = '1111111111111111'

case1 = '1000000000000000'
case2 = '0100000000000000'
case3 = '0010000000000000'
case4 = '0001000000000000'
case5 = '0000100000000000'
case6 = '0000010000000000'
case7 = '0000001000000000'
case8 = '0000000100000000'
case9 = '0000000010000000'
case10 = '0000000001000000'
case11 = '0000000000100000'
case12 = '0000000000010000'
case13 = '0000000000001000'
case14 = '0000000000000100'
case15 = '0000000000000010'
case16 = '0000000000000001'



double0 = '1000000010000000'
double1 = '0100000001000000'
double2 = '0010000000100000'
double3 = '0001000000010000'
double4 = '0000100000001000'
double5 = '0000010000000100'
double6 = '0000001000000010'
double7 = '0000000100000001'

letter0 = '01111110'
letter1 = '01001000'
letter2 = '00111101'
letter3 = '01101101'
letter4 = '01001011'
letter5 = '01100111'
letter6 = '01110011'
letter7 = '01001100'
letter8 = '01111111'
letter9 = '01001111'
lettera = '01011111'
letterb = '01110011'
letterc = '00110110'
letterd = '01111001'
lettere = '00110111'
letterf = '00010111'


stringToArr = ( binString ) ->
  arr = binString.split ''
  return arr.map ( v ) ->
    if v is '1'
      return true
    return false

write = ->
  cases = [ letter0, letter1, letter2, letter3, letter4, letter5, letter6, letter7, letter8, letter9, lettera, letterb, letterc, letterd, lettere, letterf ]
  states = cases.map ( v ) ->
    return ( done ) ->
      pushByte stringToArr( v ), done
      return
  async.series states, ( err, results ) ->
    write()
    return
  return

pushByte = ( array, done ) ->
  byteStuff = array.map ( v, i ) ->
    return ( done ) ->
      pushBit v, done
      return
  async.series byteStuff, ( err, results ) ->
    # byte pushed into register
    gpio.write 12, true, ->
      # New Byte is shifted to output
      setTimeout ->
        gpio.write 12, false, ->
          console.log 'Byte Pushed'
          done()
          return
      , delay
      return
    return
  return
    

pushBit = ( option, done ) ->
  gpio.write 7, option, ->
    setTimeout ->
      gpio.write 11, true, ->
        setTimeout ->
          async.parallel [
            ( done ) ->
              gpio.write 7, false, ->
                setTimeout ->
                  done()
                , delay
                return
            ( done ) ->
              gpio.write 11, false, ->
                setTimeout ->
                  done()
                , delay
                return
          ], (err, results) ->
            # console.log 'Set 1 Bit in Register: ' + option
            done()
        , delay
    , delay
    return
  return

async.parallel [
  (callback) ->
    # DataIn
    gpio.setup 7, gpio.DIR_OUT, callback
    return
  (callback) ->
    # Clock
    gpio.setup 11, gpio.DIR_OUT, callback
    return
  (callback) ->
    # Latch
    gpio.setup 12, gpio.DIR_OUT, callback
    return
], (err, results) ->
  console.log 'Pins set up'
  write()
  return

