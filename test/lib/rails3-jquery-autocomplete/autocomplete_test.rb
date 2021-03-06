require 'test_helper'

module Rails3JQueryAutocomplete
  class AutocompleteTest < Test::Unit::TestCase
    include Rails3JQueryAutocomplete::Autocomplete

    context '#get_autocomplete_limit' do
      context 'the limit option was specified' do
        should "return the limit option" do
          assert_equal 99, get_autocomplete_limit({:limit => 99})
        end
      end

      context 'the limit option is not specified' do
        should 'return 10' do
          assert_equal 10, get_autocomplete_limit({})
        end
      end
    end

    context '#get_object' do
      should 'return the specified sym as a class name' do
        symbol = Object.new
        class_object = Class.new
        mock(symbol).to_s.mock!.camelize.mock!.constantize { class_object }
        assert_equal class_object, get_object(symbol)
      end
    end

    context '#json_for_autocomplete' do
      should 'parse items to JSON' do
        item = generate_mocked_model_instance

        parameters = { :method => :name, :options => {} }
        items      = [item]
        response   = self.json_for_autocomplete(items, parameters).first

        assert_equal response["id"], "1"
        assert_equal response["value"], "Object Name"
        assert_equal response["label"], "Object Name"
      end

      context 'with extra data as an Array' do
        should 'add that extra data to result' do
          item = generate_mocked_model_instance
          mock(item).send("extra") { 'Object Extra' }

          parameters = { :method => :name, :options => { :extra_data => ["extra"] } }
          items      = [item]
          response   = self.json_for_autocomplete(items, parameters).first

          assert_equal "1"            , response["id"]
          assert_equal "Object Name"  , response["value"]
          assert_equal "Object Name"  , response["label"]
          assert_equal "Object Extra" , response["extra"]
        end
      end

      context 'with extra data as a Hash' do
        context 'having lambdas as values' do
          should 'add that extra data to result' do
            item = generate_mocked_model_instance

            parameters = {
              :method => :name,
              :options => {
                :extra_data => {
                  "extra" => lambda { |item, parameters| 'Lambda Extra' }
                }
              }
            }
            items    = [item]
            response = self.json_for_autocomplete(items, parameters).first

            assert_equal "1"            , response["id"]
            assert_equal "Object Name"  , response["value"]
            assert_equal "Object Name"  , response["label"]
            assert_equal "Lambda Extra" , response["extra"]
          end
        end

        context 'having non-lambdas as values' do
          should 'add that extra data to result' do
            item = generate_mocked_model_instance
            mock(item).send("exxtra") { 'Object Exxtra' }

            parameters = {
              :method => :name,
              :options => { :extra_data => {
                  "extra" => "exxtra"
                }
              }
            }
            items    = [item]
            response = self.json_for_autocomplete(items, parameters).first

            assert_equal "1"             , response["id"]
            assert_equal "Object Name"   , response["value"]
            assert_equal "Object Name"   , response["label"]
            assert_equal 'Object Exxtra' , response["extra"]
          end
        end
      end
    end
  end
end
