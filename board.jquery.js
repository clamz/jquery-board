(function() {
  $(function() {
    $.widget("clamz.board", {
      options: {
        templateColumnsId: 'columns-template',
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
              columns: [
                {
                  name: "row2-1",
                  rows: [
                    {
                      name: "test"
                    }, {
                      name: "test2"
                    }
                  ]
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
        return this._compileTemplate();
      },
      _compileTemplate: function() {
        var element, json, result, template, templateColumnsId;
        element = this.element;
        templateColumnsId = this.options.templateColumnsId;
        json = this.options.json;
        template = Handlebars.compile($("#" + templateColumnsId).html());
        this._registerPartials();
        result = template(json);
        element.html(result);
        return this._trigger("templateCompiled", element, json, result);
      },
      _registerPartials: function() {
        Handlebars.compile($("#rows-template").html());
        Handlebars.registerPartial("rows", $("#rows-template").html());
        return Handlebars.registerPartial("columns", $("#columns-template").html());
      }
    });
    return $("#board-container").board();
  });

}).call(this);
