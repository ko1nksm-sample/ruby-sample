require 'pp'
require 'rubygems'
require 'neography'

# these are the default values:
Neography.configure do |config|
  config.protocol             = "http"
  config.server               = "localhost"
  config.port                 = 7474
  config.directory            = ""  # prefix this path with '/'
  config.cypher_path          = "/cypher"
  config.gremlin_path         = "/ext/GremlinPlugin/graphdb/execute_script"
  config.log_file             = "neography.log"
  config.log_enabled          = false
  config.slow_log_threshold   = 0    # time in ms for query logging
  config.max_threads          = 20
  config.authentication       = 'basic'  # 'basic' or 'digest'
  config.username             = 'neo4j'
  config.password             = 'pass'
  config.parser               = MultiJsonParser
  config.http_send_timeout    = 1200
  config.http_receive_timeout = 1200
  config.persistent           = true
end

@neo = Neography::Rest.new

# Node creation:
node1 = @neo.create_node("age" => 31, "name" => "Max")
node2 = @neo.create_node("age" => 33, "name" => "Roel")

# Node properties:
@neo.set_node_properties(node1, {"weight" => 200})

# Relationships between nodes:
@neo.create_relationship("coding_buddies", node1, node2)

# Get node relationships:
@neo.get_node_relationships(node2, "in", "coding_buddies")

# Use indexes:
@neo.add_node_to_index("people", "name", "max", node1)
@neo.get_node_index("people", "name", "max")

# Batches:
@neo.batch [:create_node, {"name" => "Max"}],
           [:create_node, {"name" => "Marc"}]

# Cypher queries:
pp @neo.execute_query("start n=node(0) return n")
