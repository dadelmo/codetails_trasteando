require 'json'

class JsonStore

  TMP_FILE = "tmp/store.json"

  attr_accessor :id

  def initialize params=nil
    unless params.blank?
      params.keys.each do |k|
        send("#{k}=",params[k]) unless k == "errors" || k == "validation_context"
      end
    end
  end

  def update_attributes attributes
    json_db = JsonStore.open_db_file
    attributes.keys.each do |k|
      send("#{k}=",attributes[k])
    end
    return false if !valid?
    json_db.delete_if{|f| f["id"] == id}
    json_db << self
    JsonStore.save_db_file(json_db)    
  end

  def save
    return false if !valid?
    json_db = JsonStore.open_db_file
    @id = ((json_db.map{|i| i["id"]}.max || 0 ) + 1) if @id.blank?
    json_db << self
    JsonStore.save_db_file(json_db)
  end

  def destroy
    json_db = JsonStore.open_db_file
    json_db.delete_if{|f| f["id"] == id}
    JsonStore.save_db_file(json_db) 
  end

  def self.all
    json_db = open_db_file
    json_db.map do |j|
      s = self.new j
    end
  end

  def self.find id
    json_db = open_db_file
    json_db.each do |j|
      s = self.new j
      return s if s.id.to_s == id.to_s
    end
    return nil
  end

  def persisted?
    @id.present?
  end


  private

  def self.save_db_file json_hash
    File.open(TMP_FILE,"w") do |f|
      f.write(json_hash.to_json)
    end
    return false
  end

  def self.open_db_file
    file = File.read(TMP_FILE)
    file = "[]" if file.blank?
    return JSON.parse(file)
  end

end
