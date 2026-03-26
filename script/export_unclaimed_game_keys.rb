require "csv"

csv_file = "unclaimed_game_keys.csv"

CSV.open(csv_file, "w", headers: ["ID", "Name", "Key", "Created At"]) do |csv|
  csv << ["ID", "Name", "Key", "Created At"]
  
  GameKey.unclaimed.find_each do |gk|
    csv << [gk.id, gk.name, gk.key, gk.created_at]
  end
end

puts "Exported #{GameKey.unclaimed.count} unclaimed GameKeys to #{csv_file}"
