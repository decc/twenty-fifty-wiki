myPoints = {};
points_as_array = [];

Point = function(shape,text) {
  this.shape = shape;
  this.text = text;
  
  this.setDefaultAttributesToCurrentAttributes = function() {
    this.original_shape_attributes = shape.attr();
    this.original_text_attributes = text.attr();
    return this;  
  };
  
  this.resetAttributes = function() {
    this.shape.attr(this.original_shape_attributes);
    this.text.attr(this.original_text_attributes);
    return this;
  };
  
  this.highlight = function() {
    this.resetAttributes();
    this.shape.attr({fill:"#FF0", stroke: "#000"});
    this.text.attr({fill:"#000",'font-weight':'bold'});
    return this;
  };
  
  this.highlight_this_and_fade_others = function() {
    points_as_array.invoke("fade");
    this.highlight();
  };
  
  this.fade = function() {
    this.resetAttributes();
    this.shape.attr({opacity:'0.2'});
    this.text.attr({opacity:'0.2'});    
    return this;
  };
  
  // Setup
  this.setDefaultAttributesToCurrentAttributes();
  
};

ScatterPlot = function(input) {
    this.labels = input.labels || [];
    this.ids = input.ids || [];
    
    this.xTitle = input.xTitle || "";
    this.yTitle = input.yTitle || "";

    this.xData = input.xData || [];
    this.yData = input.yData || [];

    this.width = input.width || "";
    this.height = input.height || "";
    this.location = input.location;
    
    this.colors = input.colors || d3.scale.category20();

    this.paper = Raphael(this.location, this.width, this.height);
    
    max_ignoring_unknowns = function(array) {
      if(array.length == 0) {
        return 1;
      }
      var max = array[0], n = 0;
      for(i=0,l=array.length;i<l;i++) {
        n = parseFloat(array[i]);
        if( (n != NaN) && (n > max) ) {
          max = n
        }
      }
      if(max == "?") {
        return 1;
      }
      return max;
    }
    
    this.minimumDataValueX = input.minX || 0;
    this.minimumDataValueY = input.minY || 0;
    this.maximumDataValueY = input.maxY || max_ignoring_unknowns(this.yData.flatten());
    this.maximumDataValueX = input.maxX || max_ignoring_unknowns(this.xData.flatten());

    if(this.maximumDataValueX == 0) {
      this.maximumDataValueX = 10;
    }

    if(this.maximumDataValueY == 0) {
      this.maximumDataValueY = 10;
    }
    
    var screenX = d3.scale.linear().domain([this.minimumDataValueX, this.maximumDataValueX]).range([50,this.width-60]).nice();
    var screenY = d3.scale.linear().domain([this.minimumDataValueY, this.maximumDataValueY]).range([this.height-45,45]).nice();
    var x_not_known = screenX.range()[1]+20;
    var y_not_known = screenY.range()[1]-20;
    
    this.buildGrid = function() {
        // x-axis
        ticks = screenX.ticks(10);
        y = screenY.range()[0] + 10;
        for(var i=0,l=ticks.length;i<l;i++) {
          x = screenX(ticks[i]);
          this.paper.line(x,screenY.range()[0],x,screenY.range()[1]).attr({stroke:"#ccc",'stroke-dasharray':'.'});
          this.paper.text(x,y,ticks[i]).attr({font: '10px "Arial"',stroke: "none", fill: "#000"});
        }
        this.paper.text((screenX.range()[0] + screenX.range()[1])/2, y + 10, this.xTitle).attr({font: '10px "Arial"', stroke: "none", fill: "#000"});

        // not known on x-axis
        this.paper.line(x_not_known,screenY.range()[0],x_not_known,screenY.range()[1]).attr({stroke:"#ccc",'stroke-dasharray':'.'});
        this.paper.text(x_not_known,y,"?").attr({font: '10px "Arial"',stroke: "none", fill: "#000"});
        
        // y-axis
        ticks = screenY.ticks(10);
        x = screenX.range()[0] - 5;
        for(var i=0,l=ticks.length;i<l;i++) {
          y = screenY(ticks[i]);
          this.paper.line(screenX.range()[0],y,screenX.range()[1],y).attr({stroke:"#ccc",'stroke-dasharray':'.'});
          this.paper.text(x,y,ticks[i]).attr({font: '10px "Arial"',stroke: "none", fill: "#000",'text-anchor':'end'});
        }
        var ytitle = this.paper.text(x-35,(screenY.range()[0] + screenY.range()[1])/2,this.yTitle).attr({font: '10px "Arial"', stroke: "none", fill: "#000"});
        ytitle.rotate(-90);

        // not known on y-axis
        this.paper.line(screenX.range()[0],y_not_known,screenX.range()[1],y_not_known).attr({stroke:"#ccc",'stroke-dasharray':'.'});
        this.paper.text(x,y_not_known,"?").attr({font: '10px "Arial"',stroke: "none", fill: "#000"});
        
    };
    
    this.shape = function(x,y,label,color) {
      if(x.length == 1 && y.length == 1) {
        return this.pointShape(x,y,label,color);
      } else if(x.length == 1 && y.length == 2) {
        return this.rangeShape([x[0],x[0]],y,label,color);
      } else if(x.length == 2 && y.length == 1) {
        return this.rangeShape(x,[y[0],y[0]],label,color);        
      } else {
        return this.rangeShape(x,y,label,color);
      }
    };
    
    this.chartX = function(x){
        if(x == "?") {
          return x_not_known;
        } else {
          return screenX(x);
        }
    };
    
    this.chartY = function(y) {
      if(y == "?") {
        return y_not_known;
      } else {
        return screenY(y);
      }
    };
    
    this.pointShape = function(_x,_y,label,color) {
      var x = this.chartX(_x);
      var y = this.chartY(_y);
      var shape = this.paper.circle(x, y, 5).attr({
          'fill': color,
          'cursor': "pointer",
          opacity: "1.0",
          stroke: "#fff"          
      });
      var text = this.paper.text(x, y - 15, label).attr({
          "font": '10px "Arial"',
          stroke: "none",
          opacity: "1.0",
          fill: color
      });
      return new Point(shape, text);
    };
    
    this.rangeShape = function(_x,_y,label,color) {
      var x1 = this.chartX(_x[0]);
      var x2 = this.chartX(_x[1]);
      if(x1 == x2 ) {
        x1 = x1 - 2;
        x2 = x2 + 2;
      };
      var y1 = this.chartY(_y[0]);
      var y2 = this.chartY(_y[1]);
      if(y1 == y2 ) {
        y1 = y1 + 2;
        y2 = y2 - 2;
      };
      var shape = this.paper.rect(x1, y2, x2 - x1, y1 - y2).attr({
          'fill': color,
          'cursor': "pointer",          
          opacity: "1.0",
          'stroke': "#fff"
      });
      var text = this.paper.text((x1+x2)/2, y2 - 6, label).attr({
          "font": '10px "Arial"',
          opacity: "1.0",
          stroke: "none",
          fill: color
      });
      return new Point(shape, text);
    };
        
    this.setupShape = function(s,id,color) {
      s.technology_id = "cost_"+id;
      s.url = "/costs/"+id;
      myPoints[s.technology_id] = s;
      s.shape.mouseover(function(event) {
        s.highlight_this_and_fade_others();
        $(s.technology_id).addClassName("highlight");
      });
      s.shape.mouseout(function(event) {
        points_as_array.invoke("resetAttributes");     
        $(s.technology_id).removeClassName("highlight");
      });
      s.shape.click(function(event) {
        window.location = s.url;
        // $$("#"+this.technology_id+" td.label a")[0].simulate('click');
      });
      table_row = $(s.technology_id);
      if(table_row != null) {
        table_row.down('td.color').setStyle({'background-color':color});
      }
    };
    
    this.drawPoints = function() {
        for (var index = 0, length = this.xData.length; index < length; index++) {
          var s = this.shape(this.xData[index],this.yData[index],this.labels[index],this.colors(index));
          this.setupShape(s,this.ids[index],this.colors(index));
          points_as_array.push(s);
        }
    };
    
    this.grid = this.buildGrid();
    this.drawPoints();
};

function plotData(locationId, ids, labels, xValues, yValues, xTitle, yTitle, minX, maxX, xGridSpace) {
    var location = document.getElementById(locationId);
    var divHeight = location.clientHeight;
    var divWidth = location.clientWidth;
    var myPlot = new ScatterPlot({
        labels: labels,
        ids: ids,
        xTitle: xTitle,
        xData: xValues,
        yData: yValues,
        yTitle: yTitle,
        height: divHeight,
        width: divWidth,
        location: location,
        minX: minX,
        maxX: maxX,
        xGridSpace: xGridSpace
    });
};

var tableHighlight = function(event) {
   this.addClassName("highlight");
   myPoints[this.id].highlight_this_and_fade_others();
};

var tableRemoveHighlight = function(event) {
  this.removeClassName("highlight");
  points_as_array.invoke("resetAttributes");    
};
