# encoding: utf-8
require_relative '../spec_helper'

# class String
#   def to_ast
#     self
#   end
# end

describe SokclothParser do
  
  it "parses double line breaks as paragraphs" do
    SokclothParser.parse("A").to_ast.should == [:sokcloth, [:paragraph, [:plain_text, "A"]]]
    SokclothParser.parse("One two three\nfour five six").to_ast.should == [:sokcloth, [:paragraph, [:plain_text, "One two three\nfour five six"]]]
    SokclothParser.parse("One two three\n\nfour five six").to_ast.should == [:sokcloth,[:paragraph,[:plain_text, "One two three"]],[:paragraph,[:plain_text, "four five six"]]]
    SokclothParser.parse("Test material\r\n\r\nSome more material.\r\n\r\nMore?").to_ast.should == [:sokcloth,[:paragraph,[:plain_text, "Test material"]],[:paragraph,[:plain_text, "Some more material."]],[:paragraph,[:plain_text, "More?"]]]
  end
  
  it "parses h1, h2, h3, h4 as headings" do
    SokclothParser.parse("h1 This is a level one heading").to_ast.should == [:sokcloth,[:heading,'1','This is a level one heading']]
    SokclothParser.parse("H2. This is a level two heading").to_ast.should == [:sokcloth,[:heading,'2','This is a level two heading']]
        SokclothParser.parse("h1 This is a level one heading\nH2. This is a level two heading").to_ast.should == [:sokcloth,[:heading,'1','This is a level one heading'],[:heading,'2','This is a level two heading']]
  end
  
  it "parses bullet points" do
    SokclothParser.parse("* One\n*Two\n*\t Three").to_ast.should == [:sokcloth,[:bullet_list,[:list_line,[:plain_text, "One"]],[:list_line,[:plain_text, "Two"]],[:list_line,[:plain_text, "Three"]]]]
    SokclothParser.parse("* One\n**1A\n**1B\n* Two").to_ast.should == 
      [:sokcloth,
        [:bullet_list,
          [:list_line,[:plain_text, "One"],
            [:bullet_list,
              [:list_line,[:plain_text, "1A"]],
              [:list_line,[:plain_text, "1B"]]
            ]
          ],
          [:list_line,[:plain_text,"Two"]]
        ]
      ]
      SokclothParser.parse("* A http://B").to_ast.should == [:sokcloth, [:bullet_list, [:list_line, [:plain_text, "A "], [:url, "http://B"]]]]
      SokclothParser.parse("* Black and white diagrams by a nuclear expert -http://people.reed.edu/~emcmanis/radiation.html\n* Coloured diagrams by xkcd - http://xkcd.com/radiation/").to_ast.should == [:sokcloth, [:bullet_list, [:list_line, [:plain_text, "Black and white diagrams by a nuclear expert -"], [:url, "http://people.reed.edu/~emcmanis/radiation.html"]], [:list_line, [:plain_text, "Coloured diagrams by xkcd - "], [:url, "http://xkcd.com/radiation/"]]]]
  end

  it "parses number lists" do
    SokclothParser.parse("# One\n#Two\n#\t Three").to_ast.should == [:sokcloth,[:number_list,[:list_line,[:plain_text, "One"]],[:list_line,[:plain_text, "Two"]],[:list_line,[:plain_text, "Three"]]]]
    
  end
  
  it "parses bullets immediately following paragraphs" do
     SokclothParser.parse("These are some bullets:\n* One\n*Two\n*\t Three").to_ast.should == [:sokcloth,
       [:paragraph,[:plain_text, "These are some bullets:"]],[:bullet_list,[:list_line,[:plain_text, "One"]],[:list_line,[:plain_text, "Two"]],[:list_line,[:plain_text, "Three"]]]]
  end
  
  it "parses empty lines" do
    SokclothParser.parse("Paragraph 1\n\n\n \nParagraph 2").to_ast.should == [:sokcloth, [:paragraph, [:plain_text, "Paragraph 1"]], [:paragraph, [:plain_text, "Paragraph 2"]]]
  end

  it "parses emphasis" do
    SokclothParser.parse("This should be *emphasised text*").to_ast.should == [:sokcloth,[:paragraph,[:plain_text, "This should be "],[:emphasis,[:plain_text, "emphasised text"]]]]
    SokclothParser.parse("This should not be *emphasised text").to_ast.should == [:sokcloth, [:paragraph, [:plain_text, "This should not be *emphasised text"]]]
  end
  
  it "parses urls" do
    SokclothParser.parse("www.slashdot.org/page1.txt").to_ast.should == [:sokcloth,[:paragraph,[:url,"www.slashdot.org/page1.txt"]]]
    SokclothParser.parse("http://slashdot.org/page1.txt").to_ast.should == [:sokcloth,[:paragraph,[:url,"http://slashdot.org/page1.txt"]]]
    SokclothParser.parse("https://slashdot.org/page1.txt").to_ast.should == [:sokcloth,[:paragraph,[:url,"https://slashdot.org/page1.txt"]]]
    SokclothParser.parse("https://slashdot.org/").to_ast.should == [:sokcloth,[:paragraph,[:url,"https://slashdot.org/"]]]
    SokclothParser.parse("https://slashdot.org").to_ast.should == [:sokcloth,[:paragraph,[:url,"https://slashdot.org"]]]
    SokclothParser.parse("Or take a look at https://slashdot.org.").to_ast.should == [:sokcloth, [:paragraph, [:plain_text, "Or take a look at "], [:url, "https://slashdot.org"], [:plain_text, "."]]]

  end
  
  it "parses email addresses" do
    SokclothParser.parse("tom.counsell@decc.gsi.gov.uk").to_ast.should == [:sokcloth,[:paragraph,[:email,"tom.counsell@decc.gsi.gov.uk"]]]
    SokclothParser.parse("Try emailing tom.counsell@decc.gsi.gov.uk for more information").to_ast.should == [:sokcloth,[:paragraph,[:plain_text,"Try emailing "],[:email,"tom.counsell@decc.gsi.gov.uk"],[:plain_text," for more information"]]]
    SokclothParser.parse("Try emailing 'tom.counsell@decc.gsi.gov.uk' for more information").to_ast.should == [:sokcloth,[:paragraph,[:plain_text,"Try emailing '"],[:email,"tom.counsell@decc.gsi.gov.uk"],[:plain_text,"' for more information"]]]
    
  end
  
  it "parses page includes" do
    SokclothParser.parse("Insert a picture of something").to_ast.should == [:sokcloth,[:insert,"a picture of something"]]
    SokclothParser.parse("We should insert  a picture of something ").to_ast.should == [:sokcloth,[:paragraph,[:plain_text, "We should insert  a picture of something "]]]
  end
  
  it "parses page summary inserts" do
    SokclothParser.parse("Insert summary from a picture of something").to_ast.should == [:sokcloth,[:summarise,"a picture of something"]]
    SokclothParser.parse("Insert summary of a picture of something").to_ast.should == [:sokcloth,[:summarise,"a picture of something"]]
    SokclothParser.parse("Insert subcategories of a picture of something").to_ast.should == [:sokcloth,[:summarise,"a picture of something"]]
    SokclothParser.parse("Insert thumbnail of a picture of something").to_ast.should == [:sokcloth,[:summarise,"a picture of something"]]
  end
  
  it "parses matrix links" do
    SokclothParser.parse("D09/1236512").to_ast.should == [:sokcloth, [:paragraph, [:matrix, "D09/1236512"]]]
    SokclothParser.parse("D2009/1236512").to_ast.should == [:sokcloth, [:paragraph, [:matrix, "D2009/1236512"]]]
    SokclothParser.parse("See D10/301040 for more information").to_ast.should == [:sokcloth,[:paragraph,[:plain_text,"See "],[:matrix,"D10/301040"],[:plain_text," for more information"]]]
    SokclothParser.parse("A matrix link D2009/1236512, punctuated").to_ast.should == [:sokcloth, [:paragraph, [:plain_text, "A matrix link "], [:matrix, "D2009/1236512"], [:plain_text, ", punctuated"]]]
  end
  
  it "parses citations" do
    SokclothParser.parse("This is a claim[this is the source of that claim] and this is the rest.").to_ast.should == [:sokcloth,[:paragraph,[:plain_text,"This is a claim"],[:citation,[:plain_text,"this is the source of that claim"]],[:plain_text," and this is the rest."]]]
  end
  
  it "parses tables" do
    SokclothParser.parse("| td1 |td2 | \n| td3|td4|").to_ast.should == [ :sokcloth, 
      [:table,
        [:table_row,
          [:table_cell,[:plain_text,"td1"]],
          [:table_cell,[:plain_text,"td2"]],
        ],
        [:table_row,
          [:table_cell,[:plain_text,"td3"]],
          [:table_cell,[:plain_text,"td4"]],
        ]
      ]
    ]
    SokclothParser.parse("| td1 *bold* thinking |").to_ast.should == [:sokcloth,[:table,[:table_row,[:table_cell,[:plain_text,"td1 "],[:emphasis,[:plain_text,"bold"]],[:plain_text," thinking"]]]]]
    SokclothParser.parse("This is not | a table").to_ast.should == [:sokcloth, [:paragraph, [:plain_text, "This is not | a table"]]]
    
  end
  
  it "parses categories" do
    SokclothParser.parse("Category: One").to_ast.should == [:sokcloth,[:category,"One"]]
    SokclothParser.parse("category: One thing; Two thing").to_ast.should == [:sokcloth,[:category,"One thing","Two thing"]]
    SokclothParser.parse("Category: One thing\n Two thing").to_ast.should == [:sokcloth,[:category,"One thing","Two thing"]]
    SokclothParser.parse("Category:\n One thing\n Two thing").to_ast.should == [:sokcloth,[:category,"One thing","Two thing"]]
    SokclothParser.parse("Categories:\n One thing\n Two thing").to_ast.should == [:sokcloth,[:category,"One thing","Two thing"]]
    SokclothParser.parse("Category: One thing\nCategory:Two thing").to_ast.should == [:sokcloth,[:category,"One thing","Two thing"]]
  end
end