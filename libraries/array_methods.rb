#
#

class Array
    def synchronise_array_by_key(new_values, key = 'name')

        # Clear out any current array elements where the 'key' is not listed in new_values array
        delete_if { |item| not new_values.include?(item[key]) }

        new_values.each do |new_value|

            # If new_value is not in the array, add it
            if select { |item| item[key] == new_value }.empty?
                push({ key => new_value})
            end
        end

        Chef::Log.debug("Synchronised array: #{inspect}")
    end

    def synchronise_hash_by_key(new_hashes, key = 'name')

        new_hashes.each do |obj|

            case obj[key]
            when 'DISK'
                if select { |item| item[key] == obj[key] and item['value'] == obj['value'] }.empty?
                    push(obj)
                end
            else
                if select { |item| item[key] == obj[key] }.empty?
                    push(obj)
                else
                    select { |item| item[key] == obj[key] }.first.merge!(obj)
                end
            end

        end

        Chef::Log.debug("Synchronised hash: #{inspect}")
    end
end