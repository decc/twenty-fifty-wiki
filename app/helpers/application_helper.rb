# encoding: utf-8
module ApplicationHelper

  def present_cost(cost)
    return cost unless cost.respond_to?(:map)
    cost.map{ |c| c.to_f.round() }.join('–')
  end
  
  def flash_messages
    %w(notice warning error alert).each do |msg|
      concat content_tag(:div, content_tag(:p, raw(flash[msg.to_sym])), :class => "message #{msg}") unless flash[msg.to_sym].blank?
    end
  end
  
  def escape_latex(text)
    LatexToPdf.escape_latex(text)
  end
  
  def latex_author
    return "" unless target.sign_off_status == :signedOff
    "\\author{#{target.signed_off_by.title}}"
  end
  
  def similar_pages_message
    return "" unless target.autolink_title
    return "" unless similar_titles = target.autolink_title.similar_titles
    raw("<div id='similarlyTitled'><b>NB:</b> There is also "+similar_titles.map { |type,id| "a <a href='/#{type.downcase.pluralize}/#{id}'>#{type.downcase} called '#{target.title}'</a>"}.join(" and ")+"</div>" )
  end
  
  def follow_link
    if target.followed_by_current_user?
      link_to "stop getting emails about this", "/#{target.class.to_s.downcase.pluralize}/#{target.id}/un_follow"
    else
      link_to "get an email if this #{target.class.to_s.downcase} changes", "/#{target.class.to_s.downcase.pluralize}/#{target.id}/follow"
    end
  end
  
  def signed_off_message
    return "" unless target.content
    return "" if target.content.empty?
    case target.sign_off_status
    when :signedOff
      raw("<div id='signoff'>#{link_to target.signed_off_by.title, target.signed_off_by} signed this off #{time_ago_in_words(target.signed_off_at)} ago</div>")
    when :oldSignOff
      raw("<div id='signoff'>#{link_to target.signed_off_by.title, target.signed_off_by} signed this off  #{time_ago_in_words(target.signed_off_at)} ago. It may be out of date.</div>")
    when :notSignedOff
      raw("<div id='signoff'>This has not been signed off. Treat with caution.</div>")
    end
  end
  
  def sign_off_status
    return "" unless  @page || @picture || @user || @category
    target.sign_off_status
  end
  
  def target
    @page || @picture || @user || @category || @cost || @cost_category || @cost_source || Page.find(1)
  end
  
  def link_list(array)
    if array.size > 100
      render :partial => 'site/link_list_AtoZ', :locals => {:array => array }
    else
      render :partial => 'site/link_list_flat', :locals => {:array => array }
    end
  end
  
  def picture_link_list(array)
    if array.size > 100
      render :partial => 'site/picture_link_list_AtoZ', :locals => {:array => array }
    else
      render :partial => 'site/picture_link_list_flat', :locals => {:array => array }
    end    
  end
  
  def default_chart_x_axis_parameter
    case @cost_category.cost_type
    when :fuel; :valid_in_year
    when :technology; :operating_cost
    end
  end

  def default_chart_y_axis_parameter
    case @cost_category.cost_type
    when :fuel; :fuel_cost
    when :technology; :capital_cost
    end
  end
  
  def valid_chart_parameters
    %w{fuel_cost_normalised operating_cost_normalised capital_cost_normalised valid_in_year_normalised valid_for_quantity_of_fuel_normalised}
  end
  
  def axis_label(parameter)
    {
      'operating_cost_normalised' => "Operating cost (excluding fuel) #{@cost_category.default_operating_unit}",
      'capital_cost_normalised' => "Capital cost #{@cost_category.default_capital_unit}",
      'fuel_cost_normalised' => "#{@cost_category.label} cost #{@cost_category.default_fuel_unit}",
      'valid_in_year_normalised' => "Year",
      'valid_for_quantity_of_fuel_normalised' => "Maximum quantity available #{@cost_category.default_valid_for_quantity_of_fuel_unit}"
    }[parameter].to_json
  end
  
  def cost_category_chart
    x_axis_paramater = "#{params[:chart_x] || default_chart_x_axis_parameter}_normalised"
    y_axis_parameter = "#{params[:chart_y] || default_chart_y_axis_parameter}_normalised"
    range = x_axis_paramater == "valid_in_year_normalised" ? ",1970,2050" : ""
    label_tail = x_axis_paramater == "valid_in_year_normalised" ? "valid_for_quantity_of_fuel" : "valid_in_year"
    return nil unless valid_chart_parameters.include?(x_axis_paramater) 
    return nil unless valid_chart_parameters.include?(y_axis_parameter)
    data = @cost_category.costs.map do |c|
      { 
        'id' => c.id,
        'label' => "#{(c.label.blank? ? c.cost_source.label : c.label)} (#{c.send(label_tail)})",
        'x' => c.send(x_axis_paramater),
        'y' => c.send(y_axis_parameter),
      }
    end.to_json
    raw "c = plotData('chart',#{axis_label(x_axis_paramater)},#{axis_label(y_axis_parameter)},#{data}#{range});"
  end
  
  def update_field(field,title,value=title,extra_js="")
    link_to_function title, "setField('#{field}','#{value}');#{extra_js}"
  end
  
  def tsv(array)
    raw CSV.dump(array,"",:col_sep => "\t")
  end
end
