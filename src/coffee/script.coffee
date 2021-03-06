gpio = require 'rpi-gpio'
async = require 'async'

delay = 10

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

encode = ( character ) ->
  byte = '00000000'
  switch character
    when '0' then byte = '01111110'
    when '1' then byte = '01001000'
    when '2' then byte = '00111101'
    when '3' then byte = '01101101'
    when '4' then byte = '01001011'
    when '5' then byte = '01100111'
    when '6' then byte = '01110011'
    when '7' then byte = '01001100'
    when '8' then byte = '01111111'
    when '9' then byte = '01001111'
    when 'a' then byte = '01011111'
    when 'b' then byte = '01110011'
    when 'c' then byte = '00110110'
    when 'd' then byte = '01111001'
    when 'e' then byte = '00110111'
    when 'f' then byte = '00010111'
  return byte

count = [1...9]

stringToArr = ( binString ) ->
  arr = binString.split ''
  return arr.map ( v ) ->
    if v is '1'
      return true
    return false

string = '112233445566778899001234567890135792468009876543211234567890'
  # return v.toString().split('').map ( v ) ->

# binaries = string.split('').map ( v ) ->
#   return encode v.toString()

binaries = [ zero, full ]

# console.log goodies

write = ->
  # cases = [ letter0, letter1, letter2, letter3, letter4, letter5, letter6, letter7, letter8, letter9, lettera, letterb, letterc, letterd, lettere, letterf ]
  # states = cases.map ( v ) ->

  states = binaries.map ( v ) ->
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
        process.nextTick gpio.write 12, false, ->
            console.log 'Byte Pushed'
            process.nextTick done()
            return
      return
    return
  return

pushBit = ( option, done ) ->
  gpio.write 7, option, ->
    process.nextTick gpio.write 11, true, ->
      process.nextTick async.parallel [
            ( done ) ->
              gpio.write 7, false, ->
                process.nextTick done()
                return
            ( done ) ->
              gpio.write 11, false, ->
                process.nextTick done()
                return
          ], (err, results) ->
            # console.log 'Set 1 Bit in Register: ' + option
            process.nextTick done()
            return
      return
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
