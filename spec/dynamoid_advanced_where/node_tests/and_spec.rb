require 'spec_helper'

RSpec.describe "Combining multiple queries with &" do
  let(:klass) do
    new_class(table_name: 'and_check', table_opts: {key: :bar} ) do
      field :simple_string
      field :second_string
    end
  end

  describe "string equality" do
    let!(:item1) { klass.create(second_string: 'baz', simple_string: 'foo', bar: '1') }
    let!(:item2) { klass.create(second_string: 'baz', simple_string: 'bar', bar: '2') }
    let!(:item3) { klass.create(second_string: 'baz', simple_string: 'foo', bar: '3') }

    it "matches string equals" do
      expect(
        klass.where{ (second_string == 'baz') & (simple_string == 'foo') }.all
      ).to match_array [item1, item3]
    end

    it "limits" do
      expect(
        klass.where{ (second_string == 'baz') & (simple_string == 'foo') }.record_limit(1).start({bar: item1.bar }).all
      ).to match_array [item3]
    end
  end
end
