# encoding: utf-8
require_relative '../spec_helper'

describe PreProcessContent do
  
  it "converts bullet symbols into * " do
    CopyPasteRewrite.rewrite("\u2022   Bullet one").should == "* Bullet one"
    CopyPasteRewrite.rewrite(" \u2022   Bullet one").should == "* Bullet one"
    CopyPasteRewrite.rewrite("This is not \u2022   Bullet one").should == "This is not \u2022   Bullet one"
    CopyPasteRewrite.rewrite("\t\u2022   Bullet one").should == "** Bullet one"
    CopyPasteRewrite.rewrite("\t\u2022 Bullet one").should == "** Bullet one"
  end
  
  it "converts tab markers into tables" do
    CopyPasteRewrite.rewrite("c1\tc2").should == "| c1 | c2 |"
    CopyPasteRewrite.rewrite("c1\tc2\nc3\tc4\n").should == "| c1 | c2 |\n| c3 | c4 |\n"
    CopyPasteRewrite.rewrite("A	B	C").should == "| A | B | C |"
    CopyPasteRewrite.rewrite("A	B	C
    1	2	3").should == "| A | B | C |\n| 1 | 2 | 3 |"
  end
end

