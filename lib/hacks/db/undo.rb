HackTree.define do
  group :db do
    desc <<-EOT
      Load "undo" database snapshot
      
      Alias for c.db.load :undo
    EOT

    hack :undo do
      c.db.load :undo
      nil
    end
  end
end
