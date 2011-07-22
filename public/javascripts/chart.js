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
    
    this.colors = input.colors || ["#4572A7","#AA4643","#89A54E","#80699B","#3D96AE","#DB843D","#92A8CD","#A47D7C","#B5CA92"];
    this.colorIds = input.colorIds || [];

    this.paper = Raphael(this.location, this.width, this.height);
    
    var space = function(number) {
      return number / 10;
      // if( number <= 1) { 
      //   return 0.1;
      // } else if (number<= 10) {
      //   return 1.0;
      // } else if (number<= 20) {
      //     return 2.0;
      // } else if (number <= 50 ) {
      //   return 5.0;       
      // } else if (number <= 100 ) {
      //   return 10.0;
      // } else if (number <= 200 ) {
      //   return 20.0;
      // } else if (number <= 500 ) {
      //   return 50.0;
      // } else if (number <= 1000 ) {
      //   return 100.0;
      // } else if (number <= 2000 ) {
      //   return 200.0;
      // } else if (number <= 5000 ) {
      //   return 500.0;
      // } else {
      //   return number / 10;
      // }
    };
    
    var rounded_max = function(number) {
      var exp = Math.pow(10,Math.floor(Math.log(number) / Math.log(10)));
      return Math.ceil(number / exp) * exp;
    }
    
    var x_max = rounded_max(Math.max.apply(Math, this.xData.flatten()));
    var x_space = space(x_max);
    var y_max = rounded_max(Math.max.apply(Math, this.yData.flatten()));
    var y_space = space(y_max);
    
    this.minimumDataValueX = input.minX || 0;
    this.minimumDataValueY = input.minY || 0;
    this.maximumDataValueY = input.maxY || y_max;
    this.maximumDataValueX = input.maxX || x_max;
    this.xGridSpace = input.xGridSpace || x_space;
    this.yGridSpace = input.yGridSpace || y_space;

    var screenX = d3.scale.linear().domain([this.minimumDataValueX, this.maximumDataValueX]).range([50,this.width-20]);
    var screenY = d3.scale.linear().domain([this.minimumDataValueY, this.maximumDataValueY]).range([this.height-20,50]);

    this.buildGrid = function() {
        var xLabelHeight = 40;
        var yLabelWidth = 50;

        var x = yLabelWidth;
        var y = 20;
        var width = this.width - yLabelWidth - 20;
        var height = this.height - xLabelHeight - y;
        var numberOfHorizontalGridLines = ((this.maximumDataValueX-this.minimumDataValueX) / this.xGridSpace);
        var numberOfVerticalGridLines = ((this.maximumDataValueY-this.minimumDataValueY) / this.yGridSpace);

        this.paper.drawGrid(x, y, width, height, numberOfHorizontalGridLines, numberOfVerticalGridLines, "#ccc");

        var drawXLabels = function() {
            for (var index = 0, length = numberOfHorizontalGridLines; index <= length; index++) {
                var labelTextX = (index * this.xGridSpace)+this.minimumDataValueX;
                var labelPositionX = yLabelWidth + (index * width / numberOfHorizontalGridLines);
                var labelCentreX = this.height - (xLabelHeight * 0.75);

                this.paper.text(labelPositionX, labelCentreX, labelTextX).attr({
                    "font": '10px "Arial"',
                    stroke: "none",
                    fill: "#000"
                });
            }
        }.call(this);

        var drawXTitle = function() {
            this.paper.text(yLabelWidth + (width / 2), this.height - (xLabelHeight / 4), this.xTitle).attr({
                "font": '10px "Arial"',
                stroke: "none",
                fill: "#000"
            });
        }.call(this);

        var drawYLabels = function() {
            for (var index = 0, length = numberOfVerticalGridLines; index <= length; index++) {
                var labelTextY = (index * this.yGridSpace)+this.minimumDataValueY;
                var labelPositionY = height - (index * height / numberOfVerticalGridLines) + 20;

                // Use Rapha&#195;&#171;l to draw the label text onto the canvas
                this.paper.text(yLabelWidth*0.9, labelPositionY, labelTextY).attr({
                    "font": '10px "Arial"',
                    stroke: "none",
                    fill: "#000",
                    'text-anchor': "end"
                });
            }
        }.call(this);

        var drawYTitle = function() {
            var YTitle = this.paper.text(yLabelWidth * 0.25, (height / 2) + 20, this.yTitle).attr({
                "font": '10px "Arial"',
                stroke: "none",
                fill: "#000"
            });
            YTitle.rotate( - 90);
        }.call(this);

        return {
            x: x,
            y: y,
            width: width,
            height: height
        };
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
//      return this.grid.x + ( (x - this.minimumDataValueX) * this.grid.width / (this.maximumDataValueX - this.minimumDataValueX));
        return screenX(x);
    };
    
    this.chartY = function(y) {
//      return this.grid.y + this.grid.height - ( (y - this.minimumDataValueY) * this.grid.height / (this.maximumDataValueY - this.minimumDataValueY));
        return screenY(y);
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
        
    this.setupShape = function(s,id) {
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
    };
    
    this.drawPoints = function() {
        for (var index = 0, length = this.xData.length; index < length; index++) {
          var s = this.shape(this.xData[index],this.yData[index],this.labels[index],this.colors[this.colorIds[index] % this.colors.length]);
          this.setupShape(s,this.ids[index]);
          points_as_array.push(s);
        }
    };
    
    this.grid = this.buildGrid();
    this.drawPoints();
};

function plotData(locationId, ids, labels, xValues, yValues, colorIds, xTitle, yTitle, minX, maxX, xGridSpace) {
    var location = document.getElementById(locationId);
    var divHeight = location.clientHeight;
    var divWidth = location.clientWidth;
    var myPlot = new ScatterPlot({
        labels: labels,
        ids: ids,
        xTitle: xTitle,
        xData: xValues,
        yData: yValues,
        colorIds: colorIds,
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
