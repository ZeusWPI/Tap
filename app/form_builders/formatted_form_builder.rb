class FormattedFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TextHelper
  include ActionView::Context
  include ActionView::Helpers::NumberHelper

  # Field types to override with the custom form field
  FIELD_TYPES = [
    "text_field",
    "number_field",
    "password_field",
  ]

  # Initialize the form builder
  def initialize(object_name, object, template, options)
    @inline_errors = true

    super
  end

  # Add a method for each type in FIELD_TYPES.
  # This method will define a custom form field.
  FIELD_TYPES.each do |type|
    define_method(type) do |attribute, options = {}|
      form_field(attribute, options) do
        super(attribute, options.reverse_merge(class: input_css_class(attribute, options)))
      end
    end
  end

  # (override) Custom file upload input
  def file_field(attribute, options = {})
    form_field(attribute, options) do
      file_tag(attribute, options) do
        file_label_tag(attribute, options) do
          # Input for selecting the file
          control = super(attribute, options.reverse_merge(class: "file-input"))

          # File select label
          label = file_select_label_tag(attribute, options)

          # File select filename
          name = file_select_name_tag(attribute, options) do
            if object.send(attribute).present? and !options[:skip_initial_name]
              object.send(attribute).original_filename
            else
              "No file selected"
            end
          end

          content = control

          # Add the label if "skip_label" option is false
          content += label if !options[:skip_label]

          # Add the filename if "skip_name" option is false
          content += name if !options[:skip_name]

          content
        end
      end
    end
  end

  # (override) Custom collection select
  def collection_select(attribute, collection, value_method, text_method, options = {}, html_options = {})
    form_field(attribute, options) do
      content_tag(:div, class: "select is-fullwidth") do
        super(attribute, collection, value_method, text_method, options, html_options)
      end
    end
  end

  # (override) Custom checkbox
  def check_box(attribute, options = {}, checked_value = "1", unchecked_value = "0", &block)
    # Make sure the data option is set
    if !options[:data]
      options[:data] = {}
    end

    # Add "switch" to the data when the option is present
    if options[:switch]
      options[:data][:switch] = options[:switch]
    end

    # Add "submit" to the data when the option is present
    if options[:submit]
      options[:data][:submit] = options[:submit]
    end

    # Default control
    control = super(attribute, options, checked_value, unchecked_value)

    # If the "switch" option is provided, render a custom switch.
    if options[:switch]
      # Switch slider
      slider = content_tag(:span, class: "switch-slider") do
      end

      # New control in a switch wrapper
      control = content_tag(:label, class: "switch") do
        control + slider
      end
    end

    form_field(attribute, options) do
      control
    end
  end

  # (new) Custom price field
  # Wrapper around a number_field with steps in floats instead of in integers.
  def price_field(attribute, options = {})

    # Minimum value and step size
    options[:min] ||= 0
    options[:step] ||= 0.01

    # Set the prefix icon
    options[:prefix_icon] = "fas fa-euro-sign"

    # Regular number field
    number_field(attribute, options)
  end

  # (override) Custom submit button
  def submit(value = nil, options = {})
    css_class = "is-flex"

    # If the "justify" option is provided, use it as the class.
    # If not provided, justify to the end.
    if options[:justify]
      css_class += " is-justify-content-#{options[:justify]}"
    else
      css_class += " is-justify-content-flex-end"
    end

    field_tag(nil, options) do
      control_tag(nil, options) do
        content_tag(:div, class: css_class) do
          # Add "Please wait..." to the button while the form is submitting
          # Only add the option if not already provided.
          if !options[:data]
            options[:data] = {}
            if !options[:data][:disable_with]
              options[:data][:disable_with] = "Please wait..."
            end
          end

          super(value, options.reverse_merge(class: "button is-primary"))
        end
      end
    end
  end

  # (override) Custom label
  def label(attribute, text = nil, options = {}, &block)
    options[:class] = "label"
    super(attribute, text, options, &block)
  end

  # List with error messages
  def error_messages
    if object.errors.any?
      # Notification
      content_tag(:div, class: "notification is-danger is-light") do

        # Error messages
        content_tag(:ul) do
          object.errors.full_messages.map do |msg|
            content_tag(:li, msg)
          end.join.html_safe
        end
      end
    end
  end

  private

  # Input CSS class
  def input_css_class(attribute, options = {})
    css_class = "input"

    # Add error class when the field has an error.
    if object.errors[attribute].length > 0
      css_class += " is-danger"
    end

    # Add size class
    if options[:size]
      css_class += " is-#{options[:size]}"
    end

    css_class
  end


  # Field content tag
  def field_tag(attribute, options = {})
    content_tag(:div, class: "field") do
      yield
    end
  end

  # Control content tag
  def control_tag(attribute, options = {})
    css_class = "control"

    # Add "has-icons-left" class if the option "prefix_icon" is provided.
    if options[:prefix_icon]
      css_class += " has-icons-left"
    end

    # Add "has-icons-right" class if the option "suffix_icon" is provided.
    if options[:suffix_icon]
      css_class += " has-icons-right"
    end

    # Prefix icon
    prefix_icon = content_tag(:span, class: "icon is-small is-left") do
      icon_tag(options[:prefix_icon] || "")
    end

    # Suffix icon
    suffix_icon = content_tag(:span, class: "icon is-small is-right") do
      icon_tag(options[:suffix_icon] || "")
    end

    content_tag(:div, class: css_class) do
      # Only include prefix and suffix icon when the option is present
      yield + (options[:prefix_icon] ? prefix_icon : "") + (options[:suffix_icon] ? suffix_icon : "")
    end
  end

  # Icon content tag
  def icon_tag(icon, options = {})
    content_tag(:i, "", class: icon)
  end

  # File content tag
  def file_tag(attribute, options = {})
    css_class = "file"

    # Add "has-name" class if the skip_name option is false
    if !options[:skip_name]
      css_class += " has-name"
    end

    # Add "is-boxed" class if the option "boxed" is true
    if options[:boxed]
      css_class += " is-boxed"
    end

    # Add "is-fullwidth" class if the option "fullwidth" is true
    if options[:fullwidth]
      css_class += " is-fullwidth"
    end

    # Add error class when the field has an error.
    if object.errors[attribute].length > 0
      css_class += " is-danger"
    end

    content_tag(:div, class: css_class) do
      yield
    end
  end

  # File label content tag
  def file_label_tag(attribute, options = {})
    content_tag(:label, class: "file-label") do
      yield
    end
  end

  # File select file label tag
  def file_select_label_tag(attribute, options = {})
    content_tag(:span, class: "file-cta") do
      # Icon
      icon = content_tag(:span, class: "file-icon") do
        icon_tag("fas fa-upload")
      end

      # Text
      text = content_tag(:span, class: "file-label") do
        "Choose a file..."
      end

      icon + text
    end
  end

  # File select file name tag
  def file_select_name_tag(attribute, options = {})
    content_tag(:span, class: "file-name") do
      yield
    end
  end

  # Build a form field
  def form_field(attribute, options)
    content_tag(:div, class: "field") do
      # Label
      label = label(attribute, options[:label])

      # Prefix control
      prefix_control = content_tag(:div, class: "control") do
        options[:prefix_control]
      end

      # Suffix control
      suffix_control = content_tag(:div, class: "control") do
        options[:suffix_control]
      end

      # Control
      control = control_tag(attribute, options) do
        yield
      end

      # Error messages
      error = content_tag(:div, class: "help is-danger") do
        object.errors[attribute].join(", ").capitalize
      end

      # Help message
      help = content_tag(:div, class: "help") do
        options[:help]
      end

      # Content
      content = control

      # Prepend prefix control when the option is present
      if options[:prefix_control]
        content = prefix_control + content
      end

      # Append suffix control when the option is present
      if options[:suffix_control]
        content = content + suffix_control
      end

      # Append the error message when any error is present
      if object.errors[attribute].length > 0
        content = content + error
      end

      # Append the help message when any help message is present
      if options[:help]
        content = content + help
      end

      # If a prefix or suffix control is provided, wrap the content in another div with the "has-addons" class.
      # This is to ensure that the controls are aligned and the label is not rendered next to the input.
      if options[:prefix_control] || options[:suffix_control]
        content = content_tag(:div, class: "field has-addons") do
          content
        end
      end

      # If the skip_label option is false, prepend the labeL.
      if !options[:skip_label]
        content = label + content
      end

      content
    end
  end
end
