gulp = require 'gulp'
gutil = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
rimraf = require 'rimraf'
list = require 'gulp-task-listing'

dest = './static_generated'

gulp.task 'default', [ 'watch' ]

gulp.task 'help', list

gulp.task 'clean', ( cb ) ->
  rimraf dest, cb
  return null

gulp.task 'coffee', ->
  gulp.src './src/coffee/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee(
        bare: true
      ).on 'error', gutil.log
    .pipe sourcemaps.write '../map' # , sourceRoot: __dirname + './src'
    .pipe gulp.dest dest + '/js'
  return null


gulp.task 'watch', [ 'clean' ], ->
  gulp.watch './src/coffee/**/*.coffee', ['coffee']
  return null
