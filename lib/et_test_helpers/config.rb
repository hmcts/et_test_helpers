require 'i18n'
module EtTestHelpers
  class Config
    include Singleton
    attr_accessor :translation

    private

    def initialize
      self.translation = lambda { |key|
        I18n.t(key)
      }
    end
  end
end
