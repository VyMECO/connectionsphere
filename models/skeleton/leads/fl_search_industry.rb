module BlackStack
module Leads
  class SearchIndustry < Sequel::Model(:fl_search_industry)
    many_to_one :fl_search, :class=>:'BlackStack::Leads::Search', :key=>:id_search
    many_to_one :fl_industry, :class=>:'BlackStack::Leads::Industry', :key=>:id_industry

    def to_hash
      {
        'id'=>self.id,
        'positive'=>self.positive,
        'id_search'=>self.id_search
      }.merge(self.fl_industry.to_hash)
    end

    def self.validate_descriptor(h)
      errors = []
      # validate: h must be a hash
      errors << "Descriptor must be a hash" if !h.is_a?(Hash)
      # hash validations
      if h.is_a?(Hash)
        # validation: key 'name' is mandatory
        errors << "Key 'name' is mandatory for BlackStack::Leads::SearchIndustry" if !h.has_key?('name')

        # validation: key 'positive' is mandatory
        errors << "Key 'positive' is mandatory" if !h.has_key?('positive')

        # validation: value 'name' must exists in the table fl_industry
        if h.has_key?('name') && h['name'].to_s.length > 0
          industry = BlackStack::Leads::Industry.where(:name=>h['name']).first
          errors << "Value 'name' must exists in the table fl_industry" if industry.nil?
        end

        # validation: value 'positive' must be a boolean
        if h.has_key?('positive')
          errors << "Value 'positive' must be a boolean" if !h['positive'].is_a?(TrueClass) && !h['positive'].is_a?(FalseClass)
        end
      end
      # return
      errors
    end # validate_descriptor

    # map a hash descriptor to the attributes of the object
    def update(h)
      self.id_industry = h['name'].to_s.length > 0 ? BlackStack::Leads::Industry.where(:name=>h['name']).first.id : nil
      self.positive = h['positive']
      self.id_search = h['id_search']
    end

    # constructor
    def initialize(h)
      super()
      errors = BlackStack::Leads::SearchIndustry.validate_descriptor(h)
      raise "Errors found:\n#{errors.join("\n")}" if errors.size>0
      # map the hash to the attributes of the model.
      self.id = guid
      self.update(h)
    end

  end # BlackStack::Leads::SearchIndustry
end # Leads
end