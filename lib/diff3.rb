require 'tempfile'

class Diff3 
  
  # The diff3 command, including flags. Default 'diff3 -mE'
  cattr_accessor :diff3_command
  
  # The labels to assign to the different files if there is a conflict
  # Defaults are "YOUR CHANGE", "PREVIOUS CHANGE", "THE OTHER PERSON'S CHANGE"
  cattr_accessor :label_a, :label_b, :label_c
  
  # Set the defaults
  self.diff3_command ||= "diff3 -mE"
  self.label_a ||= "YOUR CHANGE"
  self.label_b ||= "PREVIOUS CHANGE"
  self.label_c ||= "THE OTHER PERSON'S CHANGE"
  
  def initialize(a,b,c)
    @tempfiles = []
    @merged_text = `#{Diff3.diff3_command} --label "#{Diff3.label_a}" #{tempfile_for(a)} --label "#{Diff3.label_b}" #{tempfile_for(b)} --label "#{Diff3.label_c}" #{tempfile_for(c)}`
    @conflict = case $?.exitstatus
    when 0; false
    when 1; true
    else    $?.exitstatus
    end
  ensure
    close_tempfiles
  end
  
  def conflict?
    @conflict
  end
  
  def merged_text
    @merged_text
  end
  
  private
  
  def tempfile_for(text)
    new_tempfile = Tempfile.new('diff3')
    new_tempfile.write(text)
    new_tempfile.close
    @tempfiles << new_tempfile
    new_tempfile.path
  end
  
  def close_tempfiles
    @tempfiles.each(&:close)
    @tempfiles.each(&:unlink)
  end
  
end