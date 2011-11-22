class Cost < ActiveRecord::Base
  
  before_validation :create_title_from_label
  validates_length_of :cost_category_label, :minimum => 3, :message => "must be present, and greater than 3 characters long"
  validates_length_of :cost_source_label, :minimum => 3, :message => "must be present, and greater than 3 characters long"  
  
  include PreProcessContent
  include DeletableExtension  
  include AutolinkTitle
  include Sokcloth
  include Versioned
  include CategoryMembershipExtension
  include Followers
  include SignOff
  include Searchable
  
  belongs_to :cost_source
  belongs_to :cost_category
  
  def clone_to_new_cost
    cloned_attributes = clone_attributes.delete_if { |k| %w{id user_id signed_off_by_id signed_of_at created_at updated_at}.include?(k)}
    Cost.new(cloned_attributes)
  end
  
  def cost_type
    cost_category.try(:cost_type)
  end
  
  def cost_type=(new_cost_type)
    @new_cost_type = new_cost_type
  end
  
  def create_title_from_label
    self.title = [cost_source_label,cost_category_label,label,valid_in_year].compact.join(" ")
  end
  
  def ast
    @ast ||= SokclothParser.parse(content)
  end
  
  def set_defaults
    if self.cost_category
      self.content ||= cost_category.cost_boilerplate
    end
  end
  
  before_validation :clean_label
  
  # Strip unwanted bits out of the label
  def clean_label
    return true unless self.label
    self.label = self.label.strip
    true
  end

  def cost_category_label
    @new_cost_category_label || cost_category.try(:label)
  end
  
  def cost_category_label=(new_cost_category_label)
    @new_cost_category_label = new_cost_category_label.try(:strip)
  end
  
  before_save :update_cost_category
  
  def update_cost_category
    return true unless @new_cost_category_label
    return true if cost_category && (cost_category.label == @new_cost_category_label)
    return true if self.cost_category = CostCategory.find_by_label(@new_cost_category_label)
    params = {:label => @new_cost_category_label}
    if @new_cost_type == 'fuel'
      params[:default_fuel_unit] = units_from(fuel)
      params[:default_valid_for_quantity_of_fuel_unit] = units_from(valid_for_quantity_of_fuel)
    elsif @new_cost_type == 'technology'
      params[:default_capital_unit] = units_from(capital)
      params[:default_operating_unit] = units_from(operating)
    end
    self.cost_category = CostCategory.create(params)
    self.cost_category.set_defaults
    self.cost_category.save!
    true
  end

  def cost_source_label
    @new_cost_source_label || cost_source.try(:label)
  end
  
  def cost_source_label=(new_cost_source_label)
    @new_cost_source_label = new_cost_source_label.try(:strip)
  end
  
  before_save :update_cost_source
  
  def update_cost_source
    return true unless @new_cost_source_label
    return true if cost_source && (cost_source.label == @new_cost_source_label)
    return true if self.cost_source = CostSource.find_by_label(@new_cost_source_label)
    params = {:label => @new_cost_source_label}
    self.cost_source = CostSource.create(params)
    self.cost_source.set_defaults
    self.cost_source.save!
    @new_cost_source_created = true
    true
  end
  
  def new_cost_source_created?
    @new_cost_source_created
  end
  
  def output_over_capacity
    return nil if self.output.blank?
    return ($1.to_f/100.0) if self.output.strip =~ /^([0-9.]+ *%$)/i
    output_as_normalised_energy = NormaliseCost.new(output).normalise
    capacity_as_normalised_energy = NormaliseCost.new(size).normalise
    return nil if output_as_normalised_energy == "?" || capacity_as_normalised_energy =="?"
    (output_as_normalised_energy / capacity_as_normalised_energy ).first.to_f
  end
  
  include CostConversions
  
  def default_capital_unit
    cost_category.default_capital_unit
  end
  
  def default_operating_unit
    cost_category.default_operating_unit
  end
  
  def default_fuel_unit
    cost_category.default_fuel_unit
  end
  
  def capital_cost_normalised
    NormaliseCost.new(capital,output_over_capacity).convert_to(default_capital_unit)
  end
  
  def operating_cost_normalised
    NormaliseCost.new(operating,output_over_capacity).convert_to(default_operating_unit)    
  end
  
  def fuel_cost_normalised
    convert(fuel,default_fuel_unit)
  end
  
  %w{capital_cost_normalised operating_cost_normalised fuel_cost_normalised}.each do |cost_attribute|
    define_method "#{cost_attribute}_low" do
      c = send(cost_attribute).first
      c.respond_to?(:to_f) ?  c.to_f : c
    end
    define_method "#{cost_attribute}_high" do
      c = send(cost_attribute).last
      c.respond_to?(:to_f) ?  c.to_f : c
    end
  end
  
  alias :capital_normalised :capital_cost_normalised
  alias :operating_normalised :operating_cost_normalised
  alias :fuel_normalised :fuel_cost_normalised
  
  def valid_in_year_normalised
    return "?" unless valid_in_year
    normalised = valid_in_year.split("-").map { |y| y.strip }
    return "?" unless normalised.first
    normalised[0] = "2010" if normalised.first.downcase == "foak"
    normalised[0] = "2050" if normalised.first.downcase == "noak"
    if normalised.size == 1
      normalised = [$1,($1.to_i+10).to_s] if normalised.first =~ /(\d+)s/
    elsif normalised.size == 2
      normalised[0] = $1 if normalised[0] =~ /(\d+)s/
      normalised[1] = ($1.to_i+10).to_s if normalised[1] =~ /(\d+)s/
    end
    normalised[0]= "#{"2010"[0,4-normalised.first.size]}#{normalised.first}" if normalised.first.size < 4
    normalised[1] = "#{normalised.first[0,4-normalised.last.size]}#{normalised.last}" if normalised.last.size < 4
    return "?" unless normalised[0] =~ /\d\d\d\d/
    return "?" if normalised[1] && normalised[1] !~ /\d\d\d\d/
    normalised.map(&:to_i)    
  end
  
  def valid_for_quantity_of_fuel_normalised
    convert(valid_for_quantity_of_fuel,cost_category.default_valid_for_quantity_of_fuel_unit)
  end
    
  def self.csv_load(meta,headers,row)
    id_index = headers.index('id')
    if id_index && row[id_index]
      cost = Cost.find(row[id_index])
    else
      cost = Cost.new
    end
    headers.each_with_index do |header,i|
      next if header == 'id'
      next unless cost.csv_load_headers.include?(header)
      value = row[i] || ""
      cost.send("#{header}=",value)
    end
    cost
  end
  
  def csv_load_headers
    @csv_load_headers ||= %w{cost_category_label cost_source_label label cost_type fuel capital operating valid_in_year valid_for_quantity_of_fuel size output efficiency life content}
  end
  
  def csv_headers
    @csv_headers ||= %w{id cost_category_label cost_source_label label cost_type fuel capital operating valid_in_year valid_for_quantity_of_fuel size output efficiency life content url fuel_cost_normalised_low fuel_cost_normalised_high default_fuel_unit capital_cost_normalised_low capital_cost_normalised_high default_capital_unit operating_cost_normalised_low operating_cost_normalised_high default_operating_unit}
  end
  
  def csv_dump(headers)
    headers.map do |h| 
      value = self.send h
      value.blank? ? nil : value
    end
  end
  
  def url
    "http://2050-wiki.greenonblack.com/costs/#{id}"
  end
  
  def url=(ignore)
    # ignore
  end
  
  def parsed_properly?(before_parse,after_parse)
    return true if before_parse.blank?
    return false if after_parse == nil
    return false if after_parse == "?"
    true
  end
  
  def problem_parsing_data?
    not (
      parsed_properly?(valid_in_year,valid_in_year_normalised) &&
      parsed_properly?(output,output_over_capacity) &&
      parsed_properly?(operating,operating_cost_normalised) &&
      parsed_properly?(capital,capital_cost_normalised) &&
      parsed_properly?(fuel,fuel_cost_normalised) &&
      parsed_properly?(valid_for_quantity_of_fuel,valid_for_quantity_of_fuel_normalised)
    )
  end
  
end
