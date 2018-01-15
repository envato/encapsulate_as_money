begin
  require 'active_model'

  if [4,5].include?(ActiveModel::VERSION::MAJOR)
    module ActiveModel::Validations::Clusivity
      private

      def inclusion_method(enumerable)
        if enumerable.first.is_a?(Money)
          :cover?
        else
          return :include? unless enumerable.is_a?(Range)
          case enumerable.first
          when Numeric, Time, DateTime
            :cover?
          else
            :include?
          end
        end
      end
    end
  end
rescue LoadError
end
