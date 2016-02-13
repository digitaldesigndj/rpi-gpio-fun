gpio = require 'rpi-gpio'
async = require 'async'

count = 0

ch13prev = false
ch15 = false

async.parallel [
  (callback) ->
    # Clock
    gpio.setup 7, gpio.DIR_IN, gpio.EDGE_RISING, callback
    return
  (callback) ->
    # Clock
    gpio.setup 11, gpio.DIR_IN, gpio.EDGE_RISING, callback
    return
  (callback) ->
    # Clock
    gpio.setup 12, gpio.DIR_IN, gpio.EDGE_RISING, callback
    return
  (callback) ->
    # Clock
    gpio.setup 13, gpio.DIR_IN, gpio.EDGE_RISING, callback
    return
  (callback) ->
    # Latch
    gpio.setup 15, gpio.DIR_IN, gpio.EDGE_RISING, callback
    return
  (callback) ->
    # Latch
    gpio.setup 16, gpio.DIR_IN, gpio.EDGE_RISING, callback
    return
], (err, results) ->
  console.log 'Pins set up'
  gpio.on 'change', ( channel, value ) ->
    if channel is 13
      if value is true
        if ch13prev is false
          gpio.read 15, ( err, ch15value ) ->
            if ch15value is false
              count--
            else
              count++
            console.log count.toString(16)
      ch13prev = value
    # if channel is 15
    #   ch15 = value
  	# console.log 'Channel ' + channel + ' value is now ' + value
    # RoA = channel 13
    # Rob = channel 15
  return


# 605 E Grant St.
# Phoenix, AZ 85004
