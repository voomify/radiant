module Admin::SettingsHelper

  def show_setting(key, options={})
    setting = setting_for(key)
    domkey = key.gsub(/\W/, '_')
    html = ""
    html << content_tag(:label, (options[:label] || setting.label || key), :for => domkey)
    if setting.boolean?
      html << content_tag(:span, setting.value.to_s, :class => setting.checked?, :id => domkey)
    else
      html << content_tag(:span, (setting.selected_value || setting.value), :id => domkey)
    end
  end
  
  def edit_setting(key, options={})
    setting = setting_for(key)
    domkey = key.gsub(/\W/, '_')
    label = content_tag(:label, options[:label] || setting.label || key)
    name = setting.key.to_sym
    html = ""
    if setting.boolean?
      html << check_box_tag(name, 1, setting.value, :class => 'setting', :id => domkey)
      html << label
    elsif setting.selector?
      html << label
      html << select_tag(name, options_from_collection_for_select(setting.definition.selection), setting.value, :class => 'setting', :id => domkey)
    else
      html << label
      text_field_tag(name, setting.value, :class => 'setting', :id => domkey)
    end
  end
  
  def setting_for(key)
    Radiant::Config.find_or_create_by_key(key)
  end
  
  def definition_for(key)
    if setting = setting_for(key)
      setting.definition
    end
  end

end