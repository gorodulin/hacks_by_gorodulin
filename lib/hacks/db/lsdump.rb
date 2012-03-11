include ActionView::Helpers::DateHelper
HackTree.define do
  group :db do
    desc <<-EOT
      List database snapshots
    EOT

    hack :lsdump do
      
      # TODO: configuration conventions needed!
      konfig = {
        :db_snapshot_folder => File.join(Rails.root, "tmp"),
      }
      
      version  = ActiveRecord::Migrator.current_version
      filemask = File.join(konfig[:db_snapshot_folder], [Rails.env, version, "*", "sql"] * ".")

      dumps = Dir[filemask].sort.map do |filepath|
        [
          File.basename(filepath).split('.')[2].to_sym,
          time_ago_in_words(File.mtime(filepath)),
          File.open(filepath, &:readline).match(/^-- DESCRIPTION: (.+)$/).to_a[1],
        ]
      end
      
      if dumps.empty?
        puts "Current DB schema (%s) has no snapshots" % version
        next
      end
      
      # calculate column widths
      width1, width2 = [0,1].map{|column| dumps.transpose[column].map(&:size).max}
      
      # output list
      puts "%-#{width1}s   %-#{width2}s    %s" % ["Name", "Time", "Comment"]
      puts "=" * 60
      dumps.each do |dump|
        puts ":%-#{width1}s  [%-#{width2}s]  %s" % dump
      end
      nil
    end
  end
end
