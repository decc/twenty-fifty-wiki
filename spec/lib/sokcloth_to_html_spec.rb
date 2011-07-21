# encoding: utf-8
require_relative '../spec_helper'

describe SokclothToHtml do
    
  it "generates paragraphs" do
    SokclothToHtml.convert("A").should == "<p>A</p>"
    SokclothToHtml.convert("One two three\nfour five six").should == "<p>One two three\nfour five six</p>"
    SokclothToHtml.convert("One two three\n\nfour five six").should == "<p>One two three</p><p>four five six</p>"
  end

  it "generates headings, offset by the relevant amount" do
    SokclothToHtml.convert("h1 This is heading one").should == "<h2>This is heading one</h2>"
    SokclothToHtml.convert("H2. This is heading two").should == "<h3>This is heading two</h3>"
  end
  
  it "generates unordered lists" do
    SokclothToHtml.convert("* One\n*Two\n*\t Three").should == "<ul>\n<li>One</li>\n<li>Two</li>\n<li>Three</li>\n</ul>"
  end
  
  it "can deal with sub lists" do
    SokclothToHtml.convert("* One\n**One A\n*Two").should == "<ul>\n<li>One<ul>\n<li>One A</li>\n</ul></li>\n<li>Two</li>\n</ul>"
  end
  
  it "generates ordered lists" do
    SokclothToHtml.convert("# One\n#Two\n#\t Three").should == "<ol>\n<li>One</li>\n<li>Two</li>\n<li>Three</li>\n</ol>"
  end
  
  it "generates empathised text" do
    SokclothToHtml.convert("This should be *emphasised text*").should == "<p>This should be <em>emphasised text</em></p>"
    SokclothToHtml.convert("This should not be *emphasised text").should == "<p>This should not be *emphasised text</p>"
  end
  
  it "generates urls" do
    SokclothToHtml.convert("www.gnb.com").should == "<p><a href='http://www.gnb.com'>www.gnb.com</a></p>"
  end
  
  it "generates mailto links" do
    SokclothToHtml.convert("tom.counsell@decc.gsi.gov.uk").should == "<p><a href='mailto:tom.counsell@decc.gsi.gov.uk'>tom.counsell@decc.gsi.gov.uk</a></p>"
  end
  
  it "generates tables" do
    SokclothToHtml.convert("| td1 | td2 |\n| td3 | td4 |").should == "<table><tr><td>td1</td><td>td2</td></tr><tr><td>td3</td><td>td4</td></tr></table>"
  end
  
  it "generates matrix links" do
    SokclothToHtml.convert("D09/1236512").should == "<p><a href='http://sdcm2w01.dti.local:8265/GetDocument.aspx?number=D09/1236512' class='matrix'>D09/1236512</a></p>"
    SokclothToHtml.convert("D2009/1236512").should == "<p><a href='http://sdcm2w01.dti.local:8265/GetDocument.aspx?number=D2009/1236512' class='matrix'>D2009/1236512</a></p>"
    SokclothToHtml.convert("A matrix link D2009/1236512, punctuated").should == "<p>A matrix link <a href='http://sdcm2w01.dti.local:8265/GetDocument.aspx?number=D2009/1236512' class='matrix'>D2009/1236512</a>, punctuated</p>"
  end
  
  it "ignores category links, they are presented separately" do
    SokclothToHtml.convert("Category: One; Two; Three").should == ""
  end
end