module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compile: {
        files: {
          'board.jquery.js': 'board.jquery.coffee', // 1:1 compile
        }
      }
    },
    compass: {
      dist: {                   // Target
        options: {              // Target options
            sassDir: 'sass',
            cssDir: '.',
            environment: 'production',
            require: ['sassy-buttons']

        }
      },
      dev: {                    // Another target
        options: {
          sassDir: 'sass',
          cssDir: '.',
          require: ['sassy-buttons']
        }
      }
    },
    watch: {
      scripts: {
        files: ['**/*.coffee'],
        tasks: ['coffee']
      },
      css : {
        files: ['**/*.sass','**/*.scss'],
        tasks: ['compass']
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-compass');

  // Default task(s).
  grunt.registerTask('default', ['watch']);

};