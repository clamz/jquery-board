$ ->
  $.widget "clamz.board",
    options:
      items: "items"
      templateString: '<ul class="board-wrapper">{{#each columns }}<li class="board-column">{{name}}<ul>{{#each rows }}<li class="board-row">{{name}}</li>{{/each}}</ul></li>{{/each}}</ul>'
      json: columns: [
          name: "test"
          rows: [
            name: "row1-1"
          ,
            name: "row1-2"
          ]
        ,
          name: "test2"
          rows: [
            name: "row2-1"
          ,
            name: "row2-2"
          ,
            name: "row2-3"
          ]
        ]
    _create: ->
      element         = @element
      templateString  = @options.templateString
      json            = @options.json     
      
      template = Handlebars.compile templateString
      element.html template json

  $("#board-container").board()