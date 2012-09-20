# Credit to Daniel J. Berger
# https://github.com/djberg96/ptools/blob/master/lib/ptools.rb

class File
  def binary?
    s = (File.read(self, File.stat(self).blksize) || "").split(//)
    ((s.size - s.grep(" ".."~").size) / s.size.to_f) > 0.30
  end
end
