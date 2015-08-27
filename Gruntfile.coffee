module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks 'grunt-contrib-less'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    watch:
      coffee:
        files: 'coffee/*.coffee'
        tasks: ['coffee:coffeeToJs']
      less:
        files: 'styles/*.less'
        tasks: ['less:lessToCss']

    coffee:
      coffeeToJs:
        options:
          bare: true
          sourceMap: true
        expand: true
        flatten: false
        cwd: "coffee"
        src: ["*.coffee"]
        dest: 'dist/js'
        ext: ".js"

    less:
      lessToCss:
        src: 'styles/*.less',
        dest: 'dist/css/main.css'

  grunt.registerTask 'default', ['coffee', 'less', 'watch']