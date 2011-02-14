module ActiveRecord
  module Validations
    module ClassMethods

      def validates_mixed_case_of(*args)
        configuration = { :on => :save, :with => nil}
        configuration.update(args.pop) if args.last.is_a?(Hash)

        
        validates_each(args, configuration) do |record, attr_name, value|
          next if value.nil?          
          next if value.gsub(/\W/, "").size < 3 # skip very short words
          error = nil
          
          if (value.upcase == value)
            error = 1
          elsif (value.downcase == value)
            error = -1
          end
          
          next if error.nil?
          
          item_name = I18n.t("activerecord.models.attributes.#{name.underscore}.#{attr_name}", :default => nil) || configuration[:attribute_name] || attr_name
          
          if error == 1
           message = I18n.t("activerecord.errors.models.attributes.#{name.underscore}.#{attr_name}.all_caps",
                       :item => item_name,
                       :default => [:"activerecord.errors.models.#{name.underscore}.all_caps",
                           configuration[:all_caps],
                          :'activerecord.errors.messages.all_caps'])
          elsif error == 2
            message = I18n.t("activerecord.errors.models.attributes.#{name.underscore}.#{attr_name}.all_lowercase",
                        :item => item_name,
                        :default => [:"activerecord.errors.models.#{name.underscore}.all_lowercase",
                            configuration[:all_lowercase],
                           :'activerecord.errors.messages.all_lowercase'])
          end
                      
          record.errors.add(attr_name, message)
            
        end # validates_each
      end # validates_at_least_one

    end    
  end
end