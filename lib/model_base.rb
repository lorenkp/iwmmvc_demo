require 'pg'
require 'active_support/inflector'
require_relative 'associatable'

# Database = PG::Connection.open(:dbname => 'mvc')

Database = PG::Connection.open(host: 'ec2-107-21-221-59.compute-1.amazonaws.com',
                               database: 'de8khgpvn6f9e',
                               port: 5432,
                               password: 'KtENQfogvyPRDC-IdkfzSgVnRC',
                               user: 'ddgdbhyinirsoj'
                              )

class ModelBase
  extend Associations

  def initialize(params)
    params.each do |key, val|
      if self.class.columns.include?(key.to_sym)
        send((key.to_s + '=').to_sym, val)
      else
        fail("unknown attribute '#{key}'")
      end
    end
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.table_name=(name)
    @table_name = name
  end

  def self.columns
    return @columns if @columns
    cols = Database.exec(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    @columns = cols.fields.map(&:to_sym)
  end

  def self.make_column_attr_accessors!
    columns.each do |col|
      define_method(col) do
        attributes[col]
      end

      define_method((col.to_s + '=').to_sym) do |obj|
        attributes[col] = obj
      end
    end
  end

  def self.all
    query_hash = Database.exec(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      ORDER BY
        id DESC
    SQL
    parse_all(query_hash)
  end

  def self.parse_all(query_hash)
    query_hash.map { |entry| new(entry) }
  end

  def self.find(id)
    result = Database.exec(<<-SQL, [id])
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = $1
    SQL
    new(result[0])
  end

  def save
    id.nil? ? insert : update
  end

  def self.where(params)
    where_line = params.keys
                 .map
                 .with_index(1) { |key, idx| key.to_s + " = $#{idx}" }
                 .join(' AND ')
    results = Database.exec(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL
    parse_all(results)
  end

  def destroy
    Database.exec_params(<<-SQL, [id])
    DELETE FROM
    #{self.class.table_name}
    WHERE
    id = $1
    SQL
    nil
  end

  private

  def attributes
    @attributes ||= {}
  end

  def insert
    insert_attributes = []
    col_names = []
    @attributes[:created_at] = Time.now
    # postgres will provide the id, upon insertion
    self.class.columns.reject { |el| el == :id }.each do |col|
      insert_attributes << attributes[col]
      col_names << col.to_s
    end
    insertion = Database.exec_params(<<-SQL, insert_attributes)
      INSERT INTO
        #{self.class.table_name} (#{col_names.join(', ')})
      VALUES
        (#{val_line})
      RETURNING
       id
    SQL
     self.id = insertion[0]['id']
  end

  def val_line
    (1..self.class.columns.length - 1).to_a.map { |el| '$' + el.to_s }.join(', ')
  end

 def update
   set_attributes = []
   set_line = []
   self.class.columns.each.with_index(1) do |col, idx|
     set_line << col.to_s + " = $#{idx}"
     set_attributes << attributes[col]
   end
   Database.exec_params(<<-SQL, set_attributes)
     UPDATE
      #{self.class.table_name}
     SET
      #{set_line.join(', ')}
     WHERE
      id = #{self.id}
    SQL
 end
end