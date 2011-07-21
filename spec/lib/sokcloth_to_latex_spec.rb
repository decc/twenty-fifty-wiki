# encoding: utf-8
require_relative '../spec_helper'

describe SokclothToLatex do
    
  it "generates latex from simple documents" do
original =<<END
This is some introductory text

h1. This is a heading & what a heading it is

Followed by a paragraph, that includes a *bold statement* of intent.

Here are some things that should be escaped: 10%; $3.50 $12.20

|messy|     mucked| table|  
| oh| no| 

* One
** One A
* Two

h2 A sub heading

# One
# Two
# Three

Good external pages[sourced from http://nowhere.special]:

insert some good stuff

Categories:
A
B
C
END
reformatted =<<END
This is some introductory text

\\tableofcontents*

\\section{This is a heading \\& what a heading it is}

Followed by a paragraph, that includes a \\emph{bold statement} of intent.

Here are some things that should be escaped: 10\\%; \\$3.50 \\$12.20

\\begin{tabular*}{\\textwidth}{l l l}
messy & mucked & table\\\\
oh & no\\\\
\\end{tabular*}

\\begin{itemize}
\\item One
\\begin{itemize}
\\item One A
\\end{itemize}
\\item Two
\\end{itemize}

\\subsection{A sub heading}

\\begin{enumerate}
\\item One
\\item Two
\\item Three
\\end{enumerate}

Good external pages\\footnote{sourced from \\url{http://nowhere.special}}:

[some good stuff to be inserted here]

END
    SokclothToLatex.convert(original).should == reformatted
  end
end