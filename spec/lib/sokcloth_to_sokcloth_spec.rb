# encoding: utf-8
require_relative '../spec_helper'

describe SokclothToSokcloth do
    
  it "generates paragraphs" do
original =<<END
h1. This is a heading
Followed immidiately by a paragraph, that
splits over a second line and runs into a table.
|messy|     mucked| table|  
 | oh| no| 
 * One
 ** One A
* Two

Good external pages[sourced from http://nowhere.special]:
* Black and white diagrams by a nuclear expert -http://people.reed.edu/~emcmanis/radiation.html
* Coloured diagrams by xkcd - http://xkcd.com/radiation/
insert an interesting page
insert summary of an interesting page
Categories: One; Two
Three
END
reformatted =<<END
h1 This is a heading

Followed immidiately by a paragraph, that splits over a second line and runs into a table.

| messy | mucked | table |
| oh    | no     |       |

* One
** One A
* Two

Good external pages[sourced from http://nowhere.special]:

* Black and white diagrams by a nuclear expert -http://people.reed.edu/~emcmanis/radiation.html
* Coloured diagrams by xkcd - http://xkcd.com/radiation/

Insert an interesting page

Insert summary of an interesting page

Categories:
One
Two
Three

END
    SokclothToSokcloth.convert(original).should == reformatted
  end
end