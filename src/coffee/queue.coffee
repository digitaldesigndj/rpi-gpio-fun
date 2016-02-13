queue = require 'queue'
q = queue()
q.concurrency = 1

q.push ( done ) ->
  console.warn 'did a thing'
  done()
  return

q.on 'success', ( result, job ) ->
  console.log 'job finished processing:', job.toString().replace(/\n/g, '')

# begin processing, get notified on end / failure

q.start ( err ) ->
  console.log 'all done:', results
