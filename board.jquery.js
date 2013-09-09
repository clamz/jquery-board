(function() {
  $(function() {
    $.widget("clamz.board", {
      options: {
        items: "items",
        templateString: '<ul class="board-wrapper">{{#each columns }}<li class="board-column"><div class="column-title">{{name}}</div><ul>{{#each rows }}<li class="board-row">{{name}}</li>{{/each}}</ul></li>{{/each}}</ul>',
        json: {
          columns: [
            {
              name: "test",
              rows: [
                {
                  name: "row1-1"
                }, {
                  name: "row1-2"
                }
              ]
            }, {
              name: "test2",
              rows: [
                {
                  name: "row2-1"
                }, {
                  name: "row2-2"
                }, {
                  name: "row2-3"
                }
              ]
            }
          ]
        }
      },
      _create: function() {
        var element, json, template, templateString;
        element = this.element;
        templateString = this.options.templateString;
        json = this.options.json;
        template = Handlebars.compile(templateString);
        return element.html(template(json));
      }
    });
    return $("#board-container").board();
  });

}).call(this);
