#
# Load the formtastic plugin if using Formtastic
#
begin
  require 'formtastic'
  begin
    require "formtastic/version"
  rescue LoadError
  end

  if defined?(Formtastic::VERSION)
    #
    # Formtastic 2.x
    #

    module Formtastic
      module Inputs
        class AutocompleteInput
          include Base
          include Base::Stringish

          def id_field_dom_id(method)
            [ builder.custom_namespace,
              sanitized_object_name,
              dom_index,
              method.to_s.gsub(/[\?\/\-]$/, '')
            ].reject { |x| x.blank? }.join('_')
          end

          def input_html_options
            if options[:id_field]
              { :id_element => '#' + id_field_dom_id(options[:id_field])
              }.merge(super)
            else
              super
            end
          end

          def to_html
            input_wrapping do
              result = label_html <<
                builder.autocomplete_field(method, options.delete(:url), input_html_options) <<
                (options[:id_field] ? builder.hidden_field(options.delete :id_field) : '')
            end
          end
        end
      end
    end
  else

    #
    # Formtastic 1.x
    #
    class Formtastic::SemanticFormBuilder < ActionView::Helpers::FormBuilder
      include Rails3JQueryAutocomplete::FormtasticPlugin
    end
  end
rescue LoadError
end
