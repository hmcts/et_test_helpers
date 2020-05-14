RSpec.describe EtTestHelpers do
  it "has a version number" do
    expect(EtTestHelpers::VERSION).not_to be nil
  end

  it "can configure the translate option" do
    EtTestHelpers.configure do |c|
      c.translate = key -> { "#{key}-translated" }
    end

    boom!
  end
end
