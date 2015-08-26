module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      coffee_to_js:
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
      development:
        options:
          compress: true
          yuicompress: true
          optimization: 2
        files:
          "dist/css/main.css": "styles/main.less"

  # Load Tasks
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.registerTask 'compile', ['coffee', 'less']