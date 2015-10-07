class FormattedFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TextHelper
  include ActionView::Context
  include ActionView::Helpers::NumberHelper

  FIELD_HELPERS = %w[text_field number_field file_field password_field]

  delegate :content_tag, to: :@template

  def initialize(object_name, object, template, options)
    @inline_errors = true

    super
  end

  FIELD_HELPERS.each do |method_name|
    with_method_name    = "#{method_name}_with_format"
    without_method_name = "#{method_name}_without_format"

    define_method(with_method_name) do |name, options = {}|
      form_group_builder(name, options) do
        send(without_method_name, name, options)
      end
    end

    alias_method_chain method_name, :format
  end

  def price_field(name, options = {})
    options[:min]   ||= 0
    options[:step]  ||= 0.01
    # if object.is_a?(ActiveRecord::Base)
      # options[:value] ||= object[name]
    if object.respond_to?(name)
      options[:value] ||= object.send name
    end
    options[:value] = number_with_precision(options[:value], precision: 2)

    form_group_builder(name, options) do
      content_tag :div, class: "input-group" do
        content_tag(:span, class: "input-group-addon") do
          content_tag :span, nil, class: "glyphicon glyphicon-euro"
        end +
        number_field_without_format(name, options)
      end
    end
  end

  def check_box_with_format(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
    options.symbolize_keys!

    checkbox = check_box_without_format(name, options.except(:label), checked_value, unchecked_value)
    label_content = block_given? ? capture(&block) : options[:label]

    content_tag :div, class: control_wrapper_class do
      if options[:skip_label]
        checkbox
      else
        checkbox + " " + label(name, label_content)
      end
    end
  end

  def counter(name, options = {})
    form_group_builder(name, options.merge(wrapper_class: "input-group input-group-lg")) do
      counter_button("btn-dec", "glyphicon-minus") +
      number_field_without_format(name, options.merge({class: 'form-control row_counter center'})) +
      counter_button("btn-inc", "glyphicon-plus")
    end
  end

  alias_method_chain :check_box, :format

  def collection_select_with_format(name, collection, value_method = :to_s, text_method = :titlecase, options = {}, html_options = {})
    form_group_builder(name, options, html_options) do
      collection_select_without_format(name, collection, value_method, text_method, options, html_options)
    end
  end

  alias_method_chain :collection_select, :format

  def submit_with_format(name = nil, options = {})
    options[:class] = submit_class unless options[:class]

    content = submit_without_format(name, options)
    if options[:skip_wrapper]
      content
    else
      content_tag :div, content, class: submit_wrapper_class
    end
  end

  alias_method_chain :submit, :format

  def error_messages
    if object.errors.any?
      content_tag :div, class: "panel panel-danger form-errors" do
        error_header + error_body
      end
    end
  end

  def error_header
    content_tag(:div, class: "panel-heading") do
      "#{pluralize(object.errors.count, "error")} prohibited this #{object.class.name.downcase} from being saved:"
    end
  end

  def error_body
    content_tag(:div, class: "panel-body") do
      content_tag :ul do
        object.errors.full_messages.map do |msg|
          content_tag :li, msg
        end.join.html_safe
      end
    end
  end

  private
    def label_class
      "control-label"
    end

    def control_class
      "form-control"
    end

    def control_wrapper_class
      "form-group"
    end

    def submit_class
      "btn btn-primary"
    end

    def submit_wrapper_class
      "actions"
    end

    def form_group(*args, &block)
      options = args.extract_options!
      name = args.first

      options[:class] = [control_wrapper_class, options[:class]].compact.join(' ')

      content_tag(:div, options.except(:label)) do
        label = generate_label(name, options[:label]) if options[:label]
        control = capture(&block).to_s

        if label
          label + control
        else
          control
        end
      end
    end

    def form_group_builder(method, options, html_options = nil)
      options.symbolize_keys!

      css_options = html_options || options
      css_options[:class] = [control_class, css_options[:class]].compact.join(" ")

      wrapper_class = css_options.delete(:wrapper_class)
      wrapper_options = css_options.delete(:wrapper)

      form_group_options = {
        class: wrapper_class
      }

      if wrapper_options.is_a?(Hash)
        form_group_options.merge!(wrapper_options)
      end

      unless options.delete(:skip_label)
        form_group_options.reverse_merge!(label: {
          text: options.delete(:label),
          class: label_class
        })
      end

      form_group(method, form_group_options) do
        yield
      end
    end

    def generate_label(name, options = {})
      label("#{name}:", options[:text], options)
    end

    def counter_button(button, glyphicon)
      content_tag :span, class: "input-group-btn" do
        content_tag :button, class: "btn btn-default #{button}", type: "button" do
          content_tag :span, "", class: "glyphicon #{glyphicon}"
        end
      end
    end
end
