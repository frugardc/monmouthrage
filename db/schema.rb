# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160614171021) do

  create_table "impressions", :force => true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "params"
  end

  create_table "power_lines", :force => true do |t|
    t.spatial "geom", :limit => {:srid=>4326, :type=>"multi_line_string"}
  end

  create_table "power_lines_buffer", :force => true do |t|
    t.spatial "st_buffer", :limit => {:srid=>2163, :type=>"polygon"}
  end

  create_table "power_parcels", :primary_key => "_uid_", :force => true do |t|
    t.spatial "geom",                 :limit => {:srid=>4326, :type=>"polygon"}
    t.integer "objectid"
    t.string  "propertylocation"
    t.string  "propertyclass"
    t.string  "ownersname"
    t.string  "ownersmailingaddress"
    t.string  "citystatezip"
    t.string  "mun",                  :limit => 4
    t.string  "block",                :limit => 10
    t.string  "lot",                  :limit => 10
    t.string  "buildingclass"
    t.string  "owner16"
    t.string  "owner15"
    t.string  "owner14"
  end

  create_table "schools", :force => true do |t|
    t.spatial "geom",       :limit => {:srid=>4326, :type=>"multi_point"}
    t.decimal "osm_id"
    t.string  "access",     :limit => 254
    t.string  "addr_house", :limit => 254
    t.string  "addr_hou_1", :limit => 254
    t.string  "addr_inter", :limit => 254
    t.string  "admin_leve", :limit => 254
    t.string  "aerialway",  :limit => 254
    t.string  "aeroway",    :limit => 254
    t.string  "amenity",    :limit => 254
    t.string  "area",       :limit => 254
    t.string  "barrier",    :limit => 254
    t.string  "bicycle",    :limit => 254
    t.string  "brand",      :limit => 254
    t.string  "bridge",     :limit => 254
    t.string  "boundary",   :limit => 254
    t.string  "building",   :limit => 254
    t.string  "capital",    :limit => 254
    t.string  "constructi", :limit => 254
    t.string  "covered",    :limit => 254
    t.string  "culvert",    :limit => 254
    t.string  "cutting",    :limit => 254
    t.string  "denominati", :limit => 254
    t.string  "disused",    :limit => 254
    t.string  "ele",        :limit => 254
    t.string  "embankment", :limit => 254
    t.string  "foot",       :limit => 254
    t.string  "generator_", :limit => 254
    t.string  "harbour",    :limit => 254
    t.string  "highway",    :limit => 254
    t.string  "historic",   :limit => 254
    t.string  "horse",      :limit => 254
    t.string  "intermitte", :limit => 254
    t.string  "junction",   :limit => 254
    t.string  "landuse",    :limit => 254
    t.string  "layer",      :limit => 254
    t.string  "leisure",    :limit => 254
    t.string  "lock",       :limit => 254
    t.string  "man_made",   :limit => 254
    t.string  "military",   :limit => 254
    t.string  "motorcar",   :limit => 254
    t.string  "name",       :limit => 254
    t.string  "natural",    :limit => 254
    t.string  "office",     :limit => 254
    t.string  "oneway",     :limit => 254
    t.string  "operator",   :limit => 254
    t.string  "place",      :limit => 254
    t.string  "poi",        :limit => 254
    t.string  "population", :limit => 254
    t.string  "power",      :limit => 254
    t.string  "power_sour", :limit => 254
    t.string  "public_tra", :limit => 254
    t.string  "railway",    :limit => 254
    t.string  "ref",        :limit => 254
    t.string  "religion",   :limit => 254
    t.string  "route",      :limit => 254
    t.string  "service",    :limit => 254
    t.string  "shop",       :limit => 254
    t.string  "sport",      :limit => 254
    t.string  "surface",    :limit => 254
    t.string  "toll",       :limit => 254
    t.string  "tourism",    :limit => 254
    t.string  "tower_type", :limit => 254
    t.string  "tunnel",     :limit => 254
    t.string  "water",      :limit => 254
    t.string  "waterway",   :limit => 254
    t.string  "wetland",    :limit => 254
    t.string  "width",      :limit => 254
    t.string  "wood",       :limit => 254
    t.integer "z_order",    :limit => 8
  end

end
