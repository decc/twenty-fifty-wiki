# encoding: utf-8
# require_relative '../spec_helper'
require 'active_support/core_ext/class/attribute_accessors'
require File.expand_path("../../../lib/diff3", __FILE__)

describe Diff3 do
  
  it "should merge where there is no conflict" do
ancestor =<<END
This is the text as it was.

It had this sort of thing. And some other stuff.

But not much else
END

  other_persons_change =<<END
This is the text as it was.

It had this sort of thing. And some other stuff.

But not much else. Except for this.
END

  my_change =<<END
This is the text as it was.

It had this sort of *thing*. And some other stuff.

But not much else
END

  result =<<END
This is the text as it was.

It had this sort of *thing*. And some other stuff.

But not much else. Except for this.
END

    d = Diff3.new(my_change,ancestor,other_persons_change)
    d.merged_text.should == result
    d.conflict?.should == false
  end

it "should flag conflicts where they exist" do
ancestor =<<END
This is the text as it was.

It had this sort of thing. And some other stuff.

But not much else
END

other_persons_change =<<END
This is the text as it was.

It had this sort of *thing*. And some other stuff.

But not much else. Except for this.
END

my_change =<<END
This is the text as it was.

It had this sort of *thing*. And some other stuff.

But not much else, including this
END

result =<<END
This is the text as it was.

It had this sort of *thing*. And some other stuff.

<<<<<<< YOUR CHANGE
But not much else, including this
=======
But not much else. Except for this.
>>>>>>> THE OTHER PERSON'S CHANGE
END

d = Diff3.new(my_change,ancestor,other_persons_change)
d.merged_text.should == result
d.conflict?.should == true
end  
end